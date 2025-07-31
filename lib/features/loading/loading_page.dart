import 'dart:async';
import 'package:flutter/material.dart';

// TODO rename to Loading view
class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  int _counter = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter = (_counter % 3) + 1; // Cycles 1 -> 2 -> 3 -> 1 ...
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'L O A D I N G${'.' * _counter} ${' ' * (3 - _counter)}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
