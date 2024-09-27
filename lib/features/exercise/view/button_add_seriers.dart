import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/features/exercise/view/modal_bottom_sheet_save_exercise.dart';

class ButtonAddSeries extends StatelessWidget {
  const ButtonAddSeries({
    super.key,
    required this.saveExercise,
  });

  final void Function(int, double) saveExercise;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => ModalBottomSheetSaveExercise(
          saveExercise: saveExercise,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        color: PPColors.amethyst300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: PPColors.neutral500,
            border: Border.all(
              color: PPColors.amethyst300,
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: PPColors.amethyst300,
            ),
          ),
        ),
      ),
    );
  }
}
