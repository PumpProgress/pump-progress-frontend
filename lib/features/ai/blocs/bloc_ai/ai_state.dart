part of 'ai_bloc.dart';

sealed class AiStatus {
  const AiStatus();
}

class AiStatusInitial implements AiStatus {
  const AiStatusInitial();
}

class AiStatusInstalling implements AiStatus {
  const AiStatusInstalling();
}

class AiStatusLoaded implements AiStatus {
  const AiStatusLoaded();
}

class AiStatusError extends ErrorStatus implements AiStatus {
  AiStatusError(super.errorMsg);
}

class AiState extends Equatable {
  const AiState({
    this.status = const AiStatusInitial(),
    this.messages = const [],
    this.isGenerating = false,
    this.downloadProgress = 0,
  });

  final AiStatus status;
  final List<ChatMessage> messages;
  final bool isGenerating;
  final int downloadProgress;

  @override
  List<Object> get props => [status, messages, isGenerating, downloadProgress];

  AiState copyWith({
    AiStatus? status,
    List<ChatMessage>? messages,
    bool? isGenerating,
    int? downloadProgress,
  }) {
    return AiState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}
