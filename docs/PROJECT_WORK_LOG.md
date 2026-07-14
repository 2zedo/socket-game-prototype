# Project Work Log

## Purpose

This short active log tracks the newest completed work for `CONCENT / 전력 부족의 시대`.

Long history is archived in `docs/old/`. When this file grows past about 200 lines, rotate it into `docs/old/PROJECT_WORK_LOG_<YYYYMMDD>_<NN>.md` and recreate a short active log.

## Current Log

### Quarterview Apartment production-readiness audit

- Compared the protected Main/DAY1/Apartment/SurvivalState/production UI composition with the latest Quarterview Environment/Playable/Room path without changing either runtime. The newest world and movement candidate is stable, but no production orchestrator, state/UI bridge, persistence, or DAY1 entry/exit connection exists.
- Characterized the blocking contracts: production and Quarterview interaction signals have different argument shapes and different seven-object ID inventories; SurvivalState is a scene-local Node rather than an Autoload; the RoomSceneContract is still a no-op skeleton; and P/ESC ownership conflicts with candidate debug/UI. The project `open_phone` action is currently Backspace while Main separately polls raw Tab.
- Added minimal regression coverage for Main child composition, single startup signal wiring, no-save startup, production Phone modal clock/movement locking, current time/power/battery seams, and the explicit Quarterview adapter requirement. The staged plan keeps the candidate at `KEEP_CANDIDATE`, adds a candidate-only room adapter first, and leaves Main, DAY1, Apartment, SurvivalState, production UI, and `project.godot` untouched.
- MCP opened and ran Main twice, the old Apartment, all three Apartment candidate scenes, and all three reusable-sample scenes. Main started at DAY 1, P changed only test mode, raw Tab opened Phone and locked both clock/movement, and ESC restored both. Quarterview mouse input moved the player toward a selected object; P/ESC independently opened/cleared Environment debug while that movement target remained active, confirming the input-owner blocker. Every current run had zero game warning/error, the fresh editor cursor gained zero entries, and the existing Debugger rows were ten pre-existing production warnings outside this task.
