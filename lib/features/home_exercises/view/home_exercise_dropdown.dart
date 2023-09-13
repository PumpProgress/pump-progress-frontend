import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';

class HomeExerciseDropdownWidget extends StatelessWidget {
  const HomeExerciseDropdownWidget(
      {super.key,
      required this.items,
      required this.selectedItems,
      required this.onChanged,
      required this.hint});

  final List<String> items;
  final List<String> selectedItems;
  final void Function(String?)? onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.00, vertical: 8.00),
        padding: const EdgeInsets.symmetric(horizontal: 16.00, vertical: 8.00),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: PumpProgressColors.coral,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          underline: Container(),
          isDense: true,
          menuMaxHeight: 500.0,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: PumpProgressColors.coral,
          ),
          hint: Text(
            hint,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: PumpProgressColors.coral),
          ),
          onChanged: onChanged,
          items: items.map((item) {
            final itemString = item.toString();
            return DropdownMenuItem<String>(
              value: itemString,
              child: Row(
                children: [
                  Icon(
                    selectedItems.contains(item)
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: PumpProgressColors.coral,
                  ),
                  Text(itemString),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
