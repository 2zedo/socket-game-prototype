# Hack Arena Tiles Atlas Region Mapping

## Purpose

This document defines future region mapping rules for `hack_arena_tiles_atlas.png`.

The atlas is a candidate for cyber arena tile bodies used by hacking action missions: floor, wall, obstacle, hazard base, objective base, exit base, and spawn markers. It is not imported into Godot yet and is not connected to `HackingActionPrototype`, `HackingPerspectiveBlockout`, Main, or DAY 1.

Coordinates stay `TBD` until the actual PNG exists.

## Atlas File

Future atlas file:

```text
hack_arena_tiles_atlas.png
```

Expected future Godot path:

```text
res://assets/hacking/arena/atlases/hack_arena_tiles_atlas.png
```

Source / reference candidates:

```text
res://assets/hacking/arena/atlases/source/
res://assets/hacking/arena/atlases/reference/
```

Format criteria:

- PNG
- RGBA / transparent background possible
- cyber arena tile body only
- no player sprite
- no enemy sprite
- no projectile sprite
- no UI panel
- no full-room quarterview background
- no quarterview room furniture / appliance / work-device sprites
- no screen-wide FX overlay
- tile regions may be arranged as a fixed-size grid
- region names and collision / hazard hints are documented separately

This task does not create the folders, PNG, TileSet, TileMapLayer, or any mapping file.

## Arena Tile Role

`hack_arena_tiles_atlas.png` owns visual tile bodies for the hacking mission space.

Includes:

- floor tiles
- wall / boundary tiles
- low obstacles
- cover / blocked tiles
- hazard zone base tiles
- objective / exit marker base visuals
- network / grid cyber arena base structure

Excludes:

- player character
- enemy character
- projectile
- hit / damage FX
- full-screen glitch
- UI
- quarterview room shell
- room objects such as laptop, phone, or NODE-17

## Viewpoint Criteria

Hacking missions are cyber / network infiltration spaces, not fantasy dungeons.

Current prototype roles:

- `HackingActionPrototype` is the control / state / objective prototype.
- `HackingPerspectiveBlockout` is the `3/4 top-down cyber action view` perspective prototype.
- `hack_arena_tiles_atlas.png` is a future visual tile body atlas candidate.

The long-term target is not a pure top-down crown view. Hacking arena tiles should support a slight `3/4 top-down` depth cue while keeping collision and navigation data separate from visual perspective.

This document does not change the actual prototype camera or scene.

## Tile Size And Grid

Tile size candidates:

```text
64x64
96x96
128x128
```

Criteria:

- MVP prototype can start from `64x64` or `96x96`.
- `96x96` or `128x128` may better support `3/4` depth.
- Final size depends on player / enemy scale, arena readability, target display size, and camera zoom.
- Default candidate: `96x96`.
- Final tile size is not locked until `HackingPerspectiveBlockout` and player scale are validated.
- `hack_avatar` spritesheets must be validated against tile size, camera zoom, and player-layer readability before gameplay wiring.
- `hack_enemies_atlas.png` must be validated against arena tile scale, obstacle readability, and z-index layering before gameplay wiring.
- `hack_arena_tiles_atlas.png` should provide arena structure and base markers, while interactive objective / device bodies should live in `hack_objects_atlas.png`.

Atlas size formula:

```text
atlas_width = tile_width * columns
atlas_height = tile_height * rows
```

## Tile Region Key Naming

Region keys use lowercase `snake_case`.

Rules:

- category + shape / state
- no temporary number-only keys
- no `final`, `new`, or `tmp`
- collision / hazard meaning should be clear when relevant

Good examples:

```text
floor_base
floor_grid
floor_data_line
wall_solid
wall_edge_north
wall_edge_south
wall_corner_ne
wall_corner_nw
barrier_low
obstacle_server_block
obstacle_node_block
hazard_trace_zone
hazard_firewall_zone
objective_data_core
exit_gate_closed
exit_gate_open
spawn_marker
cover_panel
cracked_tile
warning_floor
```

Bad examples:

