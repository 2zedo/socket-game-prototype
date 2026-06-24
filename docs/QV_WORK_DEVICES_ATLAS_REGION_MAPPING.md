# QV Work Devices Atlas Region Mapping

## Purpose

This document defines the future region mapping rules for `qv_work_devices_atlas.png`.

The atlas is for quarterview room work devices, hacking devices, and information-labor equipment body sprites. It is separate from furniture, appliances, cable visuals, room shell layers, UI icons, player sprites, and FX overlays.

Screen glow, waveform, NODE-17 pulse, signal wave, warning flash, scan effects, and other localized state FX should be separated into `qv_fx_atlas.png` rather than baked into work-device body regions.

This document does not add the actual atlas PNG, does not create a JSON / CSV / `.tres` mapping file, and does not wire work-device visuals into `QuarterviewGameplaySandbox`, `QuarterviewRoomShellPrototype`, Main, or DAY 1.

## Atlas File

Future atlas file:

```text
res://assets/rooms/quarterview/atlases/qv_work_devices_atlas.png
```

Source / reference candidate folders:

```text
res://assets/rooms/quarterview/atlases/source/
res://assets/rooms/quarterview/atlases/reference/
```

Basic file criteria:

- PNG
- RGBA / transparent background
- Same art direction as the quarterview room
- Work / hacking / information device body only
- No player sprite
- No UI labels or text
- No room shell floor / wall / window / foreground
- No furniture body
- No living appliance body
- No cable-only sprites
- No full-screen UI panels

## Atlas Role

`qv_work_devices_atlas.png` is a future atlas candidate for managing sprite bodies for devices directly related to Yui's work, hacking, signal work, and information labor.

Godot can later use `AtlasTexture`, region rect data, and a Resource / JSON / CSV mapping layer to cut out each region.

This task only defines the rules. It does not create the atlas image or the mapping file.

## RoomObjectDefinition Relationship

`RoomObjectDefinition` owns room object contract data such as `key`, `display_name`, `zone`, `role`, `future_source`, and `visual_state`.

The work-device atlas mapping is only a visual representation candidate.

Connection candidates:

- `room_object_key` <-> `RoomObjectDefinition.key`
- `role` <-> `RoomObjectDefinition.role`
- `future_source` <-> `RoomObjectDefinition.future_source`
- `visual_state` <-> `RoomObjectDefinition.visual_state`
- `region_key` <-> actual visual region

Examples:

```text
laptop_open
- room_object_key: laptop
- role: laptop_job
- future_source: apartment_laptop
- visual_state: on

node17_idle
- room_object_key: node17
- role: mystery_device
- future_source: node17_story_device
- visual_state: idle

speaker_analyzer_idle
- room_object_key: speaker
- role: audio_hacking_device
- future_source: audio_signal_analysis
- visual_state: idle
```

`RoomObjectDefinition.gd` and existing `.tres` files are not changed by this document. Actual visual wiring belongs to a future mapping layer.

## DeviceDefinition Relationship

`DeviceDefinition` currently owns DAY 1 plug-in device data: outlet slots, active drain, display name, and Result flag candidates.

Some work-device atlas regions may correspond to `DeviceDefinition` keys.

Connection candidates:

- `device_key` <-> `DeviceDefinition.device_key`
- `outlet_slots` <-> `DeviceDefinition.outlet_slots`
- `drain_per_game_hour` <-> `DeviceDefinition.drain_per_game_hour`
- `result_flag_key` <-> `DeviceDefinition.result_flag_key`

Examples:

```text
laptop_open
- device_key: laptop
- uses outlet / power system candidate
- 2-slot device candidate

communication_device_active
- device_key: communication
- 1-slot device candidate
- signal / communication work device candidate
```

Visual atlas mapping does not replace `DeviceDefinition`. This document does not modify `DeviceDefinition.gd` or existing `.tres` values.

## HackingMissionDefinition Relationship

`HackingMissionDefinition` can later use `required_device_keys` and `recommended_device_keys` to express which room devices matter for a mission.

Work-device visuals can give the player a clear room-side reason why a mission is available, blocked, easier, or riskier.

Connection candidates:

- `HackingMissionDefinition.required_device_keys`
- `HackingMissionDefinition.recommended_device_keys`
- `qv_work_devices_atlas` `region_key`
- `RoomObjectDefinition.key`
- `DeviceDefinition.device_key`

Examples:

