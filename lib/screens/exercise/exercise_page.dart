import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/features/sets/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/sets/repositories/repositories.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/screens/exercise/view/exercise_view.dart';

class PageExercise extends StatelessWidget {
  static const routeName = '/exercises';

  const PageExercise({
    super.key,
    required this.exerciseId,
  });

  final int exerciseId;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserSessionBloc>().state.user.id;
    return BlocProvider(
      create: (context) => SetsByExerciseBloc(
        repositoryExercises: context.read<RepositoryExercises>(),
        repositorySets: context.read<RepositorySets>(),
      )..add(LoadSeriesByExerciseEvent(exerciseId: exerciseId, userId: userId)),
      child: ViewExercise(),
    );
  }
}
