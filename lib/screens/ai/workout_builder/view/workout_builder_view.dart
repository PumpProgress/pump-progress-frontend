import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_workout_builder_chat/workout_builder_chat_bloc.dart';
import 'package:pump_progress_frontend/screens/ai/widgets/ai_chat_scaffold.dart';

class WorkoutBuilderView extends StatelessWidget {
  const WorkoutBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AiChatScaffold<WorkoutBuilderChatBloc>(title: 'Build Workout');
  }
}
