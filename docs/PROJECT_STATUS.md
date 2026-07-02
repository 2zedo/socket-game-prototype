# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Branch: `main`
- Current commit at task start: `2fe9978`
- Phase: QuarterviewMain minimum day-loop candidate
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
- QuarterviewMain: production candidate skeleton with temporary room background, candidate interaction panel, prototype HUD, bed / desk / power / phone / food-kitchen / door candidate overlays, Day Result candidate overlay, and status logging only.
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
- QuarterviewMain footprint tuning: split visual body, click area, and blocker footprint candidates, and made path / collision blockers prefer floor-contact polygons over top-view rectangles.
- QuarterviewMain footprint tuning mode: added object panel outside-click close, kept guessed footprints as debug/tuning candidates unless path-enabled, and added a debug-only F3 tuning mode for selected object footprint / approach / click area inspection.
- QuarterviewMain Food / Kitchen candidate overlay: added no-op Fridge / Microwave food and cooking candidate actions while keeping hunger, inventory, SurvivalState, and DayResultPanel unwired.
- QuarterviewMain Door candidate overlay: added no-op door / hallway / outing candidate actions while keeping scene transition, outside map, story flag, and save-load unwired.
- QuarterviewMain minimum day-loop candidate: added a QuarterviewMain-only mock HUD and Day Result candidate overlay from the Bed end-day option while keeping DayResultPanel, SurvivalState, save-load, and story flags unwired.
- QuarterviewMain Bed rest candidate overlay: added a no-op rest / end-day candidate overlay from the Bed object candidate panel while keeping DayResultPanel, SurvivalState day advance, and production result flow unwired.
- QuarterviewMain Phone candidate overlay: added a no-op Phone status / charge overlay from the Phone object candidate panel while keeping PhoneUI, SurvivalState, and production battery state unwired.
- QuarterviewMain power equipment close-up candidate: added a no-op power-board style overlay from the Power object candidate panel while keeping OutletMode, SurvivalState, and production power calculation unwired.
- QuarterviewMain debug / close-up stabilization: fixed debug detail mixed-value text conversion, removed shadow warnings, and added empty-backdrop click close for the desk close-up candidate.
- QuarterviewMain desk close-up candidate: added a no-op desk close-up overlay for desk / laptop use and locked room click movement while candidate UI is open.
- QuarterviewMain interaction tuning: added object click priority, tuned approach points, clamped candidate panel placement, and reduced debug overlay text clutter.
- QuarterviewMain debug input split: separated the `D` debug toggle from movement input, limited debug keyboard movement to arrow keys, and kept normal interaction panels free of developer-only object details.
- QuarterviewMain movement/debug tuning: organized click/path tuning constants, kept debug toggle from changing room/camera/player transforms, and made D show debug overlays without reintroducing blockout visual shift.
- QuarterviewMain click pathfinding hardening: guarded empty path results and removed the `skew` shadow warning in the candidate room script.
- QuarterviewMain click movement feel: enlarged the temporary player marker and added candidate grid pathfinding around blockers for click movement and object approach.
- QuarterviewMain mouse interaction cleanup: normal view now uses mouse-click movement, object click approach, candidate interaction panel, and debug-only keyboard / blockout display.
- QuarterviewMain temporary background: added a temporary room background / reference flow while keeping production systems unwired.
- QuarterviewMain candidate skeleton: created the first production candidate scene without replacing old Main.
- CONCENT handoff / identity refresh: updated the new-session handoff and identity room direction with the latest compact room, hidden power cabinet, simplified desk, and current QuarterviewMain overlay status.

## Changed Files In Latest Work

- `godot/scripts/QuarterviewMain.gd`: adds the QuarterviewMain-only prototype HUD, Day Result candidate overlay, Bed `오늘을 마무리한다` routing, mock next-day increment, and room input lock / ESC / close button / backdrop close while keeping DayResultPanel, SurvivalState, save-load, and story flags unwired.
- `docs/CONCENT_GPT_HANDOFF.md`: records the mock HUD and Day Result candidate overlay as current QuarterviewMain-only behavior.
- `docs/PROJECT_STATUS.md`, `docs/PROJECT_WORK_LOG.md`: record the QuarterviewMain minimum day-loop candidate pass.

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
- GUI confirmation is still needed for prototype HUD placement, Bed `오늘을 마무리한다` opening Day Result candidate, next-day mock DAY increment, result overlay ESC / Close / backdrop close, room movement lock while the result overlay is open, Door object approach, Door `사용하기` opening the new overlay, door no-op option logs, existing Bed / Desk / Power / Phone / Food-Kitchen close-up behavior, candidate panel empty-area click close, `D` then `F3` footprint tuning mode, `[ / ]` object selection, `C` layout snippet output / clipboard behavior, debug ON visual rect / click area / footprint readability, polygon footprint movement around bed / desk / power / fridge / kitchen objects, repeated `D` toggles without movement, player scale, path feel, obstacle avoidance, debug failure reasons, and whether the latest compact room design direction should drive the next background art pass.

## Next Recommended Task

1. QuarterviewMain GUI check:
   - Start files: `godot/scenes/QuarterviewMain.tscn`, `godot/scenes/quarterview/QuarterviewRoom.tscn`.
   - Complete when background, prototype HUD, Bed end-day Day Result candidate, next-day mock DAY increment, Door / Bed / Phone / Power / Fridge / Microwave object approach, Door / Bed / Phone / Power / Food-Kitchen close-up open/close, no-op item logs, candidate panel empty-area close, Desk close-up behavior, `D` / `F3` footprint tuning, `[ / ]` selection, `C` snippet output, debug ON visual rect / click area / footprint distinction, bed / desk / power / fridge / kitchen / door movement, debug ON object click, room input lock during close-up, approach points, panel clamp, repeated `D` toggles without movement, normal/debug candidate panel split, player scale, obstacle-aware click movement, spam-click stability, `D` debug path overlay, and `R` restart are manually verified.
2. Main replacement gate review:
   - Start files: `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md`, `docs/MAIN_REPLACEMENT_WORK_PLAN.md`.
   - Complete when Go / No-Go items are reviewed before any production entry change.
3. Deprecated content consolidation:
   - Start files: `docs/DOCUMENT_INVENTORY.md`, docs marked `Superseded Notice Added`.
   - Complete when each old direction doc is either rewritten into current docs, archived with a stub, or intentionally kept as historical context.

## Archive

- Previous accumulated status: `docs/old/PROJECT_STATUS_20260628_01.md`
