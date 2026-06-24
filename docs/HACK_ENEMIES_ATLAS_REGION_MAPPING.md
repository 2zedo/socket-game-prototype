# Hack Enemies Atlas Region Mapping

## Purpose

This document defines future region mapping rules for `hack_enemies_atlas.png`.

The atlas is a candidate for hacking mission enemy / security-program visual bodies: watchers, scanners, seekers, tracers, guard nodes, turrets, blockers, alarm nodes, corruption bodies, and daemon-like core candidates. It is not imported into Godot yet and is not connected to `HackingActionPrototype`, `HackingPerspectiveBlockout`, `HackingMissionDefinition`, Main, Laptop, Result, or DAY 1.

Coordinates stay `TBD` until the actual PNG exists.

## Atlas File

Future atlas file:

```text
hack_enemies_atlas.png
```

Expected future Godot path:

```text
res://assets/hacking/enemies/atlases/hack_enemies_atlas.png
```

Source / reference candidates:

```text
res://assets/hacking/enemies/atlases/source/
res://assets/hacking/enemies/atlases/reference/
```

Format criteria:

- PNG.
- RGBA / transparent background.
- Enemy / security-program body only.
- No player avatar sprite.
- No projectile sprite.
- No arena tile.
- No full-screen FX.
- No UI panel.
- No room quarterview assets.
- No fantasy monster, armor, sword, magic, or dungeon-hero look.
- Animation frames may be arranged as strips or grids.
- Alpha edge cleanup is required before import.

This task does not create the folders, PNG, `AtlasTexture`, `SpriteFrames`, JSON, CSV, `.tres`, or any mapping file.

## Hack Enemy Role

Hack enemies are visualized security bodies inside hacking mission space. They should read as THE GRID security systems, surveillance programs, trace agents, guard processes, or defensive nodes.

Roles:

- Track or attack the player avatar.
- Increase Trace pressure.
- Patrol a route or scan an area.
- Block access to the objective.
- Apply pressure before the exit opens.
- Make mission danger visible.

Hack enemies are not:

- Physical enemies inside Yui's room.
- Fantasy monsters.
- Main-character robot combat units.
- Player avatar bodies.
- Projectiles.
- Hit / damage FX.
- Arena tiles.
- UI cursors.

The enemy language should stay cyber / security-system based. Avoid sword, armor, monster, and magic silhouettes.

## Enemy Category Candidates

Enemy categories are broad visual and behavior families.

```text
watcher
scanner
seeker
tracer
guard
turret
blocker
alarm
corruption
daemon
patrol
node
```

Examples:

| region_key | category |
| --- | --- |
| `watcher_eye_idle` | `watcher` |
| `scanner_line_sweep` | `scanner` |
| `seeker_bot_move` | `seeker` |
| `tracer_wisp_active` | `tracer` |
| `firewall_guard_idle` | `guard` |
| `turret_node_idle` | `turret` |
| `blocker_node_closed` | `blocker` |
| `alarm_node_warning` | `alarm` |
| `corruption_blob_idle` | `corruption` |
| `daemon_core_idle` | `daemon` |
| `patrol_bot_walk` | `patrol` |

## Enemy Key Naming

`enemy_key` identifies the enemy type.

Good examples:

```text
watcher_eye
scanner_line
seeker_bot
tracer_wisp
firewall_guard
patrol_bot
sentry_node
alarm_node
blocker_node
turret_node
corruption_blob
daemon_core
```

Bad examples:

```text
enemy1
monster_001
bot_final_new
tmp_enemy
image_05
object_a
```

Rules:

- Use lowercase `snake_case`.
- Use stable gameplay / design identity, not file-export noise.
- Do not encode temporary numbering unless the number is part of a deliberate enemy family.
- Do not use `final`, `new`, `tmp`, or export iteration names.

## Region Key Naming

`region_key` identifies an actual atlas region or animation candidate.

Basic rule:

```text
enemy_key + state/action
```

Good examples:

```text
watcher_eye_idle
watcher_eye_alert
scanner_line_sweep
seeker_bot_idle
seeker_bot_move
seeker_bot_attack
tracer_wisp_active
firewall_guard_idle
firewall_guard_attack
turret_node_idle
turret_node_fire
blocker_node_closed
blocker_node_open
alarm_node_warning
corruption_blob_idle
daemon_core_idle
```

State / action suffix candidates:

```text
_idle
_move
_walk
_patrol
_alert
_attack
_fire
_hit
_hurt
_death
_warning
_active
_inactive
_open
_closed
_spawn
_despawn
```

If a region is animated, frame count, frame size, FPS, loop policy, and pivot are mapping metadata. Do not encode those details in the `region_key`.

## Animation State Criteria

Common required candidates:

```text
idle
move
alert
attack
hit
death
```

Optional candidates:

