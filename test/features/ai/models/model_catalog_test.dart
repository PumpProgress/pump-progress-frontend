// test/features/ai/models/model_catalog_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/ai/models/model_catalog.dart';

void main() {
  test('catalog is non-empty and has unique ids', () {
    expect(kModelCatalog, isNotEmpty);
    final ids = kModelCatalog.map((m) => m.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('every catalog entry has a network url and a positive size', () {
    for (final m in kModelCatalog) {
      expect(m.url, startsWith('http'));
      expect(m.id, isNotEmpty);
      expect(m.displayName, isNotEmpty);
      expect(m.sizeBytes, greaterThan(0));
    }
  });
}
