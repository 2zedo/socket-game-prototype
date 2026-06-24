# Hack FX Atlas Region Mapping

## Purpose

This document defines future region mapping rules for `hack_fx_atlas.png`.

The atlas is a candidate for hacking arena gameplay feedback: hit impact, projectile trail, Trace noise, firewall burst, data extraction, gate unlock, enemy death, avatar dash trail, alarm sweep, scan lines, corruption splash, and mission-state effects. It is not imported into Godot yet and is not connected to `HackingActionPrototype`, `HackingPerspectiveBlockout`, `HackingMissionDefinition`, Main, Laptop, Result, or DAY 1.

Coordinates stay `TBD` until the actual PNG exists.

## Atlas File

Future atlas file:

```text
hack_fx_atlas.png
```

Expected future Godot path:

```text
res://assets/hacking/fx/atlases/hack_fx_atlas.png
```

Source / reference candidates:

```text
res://assets/hacking/fx/atlases/source/
res://assets/hacking/fx/atlases/reference/
```

Format criteria:

- PNG.
- RGBA / transparent background.
- Hacking arena localized FX only.
- No player avatar body.
- No enemy body.
- No object body.
- No projectile base body, unless it is pure impact / trail FX.
- No arena floor / wall tile body.
- No room quarterview FX.
- No UI panel.
- No full-screen overlay unless specifically categorized as `arena_overlay_fx`.
- Animated frames may be arranged as strips or grids.
- Alpha edge cleanup is required before import.

This task does not create the folders, PNG, `AtlasTexture`, `SpriteFrames`, `ShaderMaterial`, JSON, CSV, `.tres`, or any mapping file.

## Hack FX Role

Hack FX are visual feedback effects inside hacking arena gameplay.

Roles:

- Attack hit feedback.
- Projectile collision feedback.
- Dash / evade feedback.
- Data extraction progress feedback.
- Objective complete feedback.
- Trace increase / warning feedback.
- Firewall / alarm / scan danger feedback.
- Enemy spawn / death / dissolve feedback.
- Gate unlock / terminal activation feedback.

Hack FX are not:

- Player avatar bodies.
- Enemy bodies.
- Objective object bodies.
- Arena tiles.
- Projectile base bodies.
- Room qv FX.
- UI panels.
- Static room lighting overlays.

FX do not own gameplay judgment. Damage, Trace, objective state, success, and failure remain script / state-machine responsibilities.

## Split From QV FX Atlas

### `qv_fx_atlas.png`

Owns:

- Quarterview room device glow.
- Laptop / phone / NODE-17 / speaker / signal booster state effects.
- Room charging / power / signal localized effects.
- Localized FX connected to room visual atmosphere.

### `hack_fx_atlas.png`

Owns:

- Hacking arena combat / action / objective feedback.
- Avatar dash / hit effects.
- Projectile hit / trail effects.
- Enemy hit / death effects.
- Trace warning.
- Firewall burst.
- Extraction beam.
- Gate unlock.
- Scan / alarm / corruption effects.

Decision rule:

- If it is a room device state FX, use `qv_fx_atlas.png`.
- If it is hacking mission arena gameplay feedback, use `hack_fx_atlas.png`.
- Do not mix the two atlases.
- The same abstract idea, such as a signal wave, belongs to `qv_fx_atlas.png` when attached to a room device screen and to `hack_fx_atlas.png` when used as mission scan / Trace feedback.

## Split From Other Hacking Atlases

### `hack_fx_atlas.png` Includes

- Dash trail.
- Hit impact.
- Projectile impact.
- Projectile trail.
- Enemy hit spark.
- Enemy death dissolve.
- Data extraction beam / ring.
- Gate unlock pulse.
- Terminal activation flash.
- Firewall burst.
- Trace warning / noise.
- Alarm sweep.
- Scan line.
- Corruption splash.
- Spawn / despawn glitch.
- Shield break.
- Objective complete flash.

### `hack_fx_atlas.png` Excludes

- Hack avatar body.
- Enemy body.
- Projectile base sprite.
- Data core / terminal / gate body.
- Arena floor / wall / hazard tile body.
- UI icons / panels.
- Room quarterview assets.
- QV room device glow.
- Fantasy spell effects that do not fit the cyber arena.