```text
spawn
despawn
charge
fire
scan
warning
disabled
stunned
```

Enemy-specific candidates:

| enemy_key | state candidates |
| --- | --- |
| `watcher_eye` | `idle`, `alert`, `scan` |
| `scanner_line` | `sweep`, `warning` |
| `seeker_bot` | `idle`, `move`, `attack`, `hit`, `death` |
| `tracer_wisp` | `active`, `chase`, `dissipate` |
| `firewall_guard` | `idle`, `attack`, `block`, `death` |
| `turret_node` | `idle`, `aim`, `fire`, `disabled` |
| `alarm_node` | `idle`, `warning`, `triggered` |

This document does not create `SpriteFrames` or animation resources.

## Frame Layout Criteria

Enemy atlas regions can be static or animated.

### Static Enemy Region

Examples:

```text
turret_node_idle
blocker_node_closed
```

Criteria:

```text
frame_count = 1
playback_policy = hold
```

### Animated Enemy Strip

Examples:

```text
seeker_bot_move
scanner_line_sweep
tracer_wisp_active
```

Criteria:

- `frame_count >= 2`.
- Frames are arranged left-to-right by default.
- Each frame has the same `frame_width` and `frame_height`.
- Transparent background stays clean.
- Anchor remains stable across frames.

### 4-Direction Enemy Candidate

Some enemies may eventually need direction-specific animation. The default row order should match the hacking avatar convention if used:

```text
row 0: down
row 1: up
row 2: left
row 3: right
```

Current recommendation:

- Start simple cyber enemies with directionless loop animation.
- Use 4-direction enemy layouts only for enemies whose gameplay needs facing direction.
- Confirm enemy 4-direction layout after actual chase, patrol, and attack needs are known.

This document does not create the actual frame layout.

## Region Mapping Schema

Future mapping metadata may use Resource, JSON, CSV, or another explicit format. This task only documents the schema.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `enemy_key` | `String` | Enemy type identifier | `seeker_bot` |
| `region_key` | `String` | Atlas region / animation identifier | `seeker_bot_move` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/hacking/enemies/atlases/hack_enemies_atlas.png` |
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
| `enemy_category` | `String` | Enemy category | `seeker` |
| `visual_state` | `String` | Visual state | `move` |
| `behavior_hint` | `String` | Behavior candidate | `chase_player` |
| `danger_role` | `String` | Danger role | `pressure` |
| `collision_hint` | `String` | Collision candidate | `enemy_body` |
| `hitbox_hint` | `String` | Attack shape candidate | `contact_damage` |
| `hurtbox_hint` | `String` | Damageable shape candidate | `small_circle` |
| `trace_hint` | `String` | Trace influence candidate | `increases_trace_on_contact` |
| `projectile_hint` | `String` | Projectile relationship | `none` |
| `mission_tag` | `String` | Mission connection candidate | `signal_trace` |
| `default_z_index` | `int` | Default z-index | `40` |
| `playback_policy` | `String` | Playback policy | `loop` |
| `notes` | `String` | Notes | `candidate only` |

All coordinate fields remain `TBD` until the atlas exists.

## Behavior Hint And Danger Role

`behavior_hint` is not AI implementation. It is a mapping hint that helps the future enemy controller choose or validate a visual.

Behavior hint candidates:

```text
stationary
patrol_route
chase_player
scan_area
fire_projectile
guard_objective
block_path
trigger_alarm
increase_trace
explode_on_contact
spawn_children
disabled
```

Danger role candidates:

```text
pressure
blocker
sniper
patrol
alarm
hazard_carrier
objective_guard
trace_source
boss_candidate
```

Examples:

| region_key | behavior_hint | danger_role |
| --- | --- | --- |
| `watcher_eye_idle` | `scan_area` | `alarm` |
| `seeker_bot_move` | `chase_player` | `pressure` |
| `turret_node_fire` | `fire_projectile` | `sniper` |
| `blocker_node_closed` | `block_path` | `blocker` |
| `alarm_node_warning` | `trigger_alarm` | `trace_source` |

This document does not implement enemy AI.

## Collision / Hitbox / Hurtbox Separation

The atlas is visual data. It must not become the source of truth for gameplay collision.

Rules:

- Enemy atlas regions are visual layer candidates.
- Actual collision is owned by an enemy controller or `Area2D` / `CollisionShape2D`.
- Visual region size and collision size may differ.
- Hitbox and hurtbox are not locked 1:1 to sprite frame boundaries.
- Contact damage, projectile fire, and Trace increase are owned by script / state.
- Animation is feedback. Gameplay judgment stays in controller data.

Collision hint candidates:

```text
none
enemy_body
static_node
wall_like_blocker
trigger_only
```

Hitbox hint candidates:

```text
none
contact_damage
projectile_origin
area_scan
explosion_radius
```

Hurtbox hint candidates:

```text
none
small_circle
medium_circle
rectangular_core
node_core
```

## Trace And Mission Relation

Hacking enemies can contribute to Trace pressure, alarm escalation, or objective access. That relation should remain data / controller driven rather than baked into the sprite.

Trace hint candidates:

```text
none
increases_trace_on_contact
increases_trace_when_seen
increases_trace_over_time
alerts_nearby
locks_exit_until_disabled
mission_failure_on_alarm_candidate
```

`HackingMissionDefinition` connection candidates:

```text
mission_type
objective_type
trace_risk
required_device_keys
recommended_device_keys
```

Examples:

```text
mission_type = signal_trace
-> scanner_line / tracer_wisp candidates