```text
required_device_keys = ["laptop"]
-> laptop_open / laptop_working region candidate

required_device_keys = ["node17"]
-> node17_idle / node17_active region candidate

recommended_device_keys = ["speaker", "signal_booster"]
-> speaker_analyzer_idle / signal_booster_idle region candidate
```

This document does not modify `HackingMissionDefinition.gd`, does not start missions, and does not wire laptop interaction into hacking gameplay.

## Region Key Naming

Region keys use:

- `snake_case`
- lowercase
- device key + state / variation
- suffix when state exists
- no temporary numbers
- no `final`, `new`, or `tmp`

Good examples:

- `laptop_closed`
- `laptop_open`
- `laptop_working`
- `phone_idle`
- `phone_charging`
- `phone_low`
- `communication_device_idle`
- `communication_device_active`
- `node17_idle`
- `node17_active`
- `node17_warning`
- `speaker_analyzer_idle`
- `speaker_analyzer_active`
- `signal_booster_idle`
- `signal_booster_active`

Bad examples:

- `sprite1`
- `item_001`
- `hacking_device2_final_new`
- `tmp_laptop`
- `image_05`
- `object_a`

State / variation suffix candidates:

- `_base`
- `_idle`
- `_active`
- `_off`
- `_on`
- `_open`
- `_closed`
- `_working`
- `_charging`
- `_low`
- `_warning`
- `_error`
- `_connected`
- `_disconnected`
- `_damaged`

This document does not create variation sprites.

## Mapping Schema

Future mapping records should include the following fields. This task does not create JSON, CSV, `.tres`, `AtlasTexture`, or any other mapping resource.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `region_key` | `String` | Atlas region identifier | `laptop_open` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/rooms/quarterview/atlases/qv_work_devices_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `pivot_x` | `float` | Sprite pivot x | `TBD` |
| `pivot_y` | `float` | Sprite pivot y | `TBD` |
| `anchor_type` | `String` | Placement anchor | `on_surface` |
| `default_z_index` | `int` | Default display order | `35` |
| `room_object_key` | `String` | `RoomObjectDefinition` key | `laptop` |
| `device_key` | `String` | `DeviceDefinition` key candidate | `laptop` |
| `work_device_category` | `String` | Work-device category | `computing` |
| `role` | `String` | `RoomObjectDefinition.role` candidate | `laptop_job` |
| `future_source` | `String` | Future system / source candidate | `apartment_laptop` |
| `visual_state` | `String` | Visual state | `open` |
| `mission_device_key` | `String` | Mission required / recommended key candidate | `laptop` |
| `power_model_hint` | `String` | Power-system hint | `outlet_powered` |
| `collision_hint` | `String` | Collision candidate | `small_static` |
| `interaction_hint` | `String` | Interaction candidate | `open_work_or_mission_list` |
| `occlusion_hint` | `String` | Foreground / player relation candidate | `above_furniture` |
| `notes` | `String` | Notes | `candidate only` |

Example candidate record:

```text
region_key: laptop_open
atlas_path: res://assets/rooms/quarterview/atlases/qv_work_devices_atlas.png
rect: TBD
pivot: TBD
anchor_type: on_surface
default_z_index: 35
room_object_key: laptop
device_key: laptop
work_device_category: computing
role: laptop_job
future_source: apartment_laptop
visual_state: open
mission_device_key: laptop
power_model_hint: outlet_powered
collision_hint: small_static
interaction_hint: open_work_or_mission_list
occlusion_hint: above_furniture
notes: candidate only
```

## Future Mapping Format Candidates

### Resource

Candidate paths:

```text
godot/scripts/resources/AtlasRegionDefinition.gd
godot/resources/rooms/quarterview/atlases/qv_work_devices_atlas_regions.tres
```

Pros:

- Editable in Godot inspector
- Consistent with the Resource pipeline
- Easy to connect to `RoomObjectDefinition`, `DeviceDefinition`, and `HackingMissionDefinition`

Cons:

- Bulk region editing can be tedious

### JSON

Candidate path:

```text
godot/assets/rooms/quarterview/atlases/qv_work_devices_atlas_regions.json
```

Pros:

- Easy to integrate with external tools or spreadsheets
- Good for bulk region management

Cons:

- Lower Godot type safety
- Requires parsing code

### CSV

Candidate path:

```text
godot/assets/rooms/quarterview/atlases/qv_work_devices_atlas_regions.csv
```

Pros:

- Easy spreadsheet editing

Cons:

- Weak support for state variation or nested metadata

Current recommendation:

- Keep this document as the source of criteria for now.
- Leave Resource / JSON open as likely future candidates.
- Decide after the actual atlas exists and the number of work-device regions / state variations is known.

