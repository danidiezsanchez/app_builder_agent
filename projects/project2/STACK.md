# STACK — language and tools

## Decision: Flutter / Dart

| Criterion | Why Flutter wins for this app |
|-----------|-------------------------------|
| iOS + Android from one codebase | Native compile per platform, single Dart source |
| Already in repo | `project1` (Cozy Focus) is Flutter; SDK pre-installed at `/opt/flutter` |
| Text rendering quality | Strong Unicode + custom `TextStyle`; renders ♠♥♦♣ + ranks cleanly |
| Test ergonomics | `flutter test` runs pure-Dart engine tests headlessly |
| Linux desktop dev loop | Fast local validation without a phone/emulator |
| Future graphics upgrade path | Easy swap from `Text` widget to `Image.asset` later |

### Considered, rejected for MVP

- **React Native**: extra setup, no pre-existing repo plumbing, JS bridge cost for nothing we need.
- **Native (Swift + Kotlin twice)**: doubles the work for an MVP.
- **Web / PWA**: user wants iOS + Android specifically.

## Versions

- **Flutter SDK**: whatever `/opt/flutter` ships (Dart `^3.11.5` per `AGENTS.md`). Don't pin in `pubspec.yaml` more strictly than `project1` already does.
- **Min Android SDK**: Flutter default (21+).
- **Min iOS**: Flutter default (12+).

## Dependencies (target — keep minimum)

| Package | Why |
|---------|-----|
| `flutter` SDK | UI + test runner |
| `flutter_lints` | analyzer baseline |

That's it for MVP. **No** state-management package — built-in `ChangeNotifier` is enough for one screen. **No** persistence, no icon pack, no animation lib. Add later only when justified by a task.

## Project layout

```
apps/spider_solitaire/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── engine/
│   │   ├── card.dart
│   │   ├── deck.dart
│   │   ├── game_state.dart
│   │   └── rules.dart
│   └── ui/
│       ├── home_page.dart
│       ├── column_widget.dart
│       └── card_widget.dart
├── test/
│   ├── card_test.dart
│   ├── rules_test.dart
│   └── game_state_test.dart
└── README.md
```

## Run / test commands (for executing agents)

```bash
cd apps/spider_solitaire
flutter pub get
flutter analyze
flutter test
flutter run -d linux        # dev loop, needs DISPLAY=:1
```

Mobile builds are **not required** for any MVP task — defer until a future task explicitly asks.
