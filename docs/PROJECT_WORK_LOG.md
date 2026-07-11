# Project Work Log

## Purpose

This short active log tracks the newest completed work for `CONCENT / 전력 부족의 시대`.

Long history is archived in `docs/old/`. When this file grows past about 200 lines, rotate it into `docs/old/PROJECT_WORK_LOG_<YYYYMMDD>_<NN>.md` and recreate a short active log.

## Current Log

### Apartment debug overlay mode separation

- Commit: `chore: improve apartment debug overlay modes`.
- Result: Split M/P/N into exclusive primary modes with opt-in combined overlays, separated measurement/object/navigation/selection layers and fixed panels, added compact/F1 help, and changed P floor/collision display to isometric four-point geometry with hover/click selection.
- Validation: Targeted GUT passed 19/19 with 847 assertions; Full GUT passed 115/115 with 1774 assertions; project parse, shell startup, and QuarterviewMain startup all exited successfully. The existing Phone PNG export warning remains unchanged.
- Manual check still needed: P hit selection and polygon alignment at four rotations, M/N panel readability, explicit Shift-combined clutter, navigation marker movement, and UI priority in the Godot window.
- Not changed: the 18 object coordinates or metadata, room/wall/door/window geometry, navigation calculations, production Main/DAY1, QuarterviewMain wiring, assets/audio/imports, or `project.godot`.

### Apartment object layout candidate synchronization

- Commit: `6ed6444`.
- Result: Replaced the old 12 shell placeholders with the user-approved 18-object first-placement candidate and added optional pixel-size, collision, interaction, wall, ceiling, and parent-attachment metadata.
- Validation: Candidate inventory, attachment references, doorway alignment, four rotations, debug-key smoke, and placement/measurement warnings are covered by targeted GUT; manual `M + P + N` visual confirmation remains required.
- Not changed: room/wall/door/window geometry, production Main/DAY1, QuarterviewMain wiring, Phone UI, assets, audio, imports, or `project.godot`.
