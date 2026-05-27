part of 'gemma_model_bloc.dart';

sealed class GemmaModelStatus {
  const GemmaModelStatus();
}

class GemmaModelStatusInitial implements GemmaModelStatus {
  const GemmaModelStatusInitial();
}

class GemmaModelStatusInstalling implements GemmaModelStatus {
  const GemmaModelStatusInstalling();
}

class GemmaModelStatusReady implements GemmaModelStatus {
  const GemmaModelStatusReady();
}

class GemmaModelStatusError extends ErrorStatus implements GemmaModelStatus {
  GemmaModelStatusError(super.errorMsg);
}

class GemmaModelState extends Equatable {
  const GemmaModelState({
    this.status = const GemmaModelStatusInitial(),
    this.downloadProgress = 0,
  });

  final GemmaModelStatus status;
  final int downloadProgress;

  @override
  List<Object> get props => [status, downloadProgress];

  GemmaModelState copyWith({
    GemmaModelStatus? status,
    int? downloadProgress,
  }) {
    return GemmaModelState(
      status: status ?? this.status,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}
