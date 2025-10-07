import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/data/sqlite/index.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  SyncBloc({required this.pumpProgressRepository}) : super(SyncState()) {
    on<StartSyncEvent>(_onStartSyncEvent);
  }
  final PumpProgressRepository pumpProgressRepository;

  Future<void> _onStartSyncEvent(
      StartSyncEvent event, Emitter<SyncState> emit) async {
    emit(SyncState(status: SyncStatus.inProgress));
    final path = await DatabaseHelper.instance.getDatabasePath;
    print('Database path: $path');

    // final lastChange = await DatabaseHelper.instance.getLastCategoryChange();
    final lastChange = null;

    // * CATEGORIES ----------------------------------
    final categories = await pumpProgressRepository.getRowsCategories(
        since: lastChange != null
            ? DateTime.fromMillisecondsSinceEpoch(lastChange).toIso8601String()
            : null);
    await DatabaseHelper.instance.insertCategories(categories);

    // * MUSCLES ----------------------------------
    final muscles = await pumpProgressRepository.getRowsMuscles(
        since: lastChange != null
            ? DateTime.fromMillisecondsSinceEpoch(lastChange).toIso8601String()
            : null);
    await DatabaseHelper.instance.insertMuscles(muscles);

    // * EQUIPMENT ----------------------------------
    final equipment = await pumpProgressRepository.getRowsEquipment(
        since: lastChange != null
            ? DateTime.fromMillisecondsSinceEpoch(lastChange).toIso8601String()
            : null);
    await DatabaseHelper.instance.insertEquipment(equipment);

    // * EXERCISES ----------------------------------
    final exercises = await pumpProgressRepository.getRowsExercises(
        since: lastChange != null
            ? DateTime.fromMillisecondsSinceEpoch(lastChange).toIso8601String()
            : null);
    await DatabaseHelper.instance.insertExercises(exercises);

    // * SECONDARY MUSCLES ----------------------------------
    final secondaryMuscles =
        await pumpProgressRepository.getRowsSecondaryMuscles(
            since: lastChange != null
                ? DateTime.fromMillisecondsSinceEpoch(lastChange)
                    .toIso8601String()
                : null);
    await DatabaseHelper.instance.insertSecondaryMuscles(secondaryMuscles);

    print('Fetched categories: $categories');

    await Future.delayed(const Duration(seconds: 2));
    emit(SyncState(status: SyncStatus.success));
  }
}
