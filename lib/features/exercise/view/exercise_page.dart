import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/bloc/exercise_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/view/sets_list.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key, required this.exerciseId});

  final String exerciseId;

  static const routeName = '/exercises';

  @override
  Widget build(BuildContext context) {
    print(exerciseId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pump Progress'),
      ),
      body: BlocProvider(
        create: (context) => ExerciseBloc(
          pumpProgressRepository: context.read<PumpProgressRepository>(),
        )..add(LoadSeriesByExercise(exerciseId)),
        child: BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, state) {
            if (state.status == ExerciseStatus.loading) {
              return const LoadingPage();
            }
            return Container(
              child: SetsList(sets: state.sets),
            );
          },
        ),
      ),
    );
  }
}
