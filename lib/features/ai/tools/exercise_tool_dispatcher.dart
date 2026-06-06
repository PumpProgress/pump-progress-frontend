import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/ai/tools/tool_definition.dart';
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
}
