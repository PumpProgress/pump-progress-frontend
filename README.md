# pump_progress_frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Flavors

```sh
fvm flutter pub run flutter_flavorizr
```

## Main.dart

```dart

import 'dart:async';

import 'package:pump_progress_frontend/app/app.dart';
import 'package:pump_progress_frontend/bootstrap.dart';

FutureOr<void> main() async {
  bootstrap(() => const App());
}
```
