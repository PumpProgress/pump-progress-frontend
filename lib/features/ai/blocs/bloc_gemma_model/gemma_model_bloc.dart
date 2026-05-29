import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'gemma_model_event.dart';
part 'gemma_model_state.dart';

class GemmaModelBloc extends Bloc<GemmaModelEvent, GemmaModelState> {
  GemmaModelBloc({required GemmaModelService modelService})
      : _modelService = modelService,
        super(const GemmaModelState()) {
    on<GemmaModelInitEvent>(_onInit);
  }

  final GemmaModelService _modelService;

  Future<void> _onInit(
    GemmaModelInitEvent event,
    Emitter<GemmaModelState> emit,
  ) async {
    try {
      emit(state.copyWith(status: const GemmaModelStatusInstalling()));
      await _modelService.initialize(
        onProgress: (progress) {
          emit(state.copyWith(downloadProgress: progress));
        },
      );
      emit(state.copyWith(
        status: const GemmaModelStatusReady(),
        downloadProgress: 100,
      ));
    } catch (e) {
      emit(state.copyWith(status: GemmaModelStatusError(e.toString())));
    }
  }
}
