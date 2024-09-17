import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/config/constants/fonts.dart';

import 'package:pump_progress_frontend/features/exercise/bloc/exercise_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/view/sets_list.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  final String exerciseId;
  final String exerciseName;

  static const routeName = '/exercises';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseBloc(
        pumpProgressRepository: context.read<PumpProgressRepository>(),
        coreState: context.read<CoreBloc>().state,
      )..add(LoadSeriesByExercise(exerciseId)),
      child: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
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

          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(
                exerciseName,
                style: PPFontStyles.h5.copyWith(color: PPColors.amethyst100),
              ),
            ),
            // floatingActionButton:
            //     FloatingActionButtonNewSeries(saveExercise: saveExercise),
            body: Container(
              child: (state.status == ExerciseStatus.loading)
                  ? const LoadingPage()
                  : Container(
                      child: SetsList(
                          sets: state.sets, saveExercise: saveExercise),
                    ),
            ),
          );
        },
      ),
    );
  }
}
