import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';

class StartCalendarDayWidget extends StatelessWidget {
  const StartCalendarDayWidget({
    super.key,
    required this.day,
    Color? bgColor,
    Color? textColor,
  })  : bgColor = bgColor ?? PPColors.neutral500,
        textColor = textColor ?? PPColors.white;
  final DateTime day;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000.0), color: bgColor),
        child: Center(
          child: Text(
            day.day.toString(),
            // style: PPFontStyles.paragraph.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
