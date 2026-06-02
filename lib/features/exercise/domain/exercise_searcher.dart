import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:pump_progress_frontend/features/exercise/domain/exercise.dart';

/// Field-aware fuzzy search over an in-memory exercise catalog.
///
/// Name and machine `code` tokens dominate scoring; muscle, equipment, and
/// mechanic are weak tie-breaking signals. Alias tiers are wired but inert
/// until alias data exists (defaults to an empty list on [Exercise]).
class ExerciseSearcher {
  ExerciseSearcher(this._exercises);

  final List<Exercise> _exercises;

  List<Exercise> search(String rawQuery, {int limit = 15}) {
    final query = _normalize(rawQuery);
    if (query.isEmpty || query.length < 2) return [];

    final scored = _exercises
        .map((ex) => (exercise: ex, score: _score(query, ex)))
        .where((r) => r.score > 40)
        .toList();

    scored.sort((a, b) {
      final cmp = b.score.compareTo(a.score);
      return cmp != 0 ? cmp : a.exercise.id.compareTo(b.exercise.id);
    });
    return scored.take(limit).map((r) => r.exercise).toList();
  }

  int _score(String query, Exercise ex) {
    final name = _normalize(ex.name);

    // Tier 1: exact and prefix matches dominate.
    if (name == query) return 100;
    if (ex.aliases.any((a) => _normalize(a) == query)) return 99;
    if (name.startsWith(query)) return 95;
    if (ex.aliases.any((a) => _normalize(a).startsWith(query))) return 92;

    // Tier 2: token fuzzy on name (handles reordering: "press bench").
    final nameScore = tokenSetRatio(query, name);

    // Tier 2b: code tokens as a machine-friendly second name.
    final codeText = ex.codeTokens.join(' '); // "barbell bench press"
    final codeScore = tokenSetRatio(query, codeText);

    // Tier 3: best alias fuzzy (inert until alias data exists).
    final aliasScore = ex.aliases.isEmpty
        ? 0
        : ex.aliases
            .map((a) => tokenSetRatio(query, _normalize(a)))
            .reduce((a, b) => a > b ? a : b);

    // Tier 4: weak signals.
    final muscleScore = ex.muscles.isEmpty
        ? 0
        : ex.muscles
                .map((m) => partialRatio(query, _normalize(m)))
                .reduce((a, b) => a > b ? a : b) ~/
            2;
    final equipScore =
        (partialRatio(query, _normalize(ex.equipment ?? '')) * 0.3).round();
    final mechanicScore =
        (partialRatio(query, _normalize(ex.mechanic ?? '')) * 0.2).round();

    // Substring bonus applies only to strong (name/code/alias) signals.
    final containsBonus = name.contains(query) ? 15 : 0;
    final strongScore =
        [nameScore, codeScore, aliasScore].reduce((a, b) => a > b ? a : b) +
            containsBonus;
    final weakScore = [muscleScore, equipScore, mechanicScore]
        .reduce((a, b) => a > b ? a : b);

    return strongScore > weakScore ? strongScore : weakScore;
  }

  String _normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
