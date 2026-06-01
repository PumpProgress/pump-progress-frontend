// lib/features/ai/blocs/bloc_workout_builder_chat/workout_builder_chat_bloc.dart
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';

class WorkoutBuilderChatBloc extends BaseChatBloc {
  WorkoutBuilderChatBloc({
    required super.modelService,
    required AiToolDispatcher toolDispatcher,
  }) : _toolDispatcher = toolDispatcher;

  final AiToolDispatcher _toolDispatcher;

  @override
  String get systemPrompt =>
      'You are a fitness assistant helping the user build a custom workout plan. '
      'Use the available tools to find exercises by muscle group. '
      'Be specific about sets, reps, and rest periods when recommending workouts.';

  @override
  List<Tool> get tools => _toolDispatcher.tools;

  @override
  AiToolDispatcher get toolDispatcher => _toolDispatcher;
}