```text
tile1
item_001
map2_final_new
tmp_wall
image_05
object_a
```

Suffix candidates:

```text
_base
_grid
_line
_solid
_edge
_corner
_open
_closed
_active
_inactive
_warning
_damaged
_blocked
_safe
_hazard
```

## Tile Categories

Category candidates:

```text
floor
wall
edge
corner
obstacle
cover
hazard
objective
exit
spawn
decoration
debug_marker
```

Examples:

| Tile Key | Category |
| --- | --- |
| `floor_base` | `floor` |
| `floor_data_line` | `floor` |
| `wall_solid` | `wall` |
| `wall_corner_ne` | `corner` |
| `barrier_low` | `obstacle` |
| `cover_panel` | `cover` |
| `hazard_trace_zone` | `hazard` |
| `objective_data_core` | `objective` |
| `exit_gate_closed` | `exit` |
| `spawn_marker` | `spawn` |
| `cracked_tile` | `decoration` |

## Region Mapping Schema

Future mapping should describe visual regions plus gameplay hints. These fields are candidates only.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `tile_key` | `String` | tile region identifier | `floor_base` |
| `atlas_path` | `String` | atlas PNG path | `res://assets/hacking/arena/atlases/hack_arena_tiles_atlas.png` |
| `rect_x` | `int` | region start x in atlas | `TBD` |
| `rect_y` | `int` | region start y in atlas | `TBD` |
| `rect_w` | `int` | region width | `TBD` |
| `rect_h` | `int` | region height | `TBD` |
| `tile_width` | `int` | logical tile width | `96` |
| `tile_height` | `int` | logical tile height | `96` |
| `category` | `String` | tile category | `floor` |
| `visual_state` | `String` | display state | `base` |
| `collision_type` | `String` | collision hint | `none` |
| `navigation_type` | `String` | navigation hint | `walkable` |
| `hazard_type` | `String` | hazard hint | `none` |
| `objective_type` | `String` | objective hint | `none` |
| `mission_tag` | `String` | mission link candidate | `data_extract` |
| `default_z_index` | `int` | default z-index | `0` |
| `y_sort_hint` | `String` | y-sort hint | `static_floor` |
| `autotile_group` | `String` | autotile candidate | `floor_grid` |
| `edge_mask` | `String` | edge / corner candidate | `none` |
| `blend_mode` | `String` | blend candidate | `normal` |
| `notes` | `String` | notes | `candidate only` |

This document does not create a JSON, CSV, `.tres`, TileSet, or TileMap file.

## Collision And Navigation

`collision_type` candidates:

```text
none
solid
low_blocker
cover
trigger
hazard_only
objective_trigger
exit_trigger
spawn_only
```

`navigation_type` candidates:

```text
walkable
blocked
slow
hazard_walkable
trigger_only
decoration_only
```

Examples:

| Tile Key | Collision Type | Navigation Type |
| --- | --- | --- |
| `floor_base` | `none` | `walkable` |
| `wall_solid` | `solid` | `blocked` |
| `barrier_low` | `low_blocker` | `blocked` or `cover` |
| `hazard_trace_zone` | `hazard_only` | `hazard_walkable` |
| `objective_data_core` | `objective_trigger` | `trigger_only` |
| `exit_gate_open` | `exit_trigger` | `trigger_only` |

Visual tile and collision shape do not need to be 1:1. Final collision can be handled through TileSet physics layers or separate `Area2D` / `CollisionShape2D` nodes.

## Hazard And Objective Hints

`hazard_type` candidates:

```text
none
trace
firewall
corruption
alarm
slow_zone
damage_zone
detection_zone
```

`objective_type` candidates:

```text
none
extract_data
disable_node
reach_exit
survive_timer
trace_signal
unlock_gate
```

Examples:

| Tile Key | Hazard Type | Objective Type | Trigger Hint |
| --- | --- | --- | --- |
| `hazard_trace_zone` | `trace` | `none` | `trace_increase` |
| `hazard_firewall_zone` | `firewall` | `none` | `damage_or_block` |
| `objective_data_core` | `none` | `extract_data` | `extraction_target` |
| `exit_gate_open` | `none` | `reach_exit` | `mission_exit` |

