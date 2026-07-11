# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Active engine: Godot project under `godot/`
- Active branch: `main`
- Current docs entry: `docs/GAME_INFO.md`
- Current reference docs: `docs/reference/*.md`
- Historical docs: `docs/old/`
- Production golden path: existing `Main.tscn` / DAY1 top-view flow
- Current candidate path: `QuarterviewMain.tscn`

## Current State

- Root `docs/` has been reduced to the active docs set: `GAME_INFO.md`, `PROJECT_STATUS.md`, and `PROJECT_WORK_LOG.md`.
- Current design, story, rule, art, room-object, and technical references live under `docs/reference/`.
- Previous root-level design and migration documents are archived under `docs/old/`.
- `Main.tscn` / DAY1 remains protected and is not replaced by this documentation cleanup.
- `QuarterviewMain` remains a production candidate scene, not the project start scene.
- `QuarterviewApartmentShellCandidate` is an independent coordinate-based shell scene for validating the two-room apartment layout before final art.
- QuarterviewMain candidate features are local/mock unless explicitly wired later:
  - click movement and hover affordance
  - portable Phone opened with `P`
  - job candidate acceptance
  - Desk / Laptop, Power Board, Bed, Food / Kitchen, Door, Day Result, and Hacking Entry candidate overlays
  - local mock HUD and local candidate state
- Production `SurvivalState`, `PhoneUI`, `OutletMode`, `DayResultPanel`, save-load, Grid Credit, story flags, and Hacking scene transitions remain unwired from QuarterviewMain.

## Latest Work

- The ROTATE_90 candidate interaction pass now uses the authored access cells directly for bed, fridge, microwave, NAVI LINK, and NODE-17 instead of applying their retired pixel offsets a second time. Their anchors, placements, cells, sizes, and seven-object interaction inventory remain unchanged; targeted geometry checks require each area to touch the owned collision or microwave's parent counter. Godot MCP P+V hover/click confirmation passed for all five. Status: `KEEP_CANDIDATE`; Manual confirmation: `REQUIRED` for user acceptance before any production promotion.
- The Apartment shell now fixes direct interaction to seven world objects and rejects interaction geometry on the other eleven footprints. P debug selection ranks interaction and physical geometry ahead of wall/parent anchors and ceiling/environment visuals, cycles overlapping candidates with `선택 n/m`, and composites effectively identical floor/collision faces. Coordinates remain unchanged. Status: `KEEP_CANDIDATE`; Manual confirmation: `REQUIRED` for final P readability and production approval.
- The rotated-floorplan second placement pass moves the kitchen line to the living side of the shared wall (`sink_counter (3,4)`, `fridge (5,4)`, microwave parented at `(3,4)`) and moves the Power Board/Housing to the work back wall while keeping the already-aligned bed, dining table, NAVI, NODE-17, bathroom fixture, and entrance door candidates. V now ghosts all candidate wall/door/window visuals instead of only the living occlusion strips. Status: `KEEP_CANDIDATE`; Manual confirmation: `REQUIRED` for final art-scale offsets.
- `QuarterviewApartmentShellCandidate` object placement pass 1 now separates `FLOOR`, `WALL_EDGE`, `CEILING`, and `PARENT_OBJECT` anchors from interaction/environment/decoration categories. P has a dedicated legend and selected-bound emphasis, V provides visual-only occlusion-wall transparency, and bed/table placement was adjusted while placement/measurement warnings remain zero. Status: `KEEP_CANDIDATE`; Manual confirmation: `REQUIRED` for final floorplan alignment and overlay readability.
- Fixed the candidate script's duplicate local variable parse error without changing placement behavior, and hardened `scripts/validate_concent.sh` so `Parse Error` or `Failed to load script` fails a Godot step even when the engine process exits 0. The known Phone PNG warning remains warning-only.
- Added `$concent-docs-sync` for minimal documentation synchronization after
  CONCENT implementation, design, or technical-structure changes. It selects a
  current reference source of truth and keeps summaries, current status, work
  history, and archive rotation distinct.
- Added `$concent-candidate-workflow` for candidate scope, production boundary,
  validation/manual-confirmation split, and graduation decisions. The Apartment
  candidate remains `KEEP_CANDIDATE`: automated placement checks are complete,
  but Godot-window visual confirmation and explicit production approval remain.
