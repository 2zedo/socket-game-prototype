# Hack Objects Atlas Region Mapping

## Purpose

This document defines future region mapping rules for `hack_objects_atlas.png`.

The atlas is a candidate for hacking mission object bodies: interactable objects, objective devices, terminals, access nodes, gate devices, caches, signal relays, security consoles, and trace-related mission devices. It is not imported into Godot yet and is not connected to `HackingActionPrototype`, `HackingPerspectiveBlockout`, `HackingMissionDefinition`, Main, Laptop, Result, or DAY 1.

Coordinates stay `TBD` until the actual PNG exists.

## Atlas File

Future atlas file:

```text
hack_objects_atlas.png
```

Expected future Godot path:

```text
res://assets/hacking/objects/atlases/hack_objects_atlas.png
```

Source / reference candidates:

```text
res://assets/hacking/objects/atlases/source/
res://assets/hacking/objects/atlases/reference/
```

Format criteria:

- PNG.
- RGBA / transparent background.
- Hackable / interactable / objective object body only.
- No player avatar sprite.
- No enemy sprite.
- No projectile sprite.
- No floor / wall tile.
- No full-screen FX.
- No UI panel.
- No room quarterview assets.
- No fantasy dungeon chest, altar, torch, or magic switch look.
- Animation frames may be arranged as strips or grids.
- Alpha edge cleanup is required before import.

This task does not create the folders, PNG, `AtlasTexture`, `SpriteFrames`, TileSet, JSON, CSV, `.tres`, or any mapping file.

## Hack Object Role

Hack objects are cyber objects that the player can interact with or that change objective / mission state inside hacking mission space.

Roles:

- Data extraction objective.
- Security device disable target.
- Exit gate opening device.
- Access permission or key fragment pickup.
- Trace-risk increase / decrease device.
- Objective progress visualizer.
- Mission-type-specific target.
- Hacking-space interaction point.

Hack objects are not:

- Floor / wall / hazard tiles.
- Player avatar bodies.
- Enemy / security program bodies.
- Projectiles.
- Hit / damage FX.
- Full-screen glitch FX.
- UI cursors.
- Quarterview room objects.
- Fantasy dungeon chests, altars, torches, or shrine props.

Objects should read as cyber terminals, access nodes, data cores, gates, relays, caches, or security devices. They should not read as treasure chests or fantasy dungeon props.

## Difference From Hack Arena Tiles

### `hack_arena_tiles_atlas.png`

Owns:

- Floor.
- Wall.
- Edge / corner.
- Obstacle body.
- Hazard zone base tile.
- Objective / exit floor marker or base tile candidate.
- Arena spatial structure.

### `hack_objects_atlas.png`

Owns:

- Actual interactable objective object.
- Data core body.
- Terminal body.
- Access node body.
- Gate device body.
- Relay node body.
- Locked cache body.
- Mission switch / hackable device body.

Decision rule:

- If it is floor, wall, or space structure, use `hack_arena_tiles_atlas.png`.
- If the player approaches it with `E` / interaction or it changes mission state, use `hack_objects_atlas.png`.
- A simple floor marker can be a tile atlas candidate.
- The actual device placed on top of that marker is an object atlas candidate.

## Object Category Candidates

Object categories are broad visual and interaction families.

```text
objective
terminal
gate
access_node
relay
security_device
cache
key_item
trace_device
corruption_object
mission_switch
extraction_target
```

Examples:

| region_key | category |
| --- | --- |
| `data_core_idle` | `objective` |
| `extraction_terminal_idle` | `terminal` |
| `security_console_locked` | `security_device` |
| `access_node_active` | `access_node` |
| `firewall_generator_active` | `security_device` |
| `exit_gate_device_locked` | `gate` |
| `signal_relay_node_idle` | `relay` |
| `locked_cache_closed` | `cache` |
| `key_fragment_idle` | `key_item` |
| `trace_anchor_active` | `trace_device` |
| `corruption_core_idle` | `corruption_object` |

## Object Key Naming

`object_key` identifies the hack object type.

Good examples:

