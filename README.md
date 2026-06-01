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

```
data/
 ├── workout/
 │     ├── remote/
 │     │     workout_api.dart
 │     ├── local/
 │     │     workout_local_data_source.dart
 │     ├── models/
 │     │     dto/
 │     │         workout_dto.dart
 │     │         create_workout_request.dart
 │     │     entity/
 │     │         workout_entity.dart
 │     │     domain/
 │     │         workout.dart
 │     ├── repository/
 │           workout_repository.dart

 data/
 ├── exercise/
 │     ├── domain/
 │     │     domain.dart          <-- exports all domain models
 │     ├── repository/
 │     │     repository.dart      <-- exports ExerciseRepository
 │     ├── remote/
 │     │     remote.dart          <-- exports all API files
 │     ├── local/
 │     │     local.dart           <-- exports local datasource
 ```

## Summary (to review)
```
lib/
 ├── core/                 # Reusable core utilities (network, database helpers)
 │     ├── network/        # API client, Dio interceptors, request config
 │     ├── database/       # SQL database init, singleton, connection helpers
 │     └── utils/          # General-purpose helpers used across app
 ├── features/             # Feature modules, including UI + logic + domain
 │     ├── workout/
 │     │     ├── domain/        # Domain models (used by UI)
 │     │     │     └── workout.dart
 │     │     ├── models/        # DTOs (API) + Entities (local DB)
 │     │     │     ├── workout_dto.dart
 │     │     │     └── workout_entity.dart
 │     │     ├── provider/      # Feature BLoC / Cubit or Provider classes
 │     │     │     └── workout_bloc.dart
 │     │     ├── remote/        # Remote API providers
 │     │     │     └── workout_api.dart
 │     │     ├── local/         # Local DB providers
 │     │     │     └── workout_local.dart
 │     │     └── presentation/  # Feature-specific widgets
 │     │           ├── workout_list_item_main_page.dart
 │     │           └── workout_list_item_calendar_page.dart
 │     └── exercise/            # Another feature, same structure
 ├── screens/             # Higher-level screens/pages (composing multiple features)
 │     ├── main_screen.dart       # Top-level screen with tabs / navigation
 │     ├── calendar_tab.dart      # Widget for calendar tab
 │     └── dashboard_tab.dart     # Widget for dashboard tab
 └── repository/          # Optional: abstract repositories coordinating data sources
```
Folder / File
Responsibility
core
General reusable utilities across app, e.g., network clients, DB helpers
features/<feature>
Encapsulates all logic, models, BLoC, and UI for a single feature
domain/
Domain models used by the app (Workout, Exercise)
models/
DTOs (API) and Entities (local DB representations)
provider/
Feature Bloc/Cubit or Provider; manages state, loading, error, and data
remote/
API clients, methods to query backend
local/
Local DB queries, e.g., SQLite or Hive access
presentation/
Feature-specific widgets (variants for different pages, e.g., calendar vs main)
screens/
Full pages that compose multiple features; orchestrate multiple blocs
repository/
Optional layer combining remote + local providers; returns domain models
