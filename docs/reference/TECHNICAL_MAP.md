# Technical Map

## Role

This is the current reference for important files, protected boundaries, validation commands, and repo navigation.

## Repo Layout

| Path | Purpose |
| --- | --- |
| `godot/` | Active Godot project |
| `godot/scenes/` | Production and candidate scenes |
| `godot/scripts/` | GDScript |
| `godot/resources/` | `.tres` gameplay / candidate data |
| `godot/test/unit/` | GUT unit tests |
| `docs/` | Active docs: game info, status, work log |
| `docs/reference/` | Current reference docs |
| `docs/old/` | Historical archived docs |
| `src/` | Legacy web prototype; do not edit unless explicitly requested |

## Active Docs

Root docs should stay small:

- `docs/GAME_INFO.md`
- `docs/PROJECT_STATUS.md`
- `docs/PROJECT_WORK_LOG.md`

Current reference docs:

- `docs/reference/WORLD.md`
- `docs/reference/STORY.md`
- `docs/reference/CHARACTERS.md`
- `docs/reference/GAME_RULES.md`
- `docs/reference/ROOM_OBJECTS.md`
- `docs/reference/ART_DIRECTION.md`
- `docs/reference/TECHNICAL_MAP.md`

## Protected Production Files

Do not modify by default:

- `godot/scenes/Main.tscn`
- `godot/scripts/Main.gd`
- `godot/scripts/Apartment.gd`
- `godot/scripts/Player.gd`
- `godot/scripts/SurvivalState.gd`
- `godot/scenes/ui/PhoneUI.tscn`
- `godot/scripts/ui/PhoneUI.gd`
- `godot/scenes/ui/OutletMode.tscn`
- `godot/scripts/ui/OutletMode.gd`
- `godot/scenes/ui/DayResultPanel.tscn`
- `godot/scripts/ui/DayResultPanel.gd`
- `godot/project.godot`

## Main Scenes

| Scene | Script | Status |
| --- | --- | --- |
| `godot/scenes/Main.tscn` | `godot/scripts/Main.gd` | protected golden path |
| `godot/scenes/Apartment.tscn` | `godot/scripts/Apartment.gd` | protected top-view room |
| `godot/scenes/QuarterviewMain.tscn` | `godot/scripts/QuarterviewMain.gd` | production candidate |
| `godot/scenes/quarterview/QuarterviewRoom.tscn` | `godot/scripts/quarterview/QuarterviewRoom.gd` | candidate room |
| `godot/scenes/quarterview/QuarterviewApartmentShellCandidate.tscn` | `godot/scripts/quarterview/QuarterviewApartmentShellCandidate.gd` | coordinate-based apartment shell candidate |
| `godot/scenes/Player.tscn` | `godot/scripts/Player.gd` | protected current Main player |

## Apartment Shell Candidate Editing

`QuarterviewApartmentShellCandidate` is a coordinate-based validation scene, not production wiring.

| Need | Where |
| --- | --- |
| Move or resize a default wall | Edit `_default_wall_segment_configs()` in `godot/scripts/quarterview/QuarterviewApartmentShellCandidate.gd` |
| Hide a default wall | Set that segment's `enabled=false` |
| Test custom wall layout in Inspector | Add `ApartmentWallSegmentConfig` items to `custom_wall_segments` |
| Move a wall | Change `start_cell` |
| Change wall direction | Change `axis` |
| Change wall length | Change `length` |
| Move the shared room door | Change `work_front_shared_wall` `doorway_offset` / `doorway_width` |
| Change how a wall is displayed | Change `render_mode` on the wall segment |
| Show wall IDs / start-end markers | Press `W` in the shell scene; labels prioritize Korean wall names with `id` as secondary info |
| Print wall inventory | Press `I` in the shell scene |
| Show floor cell coordinates | Press `G` in the shell scene; floor labels use `칸 (x,y)` |
| Show wall edge / vertex coordinates | Press `E` in the shell scene; wall labels use `벽선 from -> to` / `축=A/B` |
| Show navigation / collision debug | Press `N`; shows only movement cells, object-blocked cells, wall/door edges, the marker, current room, and a compact legend |
| Show object placement debug | Press `P`; shows projected floor/collision polygons and interaction markers, with one selected object's details in the fixed panel |
| Show room measurements / placement reference | Press `M`; shows simplified room bounds, placement zones, doorway clearance, required paths, and wall-mount availability |
| Open complete shell shortcut help | Press `F1`; press `F1` or `ESC` to close the Korean help panel |
| Open shell interaction debug menu | Press `J`; choose a mock object to test use / inspect / cancel panel flow |
| Open shell Phone debug overlay | Press `H`; switch mock Messages / Power / Jobs / Settings tabs |
| Close top shell debug UI | Press `ESC`; closes Phone, interaction detail/menu, full help, then the active M/P/N mode in priority order |
| Highlight occlusion / revealable walls | Press `O` in the shell scene; labels use `숨김벽` and Korean display-state text |
| Identify a floor cell under the mouse | Enable `G`, then hover a floor tile; click to print the cell and its four wall edges |
| Identify an exact wall edge under the mouse | Enable `E`, then hover near a floor edge; click to print the nearest wall edge `from_cell -> to_cell` |
| Identify navigation state for a floor cell | Enable `N`, then click a floor tile to print room area, walkable state, neighbors, and edge blockers |
| Move the shell-only navigation marker | Enable `N`, then use arrow keys to test movement through blocked / passable edges |
| Test room-area reveal walls | Set `debug_auto_reveal_walls=true`, enable `N`, and move the shell marker between room areas |
| Emphasize one wall | Set `debug_focus_wall_id`, e.g. `bathroom_left_wall`, in the Inspector |
| Preview revealable walls as full walls | Set `preview_revealed_walls=true` in the Inspector |

