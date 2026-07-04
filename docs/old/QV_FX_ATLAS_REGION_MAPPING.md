# QV FX Atlas Region Mapping

## Purpose

This document defines the future region mapping rules for `qv_fx_atlas.png`.

The atlas is for localized quarterview room visual effects: screen glow, status light, warning flash, spark, signal wave, pulse, scan line, waveform, glitch, charging effect, and small localized flicker. It is separate from room shell layers, furniture bodies, appliance bodies, work-device bodies, cable bodies, player sprites, and UI.

This task only defines the rules. It does not add the actual atlas PNG, does not create a JSON / CSV / `.tres` mapping file, and does not wire FX visuals into any scene.

`qv_fx_atlas.png` is for quarterview room localized FX. Hacking arena gameplay FX should use `hack_fx_atlas.png` instead.

## Atlas File

Future atlas file:

```text
qv_fx_atlas.png
```

Expected future Godot path:

```text
res://assets/rooms/quarterview/atlases/qv_fx_atlas.png
```

Source / reference candidates:

```text
res://assets/rooms/quarterview/atlases/source/
res://assets/rooms/quarterview/atlases/reference/
```

Format criteria:

- PNG
- RGBA / transparent background
- localized FX only
- no full room shell background
- no player sprite
- no UI panel
- no furniture body
- no appliance body
- no work device body
- no cable body
- no wall / floor / window / foreground layer
- animation frames may be arranged as strips or grids
- alpha edge cleanup required

## Atlas Role

`qv_fx_atlas.png` stores visual effects that can be placed on top of other room objects or triggered by future state changes. It should not own the object body.

Examples:

- laptop body: `qv_work_devices_atlas.png`
- laptop screen glow: `qv_fx_atlas.png`
- fluorescent fixture body: `qv_appliances_atlas.png` or fixture candidate atlas
- fluorescent flicker / local glow: `qv_fx_atlas.png` or static lighting overlay candidate, depending on scale
- city view: `qv_room_window_city_view.png`
- full-room mood light: `qv_room_static_lighting_overlay.png`
- device pulse / glow / spark: `qv_fx_atlas.png`

## Static Lighting Overlay Split

`qv_room_static_lighting_overlay.png` and related full-room overlays handle:

- full room base lighting
- vignette
- warm work-light mood
- base cold glow near window
- always-on night mood

`qv_fx_atlas.png` handles:

- object-attached screen glow
- status LEDs
- short spark
- signal wave
- warning blink
- NODE-17 pulse
- scan line
- hacking trace noise
- local effects toggled by state

Split rules:

- Full-room effect: static lighting overlay.
- Object-local effect: `qv_fx_atlas.png`.
- State on / off effect: `qv_fx_atlas.png`.
- Always fixed mood: static lighting overlay.

## Data Link Candidates

Future FX mappings may reference several data sources. These are candidates only; no wiring exists yet.

| Source | Candidate Link | Example |
| --- | --- | --- |
| `RoomObjectDefinition` | `room_object_key`, `role`, `visual_state` | `laptop` / `laptop_job` / `working` -> `laptop_screen_glow_working` |
| `DeviceDefinition` | `device_key`, active / inactive, connected / disconnected, result flag | `laptop` active -> `laptop_screen_glow_working` |
| `LivingDeviceDefinition` | `living_device_key`, power model, visual state | `fluorescent_light` warning -> `fluorescent_flicker_soft` |
| `HackingMissionDefinition` | `mission_type`, `trace_risk`, `required_device_keys`, mission state | `signal_trace` running -> `signal_wave_scan` |

## Region Key Naming

Region keys use lowercase `snake_case`.

Naming pattern:

```text
<target_object_or_device>_<effect_type>_<state_or_variant>
```

Animation suffixes are allowed when needed:

```text
_anim
_loop
_once
```

Good examples:

```text
laptop_screen_glow_idle
laptop_screen_glow_working
phone_screen_glow_low
node17_pulse_idle
node17_warning_flash
speaker_waveform_idle
speaker_waveform_active
signal_wave_scan
signal_booster_pulse
ups_warning_blink
charging_spark_small
plug_spark_short
microwave_glow_active
fluorescent_flicker_soft
data_scan_line
hacking_trace_noise
```

Bad examples:

```text
fx1
effect_001
glow_final_new
tmp_spark
image_05
node_fx_a
```

Suffix candidates:

