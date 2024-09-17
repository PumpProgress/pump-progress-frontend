import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/features/exercise/view/modal_bottom_sheet_save_exercise.dart';

class FloatingActionButtonNewSeries extends StatelessWidget {
  const FloatingActionButtonNewSeries({
    required this.saveExercise,
    super.key,
  });
  final void Function(int, double) saveExercise;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => ModalBottomSheetSaveExercise(
          saveExercise: saveExercise,
        ),
      ),
      child: const Icon(Icons.add_rounded),
    );
  }
}