Wall inventory columns: `id`, `name_ko`, `enabled`, `source`, `axis`, `edge_from_cell`, `edge_to_cell`, `length`, `wall_type`, `render_mode`, `current_state`, `state_ko`, `doorway`, `doorway_ko`, `reveal`, `logical`, `height_mode`, and `edit_hint`.

Object layout summary columns, printed after `I`: `id`, Korean name, source, room, anchor, pixel offset, visual/collision/interaction pixel sizes and offsets, placement type, parent, wall ratio, occupied cells, movement blocking, interaction cells, and edit hint.

Room measurement summary is printed after the existing `I` inventories. It reports room floor bounds, cell dimensions, assigned floor cells, current walkable cells, advisory placement cells, screen-space pixel bounds, center coordinates, doorways, windows, walls, wall-mount availability, and current footprint warnings. `doorway_clearance_cells` and `main_path_clearance_cells` are Inspector-tunable review margins; they do not change collision or snap object art to tiles.

Current room-area boundaries follow the existing wall shell without moving geometry:

- `entrance_area`: floor cells inside `(0,7) -> (2,10)`, the left external-door entry compartment
- `bathroom`: floor cells inside `(0,4) -> (2,7)`, the small enclosed room beyond the internal doorway
- `living_area`: the remaining assigned cells inside the large `(0,4) -> (11,10)` living bounds
- `work_power_area`: floor cells inside `(1,0) -> (9,4)`

Measurement coordinate roles:

- floor cell: approximate floor position, room membership, movement, and placement-reference unit
- wall edge: grid-line boundary used by walls, doors, windows, and wall-mount spans
- screen pixel: final sprite dimensions, collision dimensions, and per-object position offsets
- placement area: advisory free space after doorway clearance, required movement paths, current footprints, and the no-large-object zone are excluded; it is not a tile-snap rule

Debug overlay language policy:

- Screen labels are Korean-first where practical.
- Internal ids remain visible as secondary edit references.
- No custom font asset is added; the shell relies on the current Godot/default project font stack for Korean rendering.

`edge_from_cell -> edge_to_cell` is the preferred way to read wall placement. The older `start_cell + axis + length` values still drive the data model, but the `E` wall-edge overlay is the quickest way to pick an exact wall segment. `G` is for floor cell centers and room footprint checks.

Floor cell coordinates and wall grid-line coordinates are related but not identical. A floor cell `(x,y)` spans to the next grid line, so its right outside wall is on `x+1`, and its front / lower outside wall is on `y+1`. For example, the outer right edge of floor cell `(10,9)` is wall grid line `x=11`, and its outer front edge is wall grid line `y=10`. Wall segments should be specified with grid-line `from_cell -> to_cell` coordinates, not the interior floor cell coordinate.

When `G` is enabled, clicking a floor cell prints all four edge coordinates:

- top edge: `(x,y) -> (x+1,y)`
- right edge: `(x+1,y) -> (x+1,y+1)`
- bottom edge: `(x,y+1) -> (x+1,y+1)`
- left edge: `(x,y) -> (x,y+1)`