- Added the repository-local `$concent-safe-git` Skill for validated, explicit-path staging, reviewed commits, and normal upstream pushes while excluding unrelated changes and generated Godot metadata.
- Added the repository-local `$concent-godot-validation` Skill, which selects the existing CONCENT validator's full or quick mode and reports results without replacing validation logic or performing Git mutation.
- Added `scripts/validate_concent.sh`, a unified validation wrapper that issues no Git mutation commands while running Git diff checks, Godot project parse, QuarterviewMain and apartment-shell startup, and optional Full GUT. It resolves Godot safely from an explicit argument, `GODOT_BIN`, PATH, or the macOS app path and keeps logs outside the repository; normal Godot import metadata remains reported rather than deleted.
- Added and refined `QuarterviewApartmentShellCandidate` as a coordinate-based Godot scene under `godot/scenes/quarterview/`.
- The scene draws the apartment shell with placeholder floor tiles, Axis A/B walls, wall caps, baseboards, door/window placeholders, debug labels, camera presets, and a foreground no-large-object zone.
- Wall segments are now editable through named `ApartmentWallSegmentConfig` entries, with `W` for wall ID markers and `I` for a console wall inventory / edit-hint table.
- The former service area remains removed; room-area debug now separates the external-door entry at `(0,7)->(2,10)` from the bathroom at `(0,4)->(2,7)`, while legacy service wall segments remain disabled for reference.
- Floor grid coordinate debugging is available with `G`, including tile labels, origin / axis markers, hover cell display, click-to-print cell output, and `from_cell -> to_cell` wall inventory.
- Wall edge coordinate debugging is available with `E`, separating wall grid-line / vertex coordinates from floor cell coordinates; `G` click output now prints a cell's four wall edges, and `E` click output prints the nearest edge `from/to` pair.
- Bathroom / entrance shell walls now follow the specified grid-line coordinates: bathroom boundary `(0,7)->(2,7)`, bathroom doorway wall `(2,4)->(2,7)`, entrance inner wall `(2,7)->(2,10)`, and entrance doorway `(0,8)->(0,9)`.
- Wall segments now separate logical existence from display mode; living front/right occlusion walls are enabled logical walls but render as clearer low revealable stubs with body/cap/shadow in the current shell view.
- Living occlusion display now uses the actual outer grid-line walls: `living_right_wall` at `(11,4)->(11,10)` and `living_front_cutaway` at `(0,10)->(11,10)`; earlier one-cell-inward occlusion wall segments remain disabled as legacy references.
- Occlusion wall debugging is available with `O`, and `preview_revealed_walls` can temporarily show revealable walls at full height for shell inspection.
- `M`, `P`, and `N` now use one exclusive primary debug mode by default; the active key returns to no primary mode, while `Shift` or the opt-in Inspector combined setting can add overlays deliberately.
- Navigation / collision debugging is available with `N`, showing only walkable/non-walkable and object-blocked cells, room areas, blocked wall edges, passable doorway edges, and a shell-only marker at `player_debug_cell` without object placement labels.
- Room-area reveal debugging is available through `debug_auto_reveal_walls`; the shell marker's active room can switch matching `REVEALABLE` walls between stub and full-wall display without production character wiring.
- Object placement debugging is available with `P`; its dedicated legend separates visual, occupancy, collision, interaction, and wall/parent attachment ranges, while hover/click exposes the readable anchor reference and strengthens the selected bounds.
- Object footprint defaults now use explicit anchor types. Bed moved to `(9,6)` with access at `(8,7)`, the dining table moved to `(4,7)`, and wall/parent objects resolve from their real attachment reference instead of a fake floor center.
- Object footprint defaults are now Resource-backed through `godot/resources/quarterview/apartment_shell_object_footprints.tres`, with script fallback and additive Inspector custom entries preserved.
- Shell-only interaction UI is available with `J`, and shell-only Phone debug overlay is available with `H`; both are mock overlays and do not call production object / Phone systems.
- Room measurement debugging is available with `M`; its world layer is limited to room areas/bounds/names, placement and no-large zones, doorway clearance, required paths, and wall-mount availability, while numeric summaries stay in the fixed panel.
- The compact top hint identifies the ROTATE_90 review view, active M/P/N mode, and V wall-inspection state; `F1` opens the complete Korean shortcut panel without overriding J/H modal priority.
- Apartment shell debug overlays are now Korean-first for screen labels: `G` shows `칸`, `E` shows `벽선`, `W` shows Korean wall names plus ids, `N` shows movement/collision states, `P` shows Korean object names, and `O` labels hidden / revealable walls.
- Third-party selected asset inventory is now tracked in `docs/reference/TECHNICAL_MAP.md`, and `test_asset_smoke.gd` reads that current reference location instead of the archived old root document path.
- Quarterview candidate regression coverage now fixes the deterministic object-click/pending-focus/arrival signal flow, panel and modal routing, input-lock restoration, portable Phone gating, and executable dependency boundary without changing candidate gameplay code.
- Apartment shell object data still uses the 18-object rotated-floorplan candidate with unchanged pixel visual/collision/interaction sizes. Category/anchor semantics, selected display, and layout passes remain candidate-only pending manual visual review.
- It is independent and is not wired into `QuarterviewMain`, production `Main`, `SurvivalState`, or `project.godot`.
- Documentation now records the shell candidate path, coordinate basis, wall editing controls, navigation / reveal / object footprint overlay controls, and validation command.

## Validation Notes

- This change intentionally adds candidate-only shell scripts and documentation.
- It uses generated geometry only; no image assets, imports, atlas resources, or production start scene wiring are added.
- Full `git diff --check` may still report unrelated local whitespace in `godot/addons/godot_ai/handlers/texture_handler.gd`; targeted checks should be used for current-task files if that unrelated file remains dirty.

## Next Recommended Work

1. Open `QuarterviewApartmentShellCandidate.tscn` in Godot and check whether the shared wall, internal door, foreground no-large-object zone, and camera presets match the intended floor plan.
2. Adjust only the shell coordinates until the two-room structure is stable.
3. After the shell is accepted, use it as the basis for floor/wall/door atlas replacement or final room art passes.