Other atlas candidates:

```text
hack_avatar_idle_4dir.png
hack_avatar_walk_4dir.png
hack_enemies_atlas.png
hack_objects_atlas.png
hack_projectiles_atlas.png
hack_arena_tiles_atlas.png
qv_fx_atlas.png
```

Projectile body and projectile trail / impact are separate. Enemy body and enemy hit / death FX are separate. Objective object body and extraction beam / complete flash are separate.

## FX Category Candidates

FX categories are broad trigger / placement families.

```text
avatar_feedback
projectile_fx
hit_impact
enemy_feedback
objective_fx
gate_fx
terminal_fx
trace_fx
alarm_fx
firewall_fx
scan_fx
corruption_fx
spawn_fx
shield_fx
arena_overlay_fx
status_fx
```

Examples:

| fx_key | category |
| --- | --- |
| `avatar_dash_trail` | `avatar_feedback` |
| `projectile_hit_impact` | `projectile_fx` |
| `enemy_hit_spark` | `enemy_feedback` |
| `data_extract_beam` | `objective_fx` |
| `gate_unlock_pulse` | `gate_fx` |
| `terminal_activate_flash` | `terminal_fx` |
| `trace_warning_ring` | `trace_fx` |
| `alarm_sweep` | `alarm_fx` |
| `firewall_burst` | `firewall_fx` |
| `scan_line_horizontal` | `scan_fx` |
| `corruption_splash` | `corruption_fx` |
| `spawn_glitch` | `spawn_fx` |
| `shield_break` | `shield_fx` |

## FX Key Naming

`fx_key` identifies a future FX atlas region or animation candidate.

Rules:

- Use lowercase `snake_case`.
- Use target or context + effect type + state / action.
- Keep animation frame data in metadata, not in the key.
- Do not use temporary number-only keys.
- Do not use `final`, `new`, `tmp`, or export iteration names.
- Avoid fantasy-magic names unless the effect is explicitly cyber-styled.

Good examples:

```text
avatar_dash_trail
avatar_hit_flash
projectile_trail_small
projectile_hit_impact
enemy_hit_spark
enemy_death_dissolve
data_extract_beam
data_extract_ring
objective_complete_flash
terminal_activate_flash
gate_unlock_pulse
firewall_burst
trace_warning_ring
trace_noise_loop
alarm_sweep
scan_line_horizontal
corruption_splash
spawn_glitch
despawn_glitch
shield_break
```

Bad examples:

```text
fx1
effect_001
magic_boom_final_new
tmp_hit
image_05
object_a
```

Suffix candidates:

```text
_small
_medium
_large
_short
_long
_soft
_hard
_loop
_once
_warning
_success
_fail
_horizontal
_vertical
_burst
_pulse
```

## Region / Animation Mapping Schema

Future mapping metadata may use Resource, JSON, CSV, or another explicit format. This task only documents the schema.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `fx_key` | `String` | FX region / animation identifier | `data_extract_beam` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/hacking/fx/atlases/hack_fx_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `frame_count` | `int` | Animation frame count | `6` |
| `frame_width` | `int` | One frame width | `TBD` |
| `frame_height` | `int` | One frame height | `TBD` |
| `fps` | `float` | Playback speed | `12.0` |
| `loop` | `bool` | Loop candidate | `true` |
| `pivot_x` | `float` | Region pivot x | `TBD` |
| `pivot_y` | `float` | Region pivot y | `TBD` |
| `anchor_type` | `String` | Placement anchor | `target_center` |
| `effect_category` | `String` | FX category | `objective_fx` |
| `target_layer` | `String` | Target layer candidate | `ArenaOverlayFxLayer` |
| `target_key` | `String` | Target object / enemy / projectile key | `data_core` |
| `visual_state` | `String` | Target state | `extracting` |
| `trigger_hint` | `String` | Trigger candidate | `objective_extracting` |
| `mission_state_hint` | `String` | Mission state candidate | `running` |
| `gameplay_state_hint` | `String` | Gameplay state candidate | `player_interacting` |
| `hazard_type` | `String` | Hazard candidate | `none` |
| `objective_type` | `String` | Objective candidate | `extract_data` |
| `blend_mode` | `String` | Blend candidate | `add` |
| `default_alpha` | `float` | Default alpha | `0.8` |
| `default_z_index` | `int` | Default z-index | `60` |
| `duration_seconds` | `float` | One-shot duration | `0.5` |
| `playback_policy` | `String` | Playback policy | `loop` |
| `scale_policy` | `String` | Scale candidate | `target_relative` |
| `notes` | `String` | Notes | `candidate only` |

