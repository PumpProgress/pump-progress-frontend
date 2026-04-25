# Frontend Documentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Write complete contributor and architecture documentation for the pump-progress-frontend Flutter repo, stored in the pump-progress-documentation Obsidian vault, plus a `CLAUDE.md` in the repo root that directs agents and contributors to the vault first.

**Architecture:** Hub-and-spoke — `frontend/README.md` in the vault is the single entry point. All other docs link back to it. The repo root `CLAUDE.md` enforces vault-first orientation for AI agents. Documentation is split across focused files: one for setup, one for contributing, one per architecture concern.

**Tech Stack:** Markdown (Obsidian-flavoured, wiki-links for internal links), Flutter/Dart (for code examples), GitFlow branch conventions.

---

## File Map

| Action | Path |
|---|---|
| Create | `pump-progress-frontend/CLAUDE.md` |
| Update | `pump-progress-documentation/frontend/README.md` |
| Create | `pump-progress-documentation/frontend/setup.md` |
| Create | `pump-progress-documentation/frontend/contributing.md` |
| Update | `pump-progress-documentation/frontend/architecture/README.md` |
| Create | `pump-progress-documentation/frontend/architecture/folder-structure.md` |
| Create | `pump-progress-documentation/frontend/architecture/bloc-pattern.md` |
| Create | `pump-progress-documentation/frontend/architecture/routing.md` |
| Delete | `pump-progress-documentation/frontend/architecture/screens-folder-structure.md` |

---

## Task 1: CLAUDE.md (repo root)

**Files:**
- Create: `pump-progress-frontend/CLAUDE.md`

- [ ] **Step 1: Create CLAUDE.md**

  Write the following content to `/Users/sergiocarbone/repos/pumpProgress/pump-progress-frontend/CLAUDE.md`:

  ```markdown
  # PumpProgress Frontend

  ## Documentation

  Before working on this repo, read the documentation at:

  ```
  ~/repos/pumpProgress/pump-progress-documentation/frontend/README.md
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
  ```

- [ ] **Step 2: Commit**

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-frontend
  git add CLAUDE.md
  git commit -m "docs: add CLAUDE.md directing agents to vault documentation"
  ```

---

## Task 2: Update frontend/README.md (hub index)

**Files:**
- Modify: `pump-progress-documentation/frontend/README.md`

- [ ] **Step 1: Replace frontend/README.md with full hub content**

  Write the following to `/Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation/frontend/README.md`:

  ```markdown
  ---
  tags: [frontend, flutter]
  ---

  # Frontend

  PumpProgress frontend is a Flutter app (iOS/Android) for tracking gym workouts. It is
  **local-first**: all data lives in a SQLite database on the device and syncs with the
  backend API on login. Authentication is handled via AWS Cognito. State management uses
  BLoC (`flutter_bloc`). The architecture follows Clean Architecture with strict layer
  separation between features, screens, config, and utils.

  > This repo is part of a larger platform. Links to backend and infrastructure
  > documentation will be added once those repos have their own docs written.
  > Inter-repo communication documentation is a separate effort.

  ## Quick Start

  ```sh
  # 1. Install fvm (Flutter Version Manager)
  dart pub global activate fvm

  # 2. Pin the Flutter version for this project
  fvm use stable -p

  # 3. Run the app (local flavor, hits localhost:6000)
  fvm flutter run -t lib/main_local.dart
  ```

  See [[setup]] for full instructions including device setup, environment variables,
  and all flavor commands.

  ## Contents

  | Document | Description |
  |---|---|
  | [[setup]] | Prerequisites, run commands, environment variables, CI/CD tagging |
  | [[contributing]] | Branch conventions, new feature checklist, PR requirements |
  | [[architecture/README\|Architecture Overview]] | Four-layer architecture and dependency rules |
  | [[architecture/folder-structure\|Folder Structure]] | Complete `lib/` tree with every file type explained |
  | [[architecture/bloc-pattern\|BLoC Pattern]] | Event/State/Bloc conventions, `runSafeEvent`, barrel exports |
  | [[architecture/routing\|Routing]] | Route registration, `_page.dart` contract, args, protected routes |
  ```

