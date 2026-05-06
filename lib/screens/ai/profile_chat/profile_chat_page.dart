import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_ai/ai_bloc.dart';
import 'package:pump_progress_frontend/screens/ai/profile_chat/view/profile_chat_view.dart';

class ProfileChatPage extends StatelessWidget {
  const ProfileChatPage({super.key});

  static const routeName = '/ai/profile-chat';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AiBloc()..add(const AiInitEvent()),
      child: const ProfileChatView(),
    );
  }
}
