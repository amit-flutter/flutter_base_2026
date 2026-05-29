# Flutter Production Standards

> Target: Production-grade, scalable Flutter application
> Review status: Pending

> **For AI Agents — How to use this document:**
> 1. When assigned a task, identify the relevant section(s) below.
> 2. **Read the ENTIRE section** before writing code — each section contains interconnected rules; skipping parts leads to inconsistent output.
> 3. Cross-reference: Theming (§3.5) ↔ Design System (§3.5.4); Network (§11) ↔ Security (§10) ↔ Error Handling (§9); DTOs (§11.11) ↔ Feature Structure (§1.5).
> 4. For every code change, also check: AGENTS.md (always-active rules), then come here for deep details on your specific area.
> 5. If a section references another section (e.g. "see STANDARDS.md §9.4"), follow that link and read it too.

---

## Table of Contents

1. [Architecture & Project Structure](#1-architecture--project-structure)
    - [1.1 Feature-first Directory Layout](#11-feature-first-directory-layout)
    - [1.2 Clean Architecture per Feature](#12-clean-architecture-per-feature)
    - [1.3 Repository Pattern](#13-repository-pattern)
    - [1.4 Other Structural Rules](#14-other-structural-rules)
    - [1.5 Feature Template / Scaffolding](#15-feature-template--scaffolding)
2. [State Management](#2-state-management)
    - [2.1 Choice of Framework](#21-choice-of-framework)
    - [2.2 State Patterns](#22-state-patterns)
    - [2.3 What Not to Do](#23-what-not-to-do)
    - [2.4 Riverpod Best Practices](#24-riverpod-best-practices)
3. [UI & Widget Practices](#3-ui--widget-practices)
    - [3.1 Const Constructors](#31-const-constructors)
    - [3.2 Build Method Discipline](#32-build-method-discipline)
    - [3.3 Widgets Over Functions](#33-widgets-over-functions)
    - [3.4 Widget Selection Rules](#34-widget-selection-rules)
    - [3.5 Theme System](#35-theme-system)
    - [3.6 Constants & Resource Organization](#36-constants--resource-organization)
    - [3.7 Reusable & Customizable Widgets](#37-reusable--customizable-widgets)
    - [3.8 Repaint Boundaries](#38-repaint-boundaries)
    - [3.9 Responsive & Adaptive UI](#39-responsive--adaptive-ui)
    - [3.10 Localization](#310-localization)
4. [Performance & Rebuild Optimization](#4-performance--rebuild-optimization)
    - [4.1 Golden Rule](#41-golden-rule)
    - [4.2 Rebuild Prevention](#42-rebuild-prevention)
    - [4.3 List Performance](#43-list-performance)
    - [4.4 Image Performance](#44-image-performance)
    - [4.5 Animation Performance](#45-animation-performance)
    - [4.6 Build Phase Optimization](#46-build-phase-optimization)
5. [Memory Management](#5-memory-management)
    - [5.1 Controller Lifecycle](#51-controller-lifecycle)
    - [5.2 Context & Async Safety](#52-context--async-safety)
    - [5.3 Widget Memory](#53-widget-memory)
6. [Package Management](#6-package-management)
    - [6.1 Version Pinning](#61-version-pinning)
    - [6.2 Dependency Vetting](#62-dependency-vetting)
    - [6.3 Package Choice Hierarchies](#63-package-choice-hierarchies)
    - [6.4 Maintenance Rules](#64-maintenance-rules)
7. [Code Quality & Linting](#7-code-quality--linting)
    - [7.1 analysis_options.yaml](#71-analysis_optionsyaml)
    - [7.2 Type Safety](#72-type-safety)
    - [7.3 Code Organization](#73-code-organization)
    - [7.4 Lint Discipline](#74-lint-discipline)
8. [Testing](#8-testing)
    - [8.1 Test Pyramid](#81-test-pyramid)
    - [8.2 Unit Testing Rules](#82-unit-testing-rules)
    - [8.3 Widget Testing Rules](#83-widget-testing-rules)
    - [8.4 Golden Tests](#84-golden-tests)
    - [8.5 Testing Anti-patterns](#85-testing-anti-patterns)
9. [Error Handling, Logging & Crash Reporting](#9-error-handling-logging--crash-reporting)
    - [9.1 Core Principles](#91-core-principles)
    - [9.2 Result Type Pattern](#92-result-type-pattern)
    - [9.3 UI Error Handling](#93-ui-error-handling)
    - [9.4 Logging](#94-logging)
    - [9.5 Crash Reporting](#95-crash-reporting)
    - [9.6 Failure Categories](#96-failure-categories)
10. [Security](#10-security)
    - [10.1 Secrets Management](#101-secrets-management)
    - [10.2 Secure Storage](#102-secure-storage)
    - [10.3 Network Security](#103-network-security)
    - [10.4 Build Security](#104-build-security)
    - [10.5 Input Validation](#105-input-validation)
    - [10.6 Security Hardening](#106-security-hardening)
11. [Network & API](#11-network--api)
    - [11.1 HTTP Client Choice](#111-http-client-choice)
    - [11.2 Dio Configuration](#112-dio-configuration)
    - [11.3 Dio Instance as a Riverpod Provider](#113-dio-instance-as-a-riverpod-provider)
    - [11.4 Interceptors](#114-interceptors)
    - [11.5 Endpoint Constants](#115-endpoint-constants)
    - [11.6 Error Mapping](#116-error-mapping)
    - [11.7 Repository Data Source Pattern](#117-repository-data-source-pattern)
    - [11.8 Firebase Integration](#118-firebase-integration)
    - [11.9 API Design Conventions](#119-api-design-conventions)
    - [11.11 API Model Standards](#1111-api-model-standards)
    - [11.12 API Testing](#1112-api-testing)
12. [App Size Optimization](#12-app-size-optimization)
    - [12.1 Build Artifacts](#121-build-artifacts)
    - [12.2 Assets](#122-assets)
    - [12.3 Code](#123-code)
    - [12.4 File-Level Audit](#124-file-level-audit---analyze-size)
13. [Build & CI/CD](#13-build--cicd)
    - [13.1 Flavors](#131-flavors)
    - [13.2 CI Pipeline](#132-ci-pipeline)
    - [13.3 Version Management](#133-version-management)
    - [13.4 Pre-commit Checks](#134-pre-commit-checks)
    - [13.5 CI Quality Gates](#135-ci-quality-gates)
14. [Performance Monitoring](#14-performance-monitoring)
    - [14.1 Firebase Performance Monitoring](#141-firebase-performance-monitoring)
    - [14.2 Frame Timing & Jank Thresholds](#142-frame-timing--jank-thresholds)
    - [14.3 Startup Time Targets](#143-startup-time-targets)
    - [14.4 Memory Budgets](#144-memory-budgets)
15. [Navigation & Routing](#15-navigation--routing)
    - [15.1 Choice of Router](#151-choice-of-router)
    - [15.2 Route Definition Structure](#152-route-definition-structure)
    - [15.3 URL / Route Naming Conventions](#153-url--route-naming-conventions)
    - [15.4 AppRoutes Constants](#154-approutes-constants)
    - [15.5 Navigation in Code](#155-navigation-in-code)
    - [15.6 Deep Linking](#156-deep-linking)
    - [15.7 Route Guards (Auth Protection)](#157-route-guards-auth-protection)
    - [15.8 Transition Animations](#158-transition-animations)
    - [15.9 Error / 404 Handling](#159-error--404-handling)
    - [15.10 Web-Specific Routing](#1510-web-specific-routing)

---

## 1. Architecture & Project Structure

### 1.1 Feature-first Directory Layout

Organize by feature, not by layer. Every feature is self-contained, easy to navigate, and can be extracted into a standalone module if needed.

```
lib/
├── core/                  # Shared across features
│   ├── constants/
│   ├── extensions/
│   ├── theme/
│   ├── router/
│   ├── network/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/    # abstract contracts
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── pages/
│   │       └── widgets/
│   ├── home/
│   └── checkout/
└── main.dart
```

**Rule:** Domain layer has **zero import dependencies** on data, presentation, or Flutter SDK. It depends only on Dart SDK and core domain entities.

### 1.2 Clean Architecture per Feature

- **Data layer:** Handles external sources (API, local DB, cache). Contains DTOs/models, datasources, and repository implementations.
- **Domain layer:** Business logic. Contains entities, repository contracts (abstract classes), and use cases. Pure Dart — no Flutter imports.
- **Presentation layer:** UI + state management (Riverpod providers). Depends on domain layer only.

### 1.3 Repository Pattern

- Repository classes abstract the data source decision (API vs local cache).
- UI / use cases never know whether data came from network or database.
- Repositories return domain entities, never DTOs.

### 1.4 Other Structural Rules

| Rule | Rationale |
|---|---|
| One class = one file | No god files. Every file under 400 lines. |
| Export barrel files per feature | Clean imports: `import 'package:app/features/auth'` |
| No circular dependencies | Use `dart run dependency_validator` in CI |
| Avoid `part` / `part of` | Increases coupling. Use imports instead. |
| Features must not directly import another feature's data layer | Shared logic goes in `core/` or shared domain modules |

### 1.5 Feature Template / Scaffolding

Every feature follows an identical file structure. This ensures consistency across the codebase regardless of who wrote it.

#### 1.5.1 Standard Feature Directory Tree

```
features/{name}/
├── data/
│   ├── datasources/
│   │   ├── {name}_remote_datasource.dart
│   │   └── {name}_local_datasource.dart
│   ├── models/
│   │   ├── {name}_dto.dart           # @freezed DTO
│   │   └── {name}_dto.g.dart
│   └── repositories/
│       └── {name}_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── {name}.dart               # @freezed entity
│   ├── repositories/
│   │   └── {name}_repository.dart     # abstract contract
│   └── usecases/                       # optional — for complex features
│       └── get_{name}_usecase.dart
└── presentation/
    ├── providers/
    │   ├── {name}_provider.dart
    │   └── {name}_state.dart          # freezed state class
    ├── pages/
    │   └── {name}_page.dart
    └── widgets/
        ├── {name}_list_tile.dart
        └── {name}_empty_state.dart
```

#### 1.5.2 File Naming Conventions

| File Type | Pattern | Example |
|---|---|---|
| Page | `{name}_page.dart` | `profile_page.dart` |
| Provider | `{name}_provider.dart` | `auth_provider.dart` |
| State | `{name}_state.dart` | `cart_state.dart` |
| Repository interface | `{name}_repository.dart` | `user_repository.dart` |
| Repository impl | `{name}_repository_impl.dart` | `user_repository_impl.dart` |
| DTO | `{name}_dto.dart` | `product_dto.dart` |
| Entity | `{name}.dart` | `product.dart` |
| Use case | `{verb}_{name}_usecase.dart` | `get_user_usecase.dart` |
| Remote datasource | `{name}_remote_datasource.dart` | `auth_remote_datasource.dart` |
| Local datasource | `{name}_local_datasource.dart` | `cart_local_datasource.dart` |
| Widget | `{name}_{widget}.dart` | `product_list_tile.dart` |

#### 1.5.3 Barrel Export Convention

Every feature directory exports a barrel file for clean imports.

```dart
// features/auth/auth.dart  —  barrel file
export 'data/repositories/auth_repository_impl.dart';
export 'domain/entities/user.dart';
export 'domain/repositories/auth_repository.dart';
export 'presentation/providers/auth_provider.dart';
export 'presentation/pages/login_page.dart';
```

Usage:
```dart
import 'package:app/features/auth';
// vs
import 'package:app/features/auth/domain/entities/user.dart';
// vs
import 'package:app/features/auth/presentation/pages/login_page.dart';
```

#### 1.5.4 Feature Scaffold Checklist

Every new feature must verify:

- [ ] Barrel file exports all public types
- [ ] Domain layer has zero Flutter imports
- [ ] Repository interface is separate from implementation
- [ ] DTO has `fromJson`/`toJson` (via freezed)
- [ ] Entity has no serialization logic
- [ ] Presentation has loading/error/data states
- [ ] Provider auto-disposes
- [ ] Reusable widgets extracted to `core/widgets/` if used 2+ features

---

## 2. State Management

### 2.1 Choice of Framework

**Riverpod exclusively.** No Provider, BLoC, GetX, or mixed approaches.

| Reason | Detail |
|---|---|
| Compile-safe | Providers are resolved at compile time — no runtime `ProviderNotFoundException` |
| Auto-dispose | Controllers and subscriptions cleaned up automatically when no longer watched |
| Testable | Override any provider in tests without widget tree |
| Family modifiers | Parameterized providers without boilerplate |
| No `BuildContext` dependency | Providers work outside widget tree — use in use cases, services |

### 2.2 State Patterns

| Rule | Rationale |
|---|---|
| Immutable state — use `@freezed` or `sealed class` + `copyWith` | Prevents impossible states. Enables efficient equality comparison |
| `AsyncValue<T>` for async data | Built-in loading/error/data states. Eliminates manual booleans |
| `Notifier` / `AsyncNotifier` over `StateProvider` | Encapsulates business logic inside the provider |
| `ref.watch` at the **top of build** only | Mid-build watch causes subtle bugs and unexpected rebuilds |
| `ref.listen` for side effects (navigation, snackbar) | Never trigger navigation from inside `build` |
| `AutoDispose` for ephemeral state | Prevents memory leaks. Use `.keepAlive()` only when data must survive |
| `ref.invalidate()` for refresh | Triggers provider recreation. Cleaner than manual state reset |
| No `setState` beyond trivial widget-local state | Focus/selection state on a TextField is acceptable. Anything else goes in a provider |

### 2.3 What Not to Do

| Anti-pattern | Why |
|---|---|
| Storing mutable state in providers | Breaks change detection. Always use `copyWith` or immutable collections |
| Watching a provider in a callback | `ref.watch` inside `onPressed` or `GestureDetector.onTap` does nothing |
| Calling `.future` or `.future.then()` outside of `build` | Misses state transitions. Use `ref.listen` |
| Mixing Riverpod with `InheritedWidget` / `ChangeNotifierProvider` | Two state management systems = twice the complexity |

### 2.4 Riverpod Best Practices

#### 2.4.1 Provider Splitting Strategy

| Rule | Rationale |
|---|---|
| One provider = one responsibility | A provider that fetches data + transforms it + caches it does too much |
| Split by lifecycle: ephemeral providers auto-dispose, cached providers use `keepAlive` | Clear ownership of provider lifetime |
| Prefer `AsyncNotifierProvider` over `FutureProvider` + `StateNotifierProvider` | Single provider handles loading/error/data + actions |
| Use `NotifierProvider` for synchronous state mutations | Cleaner than `StateProvider` for complex state |

#### 2.4.2 `select()` Usage

```dart
// ❌ Rebuilds on every state change
final name = ref.watch(userProvider).name;

// ✅ Rebuilds only when name changes
final name = ref.watch(userProvider.select((state) => state.name));
```

| Rule | Rationale |
|---|---|
| Always use `.select()` when watching a single field | Prevents unnecessary rebuilds of the entire widget tree |
| Never use `.select()` inside a provider's build method | Use `ref.watch(otherProvider).select(...)` syntax |
| Extract derived data into separate providers with `select` | Keeps widgets lean and reactive only to what they need |

#### 2.4.3 Family Provider Naming

```dart
// ✅ Correct naming — family + parameter
final userProvider = FutureProvider.family<User, String>((ref, id) {
  return ref.read(userRepositoryProvider).getUser(id);
});

// ❌ Wrong — no parameter naming convention
final userProv = FutureProvider.family((ref, id) => ...);
```

| Rule | Rationale |
|---|---|
| Suffix family providers with the parameter type | `family<String>` makes it clear what to pass |
| Use descriptive parameter names in provider docs | `/// Fetches user by [userId]` |

#### 2.4.4 Async Caching & Invalidation

| Rule | Rationale |
|---|---|
| Use `.keepAlive()` for data that survives navigation | Master data (categories, countries, settings) |
| `ref.invalidate()` on mutations | Forces provider refetch after create/update/delete |
| `ref.refresh()` for optimistic pulls | Pull-to-refresh, retry on error states |
| Never cache user-specific data in a global provider | Use `family(id)` so each user's data is independently cached |

#### 2.4.5 Avoiding Provider Chains

```dart
// ❌ Chain of 3 providers — any change rebuilds all
final cartProvider = Provider((ref) => ...);
final cartTotalProvider = Provider((ref) => calculate(ref.watch(cartProvider)));
final checkoutProvider = Provider((ref) => CheckoutState(ref.watch(cartTotalProvider)));

// ✅ Derived provider with select
final checkoutProvider = Provider((ref) {
  final total = ref.watch(cartProvider.select((c) => c.total));
  return CheckoutState(total);
});
```

| Rule | Rationale |
|---|---|
| Max 2-3 providers in a chain | Beyond that, restructure or use computed properties |
| Prefer `.select()` over watching entire provider | Only rebuild the final provider when relevant data changes |

#### 2.4.6 Side-Effect Isolation

| Rule | Rationale |
|---|---|
| Navigation, snackbar, analytics → `ref.listen` | Never trigger these from inside `build()` |
| Logging → inside provider methods | Log at the source, not in the widget |
| Debounced search → use `Timer` inside provider | Keep debounce logic out of widgets |

```dart
// ✅ Correct — side effect handled via listen
ref.listen(authProvider, (prev, next) {
  next.whenOrNull(data: (user) {
    if (user != null) ref.read(goRouterProvider).go('/home');
  });
});

#### 2.4.7 One Source of Truth

| Rule | Rationale |
|---|---|
| Every piece of state lives in exactly one provider | Derived state watches the source, never duplicates it |
| Never store the same data in multiple providers | Causes sync bugs — updating one doesn't update the other |
| Use `select()` to derive, not duplicate | If `name` is part of `User`, don't create a separate `userNameProvider` |

```dart
// ✅ Correct — single source
final userProvider = FutureProvider<User>(...);
// Derived via select, not duplicated
final userNameProvider = Provider((ref) => ref.watch(userProvider).valueOrNull?.name);

// ❌ Wrong — duplicated state
final userProvider = FutureProvider<User>(...);
final userNameProvider = FutureProvider((ref) => _fetchUserName());  // ❌ duplicate source
```

#### 2.4.8 Avoid Boolean Explosion — Use Sealed State

```dart
// ❌ BAD — boolean explosion
bool isLoading = false;
bool isError = false;
bool isSuccess = false;
bool isRefreshing = false;
bool isEmpty = false;

// ✅ BETTER — sealed class
sealed class UiState<T> {
  const UiState();
}

class Idle<T> extends UiState<T> {
  const Idle();
}

class Loading<T> extends UiState<T> {
  const Loading();
}

class Data<T> extends UiState<T> {
  const Data(this.value);
  final T value;
}

class Error<T> extends UiState<T> {
  const Error(this.message);
  final String message;
}
```

| Rule | Rationale |
|---|---|
| Use `AsyncValue` or sealed state classes | Exhaustive pattern matching — no impossible combinations |
| If `isLoading=true` and `isError=true` at the same time → bug | Sealed states prevent this by design |
| Prefer `AsyncValue` for API data, custom sealed state for complex flows | AsyncValue covers 80% of cases |

---

## 3. UI & Widget Practices

### 3.1 Const Constructors

**Every widget that can be `const` MUST be `const`.**

```dart
// ✅ Correct
const Padding(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)

// ❌ Wrong
Padding(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)
```

`const` widgets:
- Are allocated exactly **once** — zero allocation cost on rebuilds
- Enable Flutter's widget tree diffing optimization
- Flagged by `missing_const_in_class` lint

### 3.2 Build Method Discipline

| Rule | Rationale |
|---|---|
| Build methods ≤ 80 lines | Unreadable build = untestable = buggy |
| Extract into focused widget classes | `StatelessWidget` subclasses are better than helper functions |
| Extract `build`-only calculations into `const` getters | Don't recompute on every frame |

### 3.3 Widgets Over Functions

```dart
// ✅ Correct — Widget class
class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(product.name));
  }
}

// ❌ Wrong — Helper function
Widget _buildProductTile(Product product) {
  return ListTile(title: Text(product.name));
}
```

**Reasons:**
1. Functions don't participate in the widget tree — no `const`, no hot reload isolation, no `Key` support
2. Functions can't be memoized by Flutter's diff algorithm
3. Debugging is harder — DevTools shows `_buildProductTile` instead of a named widget class

### 3.4 Widget Selection Rules

| Use Case | Preferred Widget | Avoid |
|---|---|---|
| Fixed spacing | `SizedBox(width/height)` | `Container(width/height)` |
| Layout | `Row` / `Column` | `Stack` for simple linear layouts |
| Conditional visibility | `if (condition) ...` or `Offstage` | `Opacity(0)` — triggers `saveLayer()` |
| Centering | `Center` | `Align(alignment: Alignment.center)` — heavier |
| Padding | `Padding` | `Container(padding:)` |
| Empty container | `const SizedBox.shrink()` | `Container()` |
| Loading | `const CircularProgressIndicator()` | Custom spin animations |
| Images | `Image.network` with cached network image | Raw `Image.file` / `Image.asset` without cache |
| Gradients | Use `Container(decoratioin: BoxDecoration(gradient: ...))` sparingly | Gradients trigger `saveLayer()` |

### 3.5 Theme System

#### 3.5.1 Color Palette

Define all colors in a single `AppColors` class. Never use raw `Color(0xFF...)` in widgets.

```dart
class AppColors {
  const AppColors._();

  // Primary palette
  static const primary = Color(0xFF6200EE);
  static const primaryVariant = Color(0xFF3700B3);
  static const secondary = Color(0xFF03DAC6);

  // Surface & background
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF5F5F5);

  // Text
  static const textPrimary = Color(0xFF1D1D1D);
  static const textSecondary = Color(0xFF6B7280);

  // Semantic
  static const error = Color(0xFFB00020);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);

  // Dark mode overrides
  static const backgroundDark = Color(0xFF121212);
  static const surfaceDark = Color(0xFF1E1E1E);
  static const textPrimaryDark = Color(0xFFF5F5F5);
}
```

| Rule | Rationale |
|---|---|
| One color source of truth | No scattered `Color(0xFF...)` across features |
| Prefix with `k` or use static const | Named constants are findable and auto-completable |
| Include dark mode variants from day one | Retrofitting dark mode later is expensive |
| Group by purpose (primary, text, surface, semantic) | Easy to find what to change for theming |

#### 3.5.2 Typography

Define a single `AppTextStyles` class. Every `Text` widget must use a style from here.

```dart
class AppTextStyles {
  const AppTextStyles._();

  static const headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.5,
  );
  static const headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static const bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}
```

| Rule | Rationale |
|---|---|
| Never use raw `TextStyle(...)` in widgets | Every change requires hunting through entire codebase |
| Define sizes by semantic role (headline, body, caption), not by pixel value | "I need a small text" -> `bodySmall`, not `TextStyle(fontSize: 11)` |
| Use `GoogleFonts` or custom font family at the palette level only | Single import point for custom fonts |
| Keep line-height (height) consistent per role | Vertical rhythm breaks when each widget defines its own |

#### 3.5.3 ThemeData Configuration

Create the `ThemeData` in one place using the palette and typography above.

```dart
class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface,
    ),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.headline1,
      headlineMedium: AppTextStyles.headline2,
      bodyLarge: AppTextStyles.bodyLarge,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.label,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryVariant,
      ...
    ),
  );
}
```

| Rule | Rationale |
|---|---|
| Prefer `Theme.of(context).colorScheme.primary` over custom `AppColors` calls | Integrates with Material 3 dynamic theming |
| Define component themes (button, card, input, appbar) in `ThemeData` | Widgets pick it up automatically — no per-widget styling |
| `useMaterial3: true` | Future-proof. Material 2 is deprecated |

#### 3.5.4 Design System Rules

##### 3.5.4.1 Spacing Scale Enforcement

The entire app uses a single spacing scale. Never use arbitrary pixel values.

```
Scale: 2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64
Names: xxs, xs, sm, md, lg, xl, xxl, xxxl, huge, enormous
```

| Rule | Rationale |
|---|---|
| Every `EdgeInsets`, `SizedBox`, `Gap` uses `AppSpacing` values | No raw `EdgeInsets.all(13)` or `SizedBox(height: 7)` |
| Stacking multiple widgets → use `Column` + `SizedBox(height: AppSpacing.sm)` | Consistent rhythm, easy to adjust globally |
| Pre-compose common insets in `AppInsets` | `cardPadding`, `screenPadding`, `listItemPadding` |

##### 3.5.4.2 Typography Hierarchy

| Level | Style Name | Size | Weight | Use Case |
|---|---|---|---|---|
| Display | `displayLarge` | 57 | Bold | Hero text, splash |
| Headline 1 | `headlineLarge` | 32 | Bold | Screen titles |
| Headline 2 | `headlineMedium` | 24 | Semi-bold | Section headers |
| Title | `titleLarge` | 22 | Medium | Card titles |
| Body | `bodyLarge` | 16 | Normal | Primary content |
| Body small | `bodySmall` | 14 | Normal | Secondary content |
| Caption | `labelSmall` | 12 | Medium | Labels, timestamps |
| Button | `labelLarge` | 14 | Medium | Button text |

| Rule | Rationale |
|---|---|
| Every `Text` widget uses one of these 8 roles | Consistent visual rhythm, single point of typography change |
| Never use `TextStyle(fontSize: ...)` in widget code | Every style change requires hunting through codebase |

##### 3.5.4.3 Responsive Breakpoints

```dart
class AppBreakpoints {
  const AppBreakpoints._();

  static const double mobile = 600;      // < 600 → phone
  static const double tablet = 900;     // 600-900 → tablet
  static const double desktop = 1200;   // > 1200 → desktop/web
}
```

| Rule | Rationale |
|---|---|
| Use `LayoutBuilder` or `BoxConstraints` for adaptive layouts | No hardcoded screen width checks |
| Wrap tablet/desktop layouts behind a `DeviceType` provider | Widgets read device type, not raw `MediaQuery` |
| Test at all 3 breakpoints in golden tests | Visual regression catches breakpoint issues |

##### 3.5.4.4 Dark/Light Audit Checklist

Every new screen must pass this checklist before merge:

- [ ] All colors use `AppColors` or `Theme.of(context).colorScheme`
- [ ] No hardcoded `Colors.white` / `Colors.black`
- [ ] Surface colors adapt (not the same in dark/light)
- [ ] Text colors are properly contrasting in both modes
- [ ] Shadows visible in light, subtle or non-existent in dark
- [ ] Images with transparency have proper backgrounds

##### 3.5.4.5 Tablet & Web Adaptations

| Rule | Rationale |
|---|---|
| Use `SliverGrid` with adaptive cross-axis count | Grid items resize naturally on wider screens |
| Cap content width on tablet/desktop (`maxWidth: 1200`) | Readable line length (50-75 characters) |
| Use `NavigationRail` on tablet, `BottomNavigationBar` on phone | Platform-appropriate navigation |
| Support keyboard shortcuts on web/desktop | Expected platform behavior |

### 3.6 Constants & Resource Organization

No magic values anywhere in widget code. Every string, asset path, route, icon, and dimension goes in a centralized constants file.

#### 3.6.1 String Constants

```dart
// lib/core/constants/strings.dart
class AppStrings {
  const AppStrings._();

  // General
  static const appName = 'MasterTool';
  static const ok = 'OK';
  static const cancel = 'Cancel';
  static const retry = 'Retry';
  static const loading = 'Loading...';

  // Auth feature
  static const loginTitle = 'Welcome Back';
  static const emailHint = 'Enter your email';
  static const passwordHint = 'Enter your password';
  static const loginButton = 'Sign In';
  static const signUpPrompt = "Don't have an account? Sign up";
}
```

| Rule | Rationale |
|---|---|
| Every user-facing string in `AppStrings` | One place for localization, review, and updates |
| Group by feature with comments | Easy to find, easy to remove when feature is removed |
| Never concatenate strings in widgets | Reduces translation complexity |

#### 3.6.2 Asset & Image Constants

```dart
// lib/core/constants/assets.dart
class AppAssets {
  const AppAssets._();

  // Icons (SVG)
  static const iconHome = 'assets/icons/home.svg';
  static const iconProfile = 'assets/icons/profile.svg';
  static const iconSettings = 'assets/icons/settings.svg';

  // Images
  static const imgLogo = 'assets/images/logo.png';
  static const imgEmptyState = 'assets/images/empty_state.svg';
  static const imgErrorState = 'assets/images/error_state.svg';

  // Lottie animations
  static const animLoading = 'assets/animations/loading.json';
  static const animSuccess = 'assets/animations/success.json';

  // Placeholder
  static const placeholder = 'assets/images/placeholder.png';
}
```

| Rule | Rationale |
|---|---|
| Every asset path in `AppAssets` | Renaming an asset file = change one constant. No hunting |
| Group by asset type (icons, images, animations) | Clear which directory each asset lives in |
| Use `svg` for icons, `png/webp` for photos, `json` for Lottie | Right format for right use case |

#### 3.6.3 Route Constants

```dart
// lib/core/constants/routes.dart
class AppRoutes {
  const AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const profile = '/profile/:userId';
  static const settings = '/settings';
  static const productDetail = '/product/:productId';
}
```

| Rule | Rationale |
|---|---|
| Every route path in `AppRoutes` | Route names are strings — no type safety without constants |
| Use path parameters with `:` (go_router convention) | Consistent with go_router syntax |

#### 3.6.4 Icon Constants

```dart
// lib/core/constants/icons.dart
class AppIcons {
  const AppIcons._();

  // Use Material icons or custom SVG icons
  static const home = Icons.home_outlined;
  static const search = Icons.search;
  static const cart = Icons.shopping_cart_outlined;
  static const profile = Icons.person_outline;
  static const add = Icons.add_circle_outline;
  static const delete = Icons.delete_outline;
  static const edit = Icons.edit_outlined;
  static const back = Icons.arrow_back;
  static const close = Icons.close;
  static const menu = Icons.menu;
}
```

| Rule | Rationale |
|---|---|
| Centralize icon references | Swap icon set globally (Material → Cupertino → custom SVG) in one place |
| Use `_outlined` variants as default | Outlined icons are lighter visually and trend towards Material 3 |

#### 3.6.5 Dimension & Spacing Constants

```dart
// lib/core/constants/dimensions.dart
class AppSpacing {
  const AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

class AppInsets {
  const AppInsets._();

  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(horizontal: AppSpacing.md);
  static const EdgeInsets cardPadding = EdgeInsets.all(AppSpacing.md);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  );
}

class AppRadius {
  const AppRadius._();

  static const double sm = 4;
  static const double md = 8;
  static const double lg = 16;
  static const double full = 999;
}
```

| Rule | Rationale |
|---|---|
| No raw `EdgeInsets.all(16)` or `SizedBox(height: 24)` | Inconsistent spacing is the #1 visual regression |
| Use semantic spacing (sm, md, lg) over pixel values | Easy to adjust the entire app spacing scale |
| Define common insets as pre-composed EdgeInsets | Avoids repetition of common padding patterns |

### 3.7 Reusable & Customizable Widgets

#### 3.7.1 Principle

Every widget that appears more than once must be extracted into a reusable, customizable component. Reusable widgets follow a consistent API pattern.

#### 3.7.2 Widget API Pattern

```dart
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

**API rules for all reusable widgets:**

| Rule | Rationale |
|---|---|
| `super.key` as first parameter | Every widget must accept a key for widget tree reconciliation |
| `required` for mandatory props | Compiler help — can't forget critical parameters |
| Named parameters only (no positional) | Self-documenting call sites |
| Sensible defaults for every optional prop | Consumer writes minimum code for common case |
| Suffix with `expanded` / `onChanged` pattern | Consistent API across all custom widgets |
| Accept `Widget?` (not `Widget Function()` factory) | Gives caller flexibility — can pass any widget |

#### 3.7.3 Widget Composition Rules

| Rule | Rationale |
|---|---|
| Prefer composition over configuration flags | Too many booleans make a widget untestable |
| Extract into `Slots` pattern for complex widgets | Feature: `header`, `footer`, `leading`, `trailing` slots |
| Use `DefaultTextStyle.merge` / `Theme` for inherited styling | Widget picks up parent styling without explicit props |
| Never hardcode padding/margin inside reusable widgets | Accept padding via constructor or use theme defaults |
| Support `onTap` / `onLongPress` as separate callbacks | Don't overload a single callback |

#### 3.7.4 Common Reusable Components

Every project should have these basic reusable widgets:

```
lib/core/widgets/
├── app_button.dart
├── app_text_field.dart
├── app_card.dart
├── app_dialog.dart
├── app_snackbar.dart
├── app_appbar.dart
├── app_loading.dart
├── app_error_state.dart
├── app_empty_state.dart
├── app_image.dart
├── app_avatar.dart
├── app_badge.dart
└── app_divider.dart
```

| Rule | Rationale |
|---|---|
| Prefix shared widgets with `App` | Instant recognition: "this is our widget, not Flutter's" |
| Every reusable widget has same API conventions | Developers can predict how to use any shared widget |
| Document non-obvious behavior with dart doc | `/// Shows a loading overlay. Disables interaction below.` |

### 3.8 Repaint Boundaries

```dart
RepaintBoundary(
  child: MapWidget(),
)
```

Place `RepaintBoundary` around:
- Maps
- Charts (fl_chart, syncfusion)
- CustomPaint widgets
- Video players
- WebViews

This isolates repaint: scrolling a list outside doesn't force the map to redraw every frame.

### 3.9 Responsive & Adaptive UI

#### 3.9.1 Centralized Responsive System

Create a single responsive helper that all widgets use. Never write `MediaQuery.of(context)` in widget code.

```dart
// lib/core/utils/responsive.dart
class AppBreakpoints {
  const AppBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

enum DeviceType { mobile, tablet, desktop }

class Responsive {
  const Responsive._();

  static DeviceType deviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppBreakpoints.mobile) return DeviceType.mobile;
    if (width < AppBreakpoints.tablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static bool isMobile(BuildContext context) => deviceType(context) == DeviceType.mobile;
  static bool isTablet(BuildContext context) => deviceType(context) == DeviceType.tablet;
  static bool isDesktop(BuildContext context) => deviceType(context) == DeviceType.desktop;

  /// Adaptive value: returns [mobile] / [tablet] / [desktop] value based on screen size
  static T value<T>(BuildContext context, {required T mobile, T? tablet, T? desktop}) {
    return switch (deviceType(context)) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.desktop => desktop ?? tablet ?? mobile,
    };
  }
}
```

| Rule | Rationale |
|---|---|
| Never call `MediaQuery.of(context)` directly in widgets | Every widget that calls it rebuilds on rotation/resize |
| Use `Responsive.value()` for adaptive values | Single source of breakpoint logic, easy to test |
| Provide `Responsive` as a Riverpod provider | Caches device type, only rebuilds when breakpoint changes |

#### 3.9.2 Device-Specific Provider (Performance Optimized)

```dart
// lib/core/providers/device_provider.dart
final deviceTypeProvider = Provider<DeviceType>((ref) {
  final mediaQuery = ref.watch(mediaQueryProvider);
  final width = mediaQuery.size.width;
  if (width < AppBreakpoints.mobile) return DeviceType.mobile;
  if (width < AppBreakpoints.tablet) return DeviceType.tablet;
  return DeviceType.desktop;
});
```

| Rule | Rationale |
|---|---|
| Watch `deviceTypeProvider` at the **screen level**, not inside list items | Prevents entire list from rebuilding on orientation change |
| Use `context.select(deviceTypeProvider)` over `ref.watch` | More precise rebuild targeting |
| Memoize expensive responsive calculations | Wrap with `KeepAlive` or compute once per breakpoint |

#### 3.9.3 Adaptive Layout Patterns

| Screen Type | Mobile | Tablet | Desktop/Web |
|---|---|---|---|
| Navigation | `BottomNavigationBar` | `NavigationRail` | `NavigationRail` + drawer |
| List/Detail | Push to new page | Side-by-side (split view) | Side-by-side (split view) |
| Dialogs | Full-screen modal | Centered dialog | Centered dialog |
| Grid | 2 columns | 3-4 columns | 4-6 columns |
| Content width | Full width | Max 840px centered | Max 1200px centered |

```dart
// Adaptive scaffold
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final deviceType = Responsive.deviceType(context);
    return Scaffold(
      body: Row(
        children: [
          if (deviceType != DeviceType.mobile)
            const AppNavigationRail(),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: deviceType == DeviceType.mobile
          ? const AppBottomNav()
          : null,
    );
  }
}
```

#### 3.9.4 Content Width Constraints

Always cap content width on large screens for readability.

```dart
class ContentContainer extends StatelessWidget {
  const ContentContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: child,
      ),
    );
  }
}
```

| Rule | Rationale |
|---|---|
| Every page wraps content in `ContentContainer` or equivalent | Line length stays readable (50-75 chars) on ultrawide monitors |
| Use `ConstrainedBox` over hardcoded margins | Maintains centering, adapts to smaller screens naturally |
| Never cap height — only width | Vertical scrolling is expected on mobile |

#### 3.9.5 Font & Touch Target Scaling

| Rule | Rationale |
|---|---|
| Use `MediaQuery.textScaleFactor` for accessibility | Users with large font settings must be supported |
| Never disable `textScaleFactor` | Accessibility violation |
| Minimum tap target: 48px logical pixels | Material Design guideline, WCAG compliance |
| On desktop/web, support hover states on interactive elements | Expected platform convention |
| Increase tap targets to 56px for mobile | Fat-finger prevention |

#### 3.9.6 Performance for Responsive Layouts

| Rule | Rationale |
|---|---|
| `LayoutBuilder` at the **point of change**, not at the root | Limits rebuild scope when layout changes |
| Cache `MediaQuery` via provider at the app root | Single `MediaQuery` rebuild cascades to all watchers |
| Use `ValueListenableBuilder` for animation-driven responsive values | Only the animated widget rebuilds on each frame |
| Avoid `LayoutBuilder` inside `ListView` items | Items should be fixed-height, not responsive |
| Prefer `SliverGrid` with `SliverGridDelegateWithMaxCrossAxisExtent` | Automatically adapts column count to available width |

```dart
// ✅ Performant — adaptive grid
SliverGrid(
  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200,  // each item max 200px wide
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
    childAspectRatio: 0.8,
  ),
  delegate: SliverChildBuilderDelegate(
    (context, index) => ProductCard(product: products[index]),
    childCount: products.length,
  ),
)
```

### 3.10 Localization

#### 3.10.1 i18n Setup

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: 0.19.0
```

```dart
// In MaterialApp
MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  locale: ref.watch(localeProvider),
)
```

| Rule | Rationale |
|---|---|
| Use `flutter_localizations` + `intl` for all production apps | Google-supported, ARB file workflow, codegen |
| Never hardcode English text in widgets | Every visible string makes localization harder when retrofitting |
| Use `AppStrings` that delegate to `AppLocalizations.of(context)` | Single indirection point — swap implementation without touching features |

#### 3.10.2 AppStrings with Localization Support

```dart
// lib/core/constants/strings.dart
class AppStrings {
  const AppStrings._();

  // These delegate to the generated localizations
  static String get appName => AppLocalizations.current.appName;
  static String get ok => AppLocalizations.current.ok;
  static String get cancel => AppLocalizations.current.cancel;
  static String get retry => AppLocalizations.current.retry;
  static String get loading => AppLocalizations.current.loading;
}
```

| Rule | Rationale |
|---|---|
| `AppStrings` is a static accessor, not a hardcoded string holder | Static const strings break localization — use generated localizations |
| All strings go through ARB files (`lib/l10n/app_en.arb`) | Industry standard for i18n workflows |

#### 3.10.3 RTL Layout Support

| Rule | Rationale |
|---|---|
| Test every screen in both LTR and RTL locales | Layout breaks when text direction flips |
| Use `Directionality` widget for custom directional layouts | Respects `textDirection` from localizations |
| Avoid `EdgeInsets.only(left/right)` — use `EdgeInsetsDirectional` | `start`/`end` auto-flip based on locale |
| Avoid `Alignment.centerLeft/centerRight` — use `AlignmentDirectional` | Auto-flips in RTL mode |
| Text with `textAlign: start/end` auto-flips correctly | No manual `TextAlign.left/right` |

```dart
// ✅ RTL-safe
Padding(
  padding: EdgeInsetsDirectional.only(start: 16, end: 8),
  child: Align(
    alignment: AlignmentDirectional.centerStart,
    child: Text('Hello', textAlign: TextAlign.start),
  ),
)

// ❌ RTL-broken
Padding(
  padding: EdgeInsets.only(left: 16, right: 8),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text('Hello', textAlign: TextAlign.left),
  ),
)
```

#### 3.10.4 Localization Rules

| Rule | Rationale |
|---|---|
| Every user-facing string added → immediately add to all ARB files | No untranslated strings in any locale |
| Use ICU message syntax for plurals/gender (`{count, plural, one {item} other {items}}`) | Correct grammar in every language |
| Support minimum 3 locales: en, ar (RTL), one CJK language | Verifies RTL works + CJK font rendering |
| Extract strings from packages with `flutter gen-l10n` | Generated `AppLocalizations` class is type-safe |
| Never use string concatenation for user-facing messages | Breaks word order in other languages |

---

## 4. Performance & Rebuild Optimization

### 4.1 Golden Rule

**Profile first, optimize second.** Always measure with Flutter DevTools before making changes.

### 4.2 Rebuild Prevention

| Technique | How |
|---|---|
| `const` constructors | Every widget that can be const must be const |
| `==` override on custom objects | Without it, widgets rebuild even when data hasn't changed |
| `shouldRepaint(false)` in CustomPainter | Return `false` when paint output hasn't changed |
| `child` extraction | Extract expensive sub-trees into a `child` parameter so they don't rebuild with the parent |
| `Selector` | Rebuild only when specific fields change |
| `context.select` | Watch a single property instead of the whole provider |

### 4.3 List Performance

| Rule | Rationale |
|---|---|
| `ListView.builder` / `GridView.builder` always | Lazy builds visible items only |
| Never `Column` + `for` loop | Renders every item upfront — O(n) memory |
| `itemExtent` for fixed-height items | Skips layout calculation for off-screen items |
| `addAutomaticKeepAlives: false` in lists with pagination | Prevents all pages from staying in memory |
| Debounce scroll listeners | Avoids 60fps computation on scroll events |

### 4.4 Image Performance

| Rule | Rationale |
|---|---|
| Set `ImageCache.maximumSizeBytes` per device class | Low-end devices need tighter cache limits |
| `precacheImage` for below-fold images | User scrolls to ready image instead of seeing empty space |
| Serve WebP or AVIF from backend | 30-50% smaller than PNG/JPEG |
| Use `cacheWidth` / `cacheHeight` | Decodes image at display size instead of full resolution |
| `ResizeImage` for large network images | Prevents OutOfMemoryError on low-end devices |

### 4.5 Animation Performance

| Rule | Rationale |
|---|---|
| Use `AnimatedContainer` / `AnimatedSwitcher` over manual `AnimationController` | Less code, same performance |
| Avoid `AnimatedBuilder` wrapping the entire widget tree | Narrow animation rebuild scope to only the animated part |
| Use `TweenAnimationBuilder` for one-shot transitions | Auto-manages controller lifecycle |
| Never animate `Opacity` in a scrolling list | Triggers `saveLayer()` — expensive |
| Prefer `Transform` over `AnimatedContainer` for movement | `Transform` doesn't trigger layout |

### 4.6 Build Phase Optimization

```dart
// ❌ Expensive — recalculates every build
@override
Widget build(BuildContext context) {
  final items = _computeExpensiveList(); // runs every frame
  return ListView(children: items);
}

// ✅ Correct — memoized
@override
Widget build(BuildContext context) {
  return ListView(children: _cachedItems);
}
```

---

## 5. Memory Management

### 5.1 Controller Lifecycle

| Rule | Rationale |
|---|---|
| `AutoDispose` all `TextEditingController` | Holds `TextInputConnection` — native resource leak |
| `AutoDispose` all `AnimationController` | Holds `Ticker` — crashes if not disposed |
| `AutoDispose` all `ScrollController` | Listens to scroll events — continues after widget dispose |
| `AutoDispose` all `TabController` | Holds internal listeners |

Pattern:

```dart
final nameControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});
```

### 5.2 Context & Async Safety

| Rule | Rationale |
|---|---|
| Never retain `BuildContext` across async gaps | Context is ephemeral. Using it after async causes crashes |
| Use `ref` instead of `context` for provider access | `ref` is safe across async operations |
| Check `mounted` before accessing context in async callbacks | Prevents `ScaffoldMessenger` / `Navigator` crashes |
| Cancel stream subscriptions in `ref.onDispose` | Subscriptions on closed streams accumulate |

### 5.3 Widget Memory

| Rule | Rationale |
|---|---|
| Avoid `GlobalKey` unless absolutely necessary | Prevents widget from being garbage-collected |
| Large in-memory caches are a code smell | Use DB (Hive / Drift / Isar) or disk cache instead |
| Review `keepAlive: true` usage | Every kept-alive page is in memory |
| Use `ListView.builder` (not `ListView(children: ...)`) | Huge array of widget references in memory even off-screen |

---

## 6. Package Management

### 6.1 Version Pinning

**Pin exact versions in `pubspec.yaml`.** No caret (`^`) constraints.

```yaml
# ✅ Correct
dependencies:
  flutter_riverpod: 2.6.1
  dio: 5.7.0

# ❌ Wrong — allows silent upgrades
dependencies:
  flutter_riverpod: ^2.6.1
  dio: ^5.7.0
```

**Rationale:** `^` silently upgrades on `pub get` — a patch or minor release can introduce breaking changes or bugs in CI.

### 6.2 Dependency Vetting

Before adding any package, evaluate:

| Criteria | Check |
|---|---|
| Popularity | 1000+ likes on pub.dev |
| Maintenance score | Green badge on pub.dev |
| Null safety | Sound null safety (Dart 3 compatible) |
| License | MIT, Apache 2.0, BSD (avoid GPL/Affero for commercial) |
| Open issues | No critical unresolved issues |
| Native dependencies | Review for large native library bloat |

### 6.3 Package Choice Hierarchies

| Category | First Choice | Second Choice | Avoid |
|---|---|---|---|
| HTTP client | `dio` | `http` | Custom wrappers |
| Local DB | `drift` (SQL) or `isar` (NoSQL) | `hive` | `sqflite` directly |
| State management | `flutter_riverpod` + `riverpod_annotation` | — | `provider`, `bloc`, `get_it`, `getx` |
| JSON serialization | `json_serializable` + `freezed` | — | Manual `fromJson` |
| Navigation | `go_router` | — | `auto_route`, custom navigator |
| Image loading | `cached_network_image` | — | Raw `Image.network` |
| Dependency injection | Built into Riverpod | — | `get_it` + `injectable` |
| Code generation | `build_runner` | — | — |

### 6.4 Maintenance Rules

| Rule | Rationale |
|---|---|
| Run `dart pub outdated` monthly | Stay within supported versions |
| Update one package at a time | Isolate breaking changes |
| Run full test suite after any `pubspec.lock` change | Catch regressions immediately |
| Audit transitive dependencies with `dart pub deps` | Transitive bloat is invisible |
| Remove unused dependencies | `dart pub deps --no-dev` shows what's actually used |
| Add dependency overrides only temporarily | Always document why and add a TODO to remove |

---

## 7. Code Quality & Linting

### 7.1 analysis_options.yaml

```yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    require_trailing_commas: true
    avoid_print: true
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    missing_const_in_class: true
    always_use_package_imports: true
    avoid_dynamic_calls: false  # opt-in per file

analyzer:
  errors:
    invalid_annotation_target: ignore
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "lib/generated/**"
```

### 7.2 Type Safety

| Rule | Rationale |
|---|---|
| No `dynamic`. Use proper types, `sealed class`, or `Object?` | `dynamic` disables type checking — hides bugs until runtime |
| No `late` without guarantee. Prefer `late final` | `late` throws if accessed before assignment |
| Use Dart 3+ features: records, patterns, sealed classes, `switch` expressions | Less boilerplate, exhaustive checking |
| No `as` casts — use pattern matching or `is` check | Unsafe casts crash at runtime |

### 7.3 Code Organization

| Rule | Rationale |
|---|---|
| Public API first, private helpers last | Readers see the interface before implementation |
| Order within file: constants → fields → constructor → lifecycle → build → callbacks | Consistent reading flow |
| Group provider definitions together in presentation layer | Easy to find all state for a feature |
| Avoid mega-provider files | One provider file per logical concern |

### 7.4 Lint Discipline

| Rule | Rationale |
|---|---|
| Zero lint warnings in committed code | Configure CI to block on warnings |
| `// ignore:` must include a comment explaining why | No blanket ignores |
| Run `flutter analyze` before every commit | Catch issues locally, not in CI |
| Fix lint issues at source — don't suppress | Suppression hides real problems |

---

## 8. Testing

### 8.1 Test Pyramid

| Level | What | Coverage Target |
|---|---|---|
| Unit tests | Providers, use cases, repositories, models | ≥ 90% business logic |
| Widget tests | Each screen's loading / error / data states | 100% of screens |
| Golden tests | Critical screens (visual regression) | Core flows only |
| Integration tests | End-to-end user flows (login → browse → checkout) | 3-5 critical paths |

### 8.2 Unit Testing Rules

| Rule | Rationale |
|---|---|
| Every provider must have a unit test | Providers contain business logic |
| Use `mocktail` (not `mockito`) | Less boilerplate, no code generation |
| Test loading → error → data state transitions | Not just the happy path |
| Use `ProviderContainer` directly — no pumpWidget | Faster, cleaner |
| Arrange-Act-Assert separated by blank lines | Readable, consistent |

```dart
void main() {
  group('AuthProvider', () {
    test('emits error state when login fails', () async {
      // Arrange
      final mockApi = MockAuthApi();
      when(() => mockApi.login(any(), any())).thenThrow(NetworkException());

      final container = ProviderContainer(overrides: [
        authApiProvider.overrideWithValue(mockApi),
      ]);

      // Act
      await container.read(authProvider.notifier).login('user', 'pass');

      // Assert
      expect(
        container.read(authProvider),
        isA<AsyncError>(),
      );
    });
  });
}
```

### 8.3 Widget Testing Rules

| Rule | Rationale |
|---|---|
| Test loading state | Verify loading indicator appears |
| Test error state | Verify error message + retry button appear |
| Test data state | Verify expected widget content renders |
| Use `pumpAndSettle` sparingly | Only when animations must complete. Use `pump(Duration)` otherwise |
| Prefer `find.text()` over `find.byKey()` | More resilient to refactoring |

### 8.4 Golden Tests

```bash
# Update goldens
flutter test --update-goldens

# Run goldens in CI
flutter test --reporter=github
```

| Rule | Rationale |
|---|---|
| Run on CI with defined screen sizes | Prevents OS-level rendering differences |
| Review golden changes in PRs | Visual regression must be approved |
| Store goldens in version control | Team has single source of truth |

### 8.5 Testing Anti-patterns

| Anti-pattern | Why | Fix |
|---|---|---|
| Testing implementation details | Breaks on refactor | Test behavior, not method calls |
| Using `real` APIs in tests | Slow, flaky, network-dependent | Mock everything |
| Skipping error state tests | Most bugs happen in error paths | Always test error → recovery |
| Test coverage as a number | 100% coverage of trivial code = waste | Test logic, not getters/setters |

---

## 9. Error Handling, Logging & Crash Reporting

### 9.1 Core Principles

| Rule | Rationale |
|---|---|
| No silent `catch(e) { }` | Swallowed errors are the hardest bugs to find |
| No `catch(e)` that doesn't log or rethrow | At minimum log the error |
| Use `Result<T>` pattern in domain layer | Pure functions — errors returned, not thrown |

### 9.2 Result Type Pattern

```dart
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final FailureReason error;
}
```

Usage in use cases / repositories:
```dart
class GetUserProfile {
  Future<Result<User>> call(String id) async {
    try {
      final user = await repository.getUser(id);
      return Success(user);
    } on NetworkException catch (e) {
      return Failure(NetworkFailure(e));
    } on CacheException catch (e) {
      return Failure(CacheFailure(e));
    }
  }
}
```

### 9.3 UI Error Handling

| Rule | Rationale |
|---|---|
| Show snackbar for recoverable errors | Non-intrusive |
| Show dialog only for blocking errors (must acknowledge) | Don't interrupt for minor failures |
| Always include a retry action | User should never hit a dead end |
| Map error types to user-facing messages | Never show raw exception text |

### 9.4 Logging

```yaml
dependencies:
  logging: ^1.2.0   # Dart standard logging facade
  sentry_flutter: ^8.0.0  # Production crash reporting
```

#### 9.4.1 Custom Logger with Emoji Format

Use a consistent emoji prefix pattern so logs are instantly scannable. Every log entry carries: prefix, message, relevant data, and a reference ID.

```dart
// lib/core/utils/logger.dart
class AppLogger {
  const AppLogger._();

  static final _log = Logger('App');

  // ─── Request / Response ───

  /// >>>> OUTGOING REQUEST
  static void request({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    Object? body,
    String? tag,
  }) {
    _log.info(
      '>>>> [${tag ?? method}] $method $url\n'
      'Headers: ${_safeHeaders(headers)}\n'
      'Body: ${_safeBody(body)}',
    );
  }

  /// <<<< INCOMING RESPONSE
  static void response({
    required int statusCode,
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    Object? body,
    Duration? duration,
    String? tag,
  }) {
    final icon = statusCode >= 400 ? '❌' : '✅';
    _log.info(
      '$icon <<<< [${tag ?? method}] $statusCode $method $url'
      '${duration != null ? ' (${duration.inMilliseconds}ms)' : ''}\n'
      'Headers: ${_safeHeaders(headers)}\n'
      'Body: ${_safeBody(body)}',
    );
  }

  /// ⚠️ WARNING
  static void warning(
    String message, {
    Object? data,
    StackTrace? stack,
    String? tag,
  }) {
    _log.warning(
      '⚠️  [$tag] $message${data != null ? '\nData: $data' : ''}',
      stack,
    );
  }

  /// 🚨 ERROR
  static void error(
    String message, {
    Object? error,
    StackTrace? stack,
    String? tag,
  }) {
    _log.severe(
      '🚨 [$tag] $message${error != null ? '\nError: $error' : ''}',
      stack,
    );
  }

  /// ℹ️ INFO
  static void info(
    String message, {
    Object? data,
    String? tag,
  }) {
    _log.info(
      'ℹ️  [$tag] $message${data != null ? '\nData: $data' : ''}',
    );
  }

  /// 🐛 DEBUG
  static void debug(
    String message, {
    Object? data,
    String? tag,
  }) {
    _log.fine(
      '🐛 [$tag] $message${data != null ? '\nData: $data' : ''}',
    );
  }

  // ─── Helpers ───

  static Map<String, dynamic>? _safeHeaders(Map<String, dynamic>? headers) {
    if (headers == null) return null;
    return headers.map((key, value) {
      if (key.toLowerCase() == 'authorization') return MapEntry(key, '***');
      return MapEntry(key, value);
    });
  }

  static String? _safeBody(Object? body) {
    if (body == null) return null;
    final string = body.toString();
    if (string.length > 2000) return '${string.substring(0, 2000)}... [truncated]';
    return string;
  }
}
```

**Emoji convention:**

| Emoji | Meaning | When |
|---|---|---|
| `>>>>` | Outgoing request | Before every HTTP call |
| `✅ <<<<` | Successful response | On 2xx / 3xx |
| `❌ <<<<` | Failed response | On 4xx / 5xx |
| `⚠️` | Warning | Recoverable issues, deprecations |
| `🚨` | Error | Exceptions, failures |
| `ℹ️` | Info | General flow information |
| `🐛` | Debug | Detailed debug data (dev only) |

#### 9.4.2 Dio Interceptor Integration

Wire the logger into your Dio instance so every request/response is logged automatically.

```dart
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.request(
      method: options.method,
      url: options.uri.toString(),
      headers: options.headers,
      body: options.data,
      tag: 'DIO',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.response(
      statusCode: response.statusCode ?? 0,
      method: response.requestOptions.method,
      url: response.requestOptions.uri.toString(),
      headers: response.headers.map,
      body: response.data,
      tag: 'DIO',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '${err.requestOptions.method} ${err.requestOptions.uri}',
      error: err.message,
      stack: err.stackTrace,
      tag: 'DIO',
    );
    handler.next(err);
  }
}
```

#### 9.4.3 Logging Rules

| Rule | Rationale |
|---|---|
| Every log has a **tag** (`[Auth]`, `[DIO]`, `[CartRepo]`) | Filterable by component |
| Every error log includes **stack trace** | Otherwise it's unfixable |
| Mask sensitive headers (Authorization, Cookie) | Never leak tokens to logs |
| Truncate bodies > 2000 characters | Logs stay readable and performant |
| Use `info` for business flow, `fine` for debug details | Filter noise in production |
| Never `print()` — use the logger | `print` bypasses log levels and can't be filtered |
| Log at boundaries: API call start/end, state transitions, user actions | Full trace of any operation |
| `runZonedGuarded` at app entry | Captures unhandled errors globally |

```dart
void main() {
  runZonedGuarded(
    () => runApp(const App()),
    (error, stack) {
      AppLogger.error('Unhandled error', error: error, stack: stack);
      Sentry.captureException(error, stackTrace: stack);
    },
  );
}
```

### 9.5 Crash Reporting

```yaml
dependencies:
  sentry_flutter: 8.12.0
  # or
  firebase_crashlytics: 4.3.0
```

#### 9.5.1 Setup Rules

| Rule | Rationale |
|---|---|
| Init crash reporter before `runApp` | Catch early startup crashes |
| Tag every event with environment + app version | Filter crashes by release, identify regression sources |
| Attach user ID on login, clear on logout | Correlate crashes with impacted users |
| Set release name to match `pubspec.yaml` version | Know exactly which build crashed |
| Never disable crash reporting in release builds | Production crashes are invisible otherwise |

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configure Crashlytics
  FlutterError.onError = (details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runZonedGuarded(
    () => runApp(const App()),
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
```

#### 9.5.2 What to Log vs What Not to Log

| Report to crash service | Never report |
|---|---|
| Stack traces | Auth tokens |
| HTTP endpoints called (not full URLs with tokens) | Full request/response bodies with PII |
| Device model, OS version | Credit card numbers |
| App version, build number | API keys, secrets |
| User ID (pseudonymized) | Passwords, PINs, biometric data |
| Breadcrumb events leading to crash | Full user session replay |

#### 9.5.3 User Feedback for Crashes

| Rule | Rationale |
|---|---|
| Show a "Something went wrong" dialog on fatal crash | Better UX than silent crash + cold restart |
| Include a "Send feedback" option with user description | Context helps reproduce what automated breadcrumbs miss |
| Never show raw error messages to users | Security risk + confusing |

### 9.6 Failure Categories

```dart
sealed class FailureReason {
  const FailureReason();
}

class NetworkFailure extends FailureReason { ... }
class CacheFailure extends FailureReason { ... }
class ValidationFailure extends FailureReason {
  final Map<String, String> fieldErrors;
  ...
}
class ServerFailure extends FailureReason {
  final int statusCode;
  ...
}
class TimeoutFailure extends FailureReason { ... }
class UnexpectedFailure extends FailureReason { ... }
```

---

## 10. Security

### 10.1 Secrets Management

| Rule | Implementation |
|---|---|
| No secrets in source code | Never. Not even in a comment |
| Use `--dart-define` | Passed at build time: `--dart-define=API_KEY=$API_KEY` |
| Use `.env` + `flutter_dotenv` | For dev/staging only. Never commit `.env` to repo |
| Use code generation | `envied` package generates typed accessors |
| CI secrets via environment variables | GitHub Actions secrets / GitLab CI variables |

### 10.2 Secure Storage

```yaml
dependencies:
  flutter_secure_storage: ^9.2.0
```

| Data type | Storage | Reason |
|---|---|---|
| Auth tokens | `flutter_secure_storage` | Encrypted at rest — Keychain (iOS), EncryptedSharedPreferences (Android) |
| User credentials | `flutter_secure_storage` | Never in SharedPreferences |
| App preferences | `SharedPreferences` | Non-sensitive data only |
| Cache | `Hive` (encrypted box for sensitive) | Use encryption key from secure storage |

### 10.3 Network Security

| Rule | Rationale |
|---|---|
| Certificate pinning in production | Prevents MITM attacks |
| Enforce HTTPS — reject HTTP | Clear-text traffic is intercepted easily |
| Validate SSL in debug only | Self-signed certs in dev, real validation in prod |
| Token in header, never in URL | URLs logged by proxies and servers |

### 10.4 Build Security

| Rule | Rationale |
|---|---|
| `--obfuscate --split-debug-info=build/debug-info` | Obfuscates Dart code in release builds |
| Keep debug symbols in secure storage | Needed for deobfuscating crash stacks |
| Review Android/iOS permissions | Request only what you use, only when needed |
| No `JavaScriptInterface` in WebViews (or limit to HTTPS + no file access) | Prevents XSS / file exfiltration |

### 10.5 Input Validation

| Rule | Rationale |
|---|---|
| Sanitize all user inputs | URL injection, XSS in WebViews, SQL injection |
| Validate input length, format, and range | Prevent buffer overflow / denial of service |
| Never render user input as raw HTML | XSS vector |

### 10.6 Security Hardening

#### 10.6.1 Jailbreak / Root Detection

```yaml
dependencies:
  flutter_jailbreak_detection: 5.0.0
```

| Rule | Rationale |
|---|---|
| Check on app startup, block access if detected | Sensitive apps (banking, fintech) require device integrity |
| Use server-side validation too (device attestation) | Client-side checks can be bypassed |
| Log the attempt but never leak detection logic | Don't tell attackers how to bypass |

#### 10.6.2 SSL Pinning Rotation Strategy

```yaml
dependencies:
  dio: 5.7.0
  dio_smart_retry: 7.0.0  # includes cert pinning via badcert callback
```

| Rule | Rationale |
|---|---|
| Pin the certificate public key, not the entire cert | Easier to rotate without app update |
| Include a backup pin (secondary CA) | Rotation without service disruption |
| Serve pin expiry via remote config (Firebase Remote Config) | Emergency pin rotation without app store review |
| Never disable pinning in release builds | Pinning disabled = MITM vulnerable |

#### 10.6.3 Screenshot Blocking for Sensitive Screens

```dart
// In sensitive screen provider / state
void _blockScreenshots() {
  if (Platform.isAndroid) {
    FlutterWindowManager.setFlags(FlutterWindowManager.FLAG_SECURE);
  } else if (Platform.isIOS) {
    // iOS screenshots can't be blocked natively
    // Overlay with secure field view for sensitive content
  }
}
```

| Rule | Rationale |
|---|---|
| Block screenshots on payment, KYC, and credential screens | Prevents sensitive data leakage |
| Show a warning overlay if iOS screenshots are taken | iOS doesn't allow programmatic screenshot blocking |
| Don't block screenshots app-wide | Hurts UX for non-sensitive features |

#### 10.6.4 Biometric Authentication

```yaml
dependencies:
  local_auth: 2.3.0
  flutter_secure_storage: 9.2.0
```

| Rule | Rationale |
|---|---|
| Use biometrics for payment confirmation and session unlock | Better UX than passwords for frequent actions |
| Store biometric keys in `flutter_secure_storage` with `biometricOnly: true` | Biometric data never leaves the secure enclave |
| Always provide a fallback (PIN/password) | Biometrics can fail (wet fingers, Face ID blocked) |
| Lock app after inactivity timeout | `InactivityTimeout` provider auto-locks after N minutes |

#### 10.6.5 Secure Logging Exclusions

| Never log | Reason |
|---|---|
| Auth tokens | Token theft = account takeover |
| Passwords / PINs | Plaintext password leak |
| Credit card numbers (full) | PCI DSS compliance |
| Personal Identifiable Information (PII) | GDPR / CCPA compliance |
| Biometric data | Irreplaceable — can't be rotated like a password |
| API keys / secrets | Direct infrastructure access |

```dart
// ✅ Safe — redacted
AppLogger.info('[Auth] Login result: ${error?.runtimeType ?? "success"}');

// ❌ Dangerous — full token logged
AppLogger.info('[Auth] Token: $token');
```

---

## 11. Network & API

### 11.1 HTTP Client Choice

Use `dio` as the HTTP client. Avoid raw `http` package or custom `HttpClient` wrappers.

| Reason | Detail |
|---|---|
| Interceptors | Logging, auth, retry — all pluggable without touching business code |
| Request cancellation | Cancel in-flight requests via `CancelToken` |
| Timeout per-call | `options.sendTimeout`, `options.receiveTimeout` — no global chaos |
| FormData / multipart | Built-in support for file uploads |
| Transformers | Auto-serialize/deserialize at the interceptor level |

```yaml
dependencies:
  dio: 5.7.0
  retrofit: 4.1.0  # optional — generates type-safe API clients
```

### 11.2 Dio Configuration

Create a single, pre-configured Dio instance. Never create raw `Dio()` in features.

```dart
// lib/core/network/dio_client.dart
class DioClient {
  const DioClient._();

  static Dio create({
    required String baseUrl,
    required Interceptor authInterceptor,
    bool enableLogging = true,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),          // injects auth token
      if (enableLogging) LoggingInterceptor(),  // request/response logging
      RetryInterceptor(),         // automatic retry on 5xx
    ]);

    return dio;
  }
}
```

### 11.3 Dio Instance as a Riverpod Provider

```dart
// lib/core/network/dio_provider.dart
final dioProvider = Provider<Dio>((ref) {
  final authToken = ref.watch(authTokenProvider);
  return DioClient.create(
    baseUrl: AppEndpoints.baseUrl,
    authInterceptor: AuthInterceptor(authToken),
  );
});
```

### 11.4 Interceptors

#### 11.4.1 Auth Interceptor

Injects the auth token into every request. Handles 401 → token refresh → retry.

```dart
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._token);

  final String? _token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Attempt token refresh
      try {
        final newToken = await _refreshToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final response = await Dio().fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {
        // Refresh failed — force logout
        _onSessionExpired?.call();
      }
    }
    handler.next(err);
  }
}
```

#### 11.4.2 Retry Interceptor

Automatically retries on network errors or 5xx responses. Configurable count and delay.

```dart
class RetryInterceptor extends Interceptor {
  final int _maxRetries;
  final Duration _baseDelay;

  RetryInterceptor({
    int maxRetries = 3,
    Duration baseDelay = const Duration(seconds: 1),
  })  : _maxRetries = maxRetries,
        _baseDelay = baseDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && _canRetry(err.requestOptions)) {
      final retryCount = _getRetryCount(err.requestOptions);
      await Future.delayed(_baseDelay * (retryCount + 1)); // exponential backoff
      _incrementRetryCount(err.requestOptions);
      try {
        final response = await Dio().fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {}
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.response?.statusCode == 503 ||
        err.response?.statusCode == 502;
  }

  bool _canRetry(RequestOptions options) =>
      _getRetryCount(options) < _maxRetries;

  int _getRetryCount(RequestOptions options) =>
      options.extra['retryCount'] as int? ?? 0;

  void _incrementRetryCount(RequestOptions options) =>
      options.extra['retryCount'] = _getRetryCount(options) + 1;
}
```

### 11.5 Endpoint Constants

Every API endpoint is a constant. No raw URL strings in features.

```dart
// lib/core/constants/endpoints.dart
class AppEndpoints {
  const AppEndpoints._();

  // Base URL — injected per flavor
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.dev.example.com',
  );

  // Auth
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const refreshToken = '/auth/refresh';
  static const logout = '/auth/logout';

  // Users
  static const userProfile = '/users/profile';
  static const userById = '/users/{id}';

  // Products
  static const products = '/products';
  static const productDetail = '/products/{id}';
  static const productSearch = '/products/search';

  // Cart / Orders
  static const cart = '/cart';
  static const orders = '/orders';
  static const orderDetail = '/orders/{id}';
}
```

### 11.6 Error Mapping

Map HTTP errors to domain-level failures in a single place. Features should never parse HTTP status codes.

```dart
// lib/core/network/error_mapper.dart
FailureReason mapDioErrorToFailure(DioException error) {
  return switch (error.type) {
    DioExceptionType.connectionTimeout => NetworkFailure(
        'Connection timed out. Check your internet.',
      ),
    DioExceptionType.receiveTimeout => TimeoutFailure(
        'Server is not responding. Try again.',
      ),
    DioExceptionType.badResponse => _mapStatusCode(error.response?.statusCode),
    DioExceptionType.cancellation => CancellationFailure(),
    _ => UnexpectedFailure(error.message ?? 'Something went wrong'),
  };
}

FailureReason _mapStatusCode(int? statusCode) {
  return switch (statusCode) {
    400 => ValidationFailure(),
    401 => UnauthorizedFailure('Session expired. Please login again.'),
    403 => ForbiddenFailure('You don\'t have permission.'),
    404 => NotFoundFailure('Resource not found.'),
    422 => ValidationFailure(),
    500 => ServerFailure('Internal server error.'),
    502 || 503 => ServiceUnavailableFailure('Service temporarily down.'),
    _ => UnexpectedFailure('Unexpected error ($statusCode).'),
  };
}
```

### 11.7 Repository Data Source Pattern

```dart
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<User>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        AppEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return Success(User.fromJson(response.data['user']));
    } on DioException catch (e) {
      return Failure(mapDioErrorToFailure(e));
    }
  }
}
```

### 11.8 Firebase Integration

#### 11.8.1 Firebase Setup Rules

| Rule | Rationale |
|---|---|
| Use `firebase_core` + specific Firebase services only (no catch-all) | Smaller app size, fewer native dependencies |
| One Firebase project per flavor | Dev data never mixes with production |
| Register emulator in dev mode | No cost, no network dependency for local development |
| Never hardcode Firebase config files | Use `--dart-define` per CI/CD |

```yaml
dependencies:
  firebase_core: 3.12.0
  firebase_auth: 5.5.0        # only if using Firebase Auth
  cloud_firestore: 5.7.0      # only if using Firestore
  firebase_messaging: 15.2.0  # only if using push notifications
```

```dart
Future<void> initFirebase(Flavor flavor) async {
  if (flavor == Flavor.dev) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  } else {
    await Firebase.initializeApp(
      options: flavor == Flavor.staging
          ? DefaultFirebaseOptions.staging
          : DefaultFirebaseOptions.prod,
    );
  }
}
```

#### 11.8.2 Firestore Rules

| Rule | Rationale |
|---|---|
| Always define Firestore security rules (never test mode in production) | Data safety |
| Use batched writes for atomic operations | Either all succeed or all fail |
| Index every query filter + sort combination | Firestore fails without indexes on compound queries |
| Limit document reads with pagination | Cost control — every read is billable |
| Use `DocumentReference` for relationships (not nested maps) | Scalable, queryable |

### 11.9 API Design Conventions

| Rule | Rationale |
|---|---|
| All endpoints behind `/api/v1/` prefix | Versioning without breaking existing clients |
| Use RESTful resource naming (`/users`, `/users/{id}/orders`) | Predictable, self-documenting |
| Snake_case in API → camelCase in Dart | Dart convention. Use `@JsonKey` for mapping |
| Paginated list endpoints return `{data: [], total: N, page: N, pageSize: N}` | Standardized pagination across all lists |
| Every mutation returns the created/updated resource | Client doesn't need a second read call |
| Include a correlation ID (`X-Request-ID`) in every response | Debugging across distributed systems |

### 11.11 API Model Standards

#### 11.11.1 DTO Serialization Conventions

```dart
// DTO — from JSON, to JSON
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required int id,
    required String name,
    @Default('') String email,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'profile_image') String? profileImage,
    @Default(false) bool isActive,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}

// Entity — domain model, no serialization
@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    DateTime? createdAt,
    String? profileImage,
    required bool isActive,
  }) = _User;
}
```

| Rule | Rationale |
|---|---|
| DTOs live in `data/models/`, entities live in `domain/entities/` | Strict layer separation |
| DTO has `fromJson` / `toJson`; entity has neither | Domain layer is pure Dart — no serialization concern |
| All nullable fields must be documented | `/// Null when user hasn't uploaded a profile image` |
| Never expose DTOs to the domain or presentation layer | Repository maps DTO → Entity before returning |
| Use `@Default('')` for non-nullable fields with defaults | Prevents null errors when API omits the field |
| Use `@JsonKey(name: 'snake_case')` to map API to Dart | Dart uses camelCase, APIs use snake_case |

#### 11.11.2 Nullable Handling Rules

| API Behavior | DTO Field | Why |
|---|---|---|
| Field always present | `required String name` | Compiler guarantees it exists |
| Field may be absent | `@Default('') String email` | Prevents null on `email.length` |
| Field may be null or absent | `String? profileImage` | Must handle both cases |
| Field present but can be empty | `required String description` | Empty string is valid data |
| Array always present (may be empty) | `@Default([]) List<String> tags` | Empty list ≠ null |

#### 11.11.3 Enum Serialization

```dart
@freezed
class OrderDto with _$OrderDto {
  const factory OrderDto({
    @JsonKey(name: 'status', unknownEnumValue: OrderStatus.unknown)
    required OrderStatus status,
  }) = _OrderDto;

  factory OrderDto.fromJson(Map<String, dynamic> json) => _$OrderDtoFromJson(json);
}

@JsonEnum(valueField: 'value')
enum OrderStatus {
  pending('pending'),
  confirmed('confirmed'),
  shipped('shipped'),
  delivered('delivered'),
  cancelled('cancelled'),
  unknown('unknown');  // fallback

  const OrderStatus(this.value);
  final String value;
}
```

| Rule | Rationale |
|---|---|
| Always include `unknownEnumValue` fallback | API adds new status → your app doesn't crash |
| Suffix with `Dto` for API enums | Domain enums don't need serialization |
| Use `@JsonEnum(valueField:)` for custom string values | Avoids reliance on enum name matching API string |

#### 11.11.4 API Versioning Handling

```dart
// In endpoint constants
static const baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.example.com/v1',
);

// In Dio base options
BaseOptions(
  baseUrl: AppEndpoints.baseUrl,
  headers: {'Accept': 'application/vnd.api+json; version=1'},
)
```

| Rule | Rationale |
|---|---|
| Version in URL (`/v1/`) or Accept header | Never break existing clients with backwards-incompatible changes |
| One DTO version per API version | DTO fields change only when API version changes |

#### 11.11.5 Pagination Response Standard

```dart
// Standard paginated response wrapper
@freezed
class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({
    required List<T> data,
    required int total,
    required int page,
    required int pageSize,
    @Default(false) bool hasMore,
  }) = _PaginatedResponse<T>;
}

// Generic pagination state
@freezed
class PaginationState<T> with _$PaginationState<T> {
  const factory PaginationState({
    @Default([]) List<T> items,
    @Default(1) int currentPage,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    String? error,
  }) = _PaginationState<T>;
}
```

#### 11.11.6 Generic API Response Wrapper

```dart
@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    @Default(null) T? data,
    @Default(null) String? message,
    @Default(null) Map<String, List<String>>? errors,  // validation errors
  }) = _ApiResponse;
}
```

| Rule | Rationale |
|---|---|
| Parse `ApiResponse` in the interceptor or base repository method | Single point of response validation |
| Extract `data` before passing to DTO deserialization | Clean mapping in feature code |

### 11.12 API Testing

| Rule | Rationale |
|---|---|
| Unit test error mapping for every HTTP status code | Ensure every backend error has a user-facing message |
| Mock Dio with `MockDio` or use `mocktail` | Never hit real APIs in tests |
| Test retry interceptor behavior | Verify exponential backoff and max retry count |
| Test auth interceptor 401 → refresh → retry flow | Critical path for session management |

```dart
void main() {
  group('ErrorMapper', () {
    test('maps 401 to UnauthorizedFailure', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        response: Response(statusCode: 401, requestOptions: RequestOptions()),
        requestOptions: RequestOptions(),
      );
      final result = mapDioErrorToFailure(error);
      expect(result, isA<UnauthorizedFailure>());
    });
  });
}
```

## 12. App Size Optimization

### 12.1 Build Artifacts

| Rule | Impact |
|---|---|
| Build Android AppBundle, not APK | Google Play serves per-device optimized APKs |
| `--target-platform android-arm,android-arm64` | Drops x86_64 — saves 10-15 MB |
| `--split-debug-info` | Removes debug symbols from binary |
| `--obfuscate` | Renames symbols — small size savings + security |

### 12.2 Assets

| Rule | Rationale |
|---|---|
| Vector graphics (Lottie/Rive) over animated GIF | GIF is uncompressed and large. Lottie is JSON |
| SVG over PNG icons | Scales to any density. Single file instead of mdpi/hdpi/xhdpi/xxhdpi |
| Font subsetting | Remove unused characters. Korean/CJK subset can save 80%+ |
| `--tree-shake-icons` | Removes unused Material/Cupertino icons from bundle |
| Compress images with `flutter_launcher_icons` + `squoosh` | Automated optimization in build pipeline |

### 12.3 Code

| Rule | Rationale |
|---|---|
| Remove unused imports | Every import increases compilation size |
| Avoid code generation for large model files | Generated code is not tree-shakeable |
| Use `dart compile` optimization flags | AOT compilation produces smaller binaries |
| Audit with `flutter build appbundle --analyze-size` | See exactly where your bytes go |

### 12.4 File-Level Audit (`--analyze-size`)

```
$ flutter build appbundle --analyze-size
✓  Built build/app/outputs/bundle/release/app-release.aab.
✓  Wrote size analysis to build/app/outputs/bundle/release/app-release.aab.tar.gz

$ devtools size_analyzer build/app/outputs/bundle/release/app-release.aab.tar.gz
```

This shows the top consumers of size in your app — assets, fonts, code, native libraries.

---

## 13. Build & CI/CD

### 13.1 Flavors

Define three flavors:

| Flavor | API Key | Firebase Project | App Name | App Icon |
|---|---|---|---|---|
| `dev` | Dev keys | dev-project | "App [DEV]" | Dev icon |
| `staging` | Staging keys | staging-project | "App [STAGING]" | Staging icon |
| `prod` | Production keys | prod-project | "App" | Production icon |

Implementation:
```yaml
# pubspec.yaml
flutter:
  flavors:
    dev:
    staging:
    prod:
```

```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

### 13.2 CI Pipeline

```
lint → test → build (per flavor)
```

| Step | Command | Why |
|---|---|---|
| Analyze | `flutter analyze` | Lint errors block merge |
| Unit + widget | `flutter test --coverage` | Logic and UI tests |
| Golden | `flutter test --update-goldens` (if changed) | Visual regression |
| Build dev | `flutter build apk --debug --flavor dev` | Quick feedback |
| Build prod | `flutter build appbundle --release --flavor prod --obfuscate --split-debug-info=build/debug-info` | Release artifact |

### 13.3 Version Management

| Rule | Rationale |
|---|---|
| Single version source | `pubspec.yaml` version propagates to Android/iOS |
| Use `flutter_version` action in CI | Auto-increment version per build |
| Tag releases in git | `git tag v1.2.3+build456` |
| Upload debug symbols to Sentry on each release | Deobfuscation for crash reports |

### 13.4 Pre-commit Checks

```yaml
# .git/hooks/pre-commit  —  or use lefthook / husky
flutter analyze
dart format --set-exit-if-changed .
flutter test --quick  # only changed tests
```

### 13.5 CI Quality Gates

Pull requests must pass all gates before merge. Configure CI to block merge on failure.

| Gate | Enforcement | Failure Action |
|---|---|---|
| **Analyze** | `flutter analyze` — zero warnings | ❌ Block merge |
| **Formatting** | `dart format --set-exit-if-changed .` | ❌ Block merge |
| **Unit tests** | `flutter test --coverage` — all pass | ❌ Block merge |
| **Coverage** | `--coverage` no drop below threshold | ⚠️ Warning + block if > 5% drop |
| **Golden tests** | `flutter test --update-goldens` — manual approval | ❌ Block merge without approval |
| **Dependency validation** | `dart run dependency_validator` | ❌ Block merge on unused/missing deps |
| **Commit lint** | Conventional commit format enforced | ⚠️ Warning |
| **Size tracking** | Compare against baseline APK/AAB size | ⚠️ Warning on > 10% increase |

```yaml
# .github/workflows/ci.yml  —  example
name: CI
on: pull_request

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'

      - run: flutter pub get

      # Gate 1 — Analyze
      - run: flutter analyze

      # Gate 2 — Formatting
      - run: dart format --set-exit-if-changed .

      # Gate 3 — Tests
      - run: flutter test --coverage

      # Gate 4 — Coverage check (example with very_good_analysis)
      - run: |
          lcov --list coverage/lcov.info | tail -1
          # Fail if below 80%
          coverage_percent=$(lcov --list coverage/lcov.info | tail -1 | awk '{print $2}' | tr -d '%')
          if (( $(echo "$coverage_percent < 80" | bc -l) )); then
            echo "❌ Coverage $coverage_percent% below 80% threshold"
            exit 1
          fi

      # Gate 5 — Dependencies
      - run: dart run dependency_validator
```

---

## 14. Performance Monitoring

### 14.1 Firebase Performance Monitoring

```yaml
dependencies:
  firebase_performance: 0.10.0+1
```

| Rule | Rationale |
|---|---|
| Trace every HTTP request automatically via Dio interceptor | See slow API calls in Firebase console |
| Add custom traces for critical user flows (login, checkout, search) | Measure real user experience, not just synthetic tests |
| Set custom attributes per trace (user tier, app version, device) | Segment performance data for targeted optimization |

### 14.2 Frame Timing & Jank Thresholds

| Metric | Target | Action if Exceeded |
|---|---|---|
| Frame build time | < 16ms (60fps) | Profile with DevTools, optimize rebuilds |
| Frame raster time | < 16ms (60fps) | Check for `saveLayer()` calls, heavy gradients, opacity |
| UI thread jank | < 1% of frames > 16ms | Look for expensive work on main isolate |
| GPU thread jank | < 1% of frames > 16ms | Check image decoding, shader compilation |

```dart
// Profile mode overlay
class AppPerformanceOverlay extends StatelessWidget {
  const AppPerformanceOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      right: 0,
      child: PerformanceOverlay(
        options: PerformanceOverlayOptions(
          showMemoryUsage: true,
          showFps: true,
        ),
      ),
    );
  }
}
```

### 14.3 Startup Time Targets

| Phase | Target | Measurement |
|---|---|---|
| App initialization (main → first frame) | < 500ms | `Timeline.startSync/endSync` |
| First meaningful paint | < 1.5s | Firebase Performance trace |
| Time to interactive | < 2s | Custom trace at main → navigator ready |

| Rule | Rationale |
|---|---|
| `runZonedGuarded` should not block first frame | Error reporting initialization must be async |
| Lazy-load non-critical services (chat, analytics, ads) | Don't block startup on background services |
| Pre-warm key providers in `ProviderScope` overrides | Data ready when first screen needs it |
| Use `runApp` after all sync initialization is complete | Avoid half-initialized app frame |

### 14.4 Memory Budgets

| Device Class | Max Heap | Image Cache |
|---|---|---|
| Low-end (Android Go, < 2GB RAM) | < 100MB | 50MB |
| Mid-range (2-4GB RAM) | < 200MB | 100MB |
| High-end (> 4GB RAM) | < 300MB | 200MB |

```dart
void configureImageCache(DeviceClass deviceClass) {
  PaintingBinding.instance.imageCache.maximumSizeBytes = switch (deviceClass) {
    DeviceClass.lowEnd => 50 * 1024 * 1024,
    DeviceClass.midRange => 100 * 1024 * 1024,
    DeviceClass.highEnd => 200 * 1024 * 1024,
  };
}
```

| Rule | Rationale |
|---|---|
| Monitor heap with `DevTools Memory` during QA | Catch leaks before they reach production |
| Run memory stress tests (rapid navigation, large lists) | Common leak patterns appear under stress |
| Use `flutter run --profile` for realistic memory numbers | Debug mode uses more memory than release |

---

## 15. Navigation & Routing

### 15.1 Choice of Router

Use `go_router` — the officially recommended declarative router. Avoid `auto_route`, raw `Navigator 1.0`, or custom router implementations.

```yaml
dependencies:
  go_router: 14.8.0
```

| Reason | Detail |
|---|---|
| URL-based routing | Direct mapping between path and screen — natural for web |
| Declarative | Routes defined in one place, not scattered across widgets |
| Deep linking | Built-in support for push notification navigation |
| Redirect guards | Auth protection at the route level, not in widget code |
| Shell routes | Persistent layouts (bottom nav, navigation rail) without rebuilding |

### 15.2 Route Definition Structure

All routes in a single file. Organized by feature using `GoRoute` branches.

```dart
// lib/core/router/app_router.dart
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,  // enable in dev only
    redirect: (context, state) => _authRedirect(ref, state),
    routes: [
      // Auth (no shell)
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // App shell — persistent scaffold with nav
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Detail routes (no shell — full screen)
      GoRoute(
        path: AppRoutes.productDetail,
        name: 'product-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailPage(productId: id);
        },
      ),
    ],
  );
});
```

| Rule | Rationale |
|---|---|
| One router file per app | Single source of truth for all navigation |
| `name` every route | Use `state.namedLocation(name)` for type-safe navigation |
| ShellRoute for persistent navigation | Avoids rebuilding BottomNavigationBar on every tab switch |
| Route definitions outside widget tree | Routes are testable and reviewable independently |

### 15.3 URL / Route Naming Conventions

```
# Web-friendly URL patterns
/login                  → LoginPage
/                       → HomePage
/search?q=term          → SearchPage with query param
/products/{id}          → ProductDetailPage (path param)
/products/{id}/reviews  → ProductReviewPage (nested)
/profile/settings       → SettingsPage
/profile/orders/{id}    → OrderDetailPage
```

| Rule | Rationale |
|---|---|
| `kebab-case` route paths | Web URL convention, readable in browser address bar |
| Singular resource names (`/product/{id}`, not `/products/{id}`) | Cleaner, shorter URLs |
| Path params for resource IDs (`{id}`) | Required for the page to render |
| Query params for filters/search (`?q=`, `?sort=`) | Optional parameters, bookmarkable on web |
| Max 3 path segments per route | Deep nesting is hard to read and maintain |

### 15.4 AppRoutes Constants

```dart
// lib/core/constants/routes.dart
class AppRoutes {
  const AppRoutes._();

  // Auth
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // Main
  static const home = '/';
  static const search = '/search';
  static const profile = '/profile';

  // Detail
  static const productDetail = '/product/:id';
  static const orderDetail = '/order/:id';

  // Nested
  static const settings = '/profile/settings';
  static const notifications = '/profile/notifications';
  static const productReviews = '/product/:id/reviews';
}
```

| Rule | Rationale |
|---|---|
| Every route path in `AppRoutes` | String constants prevent typos, enable find-replace |
| Use `:` for path parameters (go_router convention) | Consistent with go_router's path matching |
| Group by feature with comments | Easy to audit which features have routes defined |

### 15.5 Navigation in Code

```dart
// ✅ Correct — navigate by named route (type-safe)
context.goNamed('product-detail', pathParameters: {'id': productId});

// ✅ Correct — navigate by path constant
context.go(AppRoutes.profile);

// ❌ Wrong — raw string path
context.go('/product/123');
```

| Rule | Rationale |
|---|---|
| Prefer `goNamed` over `go` for route names | Type-safe, survives route path changes |
| Use `push` for modal/temporary screens | User expects back button behavior |
| Use `go` for tab/primary navigation | Replaces current route, no back-stack bloat |
| Never use raw string paths in code | Undetectable breakage when route path changes |

### 15.6 Deep Linking

```dart
// Android — AndroidManifest.xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="https" android:host="example.com" />
</intent-filter>

// iOS — Info.plist
<key>FlutterDeepLinkingEnabled</key>
<true/>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array><string>https</string></array>
  </dict>
</array>
```

| Rule | Rationale |
|---|---|
| Register all supported host patterns in both platforms | Required for deep links to work |
| Test deep links with `adb` and Xcode simulator | Don't merge broken deep linking |
| Handle unknown deep links with a 404 screen | Better UX than crash |

### 15.7 Route Guards (Auth Protection)

```dart
String? _authRedirect(Ref ref, GoRouterState state) {
  final isAuthenticated = ref.read(authProvider).isAuthenticated;
  final isOnAuthPage = state.matchedLocation.startsWith('/login') ||
      state.matchedLocation.startsWith('/register');

  if (!isAuthenticated && !isOnAuthPage) return AppRoutes.login;
  if (isAuthenticated && isOnAuthPage) return AppRoutes.home;

  return null;  // no redirect
}
```

| Rule | Rationale |
|---|---|
| Route-level redirect, not widget-level | Auth logic in one place, not scattered across pages |
| Return `null` when no redirect is needed | go_router interprets `null` as "proceed" |
| Check `matchedLocation` not `location` | `matchedLocation` includes resolved path params |
| Never navigate imperatively after redirect | Let go_router handle the flow declaratively |

### 15.8 Transition Animations

```dart
GoRouter(
  routes: [...],
  routesBuilder: (context, state, navigationShell) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: navigationShell,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide from right for push, slide from left for pop
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  },
)
```

| Rule | Rationale |
|---|---|
| Use platform-appropriate transitions | Slide on mobile, fade/instant on web |
| No custom animations for web | Web users expect instant page transitions |
| Keep transition duration ≤ 300ms | Longer feels sluggish |
| Avoid `Hero` animations across routes with different layouts | Hero breaks when source/target layout differs |

### 15.9 Error / 404 Handling

```dart
GoRouter(
  errorBuilder: (context, state) => NotFoundPage(
    path: state.uri.toString(),
    onGoHome: () => context.go(AppRoutes.home),
  ),
)
```

| Rule | Rationale |
|---|---|
| Always define an `errorBuilder` | Prevents white screen on invalid route |
| Show the attempted path in the 404 page | Helps debugging — "I tried to go here" |
| Include a "Go Home" action | User should never be stuck on an error |

### 15.10 Web-Specific Routing

| Rule | Rationale |
|---|---|
| Enable `urlPathStrategy: PathBasedStrategy()` | Clean URLs without `#` in web |
| Sync route changes with browser history | Back/forward buttons work as expected |
| Handle browser refresh correctly | App state restored without route mismatch |
| Support direct URL entry (bookmarking) | Deep-linked state restored from URL params |
| SEO meta tags per route | Use `seo_renderer` or `flutter_meta` for head metadata |

---

## Revision History

| Date | Author | Changes |
|---|---|---|
| 29-05-2026 | amit.flutter | Initial draft |

---

*Created by [Amit Prajapati](https://www.linkedin.com/in/amitflutter/) — Mobile Developer & Architect*
