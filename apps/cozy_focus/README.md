# Cozy Focus (Flutter)

**Path choice:** App lives at `apps/cozy_focus/` (repo root), not `projects/project1/app/`. Matches demo task suggestion in `projects/project1/tasks/demo-build.md` and keeps `projects/project1/` for docs/spec only.

**Product context:** `projects/project1/COZY_FOCUS.md`  
**Build checklist:** `projects/project1/tasks/demo-build.md`

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable), Xcode + iOS Simulator for iOS, Android Studio + emulator (or device) for Android.

## Commands

From repository root:

```bash
cd apps/cozy_focus
flutter pub get
```

**iOS Simulator** (macOS with Xcode):

```bash
cd apps/cozy_focus
flutter run -d ios
```

**Android Emulator or device:**

```bash
cd apps/cozy_focus
flutter run -d android
```

## Linting

Uses `flutter_lints` via `analysis_options.yaml`.

```bash
cd apps/cozy_focus
flutter analyze
```

## Assets

Declared in `pubspec.yaml`: `assets/images/`, `assets/audio/` (placeholders until D1 asset pack).
