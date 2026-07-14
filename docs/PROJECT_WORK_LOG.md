# Project Work Log

## Purpose

This short active log tracks the newest completed work for `CONCENT / 전력 부족의 시대`.

Long history is archived in `docs/old/`. When this file grows past about 200 lines, rotate it into `docs/old/PROJECT_WORK_LOG_<YYYYMMDD>_<NN>.md` and recreate a short active log.

## Current Log

### Apartment Floor Scene split

- Moved the four apartment TileMapLayers into `maps/apartment/ApartmentFloor.tscn` as the single Floor-cell authority. Environment now assembles one default-transform `Floor` instance, while the established `Floor/EntranceFloor`, `Floor/BathroomFloor`, `Floor/LivingFloor`, and `Floor/WorkFloor` paths remain unchanged.
- Preserved all 99 cells exactly: Entrance 6, Bathroom 7, Living 54, and Work 32, including every cell coordinate, source/atlas coordinate, the shared development TileSet, layer transforms, Korean descriptions, and room colors. Environment, Shell, and Playable contain no local Floor child data or editable-child override.
- MCP opened the Floor Scene independently, added and undid a temporary cell, then reopened Environment and ran Shell/Playable. The assembled hierarchy, screen geometry, P/M/N/G overlays, and click movement remained intact with no new editor or runtime error. Floor targeted GUT passed 7 tests/355 assertions, and full validation passed 177 tests/4910 assertions. Status remains `KEEP_CANDIDATE`; `ApartmentStructure.tscn` is the next approved separation stage, not part of this change.

### Godot Scene structure and map-authoring audit

- Inventoried all 62 tracked Godot Scenes and their roots, Scripts, child dependencies, reverse references, owned data, direct-run role, and KEEP/REVIEW/SPLIT/MOVE disposition. The set is 40 project Scenes plus 22 vendored GUT Scenes; every path is listed in `TECHNICAL_MAP.md`.
- Confirmed through godot-ai MCP that `QuarterviewApartmentEnvironment` is the single apartment geometry authority: four Floor layers, four RoomAreas, five Opening mirrors, 58 WallCells, 18 Scene-Node objects, ceiling/wall/parent sockets, and editor guides. Shell and Playable inherit that authority without local geometry overrides; no authored Navigation Node exists because navigation is derived from the provider geometry.
- Recorded the current one-cell WallCell authoring workflow, actual-child versus `mount_socket_path` attachment contracts, fragile fixed-path references, mixed Environment/provider/debug responsibilities, compatibility scaffolding, and the distinction between active Scene authority and retained legacy paths. No Scene, Script, Resource, geometry, production entry, or project setting changed.
- Defined nine rollbackable Apartment migration stages: approve roles, split Floor and Structure as single-authority child Scenes without local overrides, normalize wall groups/object boundaries, reduce Environment to assembly/provider, separate DebugShell, clarify the gameplay runtime, lock sample/legacy boundaries, and visually accept W/Junction behavior. A real second map, common extraction, and a small editor helper are three later conditional gates rather than mandatory work. Status remains `KEEP_CANDIDATE`.

### Quarterview Apartment production-readiness audit

- Compared the protected Main/DAY1/Apartment/SurvivalState/production UI composition with the latest Quarterview Environment/Playable/Room path without changing either runtime. The newest world and movement candidate is stable, but no production orchestrator, state/UI bridge, persistence, or DAY1 entry/exit connection exists.
- Characterized the blocking contracts: production and Quarterview interaction signals have different argument shapes and different seven-object ID inventories; SurvivalState is a scene-local Node rather than an Autoload; the RoomSceneContract is still a no-op skeleton; and P/ESC ownership conflicts with candidate debug/UI. The project `open_phone` action is currently Backspace while Main separately polls raw Tab.
- Added minimal regression coverage for Main child composition, single startup signal wiring, no-save startup, production Phone modal clock/movement locking, current time/power/battery seams, and the explicit Quarterview adapter requirement. The staged plan keeps the candidate at `KEEP_CANDIDATE`, adds a candidate-only room adapter first, and leaves Main, DAY1, Apartment, SurvivalState, production UI, and `project.godot` untouched.
- MCP opened and ran Main twice, the old Apartment, all three Apartment candidate scenes, and all three reusable-sample scenes. Main started at DAY 1, P changed only test mode, raw Tab opened Phone and locked both clock/movement, and ESC restored both. Quarterview mouse input moved the player toward a selected object; P/ESC independently opened/cleared Environment debug while that movement target remained active, confirming the input-owner blocker. Every current run had zero game warning/error, the fresh editor cursor gained zero entries, and the existing Debugger rows were ten pre-existing production warnings outside this task.