When `E` is enabled, the shell displays wall grid-line vertices and the hover panel reports the nearest edge with `cell`, `edge`, `edge from`, `edge to`, and `axis`. Clicking prints the same nearest-edge information to the console.

`M`, `P`, and `N` are primary debug modes backed by `DebugMode.NONE`, `ROOM_MEASUREMENT`, `OBJECT_PLACEMENT`, and `NAVIGATION`. A normal key press replaces the previous primary mode; pressing the active key again returns to `NONE`. `Shift+M/P/N`, or `allow_combined_debug_overlays=true`, explicitly permits combined inspection while the default remains exclusive. Legacy `show_room_measurements`, `show_object_placeholders`, and `show_navigation_debug` exports remain load-compatible and are normalized into the active mode at startup.

Their render responsibilities are separated into `RoomMeasurementDebugLayer`, `ObjectPlacementDebugLayer`, `NavigationDebugLayer`, and `DebugSelectionLayer`. `DebugDetailPanel` shows only the current mode's room/object/navigation summary, and `DebugHelpPanel` owns the complete Korean shortcut list. The compact top help always shows the current mode, M/P/N, F1, and ESC.

When `N` is enabled, the shell displays walkable floor cells, room areas, object-blocked cells, logical blocked wall edges, passable doorway edges, and a shell-only debug marker. It continues to use the existing footprint collision/navigation data but does not display object names, ids, sizes, interaction data, parent data, or `ObjectPlacementDebugLayer`. Walkable cells currently come from the visible living / work-power / bathroom floor cells, with future exception hooks in `_navigation_extra_walkable_cells()` and `_navigation_unwalkable_cells()`. Enabled wall segments create blocked edges; doorway units from `doorway_offset` / `doorway_width` are marked passable and excluded from blocked movement. `REVEALABLE`, `CUTAWAY_STUB`, and `HIDDEN_STUB` walls still count as logical blockers unless their edge is a doorway.

Navigation area ids are `living_area`, `work_power_area`, `bathroom`, and `entrance_area`. The shell-only marker starts at `player_debug_cell=(1,8)` by default. Arrow keys move the marker only when `N` is enabled; blocked wall edges and non-walkable target cells stop movement, while doorway edges allow passage.

When `P` is enabled, floor footprints use the same rotated grid-to-screen projection as the apartment floor. Pixel collision dimensions are drawn as four-point floor-plane parallelograms: their sides follow the current rotated isometric axes while their authored `collision_size_px` side lengths and `collision_offset_px` screen vector remain unchanged. Interaction cells use separate yellow markers/areas. `visual_size_px` remains a screen-axis sprite bound and is drawn as a dashed rectangle only for the selected object when `show_object_visual_bounds` is enabled. `uses_floor_occupancy` decides whether an object receives floor/collision geometry; wall, ceiling, and non-floor parent attachments do not block `N`, while the parent-related UPS explicitly retains a floor collision.

Hovering or clicking in `P` selects the nearest matching object placeholder. The world shows only the short Korean name for the hovered/selected object. `DebugDetailPanel` shows one selected object's id, room, placement, anchor, offsets, visual/collision/interaction sizes, occupied and interaction cells, movement blocking, parent, and wall attachment.

Object footprint defaults now live in `godot/resources/quarterview/apartment_shell_object_footprints.tres`, assigned through `object_footprint_set` on `QuarterviewApartmentShellCandidate`. If that Resource is empty or unassigned, the script fallback `_default_object_footprint_configs()` still creates the same baseline. Add `ApartmentObjectFootprintConfig` Resources to `custom_object_footprints` in the Inspector for additive layout tests. The shell warns, without stopping scene load, when a footprint is outside base walkable cells, overlaps another footprint, blocks a doorway edge, or has an unusable interaction cell.

Object placement display options:

- `show_object_names=true` permits the hover/selected Korean short name; it does not restore persistent world detail labels.
- `show_object_floor_footprints=true`, `show_object_collision_shapes=true`, and `show_object_interaction_areas=true` control the three distinct P geometry categories.
- `show_object_visual_bounds=false` keeps screen-axis sprite bounds off by default; when enabled they remain selected-only.
- `show_object_parent_links=false` keeps parent leaders off by default and selected-only when enabled.
- Legacy object display exports remain available for scene compatibility, but they do not make P details appear in M or N.
- `I` prints each object's `source`: `resource`, `fallback`, or `custom`, plus an edit hint for the correct edit location.

