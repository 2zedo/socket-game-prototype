# Project Work Log

## Purpose

This short active log tracks the newest completed work for `CONCENT / 전력 부족의 시대`.

Long history is archived in `docs/old/`. When this file grows past about 200 lines, rotate it into `docs/old/PROJECT_WORK_LOG_<YYYYMMDD>_<NN>.md` and recreate a short active log.

## Current Log

### Apartment object layout candidate synchronization

- Commit: pending in this task.
- Result: Replaced the old 12 shell placeholders with the user-approved 18-object first-placement candidate and added optional pixel-size, collision, interaction, wall, ceiling, and parent-attachment metadata.
- Validation: Candidate inventory, attachment references, doorway alignment, four rotations, debug-key smoke, and placement/measurement warnings are covered by targeted GUT; manual `M + P + N` visual confirmation remains required.
- Not changed: room/wall/door/window geometry, production Main/DAY1, QuarterviewMain wiring, Phone UI, assets, audio, imports, or `project.godot`.
