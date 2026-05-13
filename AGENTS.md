# AGENTS.md

## Cursor Cloud specific instructions

### Repository layout

- **`main` branch**: orchestration docs, `.cursor/rules/`, GitHub Actions workflow only. No buildable app code.
- **`project1` branch**: Flutter app "Cozy Focus" at `apps/cozy_focus/`. This is where development happens.
- Open PRs **to `project1`** for app code. Use `main` only for shared docs/rules. See `docs/MERGE_AND_BRANCHING.md`.

### Flutter SDK

Flutter SDK is installed at `/opt/flutter`. PATH is configured in `~/.bashrc`. Verify with `flutter --version` (requires Dart `^3.11.5`).

### Running the Cozy Focus app (`project1` branch)

```bash
git checkout project1
cd apps/cozy_focus
flutter pub get
flutter test            # 5 pass, 1 pre-existing failure (FINISH→IDLE reset test expects 420, gets 60)
flutter analyze         # 2 pre-existing issues (1 info, 1 warning) — not blockers
flutter build linux --debug
flutter run -d linux    # requires DISPLAY=:1
```

### Gotchas

- The `project1` branch app requires `linux/` platform dir for desktop builds. If missing, run `flutter create --platforms=linux .` inside `apps/cozy_focus/`.
- `flutter build linux` (release) may fail with install permissions — use `flutter build linux --debug` instead.
- Linux desktop build requires `ninja-build`, `libgtk-3-dev`, and `libstdc++-14-dev` system packages.
- Tests are pure Dart and do not require a device/emulator — `flutter test` works headlessly.
- The 1 pre-existing test failure in `cozy_focus_session_engine_test.dart` ("FINISH → IDLE resets clock") is a known issue in the codebase.
