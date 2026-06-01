// lib/features/ai/blocs/bloc_chat/chat_event.dart
part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String prompt;
  const SendMessageEvent(this.prompt);

  @override
  List<Object> get props => [prompt];
}

// Internal — fired when GemmaModelService reports model ready.
class _ChatModelReadyEvent extends ChatEvent {
  final InferenceModel model;
  const _ChatModelReadyEvent(this.model);

  @override
  List<Object> get props => [model];
}