```text
data_core
extraction_terminal
security_console
access_node
firewall_generator
alarm_console
exit_gate_device
signal_relay_node
locked_cache
key_fragment
decrypt_station
uplink_beacon
trace_anchor
corruption_core
objective_marker_device
mission_switch_candidate
```

Bad examples:

```text
object1
obj_001
chest_final_new
tmp_terminal
image_05
node_a
```

Rules:

- Use lowercase `snake_case`.
- Use stable design identity, not export iteration names.
- Do not use `final`, `new`, `tmp`, or ad hoc image names.
- Do not use fantasy names when the object is a cyber device.

## Region Key Naming

`region_key` identifies an atlas region or animation candidate.

Basic rule:

```text
object_key + state/action
```

Good examples:

```text
data_core_idle
data_core_extracting
data_core_extracted
extraction_terminal_idle
extraction_terminal_active
security_console_locked
security_console_unlocked
access_node_idle
access_node_disabled
firewall_generator_active
firewall_generator_disabled
exit_gate_device_locked
exit_gate_device_open
signal_relay_node_active
locked_cache_closed
locked_cache_open
key_fragment_idle
trace_anchor_active
corruption_core_unstable
```

State / action suffix candidates:

```text
_idle
_active
_inactive
_locked
_unlocked
_open
_closed
_extracting
_extracted
_disabled
_warning
_unstable
_complete
_failed
_damaged
_charging
_depleted
```

If a region is animated, frame count, frame size, FPS, loop policy, and pivot are mapping metadata. Do not encode those details in the `region_key`.

## Interaction State Criteria

Common state candidates:

```text
idle
active
inactive
locked
unlocked
open
closed
extracting
extracted
disabled
warning
unstable
complete
failed
depleted
```

Object-specific candidates:

| object_key | state candidates |
| --- | --- |
| `data_core` | `idle`, `extracting`, `extracted`, `warning` |
| `extraction_terminal` | `idle`, `active`, `complete` |
| `security_console` | `locked`, `unlocked`, `disabled` |
| `access_node` | `idle`, `active`, `disabled` |
| `firewall_generator` | `active`, `disabled`, `warning` |
| `exit_gate_device` | `locked`, `open` |
| `locked_cache` | `closed`, `open` |
| `trace_anchor` | `active`, `unstable`, `disabled` |

This document does not implement a state machine or modify `HackingActionPrototype`.

## Region Mapping Schema

Future mapping metadata may use Resource, JSON, CSV, or another explicit format. This task only documents the schema.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `object_key` | `String` | Hack object type identifier | `data_core` |
| `region_key` | `String` | Atlas region / animation identifier | `data_core_extracting` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/hacking/objects/atlases/hack_objects_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `frame_count` | `int` | Animation frame count | `4` |
| `frame_width` | `int` | One frame width | `TBD` |
| `frame_height` | `int` | One frame height | `TBD` |
| `fps` | `float` | Playback speed | `8.0` |
| `loop` | `bool` | Loop candidate | `true` |
| `pivot_x` | `float` | Region pivot x | `TBD` |
| `pivot_y` | `float` | Region pivot y | `TBD` |
| `anchor_type` | `String` | Placement anchor | `center` |
| `object_category` | `String` | Object category | `objective` |
| `visual_state` | `String` | Visual state | `extracting` |
| `interaction_hint` | `String` | Interaction candidate | `hold_to_extract` |
| `objective_hint` | `String` | Objective candidate | `extract_data` |
| `trigger_hint` | `String` | Trigger candidate | `player_interact` |
| `collision_hint` | `String` | Collision candidate | `static_body` |
| `interaction_area_hint` | `String` | Interaction range candidate | `medium_circle` |
| `mission_tag` | `String` | Mission connection candidate | `data_extract` |
| `objective_type` | `String` | `HackingMissionDefinition.objective_type` candidate | `extract_data` |
| `required_state` | `String` | State required for interaction | `idle` |
| `result_state` | `String` | State after interaction | `extracted` |
| `default_z_index` | `int` | Default z-index | `30` |
| `playback_policy` | `String` | Playback policy | `loop` |
| `notes` | `String` | Notes | `candidate only` |

