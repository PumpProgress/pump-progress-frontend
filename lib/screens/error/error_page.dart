import 'package:flutter/material.dart';

class PageError extends StatelessWidget {
  const PageError({super.key});

  static const String routeName = '/error';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Ocurrió un error'),
      ),
    );
  }
}
