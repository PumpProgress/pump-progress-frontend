import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';

class HomeWorkoutFloatingActionButton extends StatelessWidget {
  HomeWorkoutFloatingActionButton({super.key, required this.saveWorkout});

  final void Function(String name) saveWorkout;
  final TextEditingController nameController = TextEditingController();

  void _onClickHandler() {
    try {
      final name = nameController.text;
      saveWorkout(name);
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
                      backgroundColor: PumpProgressColors.coral,
                      foregroundColor: PumpProgressColors.white,
                    ),
                    onPressed: () {
                      _onClickHandler();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Create',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: PumpProgressColors.white),
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
