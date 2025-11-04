class PostSyncTable<T> {
  final String tableName;
  final Future<DateTime> Function() getLastSync;
  final Future<List<T>> Function() getDirtyRows;
  final Future<List<T>> Function(List<T>, DateTime) postSync;
  final Future<void> Function(List<T>) insertRows;
  final Future<void> Function(List<T>) markClean;
  final Future<List<T>> Function() readTable;

  PostSyncTable({
    required this.tableName,
    required this.getLastSync,
    required this.getDirtyRows,
    required this.postSync,
    required this.insertRows,
    required this.markClean,
    required this.readTable,
  });
}

class GetSyncTable<T> {
  final String tableName;
  final Future<List<T>> Function() readTable;
  final Future<void> Function(List<T>) insertRows;
  final Future<DateTime> Function() getLastSync;
  final Future<List<T>> Function(DateTime) getSync;

  GetSyncTable({
    required this.tableName,
    required this.readTable,
    required this.insertRows,
    required this.getLastSync,
    required this.getSync,
  });
}