## Work Device Categories

Category candidates:

- `computing`
- `communication`
- `mystery_device`
- `audio_analysis`
- `signal_support`
- `portable_terminal`
- `storage_module`
- `monitoring`

Examples:

| Region Key | Category |
| --- | --- |
| `laptop_open` | `computing` |
| `phone_idle` | `communication` |
| `communication_device_active` | `communication` |
| `node17_idle` | `mystery_device` |
| `speaker_analyzer_idle` | `audio_analysis` |
| `signal_booster_idle` | `signal_support` |
| `data_module_candidate` | `storage_module` |
| `small_monitor_candidate` | `monitoring` |

## Work Device / Furniture / Appliance / Cable Split

### `qv_work_devices_atlas.png` Includes

- laptop
- phone
- communication device
- NODE-17
- speaker / audio hacking analyzer
- signal booster
- portable terminal candidate
- data module candidate
- small monitor candidate
- hacking / work related device body

### `qv_work_devices_atlas.png` Excludes

- bed
- desk
- chair
- shelf
- cabinet
- rug
- plant pot
- fridge
- microwave
- aircon
- fluorescent light
- outlet
- plug
- cable-only sprites
- power strip body, if treated as cable / power atlas
- room shell floor / wall / window / foreground
- UI icons
- player sprite

Other atlas candidates:

- `qv_furniture_atlas.png`
- `qv_appliances_atlas.png`
- `qv_cable_atlas.png`
- `qv_props_atlas.png`
- `qv_fx_atlas.png`

Speaker is not decorative furniture. It is an audio hacking / signal-analysis device candidate and belongs in the work-devices atlas.

NODE-17 is a `mystery_device` and core story / signal / forbidden-log device candidate.

Charger, plug, and cable-only sprites should generally belong to a cable / power atlas rather than this work-devices atlas.

## Pivot And Anchor Criteria

Default placement rules:

- Desk-top devices use `on_surface`.
- Floor-standing devices use `bottom_center`.
- Wall-mounted devices use `wall_center` or `top_center`.
- Small devices use `center` or `bottom_center`, depending on placement.
- State variations must keep the same anchor.
- Visual pivot, collision, and interaction range are separate.

Device candidates:

```text
laptop:
- anchor_type = on_surface
- desk placement candidate

phone:
- anchor_type = on_surface
- bed / desk nearby placement candidate

communication_device:
- anchor_type = bottom_center or on_surface

NODE-17:
- anchor_type = bottom_center or wall_center
- can be independent device or wall device depending on room direction

speaker_analyzer:
- anchor_type = on_surface or bottom_center
- audio_hacking_device, not decoration

signal_booster:
- anchor_type = wall_center or bottom_center
```

Pivot / anchor is a visual placement rule.

Collision and interaction range are managed separately through `Area2D`, `RoomObjectDefinition`, or `RoomSceneContract`.

## Z-Index And Y-Sort Criteria

Layer candidate values:

| Layer | Z |
| --- | --- |
| `FloorLayer` | `0` |
| `WindowCityViewLayer` | `8` |
| `BackWallLayer` | `10` |
| `SideWallLayer` | `15` |
| `FurnitureLayer` | `30` |
| `ApplianceLayer` | `34` |
| `DeviceLayer` | `35` |
| `PlayerLayer` | `40` |
| `ObjectHighlightLayer` | `50` |
| `ForegroundOccluderLayer` | `80` |
| `StaticLightingOverlayLayer` | `90` |
| `InteractionPromptLayer` | `100` |
| `UILayer` | `1000` |

Work device default:

```text
default_z_index = 35
```

Exceptions:

- Laptop on desk: above desk; below or near player depth candidate; z-index `35`.
- Phone on bed / desk: must appear above parent furniture; parent placement needs composition checks.
- NODE-17 floor-standing: can overlap with player; Y-sort candidate.
- Wall-mounted signal booster: above back wall, below player, z-index `20` to `35` candidate.

Y-sort candidates:

- If tall device / player overlap becomes frequent, use `YSort` or y-position-based z-index.
- MVP can start with fixed z-index plus foreground occluder.
- If player position needs tuning, keep visual anchor and collision separate.

## State Variation Criteria

State candidates:

- `base`
- `off`
- `on`
- `idle`
- `active`
- `open`
- `closed`
- `working`
- `connected`
- `disconnected`
- `charging`
- `low`
- `warning`
- `error`
- `damaged`

Device state candidates:

