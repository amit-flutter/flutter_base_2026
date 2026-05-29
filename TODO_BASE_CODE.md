# Base Code Setup — Master Task List

## ✅ Phase 1: Project Configuration
- [x] Add all packages to `pubspec.yaml` (riverpod, dio, go_router, freezed, cached_network_image, shimmer, flutter_svg, lottie, sentry, firebase, shared_preferences, secure_storage, connectivity_plus, local_auth, image_picker, intl, mocktail, build_runner, json_serializable)
- [x] Create `assets/` folder structure (images, icons, fonts, animations, configs) with `.gitkeep`
- [x] Enhance `analysis_options.yaml` with strict lint rules
- [x] Create `lib/core/` and `lib/features/` directory structure

## Phase 2: Environment Configuration
- [ ] `core/config/env_config.dart` — dev/staging/prod enum + config model
- [ ] `core/config/app_config.dart` — runtime config (base URLs, feature flags, sentry DSN, app name)
- [ ] `assets/configs/dev.json`, `staging.json`, `prod.json` — environment-specific values
- [ ] `core/config/flavor.dart` — flavor detection logic
- [ ] Barrel export

## Phase 3: Theme System (`core/theme/`)
- [ ] `app_colors.dart` — light + dark palette, semantic colors
- [ ] `app_text_styles.dart` — complete typography scale
- [ ] `app_theme.dart` — `ThemeData` builder with component themes
- [ ] Barrel export

## Phase 4: Constants (`core/constants/`)
- [ ] `app_strings.dart` — all user-facing strings
- [ ] `app_assets.dart` — asset path constants
- [ ] `app_routes.dart` — route path constants
- [ ] `app_icons.dart` — icon constants
- [ ] `app_endpoints.dart` — API endpoint constants
- [ ] `app_spacing.dart` / `app_insets.dart` / `app_radius.dart` — dimension constants
- [ ] Barrel export

## Phase 5: Utilities (`core/utils/`)
- [ ] `logger.dart` — emoji-formatted logger with tags, levels, filtering
- [ ] `responsive.dart` — breakpoint helper
- [ ] `validators.dart` — form validators
- [ ] Barrel export

## Phase 6: App Lifecycle (`core/lifecycle/`)
- [ ] `app_lifecycle.dart` — foreground/background tracking via `WidgetsBindingObserver`
- [ ] `session_timeout.dart` — inactivity timeout with callback
- [ ] `lifecycle_service.dart` — centralized observer registration
- [ ] Barrel export

## Phase 7: Storage Abstraction (`core/storage/`)
- [ ] `preferences_service.dart` — SharedPreferences wrapper with typed getters
- [ ] `secure_storage_service.dart` — FlutterSecureStorage wrapper with key constants
- [ ] `cache_manager.dart` — file-based cache with TTL and size limits
- [ ] Barrel export

## Phase 8: Error Handling (`core/errors/`)
- [ ] `failures.dart` — sealed Failure types (ServerFailure, CacheFailure, ValidationFailure, NetworkFailure, AuthFailure, UnknownFailure)
- [ ] `result.dart` — Result<T> type with when()/map()/fold() + AsyncResult
- [ ] Barrel export

## Phase 9: Network Layer (`core/network/`)
- [ ] `dio_client.dart` — pre-configured Dio instance + Riverpod provider
- [ ] `dio_interceptors.dart` — auth token interceptor, logging interceptor (env-aware), retry interceptor (exponential backoff), connectivity interceptor
- [ ] `api_response.dart` — generic API response wrapper (data, message, statusCode)
- [ ] `pagination_state.dart` — pagination state with loadMore/refresh/error
- [ ] Barrel export

## Phase 10: Security (`core/security/`)
- [ ] `jailbreak.dart` — jailbreak/root detection
- [ ] `ssl_pinning.dart` — SSL pinning helper
- [ ] `secure_storage.dart` — convenience wrapper using storage service
- [ ] `biometric.dart` — biometric auth helper
- [ ] Barrel export

## Phase 11: Crash & Log Reporting
- [ ] `core/analytics/analytics_service.dart` — Firebase Analytics + Sentry wrapper
- [ ] `core/analytics/crashlytics_service.dart` — centralized crash reporting with user context
- [ ] `core/analytics/tracking_mixin.dart` — mixin for screen tracking
- [ ] Barrel export

## Phase 12: Reusable Widgets (`core/widgets/`)
- Note: Split into sub-folders when count exceeds 10
- [ ] `app_scaffold.dart` — shell with responsive nav rail/bottom nav/drawer
- [ ] `app_loading.dart` / `app_error_view.dart` / `app_empty_view.dart`
- [ ] `app_shimmer.dart` — skeleton loading
- [ ] `app_button.dart` — primary/secondary/text with loading state
- [ ] `app_text_field.dart` — styled input with validation error
- [ ] `app_dialog.dart` / `app_bottom_sheet.dart` — reusable overlays
- [ ] `app_snackbar.dart` — themed snackbar extension on BuildContext
- [ ] `app_card.dart` / `app_list_tile.dart` — content containers
- [ ] `app_network_image.dart` / `app_avatar.dart`
- [ ] `app_search_bar.dart` — debounced search field
- [ ] `app_chip.dart` / `app_badge.dart`
- [ ] `app_divider.dart` / `app_section_header.dart`
- [ ] Barrel export

## Phase 13: Navigation (`core/router/`)
- [ ] `app_router.dart` — go_router with ShellRoute, auth guard, 404, deep linking
- [ ] Route-level auth redirect (single place)
- [ ] URL-friendly kebab-case paths for web support
- [ ] Barrel export

## Phase 14: Bootstrap & App Initialization
- [ ] `core/bootstrap.dart` — async app initialization (Firebase, Sentry, preloading, env detection)
- [ ] `core/app.dart` — MaterialApp.router with theme, locale, router
- [ ] Update `lib/main.dart` — call bootstrap before runApp

## Phase 15: CI/CD Setup (Reference)
- [ ] `.github/workflows/analyze.yml` — flutter analyze on PR
- [ ] `.github/workflows/test.yml` — flutter test on push
- [ ] `.github/workflows/build.yml` — build verification per flavor
- [ ] Deployment pipeline reference in STANDARDS.md

---

**Total: ~70 items across 15 phases**

> Recommendation from TL: Implement incrementally — don't build every abstraction upfront.
> Current priority: Phase 2 → 3 → 4 → 5 → 8 → 9 → 12 → 13 → 14 (core path)
> Deferred: Phase 6, 7, 10, 11, 15 (add on demand)