```text
_idle
_active
_working
_low
_warning
_error
_short
_soft
_loop
_once
_anim
_small
_large
```

Do not use `temp`, `final`, `new`, or implementation-stage labels in region keys.

## FX Categories

Category candidates:

```text
screen_glow
status_light
signal_wave
warning_flash
spark
scan_line
waveform
pulse
glitch
charging
flicker
ambient_particle
```

Examples:

| FX Key | Category |
| --- | --- |
| `laptop_screen_glow_working` | `screen_glow` |
| `phone_screen_glow_low` | `screen_glow` |
| `node17_pulse_idle` | `pulse` |
| `node17_warning_flash` | `warning_flash` |
| `speaker_waveform_active` | `waveform` |
| `signal_wave_scan` | `signal_wave` |
| `ups_warning_blink` | `warning_flash` |
| `plug_spark_short` | `spark` |
| `fluorescent_flicker_soft` | `flicker` |
| `data_scan_line` | `scan_line` |
| `hacking_trace_noise` | `glitch` |

## Region Mapping Schema

Future FX mapping should be able to describe static regions and animated regions.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `fx_key` | `String` | FX region identifier | `laptop_screen_glow_working` |
| `atlas_path` | `String` | atlas PNG path | `res://assets/rooms/quarterview/atlases/qv_fx_atlas.png` |
| `rect_x` | `int` | region start x in atlas | `TBD` |
| `rect_y` | `int` | region start y in atlas | `TBD` |
| `rect_w` | `int` | region width | `TBD` |
| `rect_h` | `int` | region height | `TBD` |
| `frame_count` | `int` | animation frame count | `4` |
| `frame_width` | `int` | width of one frame | `TBD` |
| `frame_height` | `int` | height of one frame | `TBD` |
| `fps` | `float` | playback speed | `8.0` |
| `loop` | `bool` | whether playback repeats | `true` |
| `pivot_x` | `float` | region pivot x | `TBD` |
| `pivot_y` | `float` | region pivot y | `TBD` |
| `anchor_type` | `String` | placement anchor | `screen_center` |
| `target_object_key` | `String` | `RoomObjectDefinition.key` | `laptop` |
| `target_device_key` | `String` | `DeviceDefinition.key` candidate | `laptop` |
| `target_living_device_key` | `String` | `LivingDeviceDefinition.key` candidate | `fluorescent_light` |
| `effect_category` | `String` | FX category | `screen_glow` |
| `visual_state` | `String` | target visual state | `working` |
| `trigger_hint` | `String` | future trigger candidate | `device_active` |
| `blend_mode` | `String` | blend candidate | `add` |
| `default_alpha` | `float` | default opacity | `0.7` |
| `default_z_index` | `int` | default z-index | `60` |
| `duration_seconds` | `float` | one-shot effect duration | `0.5` |
| `playback_policy` | `String` | playback behavior | `loop` |
| `notes` | `String` | notes | `candidate only` |

This document does not create an actual mapping file. Coordinates remain `TBD` until the atlas PNG exists.

## Animation Frame Layout

### Static FX

Examples:

```text
laptop_screen_glow_idle
phone_screen_glow_low
```

Criteria:

```text
frame_count = 1
loop = false
playback_policy = hold
```

### Animated FX Strip

Examples:

```text
signal_wave_scan
speaker_waveform_active
fluorescent_flicker_soft
```

Criteria:

- `frame_count >= 2`
- frames are arranged left-to-right by default
- each frame has the same `frame_width` / `frame_height`
- no background
- transparent padding is allowed
- pivot / anchor must remain stable across frames

### Animated FX Grid

Grid layout is a later candidate for complex FX:

```text
row = variation
column = frame
```

Initial recommendation:

- Use left-to-right strips first.
- Consider grids only when frame counts or variations become hard to manage in strips.

## Future Mapping Format Candidates

### Resource

Candidate files:

```text
godot/scripts/resources/FxRegionDefinition.gd
godot/resources/rooms/quarterview/atlases/qv_fx_atlas_regions.tres
```

Pros:

- editable in Godot inspector
- playback, blend, and trigger metadata can be typed

Cons:

- bulk region editing may be tedious

### JSON

Candidate file:

```text
godot/assets/rooms/quarterview/atlases/qv_fx_atlas_regions.json
```

Pros:

- easy to connect with external tools or spreadsheets
- suitable for frame / trigger metadata

Cons:

- lower Godot type safety
- parsing code required

### CSV

