import 'package:flutter/material.dart';

// TODO rename to Loading view
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('L O A D I N G . . .'),
    ));
  }
}
