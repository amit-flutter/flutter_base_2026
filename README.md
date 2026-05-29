# MasterTool — Flutter Production Base

A production-grade Flutter project template with pre-built standards, AI agents, reusable core modules, build/deploy tooling, and feature scaffolding.

> **Use this repo** to bootstrap every new Flutter project with latest native configs.
> Clone once → keep forever → create unlimited projects.

---

## Quick Start (for a new project)

```bash
# 1. Clone mastertool (do this once, keep it forever)
git clone https://github.com/amit-flutter/mastertool.git

# 2. Go into mastertool to run the creator script
cd mastertool

# 3. Create a new project — it appears as a sibling folder
./tool/new_project.sh com.yourcompany your_app_name

# 4. Move into the new project
cd ../your_app_name

# 5. Copy dependencies from mastertool's pubspec.yaml to your new project's pubspec.yaml
#    (or manually add the packages you need from the list below)

# 6. Get dependencies
flutter pub get

# 7. Verify everything is clean
flutter analyze

# 8. Start building features
dart run tool/generate_feature.dart auth
dart run tool/build.dart --flavor dev --mode run
```

### Folder structure after creation

```
Your Workspace/
├── mastertool/           ← cloned once, never delete
│   ├── lib/core/         ← reusable widgets, theme, network, utils...
│   ├── tool/             ← build & scaffold tools
│   └── AGENTS.md, STANDARDS.md, analysis_options.yaml
│
├── your_app_name/        ← your new project
│   ├── lib/
│   │   ├── core/         ← copied from mastertool
│   │   └── main.dart
│   ├── android/          ← fresh native configs from flutter create
│   ├── ios/              ← fresh native configs from flutter create
│   └── pubspec.yaml      ← add dependencies manually
│
├── client_b_app/         ← your next project
└── freelance_app/        ← your next-next project
```

> **Why this way?** `flutter create` always gives you the latest Android/iOS/Gradle/Kotlin configs.
> MasterTool gives you the code. You get both, nothing stale.

---

## What's Included

### 1. Standards & Conventions
- **`AGENTS.md`** (150 lines) — Always-active rules loaded every prompt: architecture, state management, UI, code quality, navigation, logging, testing, responsive/adaptive, localization
- **`STANDARDS.md`** (3,000+ lines) — Deep reference handbook with 15 sections. Read on demand per task
- **`analysis_options.yaml`** — 40+ strict lint rules

### 2. AI Agent Configuration
- **`opencode.json`** — Loads `AGENTS.md` as instructions for every prompt
- Reference flow: AGENTS.md (always) + STANDARDS.md (read per section) = zero instruction conflicts

### 3. Pre-built Core Layer (`lib/core/`)
| Module | Files | Description |
|---|---|---|
| **Theme** | `app_colors.dart`, `app_text_styles.dart`, `app_theme.dart` | Light + dark, Material 3, all component themes |
| **Constants** | `app_strings.dart`, `app_assets.dart`, `app_routes.dart`, `app_icons.dart`, `app_endpoints.dart`, `app_spacing.dart` | Zero raw values in widgets |
| **Config** | `flavor.dart`, `env_config.dart`, `app_config.dart` | Dev/staging/prod flavors, JSON config per env |
| **Utils** | `logger.dart`, `responsive.dart`, `validators.dart` | Emoji logger, breakpoint helper, form validators |
| **Errors** | `failures.dart`, `result.dart` | 7 sealed Failure types, Result<T> type |
| **Network** | `dio_client.dart`, `dio_interceptors.dart`, `api_response.dart`, `pagination_state.dart` | 4 interceptors, generic API response, pagination state |
| **Widgets** | 13 widgets | AppScaffold, AppButton, AppTextField, AppLoading, AppErrorView, AppEmptyView, AppShimmer, AppCard, AppDialog, AppNetworkImage, AppSearchBar, AppSectionHeader, AppSnackbar |
| **Router** | `app_router.dart` | go_router with ShellRoute, 404, auth routes |
| **Bootstrap** | `bootstrap.dart`, `app.dart` | Async init, MaterialApp.router wiring |

**Barrel:** `import 'package:mastertool/core/core.dart';` — single import for everything

