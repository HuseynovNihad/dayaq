# Dayaq

Android/iOS application ID: `az.dayaq.mobile`; display name: **Dayaq**.

Flutter charity application. Azerbaijani UI; localization is intentionally deferred.

## Run

Use a Flutter SDK with Dart >=3.12.2 (the project's existing SDK constraint).

```sh
flutter pub get
flutter run
```

The foundation runs without a backend. Before adding real API features, set:

```sh
flutter run --dart-define=API_BASE_URL=https://YOUR_API_HOST/api/
```

`API_BASE_URL` is public configuration, never a secret. No requests run at startup.
Missing/invalid base URLs are rejected before a request reaches the adapter.
Backend endpoints, authentication, token storage, payment and actual campaign data
are not implemented in this foundation. Never store tokens in preferences.

## Architecture

- `lib/app`: application composition and state-preserving bottom navigation.
- `lib/core/config`, `di`, `network`, `error`: configuration, GetIt, Dio and typed results.
- `lib/core/theme`: colors, typography, spacing, radii and Material component themes.
- `lib/core/widgets`: shared button, form input and empty/error state UI.
- `lib/core/router`: route paths and GoRouter configuration.
- `lib/features/{auth,home,campaigns,donations,profile}`: feature boundaries.

Each feature has `data/{datasources,models,repositories}`,
`domain/{entities,repositories,usecases}` and
`presentation/{bloc,pages,widgets}`. Empty folders are intentional extension points,
not implementations. Avoid creating empty classes until a feature needs them.

Dependencies flow: presentation → domain ← data. Domain must not import Flutter,
Dio, GetIt or presentation. Datasources use Dio; repositories translate DTOs and
DioException to domain entities and `Result<T>`. Use cases depend on repository
interfaces. Widgets call Blocs, never Dio or repositories directly.

Use flutter_bloc for feature state. Register Blocs as GetIt factories and provide
via `BlocProvider(create: (_) => sl<FeatureBloc>())` at the route boundary; the
provider owns disposal. Keep state immutable and use Equatable for comparison.
Register shared repositories and use cases as lazy singletons. Resolve GetIt at
composition boundaries and constructor-inject dependencies elsewhere.

Do not duplicate navigation state in a Bloc: GoRouter owns the selected tab.
No business Bloc is fabricated for the current static placeholder pages.

## Design system

Primary `#F4B033`, primary container `#FFDEA2`, black text on primary.
Supporting neutral/status colors are provisional until the complete design is supplied.
Use `Theme.of(context).textTheme`, AppSpacing, AppRadius and shared widgets.
Buttons have 52px minimum height; text scaling is preserved and pages can scroll.
Uses platform fonts, with no runtime font downloads or artificial device scaling.

## Checks

```sh
dart format lib test
flutter analyze
flutter test
```

Work directly on `main`; no additional branch workflow is required.
