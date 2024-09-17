import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/config/constants/fonts.dart';
import 'package:pump_progress_frontend/features/exercise/bloc/exercise_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/view/modal_bottom_sheet_save_exercise.dart';
import 'package:pump_progress_frontend/repositories/models/series.dart';

class ExerciseSeriesItemWidget extends StatelessWidget {
  const ExerciseSeriesItemWidget({
    super.key,
    required this.series,
    this.haveBottomBorder = false,
  });

  final Series series;
  final bool haveBottomBorder;

  @override
  Widget build(BuildContext context) {
    void saveExercise(int repetitions, double weight) {
      try {
        final exerciseBloc = context.read<ExerciseBloc>();
        exerciseBloc.add(
          EditSeries(
            seriesId: series.id,
            repetitions: repetitions,
            weight: weight,
          ),
        );
      } catch (e) {
        print(e);
      }
    }

    final DateFormat formatter = DateFormat('MMM');
    String monthInString = formatter
        .format(DateTime(series.createdAt.year, series.createdAt.month));

    return InkWell(
      onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) => ModalBottomSheetSaveExercise(
                saveExercise: saveExercise,
                initialReps: series.repetitions.toString(),
                initialWeight: series.weight.toString(),
              )),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        height: 84,
        decoration: BoxDecoration(
          border: haveBottomBorder
              ? const Border(
                  bottom: BorderSide(
                  width: 1,
                  color: PPColors.amethyst300,
                ))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Text(
                    series.createdAt.day.toString(),
                    style: PPFontStyles.h3.copyWith(color: PPColors.coral300),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$monthInString.',
                        style: PPFontStyles.small
                            .copyWith(color: PPColors.coral300),
                      ),
                      Text(
                        series.createdAt.year.toString(),
                        style: PPFontStyles.xSmall
                            .copyWith(color: PPColors.amethyst100),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    series.weight.toStringAsFixed(2),
                    style: PPFontStyles.h4.copyWith(color: PPColors.coral300),
                  ),
                  Text(
                    'kgs.',
                    style: PPFontStyles.xSmall
                        .copyWith(color: PPColors.amethyst100),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    series.repetitions.toString(),
                    style: PPFontStyles.h4.copyWith(color: PPColors.coral300),
                  ),
                  Text(
                    'reps',
                    style: PPFontStyles.xSmall
                        .copyWith(color: PPColors.amethyst100),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
