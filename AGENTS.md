# Repository Guidelines2

## Project Structure & Module Organization
This repository is a single Flutter app. The main entry point lives in `lib/main.dart`, and the current widget smoke test lives in `test/widget_test.dart`. Platform wrappers are kept in `android/`, `ios/`, `macos/`, `linux/`, `windows/`, and `web/`; only touch them when a feature needs platform-specific changes. Treat `build/` and `.dart_tool/` as generated output, not source. There is no shared `assets/` directory yet; add one only when you also register it in `pubspec.yaml`.

## Build, Test, and Development Commands
Run `flutter pub get` after dependency changes. Use `flutter run` to launch the app locally, or `flutter run -d chrome` for the web target. Run `flutter test` for the widget test suite and `flutter analyze` before opening a PR. Production builds should use the standard Flutter targets, for example `flutter build apk` or `flutter build web`.

## Coding Style & Naming Conventions
Follow Dart and Flutter conventions: 2-space indentation, trailing commas in multi-line widget trees, `PascalCase` for classes and widgets, `lowerCamelCase` for fields and methods, and `snake_case.dart` for filenames. Keep UI code readable by extracting private widgets once `main.dart` starts mixing layout, animation, and state concerns. Prefer Material 3 patterns already used in the app, and keep theme values centralized instead of scattering colors through new files.

## Testing Guidelines
Use `flutter_test` for widget coverage. Name tests after behavior, for example `renders loading header` or `advances status text`. Mirror new source files with matching `*_test.dart` files under `test/` when logic moves out of `main.dart`. For UI-heavy changes, assert visible text, key widgets, and state transitions instead of only pumping frames.

## Commit & Pull Request Guidelines
Current history uses Conventional Commit style (`chore: init flutter`); continue with prefixes like `feat:`, `fix:`, `refactor:`, and `test:`. Keep commits focused and written in the imperative mood. PRs should include a short summary, test notes (`flutter test`, `flutter analyze`), linked issues when applicable, and screenshots or GIFs for visual changes.