### 4. Pre-loaded Packages (`pubspec.yaml`)
28 dependencies with pinned exact versions:
- State: `flutter_riverpod`, `riverpod_annotation`, `freezed_annotation`, `json_annotation`
- Network: `dio`, `connectivity_plus`
- Navigation: `go_router`
- Storage: `shared_preferences`, `flutter_secure_storage`, `path_provider`
- UI: `cached_network_image`, `shimmer`, `flutter_svg`, `lottie`
- Firebase: `core`, `crashlytics`, `analytics`, `messaging`, `remote_config`
- Monitoring: `sentry_flutter`
- Device: `package_info_plus`, `device_info_plus`, `permission_handler`, `url_launcher`, `share_plus`, `local_auth`, `image_picker`
- Utils: `intl`
- Dev: `build_runner`, `freezed`, `json_serializable`, `riverpod_generator`, `mocktail`

### 5. Tooling (`tool/`)
| Tool | Command | Purpose |
|---|---|---|
| **Build/Deploy** | `dart run tool/build.dart` | Build AAB/APK/Web/Run by flavor (dev/staging/prod) with obfuscation, dart-define, Firebase deploy |
| **Feature Scaffold** | `dart run tool/generate_feature.dart <name>` | Generates feature directory with DTO, entity, repository, provider, page, barrel |

### 6. Assets Structure
```
assets/
├── images/       # PNG, JPG, WebP, AVIF
├── icons/        # SVG
├── fonts/        # TTF/OTF
├── animations/   # Lottie (.json), Rive (.riv)
└── configs/      # dev.json, staging.json, prod.json
```

---

## Directory Structure

```
lib/
├── core/                     # Reusable across all features
│   ├── config/               # Flavor detection, env config
│   ├── constants/            # Strings, assets, routes, icons, endpoints, spacing
│   ├── errors/               # Failure types, Result<T>
│   ├── network/              # Dio client, interceptors, API response, pagination
│   ├── router/               # go_router config
│   ├── theme/                # Colors, text styles, ThemeData
│   ├── utils/                # Logger, responsive, validators
│   ├── widgets/              # Reusable UI components
│   ├── app.dart              # MaterialApp.router
│   ├── bootstrap.dart        # Async initialization
│   └── core.dart             # Barrel export
├── features/                 # Feature modules (generated via scaffold tool)
│   └── {feature_name}/
│       ├── data/             # DTOs, datasources, repository impl
│       ├── domain/           # Entities, repository interfaces
│       └── presentation/     # Providers, pages, widgets
└── main.dart                 # Entry point
```

---

## Quick Start

```bash
# 1. Clone / use template
git clone https://github.com/your-org/flutter-base.git my-new-project

# 2. Update project name
#    - pubspec.yaml name
#    - Android: android/app/build.gradle.kts
#    - iOS: Runner.xcodeproj

# 3. Update environment configs
#    Edit assets/configs/dev.json, staging.json, prod.json
#    Update tool/build_config.dart with real values

# 4. Get dependencies
flutter pub get

# 5. Generate first feature
dart run tool/generate_feature.dart auth

# 6. Run
dart run tool/build.dart --flavor dev --mode run
```

---

## Style Enforcement

```bash
flutter analyze    # 0 warnings = clean
dart format .      # auto-format
```

All packages pinned to exact versions — no `^` in `pubspec.yaml`.

---

## Architecture Rules

- **Feature-first layout:** `features/{name}/{data,domain,presentation}/`
- **Riverpod exclusively** for state management
- **Immutable state** with `@freezed` or sealed classes
- **Responsive UI** via `Responsive` helper — never raw `MediaQuery`
- **Adaptive layouts** — `NavigationRail` on tablet/desktop, `BottomNavigationBar` on mobile
- **go_router** with `ShellRoute` for persistent layouts
- **Zero business logic in widgets** — widgets are pure UI
- **Zero direct API calls from UI** — always through repository/provider
- **Accessible by default** — text scaling, semantics, 48px tap targets

For full detail, see `STANDARDS.md`.

---

## Deferred Modules

These are documented but not implemented yet (add on demand per TL recommendation):

- App Lifecycle (foreground/background, session timeout)
- Storage Abstraction (preferences, secure storage, cache manager)
- Security (jailbreak detection, SSL pinning, biometric)
- Crash & Log Reporting (analytics service, crashlytics wrapper)
- CI/CD (GitHub Actions workflows)

## Tags

This repo uses tags to mark base setup versions:

- `v1.0.0` — Initial production base with all 15 phases (core, lifecycle, storage, security, analytics, CI/CD)

After updating the template, tag a new version:
```bash
git tag v1.1.0
git push origin v1.1.0
```

---

*Created by [Amit Kumar](https://www.linkedin.com/in/amitflutter/)*