Candidate file:

```text
godot/assets/rooms/quarterview/atlases/qv_fx_atlas_regions.csv
```

Pros:

- spreadsheet editing is easy

Cons:

- animation metadata becomes hard to manage as columns grow

Current recommendation:

- Keep document + Resource / JSON options open.
- If the number of FX regions stays small, Resource is a strong candidate.
- If many FX regions need repeated coordinate tuning, JSON is worth considering.

## FX / Body Atlas Split

### `qv_fx_atlas.png` Includes

- screen glow
- status light
- warning flash
- spark
- signal wave
- waveform
- pulse
- scan line
- glitch / noise
- charging effect
- small localized flicker
- small localized particle

### `qv_fx_atlas.png` Excludes

- laptop body
- phone body
- NODE-17 body
- speaker body
- signal booster body
- fridge / microwave / aircon body
- furniture body
- cable / plug body
- room floor / wall / window / foreground
- full-room static lighting
- full-room shadow overlay
- UI panel
- player sprite

Other atlas / layer candidates:

```text
qv_work_devices_atlas.png
qv_appliances_atlas.png
qv_furniture_atlas.png
qv_cable_atlas.png
qv_props_atlas.png
qv_room_static_lighting_overlay.png
qv_room_neon_reflection_overlay.png
```

Cable body sprites belong to `qv_cable_atlas.png`, while sparks, glow, warning flashes, signal waves, and other localized visual effects belong to `qv_fx_atlas.png`.

## Pivot And Anchor Criteria

Default placement rules:

- Object-attached FX use target-relative anchors.
- Screen glow uses screen area center.
- Signal wave uses emitter center.
- Spark uses plug / contact point.
- Warning blink uses device status light point.
- Waveform uses speaker / display area.
- Full-room fixed effects should usually be handled by room overlay layers instead of `qv_fx_atlas.png`.

Anchor type candidates:

```text
target_center
screen_center
status_light_point
plug_contact_point
emitter_center
top_center
bottom_center
custom_offset
```

FX pivot / anchor is visual placement metadata only. Collision and interaction range are not managed by FX.

Target object regions and FX regions should either share a compatible anchor system or define a separate offset in the mapping metadata.

## Z-Index And Layer Criteria

Layer candidates:

| Layer | z-index | Role |
| --- | ---: | --- |
| `FloorLayer` | `0` | floor visual |
| `WindowCityViewLayer` | `8` | city view behind wall/window |
| `BackWallLayer` | `10` | back wall |
| `SideWallLayer` | `15` | side wall |
| `FurnitureLayer` | `30` | furniture bodies |
| `ApplianceLayer` | `34` | appliance bodies |
| `DeviceLayer` | `35` | work-device bodies |
| `PlayerLayer` | `40` | player |
| `ObjectHighlightLayer` | `50` | highlights |
| `FxLayer` | `60` | localized FX |
| `ForegroundOccluderLayer` | `80` | foreground occluders |
| `StaticLightingOverlayLayer` | `90` | full-room lighting / shadow overlay |
| `InteractionPromptLayer` | `100` | prompts |
| `UILayer` | `1000` | UI |

FX default:

```text
default_z_index = 60
```

Exceptions:

- Screen glow: above device body, below foreground occluder, z-index `60` candidate.
- Spark: above device / cable, short one-shot effect, z-index `65` candidate.
- Warning flash: above target device, tuned so static lighting overlay does not bury it.
- Signal wave: above object or as a room effect candidate, but should not read like UI.
- Full-room noise / glitch: consider separate screen overlay rather than `qv_fx_atlas.png`.

UI, prompt, and debug layers should remain above FX by default.

## Blend And Alpha Criteria

Blend mode candidates:

```text
normal
add
screen
modulate
multiply
```

Default candidates:

| Category | Blend Candidate | Alpha Candidate |
| --- | --- | --- |
| `screen_glow` | `add` or `screen` | `0.4` to `0.8` |
| `status_light` | `normal` or `add` | `0.7` to `1.0` |
| `spark` | `add` | short duration |
| `signal_wave` | `add` or `normal` | `0.3` to `0.7` |
| `glitch` / `noise` | `normal` or `screen` | depends on duration |

Godot blend behavior depends on Material, CanvasItem, and possible shader choices. This document records candidates only.

## Playback And Trigger Criteria

`trigger_hint` candidates:

