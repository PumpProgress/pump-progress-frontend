import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';

class ExerciseSeriesItemWidget extends StatelessWidget {
  const ExerciseSeriesItemWidget({
    super.key,
    required this.weight,
    required this.reps,
    required this.date,
  });

  final double weight;
  final int reps;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMM');
    String monthInString = formatter.format(DateTime(date.year, date.month));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.00, vertical: 8.00),
      padding: const EdgeInsets.symmetric(horizontal: 16.00, vertical: 8.00),
      height: 84,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: PumpProgressColors.coral,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(
                  date.day.toString(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$monthInString.'),
                    Text(date.year.toString())
                  ],
                )
              ],
            ),
          ),
          const VerticalDivider(
            color: PumpProgressColors.coral,
            // width: 2,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weight.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Text('kgs.')
              ],
            ),
          ),
          const VerticalDivider(
            color: PumpProgressColors.coral,
            // width: 2,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  reps.toString(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Text('reps')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
