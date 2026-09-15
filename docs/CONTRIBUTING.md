# Contributing to IncomePulse

## Local verification

Install Flutter and run the project checks before opening a pull request:

```bash
flutter pub get
flutter test --reporter expanded
flutter analyze --no-fatal-infos
```

The automated tests cover model serialization for fixed expenses and income entries, as well as the supported currency catalog. The application can be launched on a supported Flutter target with `flutter run`.

## Pull requests

Keep changes focused, describe the user-visible effect, and include screenshots when a UI change affects the dashboard, history, safety buffer, or settings screens. Do not commit local databases, credentials, generated build output, or private user data.