```text
device_active
device_inactive
device_connected
device_disconnected
device_low_power
device_warning
mission_available
mission_running
mission_failed
mission_success
phone_charging
power_connected
power_error
story_signal
debug_only
```

`playback_policy` candidates:

```text
once
loop
hold
pingpong
random_flicker
```

Examples:

| FX Key | Trigger Hint | Playback Policy |
| --- | --- | --- |
| `laptop_screen_glow_working` | `device_active` | `loop` |
| `charging_spark_small` | `power_connected` | `once` |
| `fluorescent_flicker_soft` | `low_power_or_warning` | `random_flicker` |

This document does not implement the trigger system.

## Example Mapping

Coordinates are intentionally `TBD`. The actual values should be extracted only after `qv_fx_atlas.png` exists.

| fx_key | target_object_key | category | visual_state | frames | fps | loop | blend | anchor | z | notes |
| --- | --- | --- | --- | --- | ---: | --- | --- | --- | ---: | --- |
| `laptop_screen_glow_working` | `laptop` | `screen_glow` | `working` | `TBD` | `8` | `true` | `add` | `screen_center` | `60` | body is in `qv_work_devices_atlas.png` |
| `phone_screen_glow_low` | `phone` | `screen_glow` | `low` | `TBD` | `4` | `true` | `add` | `screen_center` | `60` | low battery candidate |
| `node17_pulse_idle` | `node17` | `pulse` | `idle` | `TBD` | `6` | `true` | `add` | `target_center` | `60` | story signal candidate |
| `node17_warning_flash` | `node17` | `warning_flash` | `warning` | `TBD` | `10` | `true` | `add` | `status_light_point` | `65` | warning only, no story logic yet |
| `speaker_waveform_active` | `speaker` | `waveform` | `active` | `TBD` | `12` | `true` | `screen` | `screen_center` | `60` | speaker is audio hacking device |
| `signal_wave_scan` | `signal_booster` | `signal_wave` | `active` | `TBD` | `8` | `true` | `add` | `emitter_center` | `60` | signal trace mission candidate |
| `ups_warning_blink` | `ups` | `warning_flash` | `low` | `TBD` | `6` | `true` | `add` | `status_light_point` | `65` | power storage warning candidate |
| `plug_spark_short` | `power` | `spark` | `connected` | `TBD` | `15` | `false` | `add` | `plug_contact_point` | `65` | cable / power body separate |
| `fluorescent_flicker_soft` | `fluorescent_light` | `flicker` | `warning` | `TBD` | `8` | `true` | `screen` | `target_center` | `60` | full room lighting still separate |

## Pre-Application Checklist

- [ ] Atlas PNG has a transparent background.
- [ ] FX regions do not overlap each other.
- [ ] Animated frames have the same `frame_width` / `frame_height`.
- [ ] Anchors do not jitter across frames.
- [ ] `fx_key` values use lowercase `snake_case`.
- [ ] `target_object_key` / `target_device_key` relationships are documented.
- [ ] FX and device / appliance / furniture / cable bodies are not mixed.
- [ ] Full-room lighting is not included in `qv_fx_atlas.png`.
- [ ] Glow is not baked so strongly that body sprite replacement becomes difficult.
- [ ] Blend / alpha candidates are documented.
- [ ] Playback policy is documented.
- [ ] Room shell perspective still matches.
- [ ] Player / object readability remains intact.
- [ ] Effects do not read like UI prompts.

## Future Application Order

Candidate order:

1. Prepare final `qv_fx_atlas.png` asset.
2. Add PNG to the expected atlas path.
3. Write `fx_key` and rect / frame metadata list.
4. Decide mapping format: Resource, JSON, or CSV.
5. Implement FX region loader prototype.
6. Create `QuarterviewFxAtlasPrototype`.
7. Check static FX and animated FX display.
8. Review anchors against work device and appliance target objects.
9. Mock trigger tests in `QuarterviewGameplaySandbox`.
10. Review real device state, mission state, and power state wiring.

## Non-Goals

- Do not add `qv_fx_atlas.png` in this task.
- Do not create `FxRegionDefinition.gd`.
- Do not create mapping JSON / CSV / `.tres`.
- Do not create `AtlasTexture` or `SpriteFrames`.
- Do not place FX in any scene.
- Do not connect FX to `DeviceDefinition`, `LivingDeviceDefinition`, `HackingMissionDefinition`, `SurvivalState`, Main, or DAY 1.
- Do not bake full-room lighting into localized FX.
