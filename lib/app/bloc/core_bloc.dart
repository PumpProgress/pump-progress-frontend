import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pump_progress_frontend/repositories/models/user.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'core_event.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  CoreBloc() : super(CoreInitial()) {
    on<CoreEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  void _onCoreInit(CoreInit event, Emitter<CoreState> emit) {}
}