All coordinate fields remain `TBD` until the atlas exists.

## Interaction Hint And Objective Hint

`interaction_hint` is not input implementation. It is a mapping hint for future object controllers and mission logic.

Interaction hint candidates:

```text
inspect
interact_once
hold_to_extract
hold_to_disable
unlock
open
close
collect
activate
deactivate
route_signal
upload_data
download_data
restore_data
destroy_candidate
```

Objective hint candidates:

```text
none
extract_data
disable_node
reach_exit
unlock_gate
collect_key
trace_signal
survive_timer_support
reduce_trace
trigger_alarm_candidate
```

Trigger hint candidates:

```text
player_interact
objective_state_changed
enemy_disabled
timer_complete
trace_threshold
key_collected
mission_start
mission_end
```

Examples:

| region_key | interaction_hint | objective_hint |
| --- | --- | --- |
| `data_core_extracting` | `hold_to_extract` | `extract_data` |
| `security_console_locked` | `unlock` | `unlock_gate` |
| `firewall_generator_active` | `hold_to_disable` | `disable_node` |
| `locked_cache_closed` | `collect_or_unlock` | `collect_key` |

This document does not implement input, hold, unlock, extract, or interact logic.

## Collision / Interaction Area Separation

The atlas is visual data. It must not become the source of truth for collision or interaction range.

Rules:

- Hack object atlas regions are visual layer candidates.
- Actual collision is owned by an object controller or `StaticBody2D` / `CollisionShape2D`.
- Actual interaction range is owned by `Area2D` or a separate interaction area.
- Visual region size and collision / interaction area size may differ.
- Interaction prompt position may use an interaction anchor rather than visual region bounds.
- Objective triggers are not locked 1:1 to sprite frame boundaries.
- Animation is feedback. Mission state changes stay in script / state.

Collision hint candidates:

```text
none
static_body
soft_blocker
trigger_only
objective_body
gate_blocker
```

Interaction area hint candidates:

```text
none
small_circle
medium_circle
large_circle
rectangular_front
terminal_range
gate_range
```

## Relationship To HackingMissionDefinition

`HackingMissionDefinition` defines `mission_type`, `objective_type`, `map_scene_path`, `trace_risk`, and `time_limit_seconds`.

`hack_objects_atlas.png` is a future visual source for the objective, terminal, gate, cache, and security-device bodies used by those missions.

Connection candidates:

```text
HackingMissionDefinition.mission_type
HackingMissionDefinition.objective_type
HackingMissionDefinition.map_scene_path
object mission_tag
object objective_type
object interaction_hint
```

Examples:

```text
mission_type = data_extract
objective_type = extract_data
-> data_core / extraction_terminal candidates

mission_type = firewall_bypass
objective_type = disable_node
-> firewall_generator / security_console candidates

mission_type = signal_trace
objective_type = trace_signal
-> signal_relay_node / trace_anchor candidates

mission_type = archive_restore
objective_type = restore_data
-> locked_cache / decrypt_station candidates
```

This document does not modify `HackingMissionDefinition.gd`, create mission `.tres`, or wire objective logic.

## Relationship To HackingActionPrototype

`HackingActionPrototype` is the current controls, mission state, objective, exit, HP, Trace, and feedback prototype. Its current objective / exit visuals are temporary placeholders.

`hack_objects_atlas.png` is a future visual candidate for objective, exit, terminal, and interaction objects.

This task does not:

- Modify `HackingActionPrototype.gd`.
- Modify `HackingActionPrototype.tscn`.
- Replace objective visuals.
- Replace exit visuals.
- Change extraction logic.
- Change success / failure logic.
- Change Trace or damage logic.

Future connection candidate:

```text
HackingActionPrototype objective state
-> object_key / visual_state
-> region_key / animation
-> interaction feedback
-> mission state update
```

## Relationship To HackingPerspectiveBlockout

