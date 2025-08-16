import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/features/exercise/bloc/exercise_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/view/button_add_seriers.dart';
import 'package:pump_progress_frontend/features/exercise/view/series_timer.dart';
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
        // TODO: send core state to the bloc ?? think to refactor
        coreState: context.read<CoreBloc>().state,
      )..add(LoadSeriesByExercise(
          exerciseId: exerciseId,
          exerciseName: exerciseName,
        )),
      child: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          void saveExercise(int repetitions, double weight) {
            try {
              final exerciseBloc = context.read<ExerciseBloc>();
              exerciseBloc.add(
                AddNewSeries(
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
            // app bar eith button to go to analytics page
            appBar: AppBar(
              title: Text(
                exerciseName,
                // style: PPFontStyles.h5.copyWith(color: PPColors.amethyst100),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.analytics),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/exercises/analytics',
                      arguments: ExercisesPageArguments(
                        exerciseId: exerciseId,
                        exerciseName: exerciseName,
                      ),
                    );
                  },
                ),
              ],
            ),
            // floatingActionButton:
            //     FloatingActionButtonNewSeries(saveExercise: saveExercise),
            body: Container(
              child: (state.status == ExerciseStatus.loading)
                  ? const LoadingPage()
                  : Column(
                      spacing: 8,
                      children: [
                        SeriesTimer(
                            startTime: state.sets.isNotEmpty
                                ? state.sets.first.createdAt
                                : null),
                        ButtonAddSeries(saveExercise: saveExercise),
                        SetsList(sets: state.sets),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
