# Project Work Log

## Purpose

This short active log tracks the newest completed work for `CONCENT / 전력 부족의 시대`.

Long history is archived in `docs/old/`. When this file grows past about 200 lines, rotate it into `docs/old/PROJECT_WORK_LOG_<YYYYMMDD>_<NN>.md` and recreate a short active log.

## Current Log

### Rotated-floorplan placement and whole-wall inspection

- Commit message: `feat: align apartment candidate to rotated floorplan`.
- Result: Repositioned the kitchen group along the shared-wall left side, moved Power Board/Housing and conduit references onto separated work back-wall edges, and made poster fallback metadata use its actual living-right wall edge. Existing bed/table/NAVI/NODE/bathroom/entrance candidates were retained where they already matched the rotated plan.
- V inspection: Replaced the living-strip-only alpha change with one visual-only toggle for all wall, stub, door, and window layers. Floor edges, logical wall inventory, navigation, collision, reveal state, and production ownership remain unchanged.
- Visual check: Godot MCP reloaded and ran the candidate before and after the change. The kitchen line now reads beside the shared wall, work wall devices resolve from back-wall guides, and V exposes objects behind every room wall with no new game-log errors.
- Status: `KEEP_CANDIDATE`. Manual confirmation: `REQUIRED` for final art-scale offsets and user acceptance; production Main/DAY1, Apartment, SurvivalState, `project.godot`, and generated metadata remain unchanged.

### Apartment object anchor and placement display pass 1

- Commit message: `feat: refine apartment object placement debug`.
- Result: Replaced candidate `placement_type` with readable `FLOOR` / `WALL_EDGE` / `CEILING` / `PARENT_OBJECT` anchors, aligned interaction/environment categories, added a P-only geometry legend and stronger selected anchor/bounds display, and added the visual-only V occlusion-wall transparency toggle for both stub and revealed right-wall rendering.
- Layout: Bed moved from `(8,6)` to `(9,6)` with interaction access from `(8,7)`; the dining table moved from `(4,6)` to `(4,7)`. Other named floor anchors already matched the supplied textual room directions, while wall and parent visuals now resolve from their actual attachment reference.
- Validation: Candidate-specific anchor/category/layout/P-N separation/selection/V tests and candidate Scene startup pass; placement and room measurement warnings remain zero. Godot MCP reloaded and ran the candidate with no new script/game errors and confirmed the P legend/V state in the current ROTATE_90 view.
- Status: `KEEP_CANDIDATE`. Manual confirmation: `REQUIRED` because the floorplan image was unavailable in this session and final pixel alignment/readability still needs a Godot-window check. Production Main/DAY1, Apartment, SurvivalState, `project.godot`, and generated metadata remain unchanged.

### Candidate parse error and validator fatal-log detection

- Commit message: `fix: catch candidate script parse errors`.
- Result: Renamed the interaction-cell local `center` to `interaction_center` to resolve the same-scope declaration conflict, without changing its coordinate calculation or candidate behavior.
- Validation: Godot MCP reopened the candidate Scene and outlined the script with no new editor errors after the previous log cursor. A fake Godot that printed `Parse Error` and `Failed to load script` while exiting 0 made the validator return non-zero. The isolated task-only worktree passed full validation with the Phone PNG warning still classified as known; the main worktree's four GUT failures belong to the paused anchor/overlay changes and are outside this commit.
- Not changed: object placement, M/P/N behavior, coordinates, camera behavior, production files, Scenes, `project.godot`, or generated `.import`/`.uid` metadata.

### CONCENT Documentation Sync Skill

- Commit message: `chore: add concent docs sync skill`.
- Result: Added `.agents/skills/concent-docs-sync/SKILL.md` to decide whether a
  CONCENT change needs documentation, select the current canonical reference,
  and keep summary, status, work-log, and archive roles distinct.
