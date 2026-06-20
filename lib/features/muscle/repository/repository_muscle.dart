import 'package:pump_progress_frontend/features/muscle/domain/domain.dart';
import 'package:pump_progress_frontend/features/muscle/local/local.dart';

// todo small table, we should have a cache layer for this
// todo and only hit the db once per session

class ProviderMuscle {
  final LocalMuscle localMuscle = LocalMuscle();

  Future<List<Muscle>> getMuscles() async {
    final muscleRows = await localMuscle.getMuscles();
    final muscles = muscleRows
        .map((muscleRow) => Muscle.fromMap(muscleRow.toMap()))
        .toList();
    return muscles;
  }

  Future<Muscle> getMuscle({required int muscleId}) async {
    final muscleRows = await localMuscle.getMuscles();
    final muscleRow =
        muscleRows.firstWhere((muscleRow) => muscleRow.id == muscleId);
    return Muscle.fromMap(muscleRow.toMap());
  }
}