`HackingPerspectiveBlockout` checks the long-term `3/4 top-down cyber action view` scale and depth. Object visuals should be checked there before replacing gameplay prototype visuals.

Scale / readability checks:

- Objects read over arena tile bodies.
- Player avatar and interactable target are distinct.
- Enemy bodies and object bodies are not confused.
- Objective, exit, terminal, and cache roles are visually distinct.
- Objects do not read like fantasy dungeon props.
- Interaction prompt placement feels natural.

## Tile / Enemy / Avatar / Projectile / FX Split

### `hack_objects_atlas.png` Includes

- Data core body.
- Extraction terminal body.
- Security console body.
- Access node body.
- Firewall generator body.
- Alarm console body.
- Exit gate device body.
- Signal relay body.
- Locked cache body.
- Key fragment body.
- Decrypt station body.
- Trace anchor body.
- Corruption core body.

### `hack_objects_atlas.png` Excludes

- Floor / wall / hazard tile.
- Player avatar body.
- Enemy body.
- Projectile body.
- Hit impact FX.
- Signal wave FX.
- Full-screen glitch.
- UI marker.
- Quarterview room assets.
- Fantasy dungeon chest / altar / torch.

Other asset candidates:

```text
hack_arena_tiles_atlas.png
hack_enemies_atlas.png
hack_avatar_idle_4dir.png
hack_avatar_walk_4dir.png
hack_projectiles_atlas.png
hack_fx_atlas.png
```

Avoid baking glow, scan lines, warning flashes, and extraction beams too strongly into the object body. Object body and FX should remain separable where possible.

Object body sprites stay in `hack_objects_atlas.png`; extraction beams, terminal flashes, gate pulses, and completion effects belong in `hack_fx_atlas.png`.

## Z-Index / Layer Candidates

Hacking arena z-index candidates:

| Layer | z-index |
| --- | ---: |
| `ArenaFloorLayer` | `0` |
| `ArenaFloorFxLayer` | `5` |
| `ArenaWallLayer` | `10` |
| `ArenaObstacleLayer` | `20` |
| `ArenaHazardLayer` | `25` |
| `ArenaObjectLayer` | `30` |
| `EnemyLayer` | `40` |
| `PlayerLayer` | `45` |
| `ProjectileLayer` | `50` |
| `HitFxLayer` | `60` |
| `ArenaOverlayFxLayer` | `70` |
| `DebugLayer` | `100` |
| `UILayer` | `1000` |

Object default:

```text
default_z_index = 30
```

Exceptions:

- Tall terminal: can overlap with player, so y-sort is a candidate.
- Exit gate: can sit between wall and object layers, z-index `30-35` candidate.
- Data core: should stay visually readable as objective; FX belongs in a separate FX layer.

Final values should be checked in `HackingPerspectiveBlockout`.

## Animation Playback Policy

Playback policy candidates:

```text
hold
loop
once
pingpong
random_flicker
```

Guidelines:

- `idle`: `loop` or `hold`.
- `active`: `loop`.
- `extracting`: `loop`.
- `extracted` / `complete`: `hold`.
- `disabled`: `hold`.
- `warning`: `loop` or `pingpong`.
- `open` / `unlock`: `once` then `hold`.

This document does not create animation resources.

## Future Object Definition Candidates

Future data structures may be useful after atlas mapping is validated:

```text
HackingObjectDefinition.gd
HackingObjectiveDefinition.gd
```

Possible fields:

```text
object_key
display_name
object_category
interaction_type
objective_type
required_state
result_state
interaction_time
trace_delta
visual_region_key
success_fx_key
failure_fx_key
```

This task does not create those scripts or resources.

## Example Mapping

Coordinates are intentionally `TBD`.

