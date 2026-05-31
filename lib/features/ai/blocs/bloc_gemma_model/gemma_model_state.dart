// lib/features/ai/blocs/bloc_gemma_model/gemma_model_state.dart
part of 'gemma_model_bloc.dart';

sealed class GemmaModelStatus {
  const GemmaModelStatus();
}

class GemmaModelStatusInitial implements GemmaModelStatus {
  const GemmaModelStatusInitial();
}

/// Restoring a persisted selection at startup.
class GemmaModelStatusLoading implements GemmaModelStatus {
  const GemmaModelStatusLoading();
}

class GemmaModelStatusReady implements GemmaModelStatus {
  const GemmaModelStatusReady();
}

/// No active model — user must pick/download one on the Models page.
class GemmaModelStatusNoModel implements GemmaModelStatus {
  const GemmaModelStatusNoModel();
}

class GemmaModelStatusError extends ErrorStatus implements GemmaModelStatus {
  GemmaModelStatusError(super.errorMsg);
}

class GemmaModelState extends Equatable {
  const GemmaModelState({this.status = const GemmaModelStatusInitial()});

  final GemmaModelStatus status;

  @override
  List<Object> get props => [status];

  GemmaModelState copyWith({GemmaModelStatus? status}) {
    return GemmaModelState(status: status ?? this.status);
  }
}
