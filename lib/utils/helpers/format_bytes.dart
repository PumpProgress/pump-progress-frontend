// lib/utils/helpers/format_bytes.dart

/// Formats a byte count into a human-readable string (B / KB / MB / GB).
/// Sub-KB values show no decimals; KB and above show one decimal.
String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  const units = ['KB', 'MB', 'GB', 'TB'];
  double value = bytes / 1024;
  var unitIndex = 0;
  while (value >= 1024 && unitIndex < units.length - 1) {
    value /= 1024;
    unitIndex++;
  }
  return '${value.toStringAsFixed(1)} ${units[unitIndex]}';
}
