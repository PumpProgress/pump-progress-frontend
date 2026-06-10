/// Formats app version for display, e.g. "4.1.0 (29)".
/// Falls back to just the version when [buildNumber] is empty.
String formatAppVersion(String version, String buildNumber) {
  if (buildNumber.isEmpty) return version;
  return '$version ($buildNumber)';
}
