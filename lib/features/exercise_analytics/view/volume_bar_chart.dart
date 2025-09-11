import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/repositories/models/index.dart';

class WorkoutVolumeBarChart extends StatelessWidget {
  final List<ExerciseAnalytics> rawData;

  const WorkoutVolumeBarChart({super.key, required this.rawData});

  // Get the date range for the last 3 months
  DateTime get _endDate => DateTime.now();
  DateTime get _startDate {
    if (rawData.isEmpty) {
      return DateTime.now().subtract(const Duration(days: 91));
    }
    // Use the earliest date from raw data
    final earliestRawDate = rawData
        .map((e) => DateTime.parse(e.date))
        .reduce((a, b) => a.isBefore(b) ? a : b);

    // But don't go back more than 91 days
    final maxStartDate = DateTime.now().subtract(const Duration(days: 91));
    return earliestRawDate.isBefore(maxStartDate)
        ? maxStartDate
        : earliestRawDate;
  }

  // Create a map of date strings to session volumes for quick lookup
  Map<String, double> get _dataMap {
    final map = <String, double>{};
    for (final entry in rawData) {
      final dateKey =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(entry.date));
      map[dateKey] = entry.sessionVolume;
    }
    return map;
  }

  // Generate all days in the 3-month range
  List<DateTime> get _allDates {
    final dates = <DateTime>[];
    var current = _startDate;
    while (current.isBefore(_endDate) || current.isAtSameMomentAs(_endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }
    return dates;
  }

  // Get the maximum session volume to determine Y-axis range
  double get _maxVolume {
    if (rawData.isEmpty) return 100;
    return rawData.map((e) => e.sessionVolume).reduce((a, b) => a > b ? a : b);
  }

  // Calculate appropriate interval for Y-axis based on data range
  double get _yAxisInterval {
    final max = _maxVolume;
    // Increased intervals to prevent overlapping with larger font size
    if (max <= 100) return 25;
    if (max <= 500) return 125;
    if (max <= 1000) return 250;
    if (max <= 2000) return 500;
    if (max <= 5000) return 1000;
    return 1000;
  }

  // Get positions of the 1st of each month for vertical lines
  List<double> get _monthStartPositions {
    final positions = <double>[];
    final allDates = _allDates;

    // Find all month boundaries within the date range
    DateTime? lastMonth;
    for (int i = 0; i < allDates.length; i++) {
      final currentDate = allDates[i];

      // Check if we've entered a new month
      if (lastMonth == null ||
          currentDate.month != lastMonth.month ||
          currentDate.year != lastMonth.year) {
        positions.add(i.toDouble());
        lastMonth = currentDate;
      }
    }

    return positions;
  }

  List<BarChartGroupData> get _barGroups {
    final allDates = _allDates;
    final bars = <BarChartGroupData>[];

    // Add an empty slot at the beginning for padding
    bars.add(
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: 0,
            color: Colors.transparent,
            width: 3,
          ),
        ],
      ),
    );

    // Add actual data bars (shifted by 1 index)
    bars.addAll(allDates.asMap().entries.map((entry) {
      final index = entry.key + 1; // Shift by 1 to account for empty slot
      final date = entry.value;
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final volume = _dataMap[dateKey] ?? 0.0; // 0 if no workout on this day

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: volume,
            color: volume > 0
                ? PPColors.amethyst300
                : Colors.transparent, // Custom purple color
            width: 3, // Slightly wider bars for better visibility
            borderRadius: BorderRadius.circular(1),
          ),
        ],
        barsSpace: 0.5, // Add space between bars
      );
    }));

    return bars;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Volume by day [Kg x Reps]',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: PPColors.neutral100,
                ),
          ),
        ),
        // Chart container
        Container(
          height: 280, // Fixed height - about 1/3 of typical screen
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              BarChart(
                BarChartData(
                  minY: 0,
                  baselineY: 0,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 64,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final allDates = _allDates;
                          final adjustedIndex = value.toInt() -
                              1; // Account for empty slot at index 0
                          if (adjustedIndex < 0 ||
                              adjustedIndex >= allDates.length) {
                            return const SizedBox.shrink();
                          }

                          final date = allDates[adjustedIndex];
                          final dateKey = DateFormat('yyyy-MM-dd').format(date);
                          final hasWorkout = _dataMap[dateKey] != null &&
                              _dataMap[dateKey]! > 0;

                          // Show day number only for days with workout data
                          if (hasWorkout) {
                            return SideTitleWidget(
                              meta: meta,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('d')
                                      .format(date), // e.g., "15", "22"
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50, // Increased space for larger text
                        interval: _yAxisInterval,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              value
                                  .toInt()
                                  .toString(), // Show raw number without formatting
                              style: const TextStyle(
                                fontSize: 14, // Increased from 10 to 14
                                fontWeight:
                                    FontWeight.w500, // Added some weight
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final allDates = _allDates;
                          final adjustedIndex = value.toInt() -
                              1; // Account for empty slot at index 0
                          if (adjustedIndex < 0 ||
                              adjustedIndex >= allDates.length) {
                            return const SizedBox.shrink();
                          }

                          final date = allDates[adjustedIndex];

                          // Show month name on 1st day of month (regardless of workout data)
                          if (date.day == 1) {
                            return SideTitleWidget(
                              meta: meta,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  DateFormat('MMM')
                                      .format(date), // e.g., "Jan", "Feb"
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false, // Disable vertical lines
                    horizontalInterval: _yAxisInterval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  barGroups: _barGroups,
                ),
              ),
              // Custom overlay for vertical lines
              CustomPaint(
                size: Size.infinite,
                painter: MonthLinesPainter(
                  monthPositions: _monthStartPositions
                      .map((pos) => pos + 1)
                      .toList(), // Shift positions by 1
                  totalDays: _allDates.length + 1, // Account for empty slot
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MonthLinesPainter extends CustomPainter {
  final List<double> monthPositions;
  final int totalDays;

  MonthLinesPainter({required this.monthPositions, required this.totalDays});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.6)
      ..strokeWidth = 0.8 // Made thinner (was 2)
      ..style = PaintingStyle.stroke;

    // Calculate the chart area (excluding padding and labels)
    const leftPadding = 80.0; // Space for Y-axis labels
    const rightPadding = 16.0;
    const topPadding = 32.0; // Space for top labels
    const bottomPadding = 64.0; // Space for bottom labels

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    for (final position in monthPositions) {
      // Calculate x position within the chart area
      final xRatio = position / (totalDays - 1);
      final x = leftPadding + (xRatio * chartWidth);

      // Draw vertical line from top to bottom of chart area
      canvas.drawLine(
        Offset(x, topPadding),
        Offset(x, topPadding + chartHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
