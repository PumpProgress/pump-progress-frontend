# Frontend Documentation Design

**Date:** 2026-04-25  
**Scope:** pump-progress-frontend repo + pump-progress-documentation Obsidian vault (frontend section)  
**Approach:** Hub-and-spoke — strong `frontend/README.md` index linking all detail docs

---

## Context

PumpProgress frontend is a Flutter app (v3.9.0) that is part of a larger multi-repo platform. The Obsidian vault at `~/repos/pumpProgress/pump-progress-documentation` is the system-wide documentation home. This spec covers writing the complete frontend documentation set. Cross-repo communication documentation is out of scope and will be a separate effort.

The primary audience is:
- Human contributors (new and existing)
- AI agents (Claude Code and others) who need to orient quickly before touching the codebase

---

## Files to Create / Update

| File | Action | Location |
|---|---|---|
| `CLAUDE.md` | Create | Repo root (`pump-progress-frontend/`) |
| `frontend/README.md` | Update | Obsidian vault |
| `frontend/setup.md` | Create | Obsidian vault |
| `frontend/contributing.md` | Create | Obsidian vault |
| `frontend/architecture/README.md` | Update | Obsidian vault |
| `frontend/architecture/folder-structure.md` | Create | Obsidian vault (replaces `screens-folder-structure.md`) |
| `frontend/architecture/bloc-pattern.md` | Create | Obsidian vault |
| `frontend/architecture/routing.md` | Create | Obsidian vault |

`frontend/architecture/screens-folder-structure.md` is superseded by `folder-structure.md` and should be deleted.

---

## CLAUDE.md (repo root)

**Purpose:** First file any agent reads. Enforces vault-first orientation and captures the non-obvious rules that are not derivable from the code alone.

**Content:**
- Redirect to vault: path and instruction to read `frontend/README.md` before doing anything
- Key rules (non-obvious, not in code comments):
  - No BLoC definitions in `screens/` — they belong in `features/<name>/blocs/`
  - All repositories must be registered as `RepositoryProvider` in `lib/app/app.dart`
  - App-wide blocs (those used across multiple screens) are also provided in `app.dart`
  - Every route entry point must be a `_page.dart` file — the router imports only these
  - New features follow the `features/<name>/` layer structure exactly
- Flavor run commands (quick reference for the most common operations)

---

## `frontend/README.md` (hub index)

**Purpose:** Single entry point for all frontend documentation. Any human or agent reading this should be able to find any other doc from here.

**Content:**
- One-paragraph description of the app (gym workout tracker, local-first with backend sync, iOS/Android)
- System context note: part of a larger platform; links to other repos will be added once those docs are written
- Quick-start: 3 commands (install fvm, pin flutter version, run local flavor)
- Table of contents linking every doc in the `frontend/` section with a one-line description each

---

## `frontend/setup.md`

**Purpose:** Get a developer from zero to running the app locally.

**Content:**
- Prerequisites: Flutter via fvm, Xcode (iOS), Android Studio (Android)
- Install fvm and pin the Flutter version: `fvm install`, `fvm use stable -p`
- Run commands for each flavor:
  - local: `fvm flutter run -t lib/main_local.dart` (hits localhost:6000)
  - dev: `fvm flutter run -t lib/main_dev.dart` (hits prod API, dev flavor)
  - prod: `fvm flutter run -t lib/main_prod.dart`
- Environment variables: `HUGGING_FACE_TOKEN` — what it is (Gemma model download), how to pass it via `--dart-define=HUGGING_FACE_TOKEN=<token>`
- Regenerating flavors: `fvm dart run flutter_flavorizr` (when to run this)
- CI/CD:
  - Production (main branch): tag format `v1.0.0+1` — no `-test` suffix
  - Staging (staging branch): tag format `v1.0.0+1-test`
  - pubspec.yaml version must match the tag before tagging

---

## `frontend/contributing.md`

**Purpose:** Onboard a contributor to the workflow and conventions quickly.

**Content:**
- Start here: read vault architecture docs before touching code
- Branch naming: (to be confirmed by repo owner — placeholder with common convention)
- Adding a new feature checklist:
  1. Create `lib/features/<name>/` with required layers
  2. Register repository in `lib/app/app.dart` as `RepositoryProvider`
  3. Register app-wide BLoCs in `lib/app/app.dart` as `BlocProvider`
  4. Create screen under `lib/screens/<name>/` following the `_page.dart` / `view/` contract
  5. Register route in `lib/config/routes/router.dart`
- Linting: `fvm flutter analyze` — must pass before PR
- PR checklist: route registered, repository in app.dart, BLoC registered if app-wide, no UI logic in features/, no BLoC definitions in screens/

---

## `frontend/architecture/README.md` (updated)

**Purpose:** Orienting overview of the four-layer architecture. Links to detail docs.

**Content:**
- Four-layer table:

| Layer | Path | What belongs here | What does NOT belong here |
|---|---|---|---|
| Features | `lib/features/` | BLoCs, repositories, local data sources, domain models, DB entities | UI widgets, screen navigation |
| Screens | `lib/screens/` | Pages, views, screen-private widgets | BLoC definitions, business logic |
| Config | `lib/config/` | Router, theme, app-wide constants | Feature logic, UI components |
| Utils | `lib/utils/` | Shared helpers, API client, DB service, Cognito client | Feature-specific logic |

- Dependency rule: screens depend on features; features never depend on screens; utils and config have no dependencies on features or screens
- Links to: `folder-structure.md`, `bloc-pattern.md`, `routing.md`

---

## `frontend/architecture/folder-structure.md`