| object_key | region_key | category | interaction_hint | objective_hint | state | frames | fps | rect | anchor | z | notes |
| --- | --- | --- | --- | --- | --- | --- | ---: | --- | --- | ---: | --- |
| `data_core` | `data_core_idle` | `objective` | `inspect_or_extract` | `extract_data` | `idle` | `TBD` | `6` | `TBD` | `center` | `30` | data extract objective candidate |
| `data_core` | `data_core_extracting` | `objective` | `hold_to_extract` | `extract_data` | `extracting` | `TBD` | `8` | `TBD` | `center` | `30` | extraction animation candidate |
| `extraction_terminal` | `extraction_terminal_active` | `terminal` | `upload_data` | `extract_data` | `active` | `TBD` | `8` | `TBD` | `center` | `30` | terminal objective candidate |
| `security_console` | `security_console_locked` | `security_device` | `unlock` | `unlock_gate` | `locked` | `TBD` | `1` | `TBD` | `center` | `30` | gate control candidate |
| `access_node` | `access_node_disabled` | `access_node` | `hold_to_disable` | `disable_node` | `disabled` | `TBD` | `1` | `TBD` | `center` | `30` | disabled state candidate |
| `firewall_generator` | `firewall_generator_active` | `security_device` | `hold_to_disable` | `disable_node` | `active` | `TBD` | `6` | `TBD` | `center` | `30` | firewall bypass candidate |
| `exit_gate_device` | `exit_gate_device_open` | `gate` | `activate` | `reach_exit` | `open` | `TBD` | `4` | `TBD` | `center` | `30` | exit control candidate |
| `signal_relay_node` | `signal_relay_node_active` | `relay` | `route_signal` | `trace_signal` | `active` | `TBD` | `6` | `TBD` | `center` | `30` | signal trace candidate |
| `locked_cache` | `locked_cache_closed` | `cache` | `unlock` | `collect_key` | `closed` | `TBD` | `1` | `TBD` | `center` | `30` | archive / restore candidate |
| `trace_anchor` | `trace_anchor_active` | `trace_device` | `deactivate` | `reduce_trace` | `active` | `TBD` | `6` | `TBD` | `center` | `30` | trace risk candidate |
| `corruption_core` | `corruption_core_unstable` | `corruption_object` | `inspect_or_disable` | `disable_node` | `unstable` | `TBD` | `8` | `TBD` | `center` | `30` | corruption candidate |

## Pre-Application Checklist

- [ ] Atlas PNG uses transparent background.
- [ ] Object regions do not overlap each other.
- [ ] Animated frames share the same `frame_width` / `frame_height`.
- [ ] Frame anchors do not jitter.
- [ ] `object_key` and `region_key` use lowercase `snake_case`.
- [ ] Object category and `interaction_hint` are documented.
- [ ] Collision / interaction area stays separate from visuals.
- [ ] Object body and FX are not mixed.
- [ ] Object body does not read like a fantasy dungeon chest or altar.
- [ ] Object body is distinct from player avatar, enemy, projectile, and tile visuals.
- [ ] Objective / exit / terminal roles are visually distinct.
- [ ] Interaction prompt placement candidate is clear.
- [ ] UI / prompt readability is not damaged.

## Future Application Order

1. Prepare final `hack_objects_atlas.png` asset.
2. Add PNG to the expected atlas path.
3. Write `object_key`, `region_key`, and frame metadata list.
4. Decide mapping format: Resource, JSON, CSV, or another explicit file.
5. Create an object region viewer prototype.
6. Create `HackingObjectsAtlasPrototype`.
7. Verify static object and animated object display.
8. Check scale / readability in `HackingPerspectiveBlockout`.
9. Consider replacing objective / exit visuals in `HackingActionPrototype`.
10. Review interaction, objective state, and FX separation.

## Non-Goals

- Do not add `hack_objects_atlas.png`.
- Do not create mapping JSON / CSV / `.tres`.
- Do not create `AtlasTexture`, `SpriteFrames`, TileSet, or object Resources.
- Do not modify `HackingActionPrototype`.
- Do not modify `HackingPerspectiveBlockout`.
- Do not modify `HackingMissionDefinition.gd`.
- Do not implement objective / interaction logic.
- Do not modify exit, success, failure, Trace, or damage logic.
- Do not implement collision or interaction areas.
- Do not connect this atlas to Main, DAY 1, Laptop, Result, Grid Credit, or Story flags.
