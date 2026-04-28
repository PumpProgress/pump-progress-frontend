part of 'ai_bloc.dart';

sealed class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object> get props => [];
}

class AiInitEvent extends AiEvent {
  const AiInitEvent();
}

class SendPromptEvent extends AiEvent {
  final String prompt;
  const SendPromptEvent(this.prompt);
}
