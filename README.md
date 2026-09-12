# Irregular Income Budget Tracker

An offline-first Flutter app for tracking variable income, recurring monthly expenses, progress toward a minimum target, and a virtual safety buffer.

## Structure

- `lib/models`: SQLite-backed domain models.
- `lib/services`: Local database access.
- `lib/providers`: App-wide state powered by Provider.
- `lib/screens`: Onboarding, dashboard, history, buffer, and settings screens.
- `lib/widgets`: Reusable presentation pieces.

## Run

Run `flutter pub get`, then `flutter run` with an Android emulator or device. All data stays on the device; no account or network connection is required.

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