Shell-only interaction UI:

- `J` opens a mock object menu for the current footprint ids plus portable `phone`.
- Selecting an item opens a candidate-only interaction panel with `사용하기`, `살펴보기`, and `취소`.
- The panel only writes mock text; it does not move Yui, mutate hunger / power / time, call production object logic, or save state.
- `H` opens a separate shell-only Phone overlay with mock tabs: `메시지`, `전력`, `의뢰`, and `설정`.
- The shell Phone overlay does not use production `PhoneUI` and intentionally avoids `SurvivalState`, save-load, job state, and production wiring.
- Phone and interaction panels are kept mutually exclusive; `ESC` closes the topmost shell debug UI.

`debug_auto_reveal_walls=false` keeps the existing shell view: `REVEALABLE` walls stay as low stubs. When `debug_auto_reveal_walls=true`, the shell marker's active room area can reveal a `REVEALABLE` wall if that wall has `reveal_when_area_active=true` and matching `reveal_area_id`. `preview_revealed_walls=true` still has priority and forces all `REVEALABLE` walls to full-wall preview regardless of active room. Example reveal areas: `reveal_area_id="living_area"` reveals while the marker is in the living space; `reveal_area_id="work_power_area"` would reveal while the marker is in the work / power room.

`render_mode` separates logical wall existence from the current shell display. `FULL` draws a full-height wall. `CUTAWAY_STUB`, `HIDDEN_STUB`, and `REVEALABLE` keep the wall enabled in inventory while showing only a low cutaway / stub in this camera view. `REVEALABLE` walls draw a visible low body, top cap line, and base shadow by default; `preview_revealed_walls=true` temporarily draws them as full walls for inspection. `LOGICAL_ONLY` keeps the wall as data without drawing it.

Current bathroom shell wall IDs:

- `bathroom_wall`: shared bathroom / entrance boundary, `axis=A`, `from_cell=(0,7)`, `to_cell=(2,7)`
- `bathroom_right_wall`: bathroom doorway wall, `axis=B`, `from_cell=(2,4)`, `to_cell=(2,7)`, doorway `from_cell=(2,6)`, `to_cell=(2,7)`
- `entrance_inner_wall`: entrance inner wall, `axis=B`, `from_cell=(2,7)`, `to_cell=(2,10)`, doorway `from_cell=(2,8)`, `to_cell=(2,9)`
- `entrance_wall`: outer entrance wall, doorway `from_cell=(0,8)`, `to_cell=(0,9)`
- `bathroom_left_wall`: legacy disabled bathroom-left segment, `enabled=false`
- `living_right_wall`: logical right-side outer wall, `from_cell=(11,4)`, `to_cell=(11,10)`, `render_mode=REVEALABLE`
- `living_front_cutaway`: logical front outer wall / cutaway, `from_cell=(0,10)`, `to_cell=(11,10)`, `render_mode=CUTAWAY_STUB`
- `living_occlusion_right_wall`: legacy disabled wrong-cell-coordinate segment, `from_cell=(10,4)`, `to_cell=(10,9)`, `enabled=false`
- `living_occlusion_front_wall`: legacy disabled wrong-cell-coordinate segment, `from_cell=(0,9)`, `to_cell=(10,9)`, `enabled=false`

Legacy service segments remain in the inventory as disabled entries:

- `service_wall`: `enabled=false`
- `service_right_wall`: `enabled=false`

Current shell object layout candidate IDs:

- Interaction: `entrance_door`, `bed`, `fridge`, `microwave`, `navi_link`, `power_module_board`, `node_17`
- Environment/decoration: `sink_counter`, `dining_table`, `signal_booster`, `ups_unit`, `bathroom_fixture`, `sea_horizon_poster`, `fluorescent_light`, `shoes_slippers`, `cable_bundle`, `wall_conduit`, `power_housing`
- Excluded from world footprints: portable `phone`, optional `air_conditioner`, and the retired desk/panel/connector placeholders

## Candidate UI Scripts

| Feature | File |
| --- | --- |
| Portable Phone candidate | `godot/scripts/ui/quarterview/PhoneScreenCandidate.gd` |
| Power board candidate | `godot/scripts/ui/quarterview/PowerBoardCandidate.gd` |
| Quarterview orchestration | `godot/scripts/QuarterviewMain.gd` |

## Resource Scripts

