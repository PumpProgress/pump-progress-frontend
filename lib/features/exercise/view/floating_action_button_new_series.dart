import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';

class FloatingActionButtonNewSeries extends StatelessWidget {
  FloatingActionButtonNewSeries({required this.saveExercise, super.key});

  final TextEditingController weightController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final void Function(int repetitions, double weight) saveExercise;

  void _onClickHandler() {
    try {
      final weight = double.parse(weightController.text);
      final reps = int.parse(repsController.text);
      saveExercise(reps, weight);
      weightController.clear();
      repsController.clear();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add_rounded),
      shape: CircleBorder(),
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
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      isDense: true,
                      labelText: 'Weight',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      isDense: true,
                      labelText: 'Reps',
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
                      'Save',
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
    );
  }
}
