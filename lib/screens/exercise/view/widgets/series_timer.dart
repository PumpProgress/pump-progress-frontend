import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class SeriesTimer extends StatefulWidget {
  const SeriesTimer({super.key, required this.startTime});

  final DateTime? startTime;

  @override
  State<SeriesTimer> createState() => _SeriesTimerState();
}

class _SeriesTimerState extends State<SeriesTimer> {
  late Timer _timer;
  late DateTime _now;

  String formatShortDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds.remainder(60);
    return '${minutes}m ${seconds}s';
  }

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getTimeDifferenceText() {
    if (widget.startTime == null) {
      return 'never';
    }
    Duration difference = _now.difference(widget.startTime!);

    if (difference.inMinutes <= 10) {
      int minutes = difference.inMinutes;
      int seconds = difference.inSeconds.remainder(60);
      return '${minutes}m ${seconds}s';
    } else {
      return timeago.format(widget.startTime!, clock: _now);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        getTimeDifferenceText(),
        style: TextTheme.of(context).labelLarge,
      ),
    );
  }
}
