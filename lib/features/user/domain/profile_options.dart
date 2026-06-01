/// Canonical option sets for the editable profile fields. Shared by the profile
/// form (the dropdowns) and the AI profile dispatcher (the tool enums) so the
/// values saved by either path always match a dropdown item.
const genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
const fitnessLevelOptions = ['Beginner', 'Intermediate', 'Advanced'];
const primaryGoalOptions = [
  'Build muscle',
  'Lose weight',
  'Gain strength',
  'Improve endurance',
  'General fitness',
];

/// Maps a free-text [value] onto its canonical option from [options] using a
/// case-insensitive match. Returns the canonical spelling when matched, the
/// original [value] when not (callers/UI stay tolerant), or null for null.
String? canonicalizeOption(String? value, List<String> options) {
  if (value == null) return null;
  final trimmed = value.trim();
  for (final option in options) {
    if (option.toLowerCase() == trimmed.toLowerCase()) return option;
  }
  return trimmed;
}
