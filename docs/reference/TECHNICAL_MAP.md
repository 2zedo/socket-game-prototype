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
| Show floor grid coordinates | Press `G` in the shell scene |
| Highlight occlusion / revealable walls | Press `O` in the shell scene |
| Identify a floor cell under the mouse | Enable `G`, then hover a floor tile; click to print the cell |
| Emphasize one wall | Set `debug_focus_wall_id`, e.g. `bathroom_left_wall`, in the Inspector |
| Preview revealable walls as full walls | Set `preview_revealed_walls=true` in the Inspector |

Wall inventory columns: `id`, `enabled`, `source`, `axis`, `from_cell`, `to_cell`, `length`, `wall_type`, `render_mode`, `doorway`, `reveal`, `logical`, `height_mode`, and `edit_hint`.

`from_cell -> to_cell` is the preferred way to read wall placement. The older `start_cell + axis + length` values still drive the data model, but the `G` floor-coordinate overlay is the quickest way to see which direction `+X` and `+Y` currently point after `map_rotation`.

`render_mode` separates logical wall existence from the current shell display. `FULL` draws a full-height wall. `CUTAWAY_STUB`, `HIDDEN_STUB`, and `REVEALABLE` keep the wall enabled in inventory while showing only a low cutaway / stub in this camera view. `REVEALABLE` walls draw a visible low body, top cap line, and base shadow by default; `preview_revealed_walls=true` temporarily draws them as full walls for inspection. `LOGICAL_ONLY` keeps the wall as data without drawing it.

Current bathroom shell wall IDs:

- `bathroom_wall`: shared bathroom / entrance boundary, `axis=A`, `from_cell=(0,7)`, `to_cell=(2,7)`
- `bathroom_right_wall`: bathroom doorway wall, `axis=B`, `from_cell=(2,4)`, `to_cell=(2,7)`, doorway `from_cell=(2,6)`, `to_cell=(2,7)`
- `entrance_inner_wall`: entrance inner wall, `axis=B`, `from_cell=(2,7)`, `to_cell=(2,9)`, doorway `from_cell=(2,8)`, `to_cell=(2,9)`
- `entrance_wall`: outer entrance wall, doorway `from_cell=(0,8)`, `to_cell=(0,9)`
- `bathroom_left_wall`: legacy disabled bathroom-left segment, `enabled=false`
- `living_occlusion_right_wall`: logical right-side occlusion wall, `from_cell=(10,4)`, `to_cell=(10,9)`, `render_mode=REVEALABLE`
- `living_occlusion_front_wall`: logical front occlusion wall, `from_cell=(0,9)`, `to_cell=(10,9)`, `render_mode=REVEALABLE`

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
