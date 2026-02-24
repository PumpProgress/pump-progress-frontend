import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/sync/repository/repository_sync.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final RepositorySync repositorySync;
  SyncBloc({required this.repositorySync}) : super(SyncState()) {
    on<StartSyncEvent>(_onStartSyncEvent);
  }

  Future<void> _onStartSyncEvent(
      StartSyncEvent event, Emitter<SyncState> emit) async {
    await runSafeEvent(emit, state, SyncBlocStatusError.new, () async {
      emit(state.copyWith(status: SyncBlocStatusInProgress()));
      await repositorySync.syncTables();
      emit(state.copyWith(status: SyncBlocStatusSuccess()));
    });
  }
}
