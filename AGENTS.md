# Project Rules

## Always Active (Every Prompt)

### Architecture & Structure
- Feature-first layout: `features/{name}/{data,domain,presentation}/`
- Domain layer has zero Flutter/dart:io imports
- One class per file, prefer small focused files — split when readability suffers, build methods ≤ 80 lines
- Export barrels per feature
- DTOs in `data/models/`, Entities in `domain/entities/` — never mix
- Features must not directly import another feature's data layer — shared logic goes in `core/`

### State Management
- Riverpod exclusively — no Provider/BLoC/GetX/setState (except trivial widget-local state)
- Immutable state with `@freezed` or `sealed class` + `copyWith`; use `AsyncValue` for loading/error/data
- AutoDispose all controllers (TextEditing, Animation, Scroll) and subscriptions
- No mutable collections in state — always use `List.unmodifiable` / `copyWith`
- Creator disposes: whoever creates a controller/stream/subscription is responsible for disposing it

### UI & Widgets
- Every widget that can be `const` MUST be `const`
- Prefer widgets over helper methods for reusable UI sections (widgets participate in tree diffing)
- No inline styles — all colors via `AppColors`, all text via `AppTextStyles`, all spacing via `AppSpacing`
- No magic strings, assets paths, routes, or icons — use `AppStrings`, `AppAssets`, `AppRoutes`, `AppIcons`
- All reusable widgets follow the `App` prefix convention in `core/widgets/`
- Use `ListView.builder` / `GridView.builder` always — never `Column` + loop
- Place `RepaintBoundary` around maps, charts, CustomPaint, video players
- **No business logic inside widgets** — widgets are pure UI
- **No direct API calls from UI layer** — always through repository/provider
- **No nested async builders** (FutureBuilder inside FutureBuilder)
- **Never use BuildContext after async gaps without mounted check**
- **No hardcoded durations/animations** — use theme or constants
- **Accessible by default** — text scaling, semantics, minimum 48px tap targets
- **Responsive UI** — use central `Responsive` helper class, never raw `MediaQuery` in widgets
- **Adaptive layouts** — `NavigationRail` on tablet/desktop, `BottomNavigationBar` on mobile, cap content at 1200px
- Prefer pagination/lazy loading for any list > 20 items

### Code Quality
- No `dynamic` — use proper types, sealed classes, or `Object?`
- No `late` without guarantee — prefer `late final` or constructor-initialized
- No `catch(e)` without logging or rethrowing
- Zero lint warnings — run `flutter analyze` before every commit AND after every code change
- Pin exact package versions — no `^` in pubspec.yaml
- No excessive variables — prefer direct returns, avoid unnecessary intermediates
- No premature abstractions — YAGNI. Build for the current requirement, not future speculation
- No expensive computation, filtering, sorting, or API transformation inside build()
- Use `const` over `final` over `var` — in that order of preference
- Naming: `snake_case` files, `camelCase` variables/functions, `PascalCase` classes

### Theming (see STANDARDS.md §3.5 for full detail)
- All colors in `AppColors` class, all text styles in `AppTextStyles`
- Dark mode variants from day one
- Component themes (button, card, input) defined in `ThemeData`, not per-widget

### Navigation & Routing (see STANDARDS.md §15 for full detail)
- Use `go_router` — the only router. Never raw `Navigator` or `auto_route`
- All routes defined in one file with `GoRoute` + `ShellRoute` for persistent layouts
- All route paths in `AppRoutes` constants — never raw URL strings in code
- Prefer `goNamed()` with path parameters over `go()` with raw strings
- Route-level auth redirect in one place, not scattered across widgets
- Always define an `errorBuilder` (404 page)
- URL-friendly kebab-case paths for web support

### Constants (see STANDARDS.md §3.6 for full detail)
- All user-facing strings in `AppStrings`
- All asset paths in `AppAssets`
- All routes in `AppRoutes`
- All icons in `AppIcons`
- All dimension/spacing values in `AppSpacing`, `AppInsets`, `AppRadius`
- Zero raw values in widget code

