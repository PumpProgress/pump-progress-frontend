import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';
import 'package:pump_progress_frontend/screens/exercise/view/exercise_series_item.dart';

import 'package:table_calendar/table_calendar.dart';

class SetsList extends StatelessWidget {
  const SetsList({
    super.key,
    required this.sets,
  });

  final List<Series> sets;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // TODO: this list should be paginated
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: (sets.length),
          itemBuilder: (context, index) {
            final series = sets[index];
            final haveBottomBorder = index < sets.length - 1 &&
                !isSameDay(series.createdAt, sets[index + 1].createdAt);
            return ExerciseSeriesItemWidget(
              series: series,
              haveBottomBorder: haveBottomBorder,
            );
          },
        ),
      ),
    );
  }
}
