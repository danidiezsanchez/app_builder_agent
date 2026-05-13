---
id: T-0002
title: Mobile scaffold — after supervisor picks stack
status: proposed
role: junior-dev
recommended_model: Composer 2
estimated_tokens: med
iteration: allowed
depends_on: []
---

## Goal

Create **minimal** mobile project skeleton for **one** stack (Flutter **or** React Native) once supervisor names it in reply to Coordinator.

## Scope

- In: new app under `apps/<name>/` or repo root — **Coordinator + supervisor decide path** before setting `status: ready`.
- Out: store listings, AdMob, backend, feature work

## Deliverables

1. Official project init command run (document exact command in PR/commit body).
2. README section: how to run on emulator/device.
3. CI stub optional — only if already standard in repo; else skip.

## Acceptance criteria

- [ ] `flutter analyze` / `flutter test` **or** RN equivalent passes at scaffold level
- [ ] No extra features beyond template
- [ ] `status` flipped to `ready` only after stack choice recorded in this file under **Context links**

## Context links

- Stack choice: *pending supervisor*

## Notes for admin

Leave `status: proposed` until `T-0001` closes with chosen stack.
