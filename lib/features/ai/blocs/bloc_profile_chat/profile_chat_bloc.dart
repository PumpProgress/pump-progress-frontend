// lib/features/ai/blocs/bloc_profile_chat/profile_chat_bloc.dart
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';

class ProfileChatBloc extends BaseChatBloc {
  ProfileChatBloc({required super.modelService});

  @override
  String get systemPrompt =>
      'You are a fitness assistant helping the user complete their fitness profile. '
      'Ask concise questions about their fitness goals, experience level, and any health conditions. '
      'Be friendly and encouraging.';

  @override
  List<Tool> get tools => const [];

  @override
  AiToolDispatcher? get toolDispatcher => null;
}
