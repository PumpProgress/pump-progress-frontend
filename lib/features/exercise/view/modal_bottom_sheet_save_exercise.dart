import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ModalBottomSheetSaveExercise extends StatefulWidget {
  const ModalBottomSheetSaveExercise({
    required this.saveExercise,
    super.key,
    this.initialWeight = "",
    this.initialReps = "",
  });
  final String initialWeight;
  final String initialReps;

  final void Function(int repetitions, double weight) saveExercise;

  @override
  State<ModalBottomSheetSaveExercise> createState() =>
      _ModalBottomSheetSaveExerciseState();
}

class _ModalBottomSheetSaveExerciseState
    extends State<ModalBottomSheetSaveExercise> {
  int index = 0;
  double weight = 0;
  final TextEditingController weightController = TextEditingController();
  final TextEditingController weightWithMathController =
      TextEditingController();
  final TextEditingController repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    weightController.text = widget.initialWeight;
    weightController.selection =
        TextSelection.collapsed(offset: widget.initialWeight.length);

    weightWithMathController.text = widget.initialWeight;
    weightWithMathController.selection =
        TextSelection.collapsed(offset: widget.initialWeight.length);

    repsController.text = widget.initialReps;
    repsController.selection =
        TextSelection.collapsed(offset: widget.initialReps.length);

    weight =
        widget.initialWeight.isEmpty ? 0 : double.parse(widget.initialWeight);
  }

  void _onClickHandler() {
    try {
      final reps = int.parse(repsController.text);
      widget.saveExercise(reps, weight);
      weightController.clear();
      repsController.clear();
    } catch (e) {
      print(e);
    }
  }

  void setWeightState(String weightStr) {
    if (weightStr.isEmpty) {
      setState(() {
        weight = 0;
      });
    }
    var inputWeight = double.parse(weightStr);

    switch (index) {
      case 1:
        setState(() {
          weight = inputWeight * 2;
        });
        return;
      case 2:
        setState(() {
          weight = (inputWeight * 2 + 20);
        });
        return;
      default:
        setState(() {
          weight = (inputWeight);
        });
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    weightWithMathController.text = weight.toString();
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: weightController,
                      autofocus: true,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        setWeightState(value);
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        labelText: 'Weight',
                        suffixText: "Kg.",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: PumpProgressColors.coral,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: weightWithMathController,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        labelText: 'Weight',
                        suffixText: "Kg.",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: repsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        labelText: 'Reps',
                        suffixText: 'Reps',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Center(
                        child: ToggleSwitch(
                          minWidth: (constraints.maxWidth / 3) - 2,
                          minHeight: 56,
                          iconSize: 55,
                          inactiveBgColor: PumpProgressColors.black,
                          activeFgColor: PumpProgressColors.coral,
                          dividerColor: PumpProgressColors.black,
                          borderColor: const [PumpProgressColors.silver],
                          borderWidth: 1,
                          radiusStyle: true,
                          cornerRadius: 16,
                          initialLabelIndex: index,
                          totalSwitches: 3,
                          icons: const [
                            Icons.looks_one_rounded,
                            Icons.looks_two_rounded,
                            Icons.fitness_center_rounded
                          ],
                          onToggle: (newIndex) {
                            setState(() {
                              index = newIndex!;
                              setWeightState(weightController.text);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
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
      ),
    );
  }
}