All coordinate fields remain `TBD` until the atlas exists.

## Frame Layout Criteria

Hack FX atlas regions can be static or animated.

### Static FX

Examples:

```text
avatar_hit_flash
objective_complete_flash
```

Criteria:

```text
frame_count = 1
loop = false
playback_policy = once or hold
```

### Animated FX Strip

Examples:

```text
projectile_hit_impact
data_extract_beam
gate_unlock_pulse
enemy_death_dissolve
```

Criteria:

- `frame_count >= 2`.
- Frames are arranged left-to-right by default.
- Each frame has the same `frame_width` and `frame_height`.
- Transparent background stays clean.
- Anchor remains stable across frames.

### Animated FX Grid Candidate

Complex effects may eventually use:

```text
row = variation
column = frame
```

Current recommendation:

- Use left-to-right strips as the default.
- Consider grids only when frame count or variation count becomes large.

This document does not create the actual frame layout.

## Playback Policy

Playback policy candidates:

```text
once
loop
hold
pingpong
random_flicker
```

Guidelines:

- Dash trail: `once` or short loop.
- Hit impact: `once`.
- Projectile trail: `loop` or object-follow.
- Enemy death: `once`.
- Extraction beam: `loop` while extracting.
- Gate unlock: `once`.
- Trace warning: `loop` or `pingpong`.
- Alarm sweep: `loop`.
- Corruption splash: `once`.
- Spawn / despawn glitch: `once`.
- Shield break: `once`.

This document does not implement playback systems.

## Trigger Criteria

`trigger_hint` documents future event intent. It is not an implementation.

Trigger hint candidates:

```text
player_dash
player_hit
player_hurt
projectile_spawn
projectile_travel
projectile_hit
enemy_hit
enemy_death
objective_started
objective_extracting
objective_completed
terminal_activated
gate_unlocked
trace_increased
trace_warning
alarm_triggered
firewall_hit
firewall_disabled
spawn
despawn
shield_break
mission_success
mission_failed
```

Mission state hint candidates:

```text
ready
running
objective_extracted
success
failed
```

Gameplay state hint candidates:

```text
player_interacting
enemy_alert
projectile_active
hazard_active
objective_active
exit_open
```

This document does not implement a trigger system or modify the `HackingActionPrototype` state machine.

## Target / Anchor Criteria

Anchor type candidates:

```text
target_center
target_top
target_bottom
hit_point
projectile_origin
projectile_tip
emitter_center
gate_center
terminal_screen
objective_core
player_center
custom_offset
screen_center
```

Guidelines:

- Hit impact uses `hit_point`.
- Projectile trail uses `projectile_tip` or `projectile_origin`.
- Extraction beam uses `objective_core` or a player / object connection candidate.
- Gate unlock pulse uses `gate_center`.
- Terminal activate flash uses `terminal_screen`.
- Trace warning ring uses `player_center` or an arena position.
- Alarm sweep uses `emitter_center` or `screen_center`.
- Full-screen-feeling effects should use `arena_overlay_fx`, not UI.

FX pivot / anchor is visual placement metadata. Collision, damage, and Trace judgment are not managed by FX. Target object / enemy / projectile and FX can be connected through anchor or `custom_offset` metadata later.

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

FX default:

```text
default_z_index = 60
```

Exceptions:

- Floor hazard pulse: `ArenaFloorFxLayer` or above `ArenaHazardLayer`, z-index `5-25` candidate.
- Projectile trail: near `ProjectileLayer`, z-index `50-60` candidate.
- Hit impact: above player / enemy / projectile, z-index `60` candidate.
- Trace warning ring: z-index `60` around player or `70` as screen / arena overlay.
- Mission success / fail overlay: z-index `70` if arena visual; actual result UI belongs to `UILayer`.

UI, prompts, and debug overlays should stay above FX.

