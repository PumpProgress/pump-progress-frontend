class SyncResult {
  const SyncResult({required this.totalReceived, required this.totalSent});

  final int totalReceived;
  final int totalSent;

  bool get hasData => totalReceived > 0 || totalSent > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyncResult &&
        other.totalReceived == totalReceived &&
        other.totalSent == totalSent;
  }

  @override
  int get hashCode => totalReceived.hashCode ^ totalSent.hashCode;
}

class SyncPostResult {
  const SyncPostResult({required this.sent, required this.received});

  final int sent;
  final int received;
}
