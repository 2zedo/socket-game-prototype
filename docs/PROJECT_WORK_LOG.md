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

- Commit: `23d50c8`
- Result: Recorded the latest in-game room image requirements in `docs/reference/ART_DIRECTION.md`, including fixed `1920x1080`, pulled-back quarterview camera, Yui scale, indoor wall/floor material rules, palette diversification, living-space footprint reduction, logical door placement, and NAVI LINK-centered work / power room direction.
- Changed: documentation only.
- Not changed: Godot code, scenes, resources, assets, image files, `project.godot`, Main/DAY1 production flow.
- Next: Use the updated art reference as the baseline for future room image generation or review.

### Act 1 room design cues

- Commit: `639b614`
- Result: Added room-design cues for power rationing, portable Phone / Mika DM, anonymous job traces, PIP-03 support spots, NAVI LINK preparation, and NODE / signal equipment placement to current reference docs.
- Changed: `docs/reference/ART_DIRECTION.md`, `docs/reference/STORY.md`, `docs/reference/ROOM_OBJECTS.md`, `docs/reference/CHARACTERS.md`, `docs/GAME_INFO.md`, `docs/PROJECT_STATUS.md`, `docs/PROJECT_WORK_LOG.md`.
- Not changed: Godot code, scenes, resources, assets, image files, `project.godot`, Main/DAY1 production flow.
- Next: Use the living-space-only prompt direction first; do not generate both living and work rooms in one pass unless explicitly requested.

### Living-space sample review

- Commit: pending in this task.
- Result: Recorded that the latest living-space image is a usable base direction. The next pass should preserve layout and Yui scale while shrinking surrounding objects, related room proportions, and pulling the camera back slightly, then add a calmer chill nighttime mood.
- Changed: documentation only.
- Not changed: Godot code, scenes, resources, assets, image files, `project.godot`, Main/DAY1 production flow.
- Next: Revise the living-space image as a proportion/camera/mood tuning pass, not a full redesign.

### Apartment shell candidate

- Commit: pending in this task.
- Result: Added an independent coordinate-based shell scene for validating the CONCENT two-room apartment structure in Godot before final art or atlas replacement.
- Changed: `QuarterviewApartmentShellCandidate.tscn`, `QuarterviewApartmentShellCandidate.gd`, and current project docs.
- Not changed: generated image assets, furniture / prop placement, QuarterviewMain wiring, production Main/DAY1, `SurvivalState`, production UI, save-load, Grid Credit, `project.godot`.
- Next: Manually inspect the shell in Godot and tune only coordinates until the living/work room connection, camera angle, and no-large-object foreground zone are accepted.

### Apartment wall segment inventory

- Commit: pending in this task.
- Result: Added wall segment inventory output to `QuarterviewApartmentShellCandidate`; `I` prints id/source/start/end/edit hints, and `W` shows wall IDs with start/end markers independently from general debug labels.
- Changed: `QuarterviewApartmentShellCandidate.gd`, `ApartmentWallSegmentConfig.gd`, and technical/status docs.
- Not changed: shell wall positions, room size, furniture/assets/atlas, production Main/DAY1, QuarterviewMain wiring, `SurvivalState`, `project.godot`.
- Next: Use the inventory table to identify which segment to move/hide before changing the shell layout itself.

### Apartment bathroom/service merge

- Commit: pending in this task.
- Result: Merged the service area into the bathroom shell region, moved the bathroom footprint to `x=1..3`, `y=7..10`, added `bathroom_left_wall` / `bathroom_right_wall`, and left legacy service wall segments disabled in inventory.
- Changed: `QuarterviewApartmentShellCandidate.gd` and current technical/status docs.
- Not changed: furniture/assets/atlas, production Main/DAY1, QuarterviewMain wiring, `SurvivalState`, `project.godot`.
- Next: Inspect the shell visually with `W` wall IDs enabled before further coordinate edits.

### Apartment grid coordinate overlay

- Commit: pending in this task.
- Result: Added `G` floor coordinate overlay, origin / `+X` / `+Y` markers, hover/click cell readout, wall focus highlighting, and `from_cell -> to_cell` wall inventory output for apartment shell editing.
- Changed: `QuarterviewApartmentShellCandidate.gd` and current technical/status docs.
- Not changed: bathroom/wall positions, room sizes, furniture/assets/atlas, production Main/DAY1, QuarterviewMain wiring, `SurvivalState`, `project.godot`.
- Next: Use `G`, `W`, and `I` together to specify exact wall coordinate edits before moving shell walls.

### Apartment bathroom / entrance wall coordinates

- Commit: pending in this task.
- Result: Repositioned the apartment shell bathroom / entrance walls to the requested grid-line coordinates, moved the bathroom doorway to `bathroom_right_wall`, added `entrance_inner_wall`, and kept legacy bathroom-left / service segments disabled in inventory.
- Changed: `QuarterviewApartmentShellCandidate.gd` and current technical/status docs.
- Not changed: room scale, production Main/DAY1, QuarterviewMain wiring, furniture/assets/atlas, `SurvivalState`, `project.godot`.
- Next: Inspect with `G`, `W`, and `I` enabled before any further wall coordinate edits.
