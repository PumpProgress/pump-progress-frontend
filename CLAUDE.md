# PumpProgress Frontend

## Documentation

Before working on this repo, read the documentation at:

```
/Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation/frontend/README.md
```

This is the authoritative guide for contributing to this repo. It covers architecture,
folder structure, BLoC patterns, routing, and setup. Do not skip this step.

## Key Rules

These rules are not obvious from reading the code:

1. **No BLoC definitions in `screens/`** — BLoCs belong in `lib/features/<name>/blocs/`.
   A screen's `_page.dart` provides BLoCs from features; it never defines them.

2. **Register all repositories in `app.dart`** — Every `Repository*` class must be added
   as a `RepositoryProvider` in `lib/app/app.dart` before any BLoC can use it.

3. **App-wide BLoCs go in `app.dart`** — BLoCs used across multiple screens are provided
   via `MultiBlocProvider` in `lib/app/app.dart`. Screen-scoped BLoCs go in `_page.dart`.

4. **Every route entry point is a `_page.dart`** — The router
   (`lib/config/routes/router.dart`) imports only `*_page.dart` files. Never route
   directly to a view or widget.

5. **New features follow the `features/<name>/` layer structure** — domain/, models/entities/,
   blocs/, local/, repository/. See the architecture docs before starting.

## Running the App

Requires [fvm](https://fvm.app). Run `fvm use stable -p` once after cloning.

| Flavor | Command | API |
|---|---|---|
| local | `fvm flutter run -t lib/main_local.dart` | localhost:6000 |
| dev   | `fvm flutter run -t lib/main_dev.dart`   | Production API |
| prod  | `fvm flutter run -t lib/main_prod.dart`  | Production API |

## Lint

```sh
fvm flutter analyze
```

Must pass with zero errors before opening a PR.