**Purpose:** Complete reference for where every file type lives. Replaces `screens-folder-structure.md` and extends it to cover the entire `lib/` tree.

**Content:**

### Full `lib/` annotated tree
```
lib/
├── app/
│   └── app.dart                  # App root: registers all RepositoryProviders and BlocProviders
├── bootstrap.dart                # App init: Sentry, Gemma, orientation lock
├── flavors.dart                  # Flavor enum + base URL resolution
├── main.dart / main_dev.dart / main_local.dart / main_prod.dart
├── config/
│   ├── constants/                # App-wide constants (local storage keys, icon font)
│   ├── routes/                   # Router, ProtectedRoute
│   └── theme/                   # Colors, fonts, MaterialTheme
├── features/
│   └── <feature_name>/
│       ├── blocs/
│       │   ├── bloc_<name>/      # One folder per BLoC: *_bloc.dart, *_event.dart, *_state.dart
│       │   └── blocs.dart        # Barrel export for all blocs in this feature
│       ├── domain/
│       │   ├── <model>.dart      # Pure Dart domain model (used by UI and BLoC)
│       │   └── domain.dart       # Barrel export
│       ├── models/
│       │   └── entities/         # SQLite row representations (ExerciseRow, WorkoutRow, etc.)
│       ├── local/                # SQLite query methods (wraps SqlDatabaseService)
│       └── repository/
│           ├── repository_<name>.dart   # Coordinates local (and optionally remote) data sources
│           └── repository.dart          # Barrel export
├── screens/
│   └── <screen_name>/
│       ├── <screen_name>_page.dart   # Route entry point: provides BLoCs, handles route args
│       └── view/
│           ├── <screen_name>_view.dart  # Stateless UI root, consumes BLoC state
│           └── widgets/               # Widgets private to this screen
└── utils/
    ├── helpers/                  # AppLogger, ErrorEventBus, runSafeEvent, JWT parser, etc.
    └── services/                 # ApiClientPP (Dio), SqlDatabaseService, CognitoUserPool
```

### Feature layer responsibilities
| Layer | File/Folder | Responsibility |
|---|---|---|
| `domain/` | `<model>.dart` | Pure Dart class. The shape the rest of the app works with. |
| `models/entities/` | `*_row.dart` | SQLite row representation. Has `toMap()` / `fromMap()`. |
| `local/` | `local_<name>.dart` | Raw SQLite queries via `SqlDatabaseService`. Returns entities. |
| `repository/` | `repository_<name>.dart` | Converts entities → domain models. Called by BLoCs. |
| `blocs/bloc_<name>/` | `*_bloc/event/state.dart` | State machine. Calls repository. Emits states. |

### Screen layer responsibilities
| File | Responsibility |
|---|---|
| `_page.dart` | Only file the router imports. Provides BLoCs via `BlocProvider`. Passes route args. No UI. |
| `_view.dart` | Stateless widget. Reads BLoC state. Composes widgets/. |
| `widgets/` | Private to this screen. If a widget is reused, it moves to a shared library. |

### Rules
1. No BLoC definitions in `screens/` — they belong in `features/<name>/blocs/`
2. `_page.dart` is the only file the router imports
3. `widgets/` is screen-private — cross-screen widgets go to a shared component library
4. Repositories are the only entry point from BLoCs to data — BLoCs never call `local/` directly
5. `_shared/` screens (splash, loading, error) have no BLoC dependency

---

## `frontend/architecture/bloc-pattern.md`

**Purpose:** Reference for the BLoC conventions used throughout the app.

**Content:**
- File structure inside `blocs/bloc_<name>/`: three files split via `part` directive
- State shape: single state class with a `status` field (subclasses for Initial/Loading/Success/Error), `copyWith`, `Equatable`
- Event shape: sealed base event class, one subclass per action
- `runSafeEvent` helper: wraps event handler in try/catch, emits error state automatically — always use this for async handlers
- Barrel export: `blocs.dart` in the feature's `blocs/` folder exports all public BLoC classes
- Where BLoCs are provided:
  - App-wide (used across multiple screens): `lib/app/app.dart` `MultiBlocProvider`
  - Screen-scoped (used by one screen only): `_page.dart` `BlocProvider`
- Naming convention: `<Feature>Bloc`, `<Feature>Event`, `<Feature>State`, events as `<Action><Feature>Event`

---

## `frontend/architecture/routing.md`

**Purpose:** How to read the router and how to add a new route.

**Content:**
- `PumpProgressRouter.onGenerateRoute` — switch on `settings.name`, returns `MaterialPageRoute`
- `ProtectedRoute` — wraps routes that require authentication; redirects to login if unauthenticated
- Adding a new route:
  1. Create a `_page.dart` for the screen
  2. Define an args class in `router.dart` if the route needs parameters (e.g. `WorkoutsPageArguments`)
  3. Add a `case` in `onGenerateRoute`, cast `settings.arguments` to the args class
  4. Wrap with `ProtectedRoute` if auth is required
- Route name convention: defined as `static const routeName = '/route-name'` on the page class
- Current routes table (name → page class → requires auth)

---

## Constraints and decisions

- `screens-folder-structure.md` is deleted — its content is fully absorbed into `folder-structure.md`
- Branch naming convention in `contributing.md` is left as a placeholder — confirm with repo owner
- Cross-repo links in `frontend/README.md` are stubs — will be filled when other repo docs are written
- `CLAUDE.md` uses an absolute path to the vault; this assumes the standard checkout location

---

## Out of scope

- Backend, infrastructure, or mobile release pipeline documentation
- Inter-repo communication documentation (separate future effort)
- Step-by-step annotated code templates (Option B — deferred)