This document does not connect Trace, damage, objective, or mission-state logic.

## HackingMissionDefinition Relationship

`HackingMissionDefinition` may later define:

- `mission_type`
- `objective_type`
- `map_scene_path`
- `trace_risk`
- `time_limit_seconds`

`hack_arena_tiles_atlas.png` is a visual candidate for building those mission spaces.

Connection candidates:

```text
HackingMissionDefinition.mission_type
HackingMissionDefinition.objective_type
HackingMissionDefinition.map_scene_path
tile mission_tag
tile objective_type
tile hazard_type
```

Examples:

```text
mission_type = data_extract
objective_type = extract_data
-> objective_data_core tile candidate

mission_type = signal_trace
objective_type = trace_signal
-> signal_trace_floor / hazard_trace_zone candidates

trace_risk = high
-> detection_zone / warning_floor tile candidates
```

This task does not modify `HackingMissionDefinition.gd` and does not connect maps or TileMaps to missions.

## Godot Application Candidates

### Candidate A: TileSet + TileMapLayer

- import the atlas into a TileSet
- manage collision / navigation / hazard custom data through TileSet metadata
- build arena maps with TileMapLayer

Pros:

- good for repeated tile placement
- collision layers and tile metadata can be centralized

Cons:

- tall `3/4` objects or dynamic objects may still need separate scenes

### Candidate B: Sprite2D / AtlasTexture Region Prototype

- manually place tile regions as Sprite2D nodes
- useful for early visual checks

Pros:

- fast to experiment
- easy z-index control

Cons:

- inefficient for actual map production

### Candidate C: Hybrid

- floor / wall base through TileMapLayer
- objective / exit / interactive / hazard special objects as separate scenes or `Area2D`

Current recommendation:

- Keep TileSet / TileMapLayer as the long-term candidate.
- Allow a Sprite2D region viewer for early visual validation.
- Create a separate TileSet prototype before wiring into `HackingActionPrototype`.

## Z-Index And Layer Criteria

Layer candidates:

| Layer | z-index | Role |
| --- | ---: | --- |
| `ArenaFloorLayer` | `0` | floor tiles |
| `ArenaFloorFxLayer` | `5` | low floor effects |
| `ArenaWallLayer` | `10` | wall / boundary tiles |
| `ArenaObstacleLayer` | `20` | obstacles / cover |
| `ArenaHazardLayer` | `25` | hazard base tiles |
| `ArenaObjectiveLayer` | `30` | objectives / exits |
| `EnemyLayer` | `40` | enemies |
| `PlayerLayer` | `45` | player |
| `ProjectileLayer` | `50` | shots |
| `HitFxLayer` | `60` | hit / damage FX |
| `ArenaOverlayFxLayer` | `70` | overlay FX |
| `DebugLayer` | `100` | debug markers |
| `UILayer` | `1000` | UI |

Criteria:

- floor stays lowest
- wall / obstacle can be below player / enemy or y-sorted later
- hazard should remain visible above floor
- objective / exit should be easy to identify
- projectile / hit FX should appear above actors
- UI stays above all arena visuals

## Autotile And Edge Candidates

`autotile_group` candidates:

```text
floor_grid
wall_metal
hazard_trace
firewall_zone
data_line
```

`edge_mask` candidates:

```text
none
n
s
e
w
ne
nw
se
sw
inner_corner
outer_corner
```

This document does not define actual bitmasks, terrains, or TileSet terrain rules.

## FX / Actor / Tile Split

### `hack_arena_tiles_atlas.png` Includes

- floor tile
- wall tile
- corner / edge tile
- obstacle body
- hazard zone base tile
- objective body base
- exit gate base
- spawn marker base
- cover panel body

### `hack_arena_tiles_atlas.png` Excludes

- player sprite
- enemy sprite
- projectile sprite
- hit / damage animation
- full-screen glitch
- signal wave animation
- warning flash animation
- UI marker
- quarterview room assets
- laptop / phone / NODE-17 room device sprites

