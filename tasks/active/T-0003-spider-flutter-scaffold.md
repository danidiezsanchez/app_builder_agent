---
id: T-0003
title: Spider — Flutter scaffold for spider_solitaire app
status: ready
role: junior-dev
recommended_model: composer-2-fast
estimated_tokens: low
iteration: allowed
depends_on: []
---

## Goal

Create the empty Flutter project for the spider solitaire MVP at `apps/spider_solitaire/`, on a fresh `project2` branch.

## Scope

- In: `apps/spider_solitaire/` (created via `flutter create`), `pubspec.yaml`, default `lib/main.dart` replaced with a placeholder `Scaffold` saying "Spider Solitaire — coming soon".
- Out: any game logic, any custom widgets, any extra dependencies.

## Deliverables

1. Run `flutter create --org dev.cursor.spider --platforms=android,ios,linux apps/spider_solitaire` (exact command in commit body).
2. Replace `lib/main.dart` with a one-screen placeholder.
3. `apps/spider_solitaire/README.md` documenting `flutter pub get` / `flutter test` / `flutter run -d linux`.
4. New git branch `project2` pushed to origin (from `main`); this PR targets `project2`.

## Acceptance criteria

- [ ] `cd apps/spider_solitaire && flutter analyze` exits 0
- [ ] `flutter test` exits 0 (default widget test passes)
- [ ] No files touched outside `apps/spider_solitaire/`
- [ ] No new packages added beyond `flutter create` defaults + `flutter_lints`

## Context links

- Spec: `projects/project2/SPEC.md`
- Stack: `projects/project2/STACK.md`
- Agent guide: `projects/project2/AGENT_GUIDE.md`

## Notes for admin

Branch: `cursor/spider-t0003-scaffold-ac06`. Target branch: `project2` (create from `main` if missing).
