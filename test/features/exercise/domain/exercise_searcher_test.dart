import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';

void main() {
  const benchPress = Exercise(
    id: 1,
    code: 'barbell_bench_press',
    name: 'Barbell Bench Press',
    category: 'Chest',
    muscles: ['Chest', 'Triceps'],
    equipment: 'Barbell',
    mechanic: 'compound',
  );
  const inclineCurl = Exercise(
    id: 2,
    code: 'db_incline_curl',
    name: 'Dumbbell Incline Curl',
    category: 'Arms',
    muscles: ['Biceps'],
    equipment: 'Dumbbell',
    mechanic: 'isolation',
  );
  const squat = Exercise(
    id: 3,
    code: 'barbell_back_squat',
    name: 'Barbell Back Squat',
    category: 'Legs',
    muscles: ['Quadriceps', 'Glutes'],
    equipment: 'Barbell',
    mechanic: 'compound',
  );

  final searcher = ExerciseSearcher([benchPress, inclineCurl, squat]);

  test('empty query returns empty list', () {
    expect(searcher.search(''), isEmpty);
    expect(searcher.search('   '), isEmpty);
  });

  test('exact name match ranks first', () {
    final results = searcher.search('Barbell Bench Press');
    expect(results.first, benchPress);
  });

  test('prefix match surfaces the exercise', () {
    final results = searcher.search('bench');
    expect(results, contains(benchPress));
    expect(results.first, benchPress);
  });

  test('reordered tokens still match', () {
    final results = searcher.search('press bench');
    expect(results.first, benchPress);
  });

  test('typo tolerance', () {
    final results = searcher.search('bemch pres');
    expect(results, contains(benchPress));
  });

  test('code tokens match equipment-led query', () {
    final results = searcher.search('barbell bench');
    expect(results.first, benchPress);
  });

  test('unrelated query below threshold returns nothing', () {
    expect(searcher.search('zzzzzz'), isEmpty);
  });

  test('respects the limit', () {
    final results = searcher.search('barbell', limit: 1);
    expect(results.length, 1);
  });
}
