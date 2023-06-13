import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/bloc/exercise_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/view/floating_action_button_new_series.dart';
import 'package:pump_progress_frontend/features/exercise/view/sets_list.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key, required this.exerciseId});

  final String exerciseId;

  static const routeName = '/exercises';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseBloc(
        pumpProgressRepository: context.read<PumpProgressRepository>(),
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
              title: const Text('Pump Progress'),
            ),
            floatingActionButton:
                FloatingActionButtonNewSeries(saveExercise: saveExercise),
            body: Container(
              child: (state.status == ExerciseStatus.loading)
                  ? const LoadingPage()
                  : Container(
                      child: SetsList(sets: state.sets),
                    ),
            ),
          );
        },
      ),
    );
  }
}
