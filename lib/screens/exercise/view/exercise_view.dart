import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/features/sets/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/screens/exercise/view/button_add_seriers.dart';
import 'package:pump_progress_frontend/screens/exercise/view/series_timer.dart';
import 'package:pump_progress_frontend/screens/exercise/view/sets_list.dart';
import 'package:pump_progress_frontend/screens/loading/loading_page.dart';

class ViewExercise extends StatelessWidget {
  const ViewExercise({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetsByExerciseBloc, SetsByExerciseState>(
      builder: (context, state) {
        void saveExercise(int repetitions, double weight) {
          context.read<SetsByExerciseBloc>().add(
                AddNewSeriesEvent(
                  repetitions: repetitions,
                  weight: weight,
                  userId: context.read<UserSessionBloc>().state.user.id,
                ),
              );
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          // app bar with button to go to analytics page
          appBar: AppBar(
            title: Text(
              state.exercise.name,
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
                      exerciseId: state.exercise.id,
                      exerciseName: state.exercise.name,
                    ),
                  );
                },
              ),
            ],
          ),
          // floatingActionButton:
          //     FloatingActionButtonNewSeries(saveExercise: saveExercise),
          body: Container(
            child: (state.status is SetsByExerciseStatusLoading)
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
    );
  }
}
