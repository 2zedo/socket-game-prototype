# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Branch: `main`
- Current commit at task start: `22b3356`
- Phase: QuarterviewMain click movement feel / pathfinding cleanup
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
- QuarterviewMain click movement feel: enlarged the temporary player marker and added candidate grid pathfinding around blockers for click movement and object approach.
- QuarterviewMain mouse interaction cleanup: normal view now uses mouse-click movement, object click approach, candidate interaction panel, and debug-only keyboard / blockout display.
- QuarterviewMain temporary background: added a temporary room background / reference flow while keeping production systems unwired.
- QuarterviewMain candidate skeleton: created the first production candidate scene without replacing old Main.

## Changed Files In Latest Work

- `godot/scripts/quarterview/QuarterviewPlayer.gd`: follows waypoint paths and uses a larger temporary player marker.
- `godot/scripts/quarterview/QuarterviewRoom.gd`: builds a blocker-aware candidate path grid, routes floor/object clicks through paths, and shows path debug data only in debug mode.
- `godot/scripts/QuarterviewMain.gd`: reports pathfinding failure reasons in the candidate status UI.
- `godot/scenes/quarterview/QuarterviewRoom.tscn`: matches the player collision capsule to the larger marker.
- `docs/PROJECT_STATUS.md`, `docs/PROJECT_WORK_LOG.md`: record the QuarterviewMain cleanup pass.

## Validation Results

- `git diff --check` passed.
- Godot headless project parse passed.
- `res://scenes/QuarterviewMain.tscn` headless startup passed.
- Full GUT passed: 54 tests.

## Current Risks / Known Issues

- `PROJECT_STATUS.md` has been rotated; detailed previous history is archived at `docs/old/PROJECT_STATUS_20260628_01.md`.
- Actual implementation state must still be verified against repo files, Godot startup, and GUT results.
- Most image / atlas plans remain documented-only.
- Main / QuarterviewMain production connection still requires a dedicated approved task.
- Existing unrelated local changes were not staged.
- Deprecated / scope notices do not rewrite old content; readers must still prioritize `docs/CONCENT_PROJECT_IDENTITY.md` when conflicts appear.
- GUI confirmation is still needed for player scale, path feel, obstacle avoidance, object approach points, and panel placement.

## Next Recommended Task

1. QuarterviewMain GUI check:
   - Start files: `godot/scenes/QuarterviewMain.tscn`, `godot/scenes/quarterview/QuarterviewRoom.tscn`.
   - Complete when background, player scale, obstacle-aware click movement, object approach, candidate panel, `D` debug path overlay, and `R` restart are manually verified.
2. Main replacement gate review:
   - Start files: `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md`, `docs/MAIN_REPLACEMENT_WORK_PLAN.md`.
   - Complete when Go / No-Go items are reviewed before any production entry change.
3. Deprecated content consolidation:
   - Start files: `docs/DOCUMENT_INVENTORY.md`, docs marked `Superseded Notice Added`.
   - Complete when each old direction doc is either rewritten into current docs, archived with a stub, or intentionally kept as historical context.

## Archive

- Previous accumulated status: `docs/old/PROJECT_STATUS_20260628_01.md`
