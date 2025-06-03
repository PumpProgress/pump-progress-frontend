import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
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
    void updateExercise(int repetitions, double weight) {
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

    void saveExercise(int repetitions, double weight) {
      try {
        final exerciseBloc = context.read<ExerciseBloc>();
        exerciseBloc.add(
          AddNewSeries(
            exerciseId: exerciseBloc.state.exerciseId,
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
                saveExercise: updateExercise,
                initialReps: series.repetitions.toString(),
                initialWeight: series.weight.toString(),
              )),
      child: Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            autoClose: true,
            // borderRadius:
            //     const BorderRadius.horizontal(right: Radius.circular(8)),
            onPressed: (context) {
              final exerciseBloc = context.read<ExerciseBloc>();
              exerciseBloc.add(
                AddNewSeries(
                  exerciseId: exerciseBloc.state.exerciseId,
                  repetitions: series.repetitions,
                  weight: series.weight,
                ),
              );
            },
            backgroundColor: PPColors.coral200,
            foregroundColor: Colors.white,
            icon: Icons.exposure_plus_1_outlined,
            // label: 'x2',
          ),
          SlidableAction(
            autoClose: true,
            // borderRadius:
            //     const BorderRadius.horizontal(right: Radius.circular(8)),
            onPressed: (context) => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) => ModalBottomSheetSaveExercise(
                saveExercise: saveExercise,
                initialReps: series.repetitions.toString(),
                initialWeight: series.weight.toString(),
              ),
            ),
            backgroundColor: PPColors.coral300,
            foregroundColor: Colors.white,
            icon: Icons.copy_rounded,
            // label: 'New',
          ),
          SlidableAction(
            autoClose: true,
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(8)),
            onPressed: (context) {
              final exerciseBloc = context.read<ExerciseBloc>();
              exerciseBloc.add(DeleteSeries(series.id));
            },
            backgroundColor: PPColors.coral500,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            // label: 'x2',
          ),
        ]),
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
                      style: TextTheme.of(context)
                          .displayMedium
                          ?.copyWith(color: PPColors.coral300),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$monthInString.',
                            style: TextTheme.of(context).labelSmall),
                        Text(
                          series.createdAt.year.toString(),
                          style: TextTheme.of(context).labelSmall,
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
                      style: TextTheme.of(context)
                          .displaySmall
                          ?.copyWith(color: PPColors.coral300),
                    ),
                    Text(
                      'kgs.',
                      style: TextTheme.of(context).labelSmall,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(series.repetitions.toString(),
                        style: TextTheme.of(context)
                            .displaySmall
                            ?.copyWith(color: PPColors.coral300)),
                    Text(
                      'reps',
                      style: TextTheme.of(context).labelSmall,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
