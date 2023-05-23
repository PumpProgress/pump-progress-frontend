import 'package:hive/hive.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';

class HiveStorage {
  factory HiveStorage() {
    return _instance;
  }
  HiveStorage._privateConstructor();

  static final HiveStorage _instance = HiveStorage._privateConstructor();
  static late Box<String>? authBox;
  static late Box<Exercise>? exerciseBox;

  Future<void> init() async {
    Hive.registerAdapter<Exercise>(ExerciseAdapter());
    authBox = await Hive.openBox<String>('auth');
    exerciseBox = await Hive.openBox<Exercise>('exercises');
  }

  // @override
  // Future<void> delete(String key) {
  //   box!.delete(key);
  //   return Future<void>.value();
  // }

  // @override
  // Future<String>? read(String key) {
  //   try {
  //     final response = box!.get(key);
  //     return response == null ? null : Future<String>.value(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // @override
  // Future<void> write(String key, String value) {
  //   box!.put(key, value);
  //   return Future<void>.value();
  // }
}
