// lib/features/ai/blocs/bloc_chat/chat_state.dart
part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.isGenerating = false,
    this.isReady = false,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final bool isGenerating;
  final bool isReady;
  final String? errorMessage;

  @override
  List<Object?> get props => [messages, isGenerating, isReady, errorMessage];

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isGenerating,
    bool? isReady,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
      isReady: isReady ?? this.isReady,
      errorMessage: errorMessage,
    );
  }
}
