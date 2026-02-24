import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('COMING SOON 👾',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
