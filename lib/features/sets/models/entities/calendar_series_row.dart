class CalendarSeriesRow {
  final String date;
  final int totalSets;
  final int totalReps;
  final double totalVolume;

  CalendarSeriesRow({
    required this.date,
    required this.totalSets,
    required this.totalReps,
    required this.totalVolume,
  });

  factory CalendarSeriesRow.fromDB(Map<String, dynamic> row) {
    return CalendarSeriesRow(
      date: row['date'] as String,
      totalSets: row['totalSets'] as int,
      totalReps: row['totalReps'] as int,
      totalVolume: (row['totalVolume'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toDB() {
    return {
      'date': date,
      'totalSets': totalSets,
      'totalReps': totalReps,
      'totalVolume': totalVolume,
    };
  }

  @override
  String toString() {
    return 'CalendarSeriesRow(date: $date, totalSets: $totalSets, totalReps: $totalReps, totalVolume: $totalVolume)';
  }
}
