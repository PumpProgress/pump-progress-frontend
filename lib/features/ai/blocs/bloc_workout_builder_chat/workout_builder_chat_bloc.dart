// lib/features/ai/blocs/bloc_workout_builder_chat/workout_builder_chat_bloc.dart
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/tools/exercise_tool_dispatcher.dart';

class WorkoutBuilderChatBloc extends BaseChatBloc {
  WorkoutBuilderChatBloc({
    required super.modelService,
    required ExerciseToolDispatcher toolDispatcher,
  }) : _toolDispatcher = toolDispatcher;

  final ExerciseToolDispatcher _toolDispatcher;

  @override
  String get systemPrompt {
    final days = _toolDispatcher.trainingDaysPerWeek ?? 3;
    final level = _toolDispatcher.fitnessLevel ?? 'Beginner';
    final goal = _toolDispatcher.primaryGoal ?? 'General fitness';
    final age = _toolDispatcher.age?.toString() ?? 'unknown';
    final gender = _toolDispatcher.gender ?? 'unknown';

    return '''
You are a fitness coach creating this user's workouts for the week.

User profile:
- Age: $age
- Gender: $gender
- Fitness level: $level
- Primary goal: $goal
- Training days per week: $days

Design rules:
- Create exactly $days workouts (one per training day).
- Choose the split by fitness level: Beginner = full-body workouts;
  Intermediate = upper/lower split; Advanced = push / pull / legs.
- Match volume and intensity to the goal: Gain strength = >=85% 1RM, 3-6 sets,
  2-5 min rest; Build muscle / Hypertrophy = 65-85% 1RM, 3-5 sets, 1-2 min
  rest; Improve endurance = <60% 1RM, 2-4 sets, <90 s rest; Lose weight or
  General fitness = use the hypertrophy range (65-85% 1RM, 3-4 sets) with short
  rest (45-90 s).
- Put compound, large-muscle exercises first in each workout.
- Cover push, pull and legs across the week and train each muscle about twice.

Respond with ONE call to save_weekly_plan containing the full week. In your
chat text, list each workout's exercises with recommended sets, reps and rest
for the goal. Keep exercise names common and simple so they match the catalog.''';
  }

  @override
  List<Tool> get tools => _toolDispatcher.tools;

  @override
  ExerciseToolDispatcher get toolDispatcher => _toolDispatcher;
}