Other future atlas candidates:

```text
hack_player_atlas.png
hack_enemies_atlas.png
hack_objects_atlas.png
hack_projectile_atlas.png
hack_fx_atlas.png
```

`qv_fx_atlas.png` is for room FX. `hack_fx_atlas.png` is a separate future candidate for hacking arena FX. Do not mix room device glow with hacking combat / intrusion effects.

## Example Mapping

Coordinates are intentionally `TBD`.

| tile_key | category | collision_type | navigation_type | hazard_type | objective_type | rect | z | notes |
| --- | --- | --- | --- | --- | --- | --- | ---: | --- |
| `floor_base` | `floor` | `none` | `walkable` | `none` | `none` | `TBD` | `0` | default arena floor |
| `floor_data_line` | `floor` | `none` | `walkable` | `none` | `none` | `TBD` | `0` | visual data flow line |
| `wall_solid` | `wall` | `solid` | `blocked` | `none` | `none` | `TBD` | `10` | arena boundary |
| `wall_corner_ne` | `corner` | `solid` | `blocked` | `none` | `none` | `TBD` | `10` | corner candidate |
| `barrier_low` | `obstacle` | `low_blocker` | `blocked` | `none` | `none` | `TBD` | `20` | cover / blocker candidate |
| `hazard_trace_zone` | `hazard` | `hazard_only` | `hazard_walkable` | `trace` | `none` | `TBD` | `25` | increases Trace candidate |
| `hazard_firewall_zone` | `hazard` | `hazard_only` | `hazard_walkable` | `firewall` | `none` | `TBD` | `25` | damage / block candidate |
| `objective_data_core` | `objective` | `objective_trigger` | `trigger_only` | `none` | `extract_data` | `TBD` | `30` | mission target candidate |
| `exit_gate_closed` | `exit` | `solid` | `blocked` | `none` | `reach_exit` | `TBD` | `30` | locked exit candidate |
| `exit_gate_open` | `exit` | `exit_trigger` | `trigger_only` | `none` | `reach_exit` | `TBD` | `30` | active exit candidate |
| `spawn_marker` | `spawn` | `spawn_only` | `decoration_only` | `none` | `none` | `TBD` | `0` | spawn placement marker |

## Pre-Application Checklist

- [ ] Atlas PNG matches transparent background or tile background criteria.
- [ ] Tile size candidate is documented.
- [ ] Tile regions do not overlap each other.
- [ ] Region keys use lowercase `snake_case`.
- [ ] Floor / wall / hazard / objective / exit categories are clear.
- [ ] `collision_type` and `navigation_type` are documented.
- [ ] `hazard_type` / `objective_type` do not conflict with `HackingMissionDefinition` candidates.
- [ ] TileSet / TileMap application candidate is documented.
- [ ] `3/4` perspective matches player / enemy scale.
- [ ] Wall / obstacle tiles do not hide player too much.
- [ ] Hazard tiles do not read like UI.
- [ ] Quarterview room assets and hacking arena assets are not mixed.

## Future Application Order

1. Prepare final `hack_arena_tiles_atlas.png` asset.
2. Lock tile size.
3. Add PNG to the expected atlas path.
4. Write `tile_key` and rect metadata list.
5. Decide mapping format: Resource, JSON, CSV, or TileSet custom data.
6. Create `HackArenaTilesAtlasPrototype`.
7. Verify region display.
8. Validate TileSet / TileMapLayer candidate.
9. Check scale / perspective against `HackingPerspectiveBlockout`.
10. Consider separate wiring to `HackingActionPrototype`.

## Non-Goals

- Do not add `hack_arena_tiles_atlas.png`.
- Do not create TileSet or TileMapLayer data.
- Do not create mapping JSON / CSV / `.tres`.
- Do not change `HackingActionPrototype`.
- Do not change `HackingPerspectiveBlockout`.
- Do not change `HackingMissionDefinition.gd`.
- Do not implement collision, hazard, Trace, objective, or navigation logic.
- Do not connect this atlas to Main, DAY 1, Laptop, Result, Grid Credit, or Story flags.
