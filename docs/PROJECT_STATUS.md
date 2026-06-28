# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Branch: `main`
- Current commit at task start: `cc47319`
- Phase: Deprecated / scoped document notice pass
- Main target: Godot project under `godot/`
- Current source of truth: `AGENTS.md`, then `docs/CONCENT_PROJECT_IDENTITY.md`

## Current Direction

- `docs/CONCENT_PROJECT_IDENTITY.md` is the current game identity and direction reference.
- Main room direction is mouse-click first: object click, Yui moves, then `Use / Inspect / Cancel`.
- Power equipment direction is a modular power-board / power-tetris system, not the old simple multitap-only direction.
- Hacking direction focuses first on action infiltration and defense.
- Existing `Main.tscn` / DAY1 still exists as the protected golden path.
- `QuarterviewMain.tscn` is a production candidate skeleton, not the project start scene.

## Current Implementation State

- Current Main / DAY1: implemented top-view golden path; protected until explicit replacement approval.
- QuarterviewMain: production candidate skeleton with temporary room background and status logging only.
- QuarterviewRoom: candidate room shell using `RoomObjectDefinition` data, prompt / interaction signals, and debug overlay.
- QuarterviewGameplaySandbox: sandbox-only flow for interaction, mock panels, local clock, local result, and local test mode.
- Phone / Outlet / Result: still current Main-only production UI; not wired to QuarterviewMain.
- SurvivalState: production source of truth for day, time, power, connected / active devices, phone, and result data.
- Hacking prototypes: prototype-only; not wired to Laptop, rewards, Result, story flags, or save/load.
- Asset / atlas state: most qv / hack / ui atlas documents are documented-only; actual PNG, mapping Resource, Theme, and scene wiring are absent unless separately tracked.

## Latest Completed Work

- Project identity consolidation: added `docs/CONCENT_PROJECT_IDENTITY.md` and `docs/PROJECT_WORK_LOG.md`, and made AGENTS point to the identity document.
- Room / power / hacking design direction docs: fixed the current direction for mouse-centric room flow, desk close-up, modular power, hunger, hacking infiltration, and defense.
- Deprecated / scoped document notice pass: added targeted notices to legacy / conflict candidate docs, while leaving current source-of-truth docs unchanged.
- QuarterviewMain temporary background: added a temporary room background / reference flow while keeping production systems unwired.
- QuarterviewMain candidate skeleton: created the first production candidate scene without replacing old Main.

## Changed Files In Latest Work

- Superseded notices added: `docs/CONCENT_GAME_SPEC.md`, `docs/PROJECT_DIRECTION_REVISED.md`, `docs/IMPLEMENTATION_ROADMAP_REVISED.md`, `docs/DAILY_LOOP_REVISED.md`, `docs/ROOM_DEVICE_DIRECTION.md`, `docs/VISUAL_DIRECTION.md`.
- Scope notices added: `docs/GODOT_DAY1_MVP_PLAN.md`, `docs/DAY1_CONTENT_BRIEF.md`, `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`, `docs/ASSET_APPLICATION_NOTES.md`.
- `docs/DOCUMENT_INVENTORY.md`: records notice results and confirms no archive moves in this pass.
- `docs/PROJECT_STATUS.md`, `docs/PROJECT_WORK_LOG.md`: record the notice cleanup pass.

## Validation Results

- `find docs -type f | sort` was checked.
- `wc -l docs/PROJECT_STATUS.md docs/PROJECT_WORK_LOG.md docs/CONCENT_PROJECT_IDENTITY.md docs/DOCUMENT_INVENTORY.md AGENTS.md` was checked.
- `git diff --check` passed.
- `git diff --cached --check` passed.
- Godot headless was not run because this was docs-only.

## Current Risks / Known Issues

- `PROJECT_STATUS.md` has been rotated; detailed previous history is archived at `docs/old/PROJECT_STATUS_20260628_01.md`.
- Actual implementation state must still be verified against repo files, Godot startup, and GUT results.
- Most image / atlas plans remain documented-only.
- Main / QuarterviewMain production connection still requires a dedicated approved task.
- Existing unrelated local changes were not staged.
- Deprecated / scope notices do not rewrite old content; readers must still prioritize `docs/CONCENT_PROJECT_IDENTITY.md` when conflicts appear.

## Next Recommended Task

1. Deprecated content consolidation:
   - Start files: `docs/DOCUMENT_INVENTORY.md`, docs marked `Superseded Notice Added`.
   - Complete when each old direction doc is either rewritten into current docs, archived with a stub, or intentionally kept as historical context.
2. QuarterviewMain GUI check:
   - Start files: `godot/scenes/QuarterviewMain.tscn`, `godot/scenes/quarterview/QuarterviewRoom.tscn`.
   - Complete when background, prompt, invisible interaction / collision, `D` debug, and `R` restart are manually verified.
3. Main replacement gate review:
   - Start files: `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md`, `docs/MAIN_REPLACEMENT_WORK_PLAN.md`.
   - Complete when Go / No-Go items are reviewed before any production entry change.

## Archive

- Previous accumulated status: `docs/old/PROJECT_STATUS_20260628_01.md`
