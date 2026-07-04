# Project Work Log

## Purpose

This short active log tracks the newest completed work for `CONCENT / 전력 부족의 시대`.

Long history is archived in `docs/old/`. When this file grows past about 200 lines, rotate it into `docs/old/PROJECT_WORK_LOG_<YYYYMMDD>_<NN>.md` and recreate a short active log.

## Current Log

### Documentation structure consolidation

- Commit: `c1ffa22`
- Result: Created `docs/GAME_INFO.md` and current `docs/reference/*.md` files, rotated previous status/work-log files, moved old root-level docs into `docs/old/`, and updated `AGENTS.md` to the new docs policy.
- Changed: documentation only.
- Not changed: Godot code, scenes, resources, assets, `project.godot`, Main/DAY1 production flow.
- Next: Treat `docs/GAME_INFO.md` as the project info entry and update the relevant `docs/reference/*.md` file before reflecting top-level changes back into `GAME_INFO.md`.

### Room image direction update

- Commit: pending in this task.
- Result: Recorded the latest in-game room image requirements in `docs/reference/ART_DIRECTION.md`, including fixed `1920x1080`, pulled-back quarterview camera, Yui scale, indoor wall/floor material rules, palette diversification, living-space footprint reduction, logical door placement, and NAVI LINK-centered work / power room direction.
- Changed: documentation only.
- Not changed: Godot code, scenes, resources, assets, image files, `project.godot`, Main/DAY1 production flow.
- Next: Use the updated art reference as the baseline for future room image generation or review.
