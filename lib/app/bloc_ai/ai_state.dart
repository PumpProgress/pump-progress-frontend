part of 'ai_bloc.dart';

enum AiStatus { uninitiated, installing, loaded, error }

class AiState extends Equatable {
  const AiState({this.status = AiStatus.uninitiated});

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