- [ ] **Step 2: Commit**

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation
  git add frontend/README.md
  git commit -m "docs(frontend): rewrite README as hub index with quick-start and contents table"
  ```

---

## Task 3: Create frontend/setup.md

**Files:**
- Create: `pump-progress-documentation/frontend/setup.md`

- [ ] **Step 1: Create setup.md**

  Write the following to `/Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation/frontend/setup.md`:

  ```markdown
  ---
  tags: [frontend, flutter, setup]
  ---

  # Setup

  ## Prerequisites

  - **fvm** (Flutter Version Manager) — do not install Flutter directly.
    Install fvm with: `dart pub global activate fvm`
  - **Xcode** (macOS, for iOS) — install from the App Store, then:
    `sudo xcode-select --switch /Applications/Xcode.app`
  - **Android Studio** (for Android) — install from
    [developer.android.com/studio](https://developer.android.com/studio)

  ## Flutter Version

  After cloning the repo, pin the Flutter version:

  ```sh
  fvm use stable -p
  ```

  The `-p` flag auto-configures Xcode and Android Studio to use the fvm-managed Flutter.
  The pinned version is stored in `.fvm/fvm_config.json`.

  ## Running the App

  The project has three flavors. Each has its own entry point:

  | Flavor | Command | API target |
  |---|---|---|
  | local | `fvm flutter run -t lib/main_local.dart` | `localhost:6000` |
  | dev   | `fvm flutter run -t lib/main_dev.dart`   | Production API (dev flavor) |
  | prod  | `fvm flutter run -t lib/main_prod.dart`  | Production API (prod flavor) |

  Use `local` when running the backend locally. Use `dev` to test against the real API
  without affecting production data.

  ## Environment Variables

  ### HUGGING_FACE_TOKEN

  Required to download the on-device Gemma AI model. A default token is bundled in the
  app but can be overridden at build time:

  ```sh
  fvm flutter run -t lib/main_local.dart \
    --dart-define=HUGGING_FACE_TOKEN=<your_token>
  ```

  Get a token at [huggingface.co/settings/tokens](https://huggingface.co/settings/tokens).
  The token needs read access to the Gemma model.

  ## Regenerating Flavors

  Flavor configuration lives in `flavorizr.yaml`. If you change it, regenerate the
  platform files:

  ```sh
  fvm dart run flutter_flavorizr
  ```

  This updates `ios/Flutter/*.xcconfig`, `android/` build configs, and the main entry
  point files. Commit all generated changes alongside your `flavorizr.yaml` changes.

  ## Linting

  ```sh
  fvm flutter analyze
  ```

  Must pass with zero errors. Run this before opening any PR.

  ## CI/CD

  Releases are triggered by git tags pushed to specific branches. The tag format
  determines which environment gets the build:

  | Environment | Branch    | Tag format         | Example          |
  |---|---|---|---|
  | Production  | `main`    | `v<semver>`        | `v3.9.0+20`      |
  | Staging     | `staging` | `v<semver>-test`   | `v3.9.0+20-test` |

  **Before tagging:**
  1. Update `version` in `pubspec.yaml` to match (e.g. `3.9.0+20`).
  2. Bump the build number (`+N`) for every release — it must be unique and increasing.
  3. Commit `pubspec.yaml`, then create and push the tag.

  ```sh
  git tag v3.9.0+20
  git push origin v3.9.0+20
  ```
  ```

- [ ] **Step 2: Commit**

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation
  git add frontend/setup.md
  git commit -m "docs(frontend): add setup guide covering fvm, flavors, env vars, CI/CD"
  ```

---

## Task 4: Create frontend/contributing.md

**Files:**
- Create: `pump-progress-documentation/frontend/contributing.md`

- [ ] **Step 1: Create contributing.md**

  Write the following to `/Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation/frontend/contributing.md`:

  ```markdown
  ---
  tags: [frontend, flutter, contributing]
  ---

  # Contributing

  ## Before You Start

  Read these docs first — they prevent structural mistakes:

  1. [[architecture/README|Architecture Overview]] — understand the four layers
  2. [[architecture/folder-structure|Folder Structure]] — know where every file type lives
  3. [[architecture/bloc-pattern|BLoC Pattern]] — state management conventions
  4. [[architecture/routing|Routing]] — how to register a new route

  ## Branch Conventions (GitFlow)

  | Branch | Purpose | Branches off | Merges into |
  |---|---|---|---|
  | `main` | Production releases | — | — |
  | `dev` | Active development | `main` | `main` via release |
  | `feature/<name>` | New features | `dev` | `dev` |
  | `bugfix/<name>` | Bug fixes | `dev` | `dev` |
  | `hotfix/<name>` | Urgent production fixes | `main` | `main` + `dev` |
  | `release/<version>` | Release preparation | `dev` | `main` + `dev` |

  All day-to-day work starts from `dev`. Open PRs targeting `dev`.

  ## Adding a New Feature

  Follow this checklist in order. Do not skip steps — each builds on the previous.

  - [ ] **1. Create the feature folder** at `lib/features/<name>/`

    ```
    lib/features/<name>/
    ├── blocs/
    │   ├── bloc_<name>/
    │   │   ├── <name>_bloc.dart
    │   │   ├── <name>_event.dart
    │   │   └── <name>_state.dart
    │   └── blocs.dart              ← barrel export
    ├── domain/
    │   ├── <name>.dart             ← pure Dart domain model
    │   └── domain.dart             ← barrel export
    ├── models/
    │   └── entities/
    │       ├── <name>_row.dart     ← SQLite row representation
    │       └── entities.dart       ← barrel export
    ├── local/
    │   ├── local_<name>.dart       ← SQLite query methods
    │   └── local.dart              ← barrel export
    └── repository/
        ├── repository_<name>.dart  ← converts entities → domain models
        └── repository.dart         ← barrel export
    ```

    See [[architecture/folder-structure]] for the responsibility of each layer.

  - [ ] **2. Register the repository** in `lib/app/app.dart`

    Add inside `repositoryProviders`:

    ```dart
    RepositoryProvider<Repository<Name>>(
      create: (context) => Repository<Name>(),
    ),
    ```

  - [ ] **3. Register app-wide BLoCs** in `lib/app/app.dart` *(only if used across multiple screens)*

    Add inside `blocProviders`:

    ```dart
    BlocProvider(create: (context) {
      return <Name>Bloc(
        repository<Name>: context.read<Repository<Name>>(),
      );
    }),
    ```

    If the BLoC is only used by one screen, provide it in that screen's `_page.dart` instead.

  - [ ] **4. Create the screen** at `lib/screens/<name>/`

    ```
    lib/screens/<name>/
    ├── <name>_page.dart     ← route entry point, provides BLoCs, no UI
    └── view/
        ├── <name>_view.dart ← stateless UI root, reads BLoC state
        └── widgets/         ← widgets private to this screen
    ```

    See [[architecture/routing]] for the `_page.dart` contract.

  - [ ] **5. Register the route** in `lib/config/routes/router.dart`

    Add a `case` in `onGenerateRoute`:

    ```dart
    case <Name>Page.routeName:
      return MaterialPageRoute<void>(
        settings: const RouteSettings(name: <Name>Page.routeName),
        builder: (_) => ProtectedRoute(child: const <Name>Page()),
      );
    ```

    Add a `static const routeName = '/<name>'` on the page class.
    Omit `ProtectedRoute` only if the route does not require authentication.

  ## PR Checklist

  Before marking a PR ready for review:

  - [ ] New route registered in `lib/config/routes/router.dart`
  - [ ] Repository registered as `RepositoryProvider` in `lib/app/app.dart`
  - [ ] App-wide BLoC registered as `BlocProvider` in `lib/app/app.dart` (if applicable)
  - [ ] No BLoC class definitions inside `lib/screens/`
  - [ ] No UI widgets inside `lib/features/`
  - [ ] `fvm flutter analyze` returns zero errors
  - [ ] `pubspec.yaml` version bumped if this is a release commit
  ```

- [ ] **Step 2: Commit**

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation
  git add frontend/contributing.md
  git commit -m "docs(frontend): add contributing guide with GitFlow conventions and feature checklist"
  ```

---

## Task 5: Update frontend/architecture/README.md

**Files:**
- Modify: `pump-progress-documentation/frontend/architecture/README.md`

- [ ] **Step 1: Rewrite architecture/README.md**

  Write the following to `/Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation/frontend/architecture/README.md`:

  ```markdown
  ---
  tags: [frontend, architecture, flutter]
  ---

  # Frontend Architecture

  Architecture decisions and conventions for the Flutter frontend (`pump-progress-frontend`).

  ## Four Layers

  | Layer | Path | What belongs here | What does NOT belong here |
  |---|---|---|---|
  | Features | `lib/features/` | BLoCs, repositories, local data sources, domain models, DB entities | UI widgets, screen navigation |
  | Screens | `lib/screens/` | Pages, views, screen-private widgets | BLoC definitions, business logic |
  | Config | `lib/config/` | Router, theme, app-wide constants | Feature logic, UI components |
  | Utils | `lib/utils/` | Shared helpers, API client, DB service, Cognito client | Feature-specific logic |

  ## Dependency Rule

  ```
  screens → features → utils / config
  ```

  - Screens depend on features (consume BLoC state, navigate via router)
  - Features never depend on screens
  - Utils and config have no dependencies on features or screens
  - BLoCs never call `local/` directly — they go through the `repository/` layer

  ## Contents

  - [[folder-structure]] — Complete `lib/` tree with every folder and file type explained
  - [[bloc-pattern]] — BLoC conventions, event/state structure, `runSafeEvent`, barrel exports
  - [[routing]] — Route registration, `_page.dart` contract, argument passing, protected routes
  ```

- [ ] **Step 2: Commit**

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation
  git add frontend/architecture/README.md
  git commit -m "docs(frontend): rewrite architecture README with four-layer table and dependency rule"
  ```

---

## Task 6: Create folder-structure.md and delete screens-folder-structure.md

**Files:**
- Create: `pump-progress-documentation/frontend/architecture/folder-structure.md`
- Delete: `pump-progress-documentation/frontend/architecture/screens-folder-structure.md`

- [ ] **Step 1: Create folder-structure.md**

  Write the following to `/Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation/frontend/architecture/folder-structure.md`:

  ```markdown
  ---
  tags: [frontend, architecture, flutter, structure]
  ---

  # Folder Structure

  Complete reference for where every file type lives in `lib/`.

  ## Full `lib/` Tree

  ```
  lib/
  ├── app/
  │   └── app.dart                    # App root. Registers all RepositoryProviders
  │                                   # and BlocProviders. Entry point for App widget.
  ├── bootstrap.dart                  # App init: Sentry setup, Gemma init,
  │                                   # orientation lock, BlocObserver registration.
  ├── flavors.dart                    # Flavor enum (local/dev/prod) + base URL resolver.
  ├── main.dart                       # Default entry point (prod)
  ├── main_dev.dart                   # Dev flavor entry point
  ├── main_local.dart                 # Local flavor entry point
  ├── main_prod.dart                  # Prod flavor entry point
  ├── config/
  │   ├── constants/
  │   │   ├── icomoon_icons.dart      # Icon font constants for the icomoon font family
  │   │   └── local_storage.dart      # SharedPreferences key constants
  │   ├── routes/
  │   │   ├── router.dart             # PumpProgressRouter: onGenerateRoute switch,
  │   │   │                           # route argument classes
  │   │   └── protected_route.dart    # ProtectedRoute widget: redirects to login
  │   │                               # if UserSessionBloc is unauthenticated
  │   └── theme/
  │       ├── colors.dart             # App color palette
  │       ├── fonts.dart              # Font family constants
  │       └── theme.dart              # MaterialTheme definition
  ├── features/
  │   └── <feature_name>/             # One folder per domain feature (see below)
  ├── screens/
  │   └── <screen_name>/              # One folder per screen (see below)
  └── utils/
      ├── helpers/
      │   ├── app_logger.dart         # Structured logger (wraps logger package)
      │   ├── error_event_bus.dart    # StreamController for app-wide error snackbars
      │   ├── error_status.dart       # ErrorStatus base class + runSafeEvent helper
      │   ├── general_exception.dart  # App-specific exception type
      │   ├── global_bloc_observer.dart # BlocObserver for debug logging
      │   ├── parse_jwt.dart          # JWT decode utility
      │   └── route_observer.dart     # RouteObserver singleton for analytics
      └── services/
          ├── api_client_pp/
          │   └── api_client_pp.dart  # Dio HTTP client singleton (base URL from flavor)
          ├── cognito_user_pool/
          │   ├── cognito_user_pool.dart        # CognitoUserPool singleton
          │   └── cognito_user_pool_client.dart # Auth methods: login, logout, refresh
          ├── native_service/
          │   └── timer_service.dart  # Native timer for rest intervals
          └── sql_database_service/
              └── sql_database_service.dart # SQLite singleton (sqflite). All features
                                            # use this for local queries.
  ```

  ## Feature Layer Structure

  Every feature under `lib/features/` follows the same internal structure:

  ```
  lib/features/<name>/
  ├── blocs/
  │   ├── bloc_<name>/
  │   │   ├── <name>_bloc.dart    # BLoC class. Handles events, calls repository.
  │   │   ├── <name>_event.dart   # Sealed event class + subclasses (part of bloc).
  │   │   └── <name>_state.dart   # State class with status + data fields (part of bloc).
  │   └── blocs.dart              # Barrel export for all BLoCs in this feature.
  ├── domain/
  │   ├── <name>.dart             # Pure Dart domain model. No SQLite or API concerns.
  │   │                           # This is the shape the rest of the app works with.
  │   └── domain.dart             # Barrel export.
  ├── models/
  │   └── entities/
  │       ├── <name>_row.dart     # SQLite row representation. Has toMap()/fromMap().
  │       └── entities.dart       # Barrel export.
  ├── local/
  │   ├── local_<name>.dart       # Raw SQLite queries via SqlDatabaseService.
  │   │                           # Returns entities, not domain models.
  │   └── local.dart              # Barrel export.
  └── repository/
      ├── repository_<name>.dart  # Converts entities → domain models.
      │                           # Called by BLoCs. The only entry point to data.
      └── repository.dart         # Barrel export.
  ```

  ### Feature layer responsibilities

  | Layer | File | Responsibility |
  |---|---|---|
  | `domain/` | `<name>.dart` | Pure Dart class. No persistence concerns. Used by UI and BLoC. |
  | `models/entities/` | `<name>_row.dart` | SQLite row shape. `toMap()` writes to DB, `fromMap()` reads from DB. |
  | `local/` | `local_<name>.dart` | SQLite queries via `SqlDatabaseService`. Returns entities. |
  | `repository/` | `repository_<name>.dart` | Calls `local/`, maps entities to domain models. Called by BLoCs. |
  | `blocs/bloc_<name>/` | three `.dart` files | State machine. Calls repository. Emits states. |

  > **Sync feature:** `lib/features/sync/` also has an `api/` layer that fetches data from
  > the backend API. All other features are read-only from local SQLite — sync is the only
  > feature that writes data coming from the network.

  ## Screen Layer Structure

  Every screen under `lib/screens/` follows the same internal structure:

  ```
  lib/screens/<name>/
  ├── <name>_page.dart        # Route entry point. Provides BLoCs via BlocProvider.
  │                           # Passes route arguments down. Contains NO UI logic.
  └── view/
      ├── <name>_view.dart    # Stateless root widget. Reads BLoC state via BlocBuilder
      │                       # or BlocConsumer. Composes widgets from widgets/.
      └── widgets/            # Sub-widgets private to this screen. If a widget is
                              # reused across screens it moves to a shared library.
  ```

  ### Screen file responsibilities

  | File | Responsibility |
  |---|---|
  | `_page.dart` | The only file the router imports. Provides BLoCs. Handles route args. No UI. |
  | `_view.dart` | Stateless widget. Reads BLoC state. Composes widgets/. |
  | `widgets/` | Private to this screen. Not imported from outside `<screen_name>/`. |

  ### Special screens

  | Path | Purpose |
  |---|---|
  | `lib/screens/_shared/` | Utility screens not tied to a domain (splash, loading, error). No BLoC dependency. |
  | `lib/screens/main/` | Navigation shell: tab bar + tab content screens (home, workouts, calendar). |

  ## Rules

  1. **No BLoC definitions in `screens/`** — they belong in `features/<name>/blocs/`
  2. **`_page.dart` is the only file the router imports**
  3. **`widgets/` is screen-private** — cross-screen widgets go to a shared component library
  4. **BLoCs never call `local/` directly** — they go through `repository/`
  5. **`_shared/` screens have no BLoC dependency** — they are pure UI

  ## Related

  - [[architecture/README|Architecture Overview]] — dependency rules between layers
  - [[bloc-pattern]] — BLoC conventions used across all features
  - [[routing]] — how routes map to `_page.dart` files
  ```

- [ ] **Step 2: Delete the old screens-folder-structure.md**

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation
  git rm frontend/architecture/screens-folder-structure.md
  ```

- [ ] **Step 3: Commit**

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation
  git add frontend/architecture/folder-structure.md
  git commit -m "docs(frontend): add complete folder-structure doc, remove screens-only doc"
  ```

---

## Task 7: Create bloc-pattern.md

**Files:**
- Create: `pump-progress-documentation/frontend/architecture/bloc-pattern.md`

- [ ] **Step 1: Create bloc-pattern.md**

  Write the following to `/Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation/frontend/architecture/bloc-pattern.md`:

  ```markdown
  ---
  tags: [frontend, architecture, flutter, bloc]
  ---

  # BLoC Pattern

  State management conventions for the `flutter_bloc` package used throughout the app.

  ## File Structure

  Each BLoC lives in its own folder under `lib/features/<name>/blocs/bloc_<name>/`.
  The three files are linked via Dart's `part` directive:

  ```
  blocs/
  ├── bloc_<name>/
  │   ├── <name>_bloc.dart    ← defines the Bloc class; others are `part of` this
  │   ├── <name>_event.dart   ← `part of '<name>_bloc.dart'`
  │   └── <name>_state.dart   ← `part of '<name>_bloc.dart'`
  └── blocs.dart              ← barrel export: exports the Bloc class and any public types
  ```

  ## Event Shape

  Events use a `sealed` base class extending `Equatable`. Each user action or lifecycle
  trigger is a separate subclass:

  ```dart
  // <name>_event.dart
  part of '<name>_bloc.dart';

  sealed class <Name>Event extends Equatable {
    const <Name>Event();

    @override
    List<Object> get props => [];
  }

  class Fetch<Name>Event extends <Name>Event {
    const Fetch<Name>Event();
  }
  ```

  ## State Shape

  State is a single class with a `status` field and data fields. The `status` field uses
  a `sealed` class hierarchy with one subclass per state:

  ```dart
  // <name>_state.dart
  part of '<name>_bloc.dart';

  sealed class <Name>Status {
    const <Name>Status();
  }

  class <Name>StatusLoading implements <Name>Status {
    const <Name>StatusLoading();
  }

  class <Name>StatusSuccess implements <Name>Status {
    const <Name>StatusSuccess();
  }

  class <Name>StatusError extends ErrorStatus implements <Name>Status {
    <Name>StatusError(super.errorMsg);
  }

  class <Name>State extends Equatable {
    const <Name>State({
      this.status = const <Name>StatusLoading(),
      this.items = const [],
    });

    final <Name>Status status;
    final List<<Name>> items;

    @override
    List<Object> get props => [status, items];

    <Name>State copyWith({
      <Name>Status? status,
      List<<Name>>? items,
    }) {
      return <Name>State(
        status: status ?? this.status,
        items: items ?? this.items,
      );
    }
  }
  ```

  Import `ErrorStatus` from `package:pump_progress_frontend/utils/helpers/error_status.dart`.

  ## Bloc Class

  ```dart
  // <name>_bloc.dart
  import 'package:bloc/bloc.dart';
  import 'package:equatable/equatable.dart';
  import 'package:pump_progress_frontend/features/<name>/domain/domain.dart';
  import 'package:pump_progress_frontend/features/<name>/repository/repository.dart';
  import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

  part '<name>_event.dart';
  part '<name>_state.dart';

  class <Name>Bloc extends Bloc<<Name>Event, <Name>State> {
    <Name>Bloc({required this.repository<Name>})
        : super(const <Name>State()) {
      on<Fetch<Name>Event>(_onFetch<Name>Event);
    }

    final Repository<Name> repository<Name>;

    Future<void> _onFetch<Name>Event(
        <Name>Event event, Emitter<<Name>State> emit) async {
      await runSafeEvent(emit, state, <Name>StatusError.new, () async {
        emit(state.copyWith(status: const <Name>StatusLoading()));
        final items = await repository<Name>.get<Name>s();
        emit(state.copyWith(
          status: const <Name>StatusSuccess(),
          items: items,
        ));
      });
    }
  }
  ```

  ## runSafeEvent

  All async event handlers must use `runSafeEvent` instead of a raw try/catch:

  ```dart
  await runSafeEvent(emit, state, <Name>StatusError.new, () async {
    // your async logic here
  });
  ```

  What it does:
  - Calls the inner `action()` function
  - On any exception: logs to console, sends to Sentry, emits the error status,
    and broadcasts an error message to the app-wide snackbar (`ErrorEventBus`)

  Source: `lib/utils/helpers/error_status.dart`

  ## Barrel Exports

  `blocs.dart` in the feature's `blocs/` folder exports everything consumers need:

  ```dart
  // blocs.dart
  export 'bloc_<name>/<name>_bloc.dart';
  ```

  Screens and `app.dart` import only the barrel: `features/<name>/blocs/blocs.dart`.

  ## Where BLoCs Are Provided

  | Scope | Where to provide | How |
  |---|---|---|
  | App-wide (used across multiple screens) | `lib/app/app.dart` | `MultiBlocProvider` list |
  | Screen-scoped (used by one screen only) | `<screen>_page.dart` | `BlocProvider` wrapping the view |

  Never create a `BlocProvider` inside a `_view.dart` or `widgets/` file.

  ## Naming Conventions

  | Thing | Convention | Example |
  |---|---|---|
  | Bloc class | `<Feature>Bloc` | `ExercisesBloc` |
  | Event base | `<Feature>Event` | `ExercisesEvent` |
  | Event subclass | `<Action><Feature>Event` | `FetchExercisesEvent` |
  | State class | `<Feature>State` | `ExercisesState` |
  | Status sealed | `<Feature>Status` | `ExercisesStatus` |
  | Status subclass | `<Feature>Status<Variant>` | `ExercisesStatusSuccess` |
  ```

- [ ] **Step 2: Commit**

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation
  git add frontend/architecture/bloc-pattern.md
  git commit -m "docs(frontend): add bloc-pattern reference with event/state templates and runSafeEvent"
  ```

---

## Task 8: Create routing.md

**Files:**
- Create: `pump-progress-documentation/frontend/architecture/routing.md`

- [ ] **Step 1: Create routing.md**

  Write the following to `/Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation/frontend/architecture/routing.md`:

  ```markdown
  ---
  tags: [frontend, architecture, flutter, routing]
  ---

  # Routing

  Navigation conventions for the `pump-progress-frontend` app.

  ## How the Router Works

  All navigation goes through `PumpProgressRouter` in `lib/config/routes/router.dart`.
  It uses Flutter's `onGenerateRoute` with a `switch` on the route name string:

  ```dart
  class PumpProgressRouter {
    Route<void> onGenerateRoute(RouteSettings settings) {
      switch (settings.name) {
        case PageStart.routeName:
          return MaterialPageRoute<void>(
            settings: const RouteSettings(name: PageStart.routeName),
            builder: (_) => const ProtectedRoute(child: PageStart()),
          );
        // ...
        default:
          return MaterialPageRoute<void>(
            builder: (_) => const PageError(),
          );
      }
    }
  }
  ```

  The router is registered in `lib/app/app.dart`:

  ```dart
  static const router = PumpProgressRouter();
  // ...
  MaterialApp(onGenerateRoute: App.router.onGenerateRoute)
  ```

  ## ProtectedRoute

  Wrap any route that requires authentication with `ProtectedRoute`:

  ```dart
  builder: (_) => ProtectedRoute(child: const MyPage())
  ```

  `ProtectedRoute` listens to `UserSessionBloc`. It:
  - Shows the child when `UserSessionStatusAuthenticated`
  - Redirects to `/login` when `UserSessionStatusUnauthenticated`
  - Shows `LoadingPage` during `UserSessionStatusLoading`

  Source: `lib/config/routes/protected_route.dart`

  ## Current Routes

  | Route name | Page class | Auth required |
  |---|---|---|
  | `/` (PageStart.routeName) | `PageStart` | Yes |
  | `/login` (PageLogin.routeName) | `PageLogin` | No |
  | `PageExercise.routeName` | `PageExercise` | Yes |
  | `/exercises/analytics` | `ExerciseAnalyticsPage` | Yes |
  | `/workouts` | `WorkoutPage` | Yes |

  ## Adding a New Route

  ### 1. Create the page file

  Add `lib/screens/<name>/<name>_page.dart` with a `static const routeName`:

  ```dart
  class <Name>Page extends StatelessWidget {
    const <Name>Page({super.key});

    static const routeName = '/<name>';

    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        create: (context) => <Name>Bloc(
          repository<Name>: context.read<Repository<Name>>(),
        ),
        child: const <Name>View(),
      );
    }
  }
  ```

  ### 2. Define an args class (if the route needs parameters)

  Add the args class at the bottom of `lib/config/routes/router.dart`:

  ```dart
  class <Name>PageArguments {
    <Name>PageArguments({required this.id});
    final int id;
  }
  ```

  ### 3. Register the route

  Add a `case` in `PumpProgressRouter.onGenerateRoute`:

  ```dart
  case <Name>Page.routeName:
    // Cast arguments if needed:
    final args = settings.arguments! as <Name>PageArguments;
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: <Name>Page.routeName),
      builder: (_) => ProtectedRoute(
        child: <Name>Page(id: args.id),
      ),
    );
  ```

  ### 4. Navigate to the route

  From anywhere in the widget tree:

  ```dart
  // Without args:
  Navigator.of(context).pushNamed(<Name>Page.routeName);

  // With args:
  Navigator.of(context).pushNamed(
    <Name>Page.routeName,
    arguments: <Name>PageArguments(id: 42),
  );
  ```

  ## _page.dart Contract

  The `_page.dart` file is the **only** file the router imports. It must:

  - Provide the screen's BLoC(s) via `BlocProvider` (if screen-scoped) or read them from
    context (if app-wide, already provided in `app.dart`)
  - Accept and pass down route arguments
  - Contain **no UI logic** — delegate everything to `_view.dart`

  ```dart
  // Good _page.dart
  class WorkoutPage extends StatelessWidget {
    const WorkoutPage({super.key, required this.workout});
    static const routeName = '/workouts';
    final Workout workout;

    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        create: (context) => WorkoutDetailBloc(
          repositoryWorkout: context.read<RepositoryWorkout>(),
        )..add(FetchWorkoutDetailEvent(workout: workout)),
        child: WorkoutView(workout: workout),
      );
    }
  }
  ```
  ```

- [ ] **Step 2: Commit**

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation
  git add frontend/architecture/routing.md
  git commit -m "docs(frontend): add routing reference with ProtectedRoute, route table, and how-to"
  ```

---

## Task 9: Final verification pass

- [ ] **Step 1: Verify all Obsidian links resolve**

  Open each file and confirm every `[[link]]` points to a file that exists in the vault:

  - `frontend/README.md` → links to `setup`, `contributing`, `architecture/README`, `architecture/folder-structure`, `architecture/bloc-pattern`, `architecture/routing`
  - `frontend/architecture/README.md` → links to `folder-structure`, `bloc-pattern`, `routing`
  - `frontend/contributing.md` → links to all four architecture docs
  - `frontend/architecture/folder-structure.md` → links to `architecture/README`, `bloc-pattern`, `routing`

  All target files should exist after Tasks 2–8.

- [ ] **Step 2: Verify screens-folder-structure.md is gone**

  ```bash
  ls /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation/frontend/architecture/
  ```

  Expected output: `README.md  bloc-pattern.md  folder-structure.md  routing.md`
  (no `screens-folder-structure.md`)

- [ ] **Step 3: Verify CLAUDE.md exists at repo root**

  ```bash
  ls /Users/sergiocarbone/repos/pumpProgress/pump-progress-frontend/CLAUDE.md
  ```

  Expected: file exists, no error.

- [ ] **Step 4: Verify vault git log shows all commits**

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation
  git log --oneline -8
  ```

  Expected: 6 commits visible from Tasks 2–8 (README, setup, contributing, architecture README, folder-structure, bloc-pattern, routing).

- [ ] **Step 5: Final commit for vault if any corrections were made**

  Only if Step 1 revealed broken links and you fixed them:

  ```bash
  cd /Users/sergiocarbone/repos/pumpProgress/pump-progress-documentation
  git add -A
  git commit -m "docs(frontend): fix broken links in verification pass"
  ```