| Resource | File |
| --- | --- |
| DeviceDefinition | `godot/scripts/resources/DeviceDefinition.gd` |
| RoomObjectDefinition | `godot/scripts/resources/RoomObjectDefinition.gd` |
| QuarterviewJobDefinition | `godot/scripts/resources/QuarterviewJobDefinition.gd` |
| PowerModuleDefinition | `godot/scripts/resources/PowerModuleDefinition.gd` |
| HackingMissionDefinition | `godot/scripts/resources/HackingMissionDefinition.gd` |
| LivingDeviceDefinition | `godot/scripts/resources/LivingDeviceDefinition.gd` |
| GridCreditState | `godot/scripts/systems/GridCreditState.gd` |
| ApartmentObjectFootprintConfig | `godot/scripts/quarterview/ApartmentObjectFootprintConfig.gd` |
| ApartmentObjectFootprintSetConfig | `godot/scripts/quarterview/ApartmentObjectFootprintSetConfig.gd` |

## Prototype Scenes

| Scene | Purpose |
| --- | --- |
| `godot/scenes/prototypes/PrototypeHub.tscn` | Prototype menu |
| `godot/scenes/prototypes/QuarterviewGameplaySandbox.tscn` | Sandbox-only room/UI/state flow |
| `godot/scenes/prototypes/QuarterviewRoomPrototype.tscn` | Object / interaction contract prototype |
| `godot/scenes/prototypes/QuarterviewPerspectiveBlockout.tscn` | Quarterview perspective blockout |
| `godot/scenes/prototypes/QuarterviewRoomShellPrototype.tscn` | Room shell layer path / missing check |
| `godot/scenes/prototypes/HackingActionPrototype.tscn` | Hacking action state / control prototype |
| `godot/scenes/prototypes/HackingPerspectiveBlockout.tscn` | Hacking perspective blockout |
| `godot/scenes/prototypes/quarterview/WorkDevicesAtlasPreview.tscn` | Work device atlas preview |

## Tests

Unit tests live in `godot/test/unit/`.

Current important tests:

- `test_survival_state.gd`
- `test_room_scene_contract.gd`
- `test_quarterview_room_interaction_flow.gd`
- `test_quarterview_main_candidate_flow.gd`
- `test_quarterview_candidate_dependencies.gd`
- `test_room_object_definition.gd`
- `test_quarterview_job_definition.gd`
- `test_power_module_definition.gd`
- `test_power_board_candidate_state.gd`
- `test_hacking_action_state_machine.gd`
- `test_grid_credit_state.gd`
- `test_living_device_definition.gd`
- `test_asset_smoke.gd`
- `test_apartment_object_layout_candidate.gd`

The Quarterview candidate regression tests keep movement completion deterministic: they test object selection, pending focus, cancellation/replacement, and the arrival gate without waiting on long physics movement. Main candidate tests instantiate the real scene and cover panel/modal routing, room input lock restoration, close/ESC/backdrop paths, and portable Phone gating. The dependency boundary test recursively inspects candidate Resource dependencies and executable reference patterns while leaving production-wide autoload policy outside candidate ownership.

## Third-Party Asset Inventory

The current asset smoke test reads this section instead of the archived `docs/old/THIRD_PARTY_ASSET_INVENTORY.md`. Root `docs/` stays limited to `GAME_INFO.md`, `PROJECT_STATUS.md`, and `PROJECT_WORK_LOG.md`.

This inventory tracks selected copies that are actually present under `godot/assets/.../third_party/...`. Broad Asset Library addon folders, generated `.uid` files, and unrelated local addon installs remain outside the current commit scope unless a dedicated vendor-assets task says otherwise.

| Asset Group | Selected Copies | License Evidence | Current Use | Notes |
| --- | --- | --- | --- | --- |
| Kenney UI Audio | selected copies under `godot/assets/audio/third_party/kenney/ui/`: `ui_select.wav`, `ui_confirm.wav` | `godot/assets/audio/third_party/kenney/LICENSES/kenney_ui_audio_LICENSE.txt` | Prototype UI select / confirm SFX smoke-tested as `AudioStreamWAV` | Source addon folder is not a required committed source for the smoke test. |
| Kenney Interface Sounds | selected copies under `godot/assets/audio/third_party/kenney/interface/`: `prototype_open.wav`, `prototype_cancel.wav`, `hacking_hit.wav`, `hacking_damage.wav`, `hacking_success.wav`, `hacking_fail.wav` | `godot/assets/audio/third_party/kenney/LICENSES/kenney_interface_sounds_LICENSE.txt` | Prototype overlay / hacking feedback SFX smoke-tested as `AudioStreamWAV` | Only the selected copied asset paths are required for current tests. |
| Kenney Input Prompts | selected copies under `godot/assets/ui/third_party/kenney/input_prompts/`: `key_a.png`, `key_arrows.png`, `key_b.png`, `key_backspace.png`, `key_d.png`, `key_e.png`, `key_enter.png`, `key_escape.png`, `key_j.png`, `key_r.png`, `key_s.png`, `key_shift.png`, `key_space.png`, `key_w.png`, `mouse_left.png` | `godot/assets/ui/third_party/kenney/LICENSES/kenney_input_prompts_LICENSE.txt` | Prototype prompt icons smoke-tested as `Texture2D` | Keep these as selected copies; do not point tests at raw addon source folders. |

