import 'package:flutter/material.dart';

class FloatingActionButtonNewSeries extends StatelessWidget {
  FloatingActionButtonNewSeries({required this.saveExercise, super.key});

  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  void Function(int repetitions, double weight) saveExercise;

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
                      labelText: 'Weight',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _onClickHandler();
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
        //   context: context,
        //   builder: (BuildContext context) {
        //     return SizedBox(
        //       height: 200,
        //       child: Center(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           mainAxisSize: MainAxisSize.min,
        //           children: <Widget>[
        //             const Text('Modal BottomSheet'),
        //             ElevatedButton(
        //               child: const Text('Close BottomSheet'),
        //               onPressed: () => context.read<ExerciseBloc>().add(),
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