- Validation: Skill frontmatter/structure checks passed. `$concent-godot-validation`
  quick validation passed; project parse, QuarterviewMain, and apartment-shell
  startup passed, while Full GUT was correctly skipped.
- Not changed: game code, Scenes, Resources, GAME_INFO, game-design reference
  documents, validation script, or existing Skills.

### CONCENT Candidate Development and Graduation Workflow Skill

- Commit message: `chore: add concent candidate workflow skill`.
- Result: Added `.agents/skills/concent-candidate-workflow/SKILL.md` for
  candidate scope, protected production boundaries, agent selection,
  automated/manual confirmation separation, anti-overbuild decisions, and
  `GRADUATE` / `KEEP_CANDIDATE` / `ABANDON` reporting.
- Validation: YAML frontmatter and folder/name parity passed; the workflow
  delegates validation and Git without copying their command sequences.
  `$concent-godot-validation` quick validation passed: project parse,
  QuarterviewMain, and apartment-shell startup passed; Full GUT was correctly
  skipped and the known Phone PNG warning was reported once.
- Status: Apartment remains `KEEP_CANDIDATE` pending Godot-window visual
  confirmation and explicit production approval; no production wiring changed.

### CONCENT Safe Git Skill

- Commit message: `chore: add concent safe git skill`.
- Result: Added `.agents/skills/concent-safe-git/SKILL.md` for branch/upstream checks, validation delegation, explicit-path staging, staged-diff review, conventional commits, normal upstream pushes, and final hash/status reporting.
- Validation: Ruby YAML frontmatter and folder/name parity passed; validation delegation is present, forbidden Git operations appear only in the explicit `Never run` guardrail, and no Godot validation command is duplicated. The skill-creator Python validator could not run because `PyYAML` is unavailable and was not installed. `$concent-godot-validation` quick validation passed with Full GUT correctly skipped and the known Phone PNG warning reported once.
- Not changed: `$concent-godot-validation`, validator logic, game code, scenes, Resources, `project.godot`, addons, generated `.import`/`.uid`, or unrelated user files.

### CONCENT Godot validation Skill

- Commit message: `chore: add concent godot validation skill`.
- Result: Added the repository-local `.agents/skills/concent-godot-validation/SKILL.md` to select `--full` or `--quick` for the existing `scripts/validate_concent.sh` runner, inspect failures, and summarize results without duplicating validation logic or performing Git mutation.
- Validation: Ruby YAML frontmatter/name validation and the single-file repository Skill structure passed. The skill-creator Python validator could not run because `PyYAML` is unavailable and was not installed. `scripts/validate_concent.sh --quick` passed; Full GUT was correctly skipped and the known Phone PNG warning was reported once.
- Not changed: validator logic, game code, scenes, Resources, `project.godot`, addons, global skills, `agents/openai.yaml`, or `.import`/`.uid` files.

### Unified CONCENT validation script

- Commit message: `chore: add unified concent validation script`.
- Result: Added `scripts/validate_concent.sh` for Git-non-mutating diff checks, Godot parse, QuarterviewMain and apartment-shell startup, and Full GUT. It supports `--full`, `--quick`, `--godot-bin`, `GODOT_BIN`, and `--keep-logs`, with temporary logs outside the repository; normal Godot import metadata is reported rather than deleted.
- Validation: Passed `bash -n` on macOS Bash 3.2, help/invalid-argument checks, a subdirectory quick run, explicit `GODOT_BIN` and `--godot-bin` runs, keep-log preservation, and a Full run in 49 seconds. A fake Godot exit-7 check confirmed that later steps continue, the first failure code is returned, and failure logs are preserved. The known Phone PNG export warning remains reported but does not override process exit status.
- Not changed: game code, scenes, Resources, `project.godot`, addons/dependencies, assets, `.import`/`.uid` files, or Git state beyond this task's explicit script/document commit. Godot may still generate its normal local import metadata during validation.

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