```text
laptop:
- closed
- open
- working
- error

phone:
- idle
- charging
- low
- notification

communication_device:
- idle
- active
- no_signal
- connected

NODE-17:
- idle
- active
- warning
- locked
- unlocked

speaker_analyzer:
- idle
- active
- analyzing

signal_booster:
- idle
- active
- failed
```

This document only defines naming rules. It does not create state sprites.

## Screen / Glow / Signal FX Split

The work-devices atlas should contain device bodies, not full-screen UI, glow systems, or hacking FX.

Allowed in work-device body sprites:

- laptop body
- phone body
- communication device body
- NODE-17 body
- speaker / analyzer body
- signal booster body
- small indicator lights when they are part of the body

Split into FX / lighting layers:

- laptop screen glow
- phone screen glow
- NODE-17 pulse / glitch
- signal wave
- warning flash
- data scan effect
- speaker waveform visualizer
- hacking mission effect
- whole-room reflection

Other visual candidates:

- `qv_fx_atlas.png`
- `qv_room_static_lighting_overlay.png`
- `qv_room_neon_reflection_overlay.png`

Screen glow should not be strongly baked into body sprites. If it is baked too heavily, later on / off, battery, signal, and mission-state changes become harder to express.

## Example Mapping Table

Coordinates are intentionally `TBD`. Do not treat this table as final atlas data.

| region_key | room_object_key | device_key | category | role | visual_state | rect | anchor | z | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `laptop_open` | `laptop` | `laptop` | `computing` | `laptop_job` | `open` | `TBD` | `on_surface` | `35` | desk placed, mission list candidate |
| `laptop_working` | `laptop` | `laptop` | `computing` | `laptop_job` | `working` | `TBD` | `on_surface` | `35` | screen / FX should be separate |
| `phone_idle` | `phone` | `phone` | `communication` | `phone_status` | `idle` | `TBD` | `on_surface` | `35` | phone panel candidate |
| `communication_device_active` | `comm` | `communication` | `communication` | `communication` | `active` | `TBD` | `bottom_center` | `35` | signal device candidate |
| `node17_idle` | `node17` | `node17` | `mystery_device` | `mystery_device` | `idle` | `TBD` | `bottom_center` | `35` | story / mystery device candidate |
| `speaker_analyzer_idle` | `speaker` | `speaker` | `audio_analysis` | `audio_hacking_device` | `idle` | `TBD` | `on_surface` | `35` | not decorative furniture |
| `signal_booster_idle` | `signal_booster` | `signal_booster` | `signal_support` | `support_device` | `idle` | `TBD` | `wall_center` | `35` | mission support candidate |

## Pre-Application Checklist

- [ ] Atlas PNG has transparent background.
- [ ] Regions do not overlap.
- [ ] Each region rect fully contains the sprite.
- [ ] Device edges are not cropped.
- [ ] `region_key` uses `snake_case`.
- [ ] `room_object_key` / `device_key` / `mission_device_key` relationship is documented.
- [ ] Pivot / anchor is clear.
- [ ] Work device, furniture, appliance, and cable categories are not mixed.
- [ ] State variations keep stable anchors.
- [ ] Screen glow / FX are not over-baked into device body sprites.
- [ ] Room shell perspective matches.
- [ ] Desk / bed / furniture placement relation is natural.
- [ ] Player scale matches.
- [ ] Foreground occluder / lighting overlay does not conflict.
- [ ] Interaction prompt is not hidden by device body.

## Future Application Order

1. Prepare final `qv_work_devices_atlas.png` asset.
2. Add PNG to the atlas path.
3. Write region key and rect list.
4. Decide mapping format: Resource, JSON, or CSV.
5. Create `AtlasTexture` or region loader prototype.
6. Create `QuarterviewWorkDevicesAtlasPrototype`.
7. Check every region visually.
8. Review links to `RoomObjectDefinition`, `DeviceDefinition`, and `HackingMissionDefinition`.
9. Test work-device placement in `QuarterviewGameplaySandbox`.
10. Check state variation / screen glow / signal FX separation.

## Non-Goals

This document does not:

- Add actual PNG assets
- Generate or resize images
- Create `AtlasTexture`
- Create JSON / CSV / `.tres` mapping files
- Modify scenes
- Modify `HackingMissionDefinition.gd`
- Modify `DeviceDefinition.gd`
- Modify `RoomObjectDefinition.gd`
- Wire work-device art into `QuarterviewGameplaySandbox`
- Connect laptop to hacking gameplay
- Change Main / DAY 1
