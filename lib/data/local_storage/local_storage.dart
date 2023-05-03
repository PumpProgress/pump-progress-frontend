abstract class LocalStorage {
  Future<void> write(LocalStorageKey key, String value);
  Future<String>? read(LocalStorageKey key);
  Future<void> delete(LocalStorageKey key);
}

enum LocalStorageKey { jwt }
