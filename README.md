# pump_progress_frontend

A new Flutter project.

## Update Flutter version using fvm

```sh
fvm use stable -p
```

## CI/CD

Tag must follow format `v1.0.0+1` and version of the pubspec.yaml have to be updated. (It defines the build number and version for the CI/CD pipeline)

### Production (main)

Create tag at release production commit without: `-test` ie. `v1.0.0+1`

### Staging (staging)

Create tag at release staging commit with: `-test` ie. `v1.0.0+1-test`

## Flavors

```sh
fvm dart run flutter_flavorizr
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

