import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/features/exercise/view/button_add_seriers.dart';
import 'package:pump_progress_frontend/features/exercise/view/exercise_series_item.dart';
import 'package:pump_progress_frontend/repositories/models/series.dart';
import 'package:table_calendar/table_calendar.dart';

class SetsList extends StatelessWidget {
  const SetsList({
    super.key,
    required this.sets,
    required this.saveExercise,
  });

  final List<Series> sets;
  final void Function(int, double) saveExercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: (sets.length + 1),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ButtonAddSeries(saveExercise: saveExercise);
          }
          final series = sets[index - 1];
          final haveBottomBorder = index <= sets.length - 1 &&
              !isSameDay(series.createdAt, sets[index].createdAt);

          return ExerciseSeriesItemWidget(
            series: series,
            haveBottomBorder: haveBottomBorder,
          );
        },
      ),
    );
  }
}
