import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_profile_chat/profile_chat_bloc.dart';
import 'package:pump_progress_frontend/screens/ai/widgets/ai_chat_scaffold.dart';

class ProfileChatView extends StatelessWidget {
  const ProfileChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AiChatScaffold<ProfileChatBloc>(title: 'Complete Profile');
  }
}
