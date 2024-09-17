import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_workouts/workouts_bloc.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';

class StartWorkoutFloatingActionButton extends StatelessWidget {
  StartWorkoutFloatingActionButton({super.key});

  final TextEditingController nameController = TextEditingController();

  void _onClickHandler(BuildContext context) {
    try {
      final name = nameController.text;
      context.read<WorkoutsBloc>().add(AddWorkoutWorkoutsEvent(name: name));
      nameController.clear();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      isDense: true,
                      labelText: 'name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PPColors.coral300,
                      foregroundColor: PPColors.white,
                    ),
                    onPressed: () {
                      _onClickHandler(context);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Create',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: PPColors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      child: const Icon(Icons.add_rounded),
    );
  }
}
