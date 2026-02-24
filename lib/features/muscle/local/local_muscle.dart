import 'package:pump_progress_frontend/features/muscle/models/entities/entities.dart';
import 'package:pump_progress_frontend/utils/services/sql_database_service/sql_database_service.dart';

class LocalMuscle {
  final db = SqlDatabaseService.instance.database;

  Future<List<MuscleRow>> getMuscles() async {
    final database = await db;
    final musclesResult = await database.rawQuery('''SELECT * FROM muscles 
        WHERE deleted_at IS NULL 
        ''');
    return musclesResult.map((muscle) => MuscleRow.fromDB(muscle)).toList();
  }
}