trace_risk = high
-> watcher_eye / alarm_node / tracer_wisp ratio candidate

objective_type = extract_data
-> guard enemies near objective_data_core candidate
```

This document does not modify `HackingMissionDefinition.gd`, spawn logic, trace logic, or mission `.tres` files.

## Relationship To HackingActionPrototype

`HackingActionPrototype` is the current controls, mission state, objective, exit, HP, Trace, and feedback prototype. `HackingPrototypeEnemy` is a temporary enemy controller.

`hack_enemies_atlas.png` is a future visual candidate for replacing or extending the current placeholder enemy visuals.

This task does not:

- Modify `HackingPrototypeEnemy.gd`.
- Modify `HackingActionPrototype.tscn`.
- Replace enemy visuals.
- Change enemy AI.
- Change spawn logic.
- Change Trace or damage logic.

Future connection candidate:

```text
HackingPrototypeEnemy behavior/state
-> enemy_key
-> region_key / animation
-> AnimatedSprite2D or SpriteFrames
-> hit / hurt / death feedback
```

## Relationship To HackingPerspectiveBlockout

`HackingPerspectiveBlockout` checks the long-term `3/4 top-down cyber action view` scale and depth. Enemy visuals should be checked there before replacing gameplay prototype visuals.

Scale / readability checks:

- Enemy body reads over arena tile bodies.
- Player avatar and enemy silhouette are distinct.
- Enemy body is distinct from projectile and FX.
- Enemy scale matches obstacle and wall scale.
- Enemy body does not read like fantasy monster art.
- Trace / danger role can be read visually.

## Avatar / Projectile / FX / Tile Split

### `hack_enemies_atlas.png` Includes

- Enemy body idle / move / attack / hit / death candidates.
- Watcher / scanner / seeker / tracer / guard / turret / alarm / blocker / corruption / daemon bodies.
- Small built-in status lights if they belong to the enemy body.

### `hack_enemies_atlas.png` Excludes

- Player avatar body.
- Projectile body.
- Hit impact FX.
- Explosion / spark / glitch / signal wave FX.
- Arena floor / wall / tile.
- Objective / exit base tile.
- UI marker.
- Room quarterview assets.
- Fantasy monster parts.

Other asset candidates:

```text
hack_avatar_idle_4dir.png
hack_avatar_walk_4dir.png
hack_objects_atlas.png
hack_projectiles_atlas.png
hack_fx_atlas.png
hack_arena_tiles_atlas.png
```

Avoid baking warning glow, laser, hit flash, or large state FX too strongly into the enemy body. Enemy body and FX should remain separable where possible.

Security programs and enemy bodies stay in `hack_enemies_atlas.png`; objective terminals, gates, data cores, and interactable nodes stay in `hack_objects_atlas.png`.

## Z-Index / Layer Candidates

Hacking arena z-index candidates:

| Layer | z-index |
| --- | ---: |
| `ArenaFloorLayer` | `0` |
| `ArenaFloorFxLayer` | `5` |
| `ArenaWallLayer` | `10` |
| `ArenaObstacleLayer` | `20` |
| `ArenaHazardLayer` | `25` |
| `ArenaObjectiveLayer` | `30` |
| `EnemyLayer` | `40` |
| `PlayerLayer` | `45` |
| `ProjectileLayer` | `50` |
| `HitFxLayer` | `60` |
| `ArenaOverlayFxLayer` | `70` |
| `DebugLayer` | `100` |
| `UILayer` | `1000` |

Enemy default:

```text
default_z_index = 40
```

Exceptions:

- `turret_node`: can sit near obstacle / objective layer; z-index `30-40` candidate.
- `tracer_wisp`: can render above or near player; z-index `45-55` candidate.
- `alarm_node`: can sit near objective / obstacle layer; warning FX belongs to hit / overlay FX layer.

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
- `move`: `loop`.
- `attack` / `fire`: `once` or short loop.
- `alert` / `warning`: `loop` or `pingpong`.
- `hit`: `once`.
- `death` / `despawn`: `once`.
- `scanner_line_sweep`: `loop`.
- `corruption_blob_idle`: `random_flicker` candidate.

This document does not create animation resources.

## Future Enemy Definition Candidates

Future data structures may be useful after atlas mapping is validated:

```text
HackingEnemyDefinition.gd
HackingEnemySpawnDefinition.gd
```

Possible fields:

```text
enemy_key
display_name
behavior_type
hp
speed
contact_damage
trace_gain
projectile_key
visual_region_key
death_fx_key
```

This task does not create those scripts or resources.

## Example Mapping

Coordinates are intentionally `TBD`.

| enemy_key | region_key | category | behavior_hint | danger_role | state | frames | fps | rect | anchor | z | notes |
| --- | --- | --- | --- | --- | --- | --- | ---: | --- | --- | ---: | --- |
| `watcher_eye` | `watcher_eye_idle` | `watcher` | `scan_area` | `alarm` | `idle` | `TBD` | `6` | `TBD` | `center` | `40` | detects player candidate |
| `scanner_line` | `scanner_line_sweep` | `scanner` | `scan_area` | `trace_source` | `sweep` | `TBD` | `8` | `TBD` | `center` | `40` | trace zone candidate |
| `seeker_bot` | `seeker_bot_move` | `seeker` | `chase_player` | `pressure` | `move` | `TBD` | `8` | `TBD` | `bottom_center` | `40` | basic chaser candidate |
| `tracer_wisp` | `tracer_wisp_active` | `tracer` | `increase_trace` | `trace_source` | `active` | `TBD` | `10` | `TBD` | `center` | `45` | trace pressure candidate |
| `firewall_guard` | `firewall_guard_attack` | `guard` | `guard_objective` | `objective_guard` | `attack` | `TBD` | `8` | `TBD` | `bottom_center` | `40` | objective guard candidate |
| `turret_node` | `turret_node_fire` | `turret` | `fire_projectile` | `sniper` | `fire` | `TBD` | `8` | `TBD` | `center` | `40` | projectile source candidate |
| `blocker_node` | `blocker_node_closed` | `blocker` | `block_path` | `blocker` | `closed` | `TBD` | `1` | `TBD` | `center` | `30` | blocks path candidate |
| `alarm_node` | `alarm_node_warning` | `alarm` | `trigger_alarm` | `trace_source` | `warning` | `TBD` | `8` | `TBD` | `center` | `40` | alarm candidate |
| `corruption_blob` | `corruption_blob_idle` | `corruption` | `hazard_carrier` | `pressure` | `idle` | `TBD` | `6` | `TBD` | `center` | `40` | corruption hazard candidate |
| `daemon_core` | `daemon_core_idle` | `daemon` | `guard_objective` | `boss_candidate` | `idle` | `TBD` | `6` | `TBD` | `center` | `40` | boss-like candidate |

## Pre-Application Checklist

- [ ] Atlas PNG uses transparent background.
- [ ] Enemy regions do not overlap each other.
- [ ] Animated frames share the same `frame_width` / `frame_height`.
- [ ] Frame anchors do not jitter.
- [ ] `enemy_key` and `region_key` use lowercase `snake_case`.
- [ ] Enemy category and `behavior_hint` are documented.
- [ ] Collision / hitbox / hurtbox stay separate from visuals.
- [ ] Enemy body and projectile / FX are not mixed.
- [ ] Enemy body does not read like a fantasy monster.
- [ ] Player avatar and enemy silhouettes are distinct.
- [ ] Enemy regions read clearly over arena tiles.
- [ ] Trace / danger role is visually distinct.
- [ ] UI / prompt readability is not damaged.

## Future Application Order

1. Prepare final `hack_enemies_atlas.png` asset.
2. Add PNG to the expected atlas path.
3. Write `enemy_key`, `region_key`, and frame metadata list.
4. Decide mapping format: Resource, JSON, CSV, or another explicit file.
5. Create an enemy region viewer prototype.
6. Create `HackingEnemiesAtlasPrototype`.
7. Verify static enemy and animated enemy display.
8. Check scale / readability in `HackingPerspectiveBlockout`.
9. Consider replacing placeholder visuals in `HackingPrototypeEnemy`.
10. Review enemy behavior, state, FX, and projectile separation.

## Non-Goals

- Do not add `hack_enemies_atlas.png`.
- Do not create mapping JSON / CSV / `.tres`.
- Do not create `AtlasTexture` or `SpriteFrames`.
- Do not modify `HackingActionPrototype`.
- Do not modify `HackingPrototypeEnemy.gd`.
- Do not modify `HackingPerspectiveBlockout`.
- Do not modify `HackingMissionDefinition.gd`.
- Do not implement AI, spawn logic, collision, hitbox, hurtbox, damage, or Trace logic.
- Do not connect this atlas to Main, DAY 1, Laptop, Result, Grid Credit, or Story flags.
