import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () {
          // throw StateError('This is test exception');
          throw Exception('This is test exception :o ');
        },
        child: const Text('Verify Sentry Setup!'),
      ),
    ));
  }
}
