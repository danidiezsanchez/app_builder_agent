---
id: T-0012
title: Spider — mobile build smoke test
status: ready
role: junior-dev
recommended_model: composer-2-fast
estimated_tokens: low
iteration: allowed
depends_on: [T-0011]
---

## Goal

Prove the app compiles for Android. iOS build deferred (CI box has no Xcode); just `flutter analyze` for the iOS target.

## Scope

- In: build commands only; **no code changes** unless required to fix a compile error revealed by the build.
- Out: signing, store metadata, app icons, screenshots.

## Deliverables

1. Run `flutter build apk --debug` in `apps/spider_solitaire/`, paste the final lines of output to PR body.
2. Run `flutter analyze --no-pub` after switching to the iOS target if available; otherwise document why skipped.
3. Append a "Mobile build status" section to `apps/spider_solitaire/README.md`.

## Acceptance criteria

- [ ] `flutter build apk --debug` exits 0
- [ ] `flutter analyze` clean
- [ ] No new dependencies added

## Context links

- Stack: `projects/project2/STACK.md`

## Notes for admin

Branch: `cursor/spider-t0012-mobile-smoke-ac06`. Target branch: `project2`. **Stop and escalate** if APK build needs Gradle / NDK config beyond defaults — that becomes a senior-dev task.
