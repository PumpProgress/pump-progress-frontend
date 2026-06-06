import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/ai/tools/tool_definition.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/features/muscle/repository/repository_muscle.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/features/user/services/current_user_service.dart';
import 'package:pump_progress_frontend/features/workout/repository/repository.dart';

/// Dispatcher for the workout-builder chat: lets the model look up exercises by
/// muscle group and create the user's workouts for the week.
class ExerciseToolDispatcher extends AiToolDispatcher {
  ExerciseToolDispatcher({
    required this.repositoryExercises,
    required this.providerMuscle,
    required this.repositoryWorkout,
    required this.currentUserService,
  });

  final RepositoryExercises repositoryExercises;
  final ProviderMuscle providerMuscle;
  final RepositoryWorkout repositoryWorkout;
  final CurrentUserService currentUserService;

  /// Cached snapshot of the current user, loaded in [init]. Used by the chat
  /// bloc to tailor the prompt and by [_saveWeeklyPlan] for the user id.
  /// The snapshot is refreshed only when [init] re-runs (on model-ready), so a
  /// profile edit made mid-chat is not reflected until the chat reinitializes.
  User? _user;

  // Sync profile getters seeded from [_user] in [init]; read by the chat
  // bloc to tailor the system prompt. Null until init() runs / when unauthenticated.
  int? get age => _user?.age;
  String? get gender => _user?.gender;
  String? get fitnessLevel => _user?.fitnessLevel;
  String? get primaryGoal => _user?.primaryGoal;
  int? get trainingDaysPerWeek => _user?.trainingDaysPerWeek;

  @override
  Future<void> init() async {
    _user = await currentUserService.getCurrentUser();
    final muscles = await providerMuscle.getMuscles();
    final muscleNames = muscles.map((m) => m.name).toList();
    definitions = [
      ToolDefinition(
        tool: Tool(
          name: 'get_exercises_by_muscle',
          description:
              'Returns a list of exercises that target a specific muscle group.',
          parameters: {
            'type': 'object',
            'properties': {
              'muscle': {
                'type': 'string',
                'description': 'The muscle group to filter by.',
                'enum': muscleNames,
              },
              'limit': {
                'type': 'integer',
                'description':
                    'Maximum number of exercises to return. Defaults to 10.',
              },
            },
            'required': ['muscle'],
          },
        ),
        messageBuilder: (args) =>
            'Fetching exercises for "${args['muscle'] ?? 'muscle'}"...',
        handler: _getExercisesByMuscle,
      ),
      ToolDefinition(
        tool: Tool(
          name: 'save_weekly_plan',
          description:
              "Create the user's workouts for the week. Call once with the full plan.",
          parameters: {
            'type': 'object',
            'properties': {
              'workouts': {
                'type': 'array',
                'description': 'One entry per training day.',
                'items': {
                  'type': 'object',
                  'properties': {
                    'name': {
                      'type': 'string',
                      'description': "Workout name, e.g. 'Push Day'.",
                    },
                    'exercises': {
                      'type': 'array',
                      'items': {'type': 'string'},
                      'description':
                          'Exercise names for this workout, ordered with compound / '
                          'large-muscle exercises first.',
                    },
                  },
                  'required': ['name', 'exercises'],
                },
              },
            },
            'required': ['workouts'],
          },
        ),
        messageBuilder: (args) => 'Creating your weekly plan...',
        handler: _saveWeeklyPlan,
      ),
    ];
  }

  Future<Map<String, dynamic>> _getExercisesByMuscle(
    Map<String, dynamic> args,
  ) async {
    final muscle = args['muscle'] as String? ?? '';
    final limit = (args['limit'] as num?)?.toInt() ?? 10;
    final exercises = await repositoryExercises.getExercisesByMuscle(
      muscle,
      limit: limit,
    );
    return {
      'exercises':
          exercises.map((e) => {'id': e.id, 'name': e.name}).toList(),
    };
  }

  Future<Map<String, dynamic>> _saveWeeklyPlan(
    Map<String, dynamic> args,
  ) async {
    final userId = _user?.id ?? '';
    if (userId.isEmpty) {
      return {
        'status': 'error',
        'display_message':
            "I couldn't find your account. Please make sure you're logged in.",
      };
    }

    final rawWorkouts = args['workouts'];
    if (rawWorkouts is! List || rawWorkouts.isEmpty) {
      return {
        'status': 'error',
        'display_message': "I couldn't build the plan. Please ask me again to "
            'create your weekly workouts.',
      };
    }

    final created = <Map<String, dynamic>>[];
    final unmatched = <String>[];

    for (final raw in rawWorkouts) {
      if (raw is! Map) continue;
      final name = (raw['name'] as String?)?.trim() ?? '';
      if (name.isEmpty) continue;
      final exerciseNames =
          (raw['exercises'] as List?)?.whereType<String>().toList() ??
              const <String>[];

      final matched = <Exercise>[];
      final seenIds = <int>{};
      for (final exerciseName in exerciseNames) {
        final results = await repositoryExercises.searchExercises(exerciseName);
        if (results.isEmpty) {
          unmatched.add(exerciseName);
          continue;
        }
        final exercise = results.first;
        // De-dup within a day: a small model may repeat an exercise name; add
        // each resolved exercise at most once per workout.
        if (seenIds.add(exercise.id)) {
          matched.add(exercise);
        }
      }
      // Skip days with no resolvable exercises: a day whose exercises were all
      // unmatched, or that arrived with an empty list (e.g. a rest day), is not
      // persisted as a workout.
      if (matched.isEmpty) continue;

      final workout =
          await repositoryWorkout.createWorkout(userId: userId, name: name);
      for (final exercise in matched) {
        await repositoryWorkout.addExerciseToWorkout(
          workoutId: workout.id,
          exerciseId: exercise.id,
          userId: userId,
        );
      }
      created.add({
        'name': name,
        'exercises': matched.map((e) => e.name).toList(),
      });
    }

    return {
      'status': created.isEmpty ? 'error' : 'saved',
      'created': created,
      'unmatched': unmatched,
      'display_message': _buildPlanSummary(created, unmatched),
    };
  }

  String _buildPlanSummary(
    List<Map<String, dynamic>> created,
    List<String> unmatched,
  ) {
    if (created.isEmpty) {
      return "I couldn't match those exercises to the catalog. Try asking "
          'again with more common exercise names.';
    }
    final buffer = StringBuffer("Here's your week:\n");
    for (final workout in created) {
      buffer.writeln('\n${workout['name']}:');
      for (final exercise in workout['exercises'] as List) {
        buffer.writeln('• $exercise');
      }
    }
    if (unmatched.isNotEmpty) {
      buffer.writeln("\nI couldn't add: ${unmatched.join(', ')}.");
    }
    buffer.writeln('\nSets, reps and rest are in my notes above.');
    return buffer.toString();
  }
}
