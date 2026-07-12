# Project Work Log

## Purpose

This short active log tracks the newest completed work for `CONCENT / 전력 부족의 시대`.

Long history is archived in `docs/old/`. When this file grows past about 200 lines, rotate it into `docs/old/PROJECT_WORK_LOG_<YYYYMMDD>_<NN>.md` and recreate a short active log.

## Current Log

### Apartment direct-interaction Node migration stage 2

- Result: Migrated bed, NODE-17, and entrance door into the existing 2.5D editable Scene-node contract. All seven direct-interaction objects now use `SCENE_NODE` geometry; the other eleven environment objects remain Resource-backed.
- Contracts: Bed/NODE-17 derive movement and floor occupancy from BodyPolygon. NODE-17's Resource-backed signal booster and cable bundle follow AttachmentSocket. Entrance Door is parented to `EntranceWallParentAnchor`; its BodyPolygon blocks only the doorway edge while closed, disables while open, and never becomes floor occupancy.
- MCP check: Inspected the complete Scene tree and Korean descriptions, added/moved/restored polygon points and independent Selection/Interaction/Use positions, verified NODE-17 socket child following and door closed/open navigation, then ran P+V with zero placement/measurement warnings. Status: `KEEP_CANDIDATE`; Manual confirmation: `REQUIRED` before production wiring.

### Apartment editable object 2.5D reference and selection split

- Result: Added BasePoint, TopPoint, and debug-only SelectionArea/SelectionPolygon to fridge, NAVI LINK, microwave, and Power Board. Body remains movement collision/floor occupancy, Selection owns P hover/click, Interaction owns game-use range, UsePoint owns the access position, Visual owns screen bounds, and AttachmentSocket owns child/wall attachment.
- P debug: Added cyan SelectionPolygon, green BasePoint, yellow TopPoint/height guide, and SCENE_NODE detail fields without duplicating equivalent Body/floor faces. PlacementFootprint remains optional and absent; the other fourteen objects retain Resource/fallback geometry.
- MCP check: Restarted the editor to clear a stale PackedScene cache, confirmed the 59-node hierarchy and Korean Inspector descriptions, edited/restored BasePoint, TopPoint, UsePoint, and a five-point NAVI SelectionPolygon, ran P+V, and verified Selection/Interaction/Use independence plus Microwave/Board parent-follow. Fresh game/editor errors and placement/measurement warnings were zero. Status: `KEEP_CANDIDATE`; Manual confirmation: `REQUIRED` for user Inspector fine tuning.

### Apartment editable object common structure cleanup

- Result: Replaced the stage-1 VisualAnchor/mixed-shape contract with `Visual/Sprite2D/VisualPreview`, named BodyPolygon and InteractionPolygon nodes, independent UsePoint, and AttachmentSocket for fridge, NAVI LINK, microwave, and Power Board. Microwave/Board remain non-blocking and have no BodyPolygon; no current object gained PlacementFootprint.
- Ownership: Sprite texture or VisualPreview supplies visual bounds only, BodyPolygon supplies collision and floor occupancy, InteractionPolygon supplies click/use detection, and UsePoint supplies access position. Migrated Resource geometry remains disabled; the other fourteen objects remain Resource-backed.
- MCP check: Godot MCP moved and added polygon vertices, separated InteractionArea and UsePoint edits, moved both parent anchors, verified the running P view, then restored and reloaded every test value. Status: `KEEP_CANDIDATE`; Manual confirmation: `REQUIRED` for user Inspector tuning.

### Apartment editable object Node migration stage 1

- Result: Added a common editable object Scene/Script and migrated fridge, NAVI LINK, Power Board, and microwave to real ObjectRoot/VisualAnchor/Body/InteractionArea/UsePoint/Socket nodes in the candidate Scene. Fridge uses RectangleShape2D Body collision, NAVI uses editable CollisionPolygon2D, and all four use editable interaction polygons.
- Ownership: Exact ROTATE_90 transforms and pixel geometry now come from Scene nodes; the four Resource/fallback entries retain logical metadata only. The other fourteen objects keep the legacy Resource path. P hover/click/detail, Node-backed N blocking, measurement access cells, and wall/parent following use resolved Node data.
- MCP check: Godot MCP inspected every hierarchy/property path, then moved a Shape, Polygon, UsePoint, and both ParentAnchors. The running P+V view and evaluated geometry followed each edit; test values were restored and saved to the original positions.
- Status: `KEEP_CANDIDATE`. Manual confirmation: `REQUIRED` for user Inspector tuning and approval before more objects migrate. Production Main/DAY1/Apartment/SurvivalState, `project.godot`, and generated metadata remain unchanged.

### Apartment interaction position alignment

- Result: Removed legacy pixel offsets from bed, fridge, microwave, NAVI LINK, and NODE-17 interaction geometry. Their existing access cells already represented the usable adjacent floor positions, so adding the offsets during draw/hit/detail calculations displaced the orange areas a second time.
- Layout: Kept all object anchors and placements unchanged because the kitchen line, right-side bed, and work-room NAVI/NODE positions already match the latest rotated floorplan. Interaction cells and sizes also remain unchanged; only the five offsets are now `(0,0)` in both Resource and fallback data.
- Visual check: Godot MCP ran the candidate in ROTATE_90 with P+V. Direct hover/click selected each of the five through its interaction hit, detail cells matched the Resource, and the fresh editor/game log window contained no errors.
- Validation: Candidate regression coverage now requires each corrected interaction area to touch its object collision or, for microwave, its parent sink-counter collision. Status: `KEEP_CANDIDATE`; Manual confirmation: `REQUIRED` for user acceptance. Production files, camera, project settings, interaction inventory, and generated metadata remain unchanged.

### Apartment interaction contract and overlap selection

- Commit message: `fix: align apartment interaction debug with object spec`.
- Result: Fixed direct world interaction to seven objects, removed gameplay interaction geometry from the other eleven, recorded the entrance door's closed-state wall blocking without adding floor occupancy, and kept every placement coordinate unchanged.
- P debug: Added interaction/floor-collision/attachment/visual hit priority, repeated-click `선택 n/m` cycling, interaction-owner hover text, selected-only visual bounds, and blue-fill/red-outline composition for effectively identical floor/collision surfaces.
- Visual check: Godot MCP reproduced the fluorescent-light overlap before the change, then confirmed the ranked `fridge 1/3 → microwave 2/3 → fluorescent_light 3/3` cycle, no fluorescent interaction nodes, composite fridge geometry, and zero new editor/game errors.
- Validation: Candidate GUT `28/28` with 1,093 assertions; full validator PASS in `00:02:20`, placement/measurement warnings and other warnings zero, known Phone PNG warning 32 only.
- Status: `KEEP_CANDIDATE`. Manual confirmation: `REQUIRED` for click-cycle feel and production approval; production files, scene geometry, camera, Excel, and generated metadata remain unchanged.

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