## Blend / Alpha Criteria

Blend mode candidates:

```text
normal
add
screen
modulate
multiply
```

Default candidates:

| FX type | blend candidate | alpha candidate | notes |
| --- | --- | --- | --- |
| dash trail | `add` or `screen` | `0.4-0.8` | short feedback |
| hit impact | `add` or `normal` | short / high contrast | one-shot |
| projectile trail | `add` | `0.4-0.7` | follow projectile candidate |
| extraction beam | `add` or `screen` | `0.5-0.9` | loop while extracting |
| trace warning | `screen` or `add` | `0.4-0.8` | warning readability |
| firewall burst | `add` or `normal` | short / strong | disable feedback |
| corruption splash | `normal` or `screen` | moderate | avoid over-bright magic feel |

Actual Godot blend handling depends on Material, CanvasItem, or Shader setup. This task only documents candidates.

## Relationship To HackingMissionDefinition

`HackingMissionDefinition` defines `mission_type`, `objective_type`, `trace_risk`, and `time_limit_seconds`.

`hack_fx_atlas.png` is a future visual source for mission state and objective feedback.

Connection candidates:

```text
HackingMissionDefinition.mission_type
HackingMissionDefinition.objective_type
HackingMissionDefinition.trace_risk
mission_state_hint
trigger_hint
fx_key
```

Examples:

```text
mission_type = data_extract
objective_type = extract_data
-> data_extract_beam / objective_complete_flash candidates

mission_type = firewall_bypass
objective_type = disable_node
-> firewall_burst / shield_break candidates

mission_type = signal_trace
objective_type = trace_signal
-> trace_warning_ring / scan_line / alarm_sweep candidates

trace_risk = high
-> trace_noise_loop / alarm_sweep frequency candidate
```

This document does not modify `HackingMissionDefinition.gd`, create mission `.tres`, or wire mission FX.

## Relationship To HackingActionPrototype

`HackingActionPrototype` is the current controls, mission state, objective, exit, HP, Trace, projectile, enemy, and feedback prototype.

`hack_fx_atlas.png` is a future visual candidate for dash, projectile hit, enemy hit / death, objective extraction, Trace warning, and mission result arena feedback.

This task does not:

- Modify `HackingActionPrototype.gd`.
- Modify `HackingPrototypeProjectile.gd`.
- Modify `HackingPrototypeEnemy.gd`.
- Modify scenes.
- Connect SFX / FX triggers.
- Apply particles or shaders.
- Change the state machine.

Future connection candidate:

```text
HackingActionPrototype event
-> trigger_hint
-> fx_key
-> FX instance spawn
-> playback_policy
-> auto cleanup
```

## Future FX Definition Candidates

Future data structures may be useful after atlas mapping is validated:

```text
HackingFxDefinition.gd
HackingFxSpawnRequest.gd
```

Possible fields:

```text
fx_key
effect_category
atlas_path
region_rect
frame_count
fps
loop
blend_mode
default_alpha
anchor_type
default_z_index
duration_seconds
auto_free
follow_target
```

This task does not create those scripts or resources.

## Example Mapping

Coordinates are intentionally `TBD`.