## Validation Commands

Godot project parse:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --quit-after 2
```

QuarterviewMain startup:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/QuarterviewMain.tscn --quit-after 2
```

Apartment shell candidate startup:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/quarterview/QuarterviewApartmentShellCandidate.tscn --quit-after 2
```

Full GUT:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
```

### Unified Validation Script

Run `scripts/validate_concent.sh` from any directory to execute the current Git checks, Godot project parse, QuarterviewMain and apartment-shell startup checks, and the Full GUT runner without issuing Git mutation commands.

Codex should use the repository Skill at `.agents/skills/concent-godot-validation/SKILL.md` to choose `--full` or `--quick`; invoke it explicitly as `$concent-godot-validation` when needed.

### Candidate Workflow

`.agents/skills/concent-candidate-workflow/SKILL.md` defines the CONCENT-only
candidate decision, protected-production boundary, automated/manual completion
criteria, and `GRADUATE` / `KEEP_CANDIDATE` / `ABANDON` decision. It delegates
validation to `$concent-godot-validation` and selective Git completion to
`$concent-safe-git`; it does not wire a candidate into production.

```bash
scripts/validate_concent.sh --full
scripts/validate_concent.sh --quick
GODOT_BIN=/Applications/Godot.app/Contents/MacOS/Godot scripts/validate_concent.sh --full
scripts/validate_concent.sh --godot-bin /Applications/Godot.app/Contents/MacOS/Godot --keep-logs
```

- `--full` is the default and includes Full GUT; `--quick` skips only Full GUT.
- Godot lookup order is `--godot-bin`, `GODOT_BIN`, `godot`/`godot4` on `PATH`, then the macOS app path above.
- Logs are created outside the repository and are removed after a successful run unless `--keep-logs` is supplied. Failed runs preserve their logs.
- The script only reports Git status; it never stages, commits, pushes, cleans, restores, or deletes repository files. Godot may still generate its normal `.import`, `.uid`, or `.godot` metadata, which the final Git-status comparison reports.
- The known Phone PNG direct-load export warning may appear during QuarterviewMain startup. Exit status remains authoritative; the script reports the known warning separately and counts other warning/error markers without filtering failures.

Targeted GUT examples:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_survival_state.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_power_board_candidate_state.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_room_object_definition.gd -gexit
```

## Git / Staging Rules

Codex should use the repository Skill at `.agents/skills/concent-safe-git/SKILL.md` for explicit-path staging, reviewed commit creation, normal upstream push, and final hash/status reporting. Invoke it explicitly as `$concent-safe-git`; it delegates Godot checks to `$concent-godot-validation` rather than duplicating validation commands.

- Work on `main` unless user asks otherwise.
- Before work:

```bash
git status --short --branch
git rev-parse --short HEAD
git fetch origin
git log --oneline HEAD..origin/main
```

- If `origin/main` has commits, stop and report.
- Never use `git add .`.
- Stage only files changed for the current task.
- Do not stage unrelated `godot/addons/*`, `.uid`, `.import`, license files, generated caches, or `godot/.godot/`.
- Force push is forbidden.

Known current caveat:

- Full `git diff --check` may fail on unrelated `godot/addons/godot_ai/handlers/texture_handler.gd` EOF whitespace if that unrelated local change remains. Do not fix it unless explicitly tasked.

## Documentation Rotation

- `PROJECT_STATUS.md` and `PROJECT_WORK_LOG.md` are active progress docs.
- When either grows beyond about 200 lines, move it to `docs/old/<NAME>_<YYYYMMDD>_<NN>.md` and recreate a short active file.
- Do not rotate `GAME_INFO.md` or reference docs by default.
