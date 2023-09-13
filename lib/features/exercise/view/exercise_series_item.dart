import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/features/exercise/bloc/exercise_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/view/modal_bottom_sheet_save_exercise.dart';
import 'package:pump_progress_frontend/repositories/models/series.dart';

class ExerciseSeriesItemWidget extends StatelessWidget {
  const ExerciseSeriesItemWidget({
    super.key,
    required this.series,
  });

  final Series series;

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
                    series.createdAt.day.toString(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$monthInString.'),
                      Text(series.createdAt.year.toString())
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
                    series.weight.toStringAsFixed(2),
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
                    series.repetitions.toString(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const Text('reps')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