| fx_key | category | trigger_hint | target | frames | fps | loop | blend | anchor | z | notes |
| --- | --- | --- | --- | --- | ---: | --- | --- | --- | ---: | --- |
| `avatar_dash_trail` | `avatar_feedback` | `player_dash` | `player` | `TBD` | `12` | `false` | `screen` | `player_center` | `60` | short dash feedback |
| `avatar_hit_flash` | `avatar_feedback` | `player_hit` | `player` | `TBD` | `10` | `false` | `add` | `player_center` | `60` | hurt feedback candidate |
| `projectile_trail_small` | `projectile_fx` | `projectile_travel` | `projectile` | `TBD` | `12` | `true` | `add` | `projectile_tip` | `55` | projectile body separate |
| `projectile_hit_impact` | `hit_impact` | `projectile_hit` | `hit_point` | `TBD` | `15` | `false` | `add` | `hit_point` | `60` | short impact |
| `enemy_hit_spark` | `enemy_feedback` | `enemy_hit` | `enemy` | `TBD` | `12` | `false` | `add` | `target_center` | `60` | enemy body separate |
| `enemy_death_dissolve` | `enemy_feedback` | `enemy_death` | `enemy` | `TBD` | `10` | `false` | `screen` | `target_center` | `60` | death feedback |
| `data_extract_beam` | `objective_fx` | `objective_extracting` | `data_core` | `TBD` | `8` | `true` | `add` | `objective_core` | `60` | extraction loop |
| `objective_complete_flash` | `objective_fx` | `objective_completed` | `objective` | `TBD` | `12` | `false` | `add` | `target_center` | `60` | complete feedback |
| `gate_unlock_pulse` | `gate_fx` | `gate_unlocked` | `exit_gate` | `TBD` | `10` | `false` | `add` | `gate_center` | `60` | exit opens |
| `firewall_burst` | `firewall_fx` | `firewall_disabled` | `firewall_generator` | `TBD` | `12` | `false` | `add` | `target_center` | `60` | disable feedback |
| `trace_warning_ring` | `trace_fx` | `trace_warning` | `player_or_arena` | `TBD` | `8` | `true` | `screen` | `player_center` | `70` | trace warning candidate |
| `alarm_sweep` | `alarm_fx` | `alarm_triggered` | `arena` | `TBD` | `8` | `true` | `screen` | `emitter_center` | `70` | alarm sweep candidate |
| `scan_line_horizontal` | `scan_fx` | `objective_started` | `arena` | `TBD` | `12` | `true` | `screen` | `screen_center` | `70` | arena overlay candidate |
| `corruption_splash` | `corruption_fx` | `hazard_active` | `hit_point` | `TBD` | `10` | `false` | `normal` | `hit_point` | `60` | corruption hazard feedback |
| `spawn_glitch` | `spawn_fx` | `spawn` | `enemy_or_object` | `TBD` | `12` | `false` | `screen` | `target_center` | `60` | spawn feedback |
| `shield_break` | `shield_fx` | `shield_break` | `target` | `TBD` | `14` | `false` | `add` | `target_center` | `60` | defense break candidate |

## Pre-Application Checklist

- [ ] Atlas PNG uses transparent background.
- [ ] FX regions do not overlap each other.
- [ ] Animated frames share the same `frame_width` / `frame_height`.
- [ ] Frame anchors do not jitter.
- [ ] `fx_key` uses lowercase `snake_case`.
- [ ] FX category and `trigger_hint` are documented.
- [ ] FX and avatar / enemy / object / projectile / tile bodies are not mixed.
- [ ] Room `qv_fx_atlas.png` and hacking `hack_fx_atlas.png` are not mixed.
- [ ] Blend / alpha candidates are documented.
- [ ] Playback policy is documented.
- [ ] Target anchor is clear.
- [ ] Effects do not read too much like UI.
- [ ] Effects fit cyber arena feedback rather than fantasy spell visuals.
- [ ] Effects do not damage player / enemy / object readability.

## Future Application Order

1. Prepare final `hack_fx_atlas.png` asset.
2. Add PNG to the expected atlas path.
3. Write `fx_key`, rect, and frame metadata list.
4. Decide mapping format: Resource, JSON, CSV, or another explicit file.
5. Create an FX region viewer prototype.
6. Create `HackingFxAtlasPrototype`.
7. Verify static FX and animated FX display.
8. Check readability in `HackingPerspectiveBlockout`.
9. Consider mock trigger connection from `HackingActionPrototype` events.
10. Review actual state machine / objective / enemy / projectile event wiring separately.

## Non-Goals

- Do not add `hack_fx_atlas.png`.
- Do not create mapping JSON / CSV / `.tres`.
- Do not create `AtlasTexture`, `SpriteFrames`, ShaderMaterial, or FX Resources.
- Do not modify `HackingActionPrototype`.
- Do not modify `HackingPrototypeProjectile.gd`.
- Do not modify `HackingPrototypeEnemy.gd`.
- Do not modify `HackingPerspectiveBlockout`.
- Do not modify `HackingMissionDefinition.gd`.
- Do not implement gameplay triggers.
- Do not implement particle systems.
- Do not connect SFX.
- Do not connect this atlas to Main, DAY 1, Laptop, Result, Grid Credit, or Story flags.
