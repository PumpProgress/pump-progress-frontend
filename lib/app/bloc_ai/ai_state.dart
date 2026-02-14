part of 'ai_bloc.dart';

// enum AiStatus { uninitiated, installing, loaded, error }
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
  const AiState({this.status = const AiStatusInitial()});

  @override
  List<Object> get props => [status];
  final AiStatus status;

  AiState copyWith({
    AiStatus? status,
  }) {
    return AiState(
      status: status ?? this.status,
    );
  }
}
