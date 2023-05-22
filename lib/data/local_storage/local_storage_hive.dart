import 'package:hive/hive.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage.dart';
import 'package:pump_progress_frontend/utils/helpers/general_exception.dart';

class HiveStorage implements LocalStorage {
  factory HiveStorage() {
    return _instance;
  }
  HiveStorage._privateConstructor();

  static final HiveStorage _instance = HiveStorage._privateConstructor();

  static late Box? box;

  Future<void> init() async {
    box = await Hive.openBox<String>('auth');
  }

  @override
  Future<void> delete(String key) {
    box!.delete(key);
    return Future<void>.value();
  }

  @override
  Future<String>? read(String key) {
    try {
      final response = box!.get(key) as String?;
      return response == null ? null : Future<String>.value(response);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> write(String key, String value) {
    box!.put(key, value);
    return Future<void>.value();
  }
}