### Reusable Widgets (see STANDARDS.md §3.7 for full detail)
- Every widget used 2+ times becomes a reusable component in `core/widgets/`
- API pattern: `super.key` first, `required` for mandatory, named params only, sensible defaults
- Accept padding/styling via constructor or theme — never hardcode inside reusable widgets
- Check `core/widgets/` **before** creating a new widget — reuse first

### Testing
- Unit test every provider and repository
- Widget test every screen's loading → error → data states
- Use `mocktail` (not mockito); AAA pattern
- Form validation states tested independently

### Network & API (see STANDARDS.md §11 for full detail)
- Use `dio` as HTTP client — never raw `http` or `HttpClient`
- Single pre-configured `Dio` instance via Riverpod provider
- Always use `LoggingInterceptor` for request/response logging
- All endpoint paths in `AppEndpoints` constants — never raw URL strings
- Map HTTP errors to domain `Failure` types — features never parse status codes
- Auth interceptor handles 401 → token refresh → retry automatically
- Retry interceptor with exponential backoff for transient failures
- Paginated APIs use a reusable pagination state pattern

### Logging (see STANDARDS.md §9.4 for full detail)
- Use `AppLogger` everywhere — never `print()`
- Emoji convention: `>>>>` request, `✅ <<<<` success, `❌ <<<<` failure, `🚨` error, `⚠️` warning, `ℹ️` info, `🐛` debug
- Every log has a tag (`[Auth]`, `[DIO]`, `[CartRepo]`)
- Mask `Authorization` headers, truncate bodies > 2000 chars
- Log at boundaries: API call start/end, state transitions, user actions

### Localization
- All user-facing strings support localization from day one — no hardcoded English in widgets
- Use `AppStrings` constants, never raw strings for visible text
- RTL-safe layouts required for all screens

### Performance
- Profile before optimizing — always measure with DevTools first
- `==` override on custom objects for proper rebuild detection
- `ImageCache.maximumSizeBytes` configured per device class
- `precacheImage` for below-fold images
- Avoid broad provider watching (use `.select` / `context.select`)

### Size
- Build AppBundle (not APK); `--obfuscate --split-debug-info` for release
- `--tree-shake-icons`, font subsetting, WebP/AVIF assets
- Audit with `--analyze-size`

## Workflow Rules (How I Work)

1. **Inspect first** — Before writing code, read existing files in the same area to match conventions
2. **Ask before guessing** — Any uncertainty about architecture, API, or business logic → clarify first
3. **Reuse before build** — Check existing components/providers/services before creating new ones
4. **Suggest better** — If a better approach exists than requested, mention it briefly before implementing
5. **Production-ready always** — Every change includes: error handling, loading/empty/retry states, logging, type safety
6. **Package discipline** — New dependency? Justify in code: why needed, why this package, version pinned
7. **Consistency across features** — Same provider structure, naming, API handling in every feature
8. **Learn during session** — Continuously adapt to project patterns, don't repeat mistakes
9. **Sectional reference** — Read only relevant STANDARDS.md section per task, never the whole file
10. **Quality over speed** — Production code always prioritizes correctness and maintainability
11. **Discuss big changes** — Architectural decisions or refactors proposed, not silently executed

## Reference Flow
1. I follow the rules above on every code change automatically
2. For detailed guidance on a specific area, I read relevant section of STANDARDS.md:
   - Adding a package → STANDARDS.md §6
   - Writing tests → STANDARDS.md §8
   - Error handling pattern → STANDARDS.md §9
   - Logging setup → STANDARDS.md §9.4
   - Crash reporting → STANDARDS.md §9.5
   - Localization → STANDARDS.md §3.10
   - Network/API calls → STANDARDS.md §11
   - CI/CD setup → STANDARDS.md §13
   - Security review → STANDARDS.md §10
   - Riverpod advanced patterns → STANDARDS.md §2.4
   - Design system rules → STANDARDS.md §3.5.4
   - Responsive/adaptive UI → STANDARDS.md §3.9
   - API model standards → STANDARDS.md §11.11
   - Navigation/routing → STANDARDS.md §15
   - Performance monitoring → STANDARDS.md §14
