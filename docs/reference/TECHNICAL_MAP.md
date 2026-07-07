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
| Show wall IDs / start-end markers | Press `W` in the shell scene |
| Print wall inventory | Press `I` in the shell scene |
| Show floor cell coordinates | Press `G` in the shell scene |
| Show wall edge / vertex coordinates | Press `E` in the shell scene |
| Show navigation / collision debug | Press `N` in the shell scene |
| Highlight occlusion / revealable walls | Press `O` in the shell scene |
| Identify a floor cell under the mouse | Enable `G`, then hover a floor tile; click to print the cell and its four wall edges |
| Identify an exact wall edge under the mouse | Enable `E`, then hover near a floor edge; click to print the nearest wall edge `from_cell -> to_cell` |
| Identify navigation state for a floor cell | Enable `N`, then click a floor tile to print room area, walkable state, neighbors, and edge blockers |
| Move the shell-only navigation marker | Enable `N`, then use arrow keys to test movement through blocked / passable edges |
| Test room-area reveal walls | Set `debug_auto_reveal_walls=true`, enable `N`, and move the shell marker between room areas |
| Emphasize one wall | Set `debug_focus_wall_id`, e.g. `bathroom_left_wall`, in the Inspector |
| Preview revealable walls as full walls | Set `preview_revealed_walls=true` in the Inspector |

Wall inventory columns: `id`, `enabled`, `source`, `axis`, `edge_from_cell`, `edge_to_cell`, `length`, `wall_type`, `render_mode`, `current_state`, `doorway`, `reveal`, `logical`, `height_mode`, and `edit_hint`.

`edge_from_cell -> edge_to_cell` is the preferred way to read wall placement. The older `start_cell + axis + length` values still drive the data model, but the `E` wall-edge overlay is the quickest way to pick an exact wall segment. `G` is for floor cell centers and room footprint checks.

Floor cell coordinates and wall grid-line coordinates are related but not identical. A floor cell `(x,y)` spans to the next grid line, so its right outside wall is on `x+1`, and its front / lower outside wall is on `y+1`. For example, the outer right edge of floor cell `(10,9)` is wall grid line `x=11`, and its outer front edge is wall grid line `y=10`. Wall segments should be specified with grid-line `from_cell -> to_cell` coordinates, not the interior floor cell coordinate.

When `G` is enabled, clicking a floor cell prints all four edge coordinates:

- top edge: `(x,y) -> (x+1,y)`
- right edge: `(x+1,y) -> (x+1,y+1)`
- bottom edge: `(x,y+1) -> (x+1,y+1)`
- left edge: `(x,y) -> (x,y+1)`

When `E` is enabled, the shell displays wall grid-line vertices and the hover panel reports the nearest edge with `cell`, `edge`, `edge from`, `edge to`, and `axis`. Clicking prints the same nearest-edge information to the console.

When `N` is enabled, the shell displays walkable floor cells, room areas, logical blocked wall edges, passable doorway edges, and a shell-only debug marker. Walkable cells currently come from the visible living / work-power / bathroom floor cells, with future exception hooks in `_navigation_extra_walkable_cells()` and `_navigation_unwalkable_cells()`. Enabled wall segments create blocked edges; doorway units from `doorway_offset` / `doorway_width` are marked passable and excluded from blocked movement. `REVEALABLE`, `CUTAWAY_STUB`, and `HIDDEN_STUB` walls still count as logical blockers unless their edge is a doorway.

Navigation area ids are `living_area`, `work_power_area`, `bathroom`, and `entrance_area`. The shell-only marker starts at `player_debug_cell=(1,8)` by default. Arrow keys move the marker only when `N` is enabled; blocked wall edges and non-walkable target cells stop movement, while doorway edges allow passage.

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
- `test_room_object_definition.gd`
- `test_quarterview_job_definition.gd`
- `test_power_module_definition.gd`
- `test_power_board_candidate_state.gd`
- `test_hacking_action_state_machine.gd`
- `test_grid_credit_state.gd`
- `test_living_device_definition.gd`
- `test_asset_smoke.gd`

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

Targeted GUT examples:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_survival_state.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_power_board_candidate_state.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_room_object_definition.gd -gexit
```

## Git / Staging Rules

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
