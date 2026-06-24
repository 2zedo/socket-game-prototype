# QV Appliances Atlas Region Mapping

## Purpose

This document defines the future region mapping rules for `qv_appliances_atlas.png`.

The atlas is for quarterview room appliance, life-support, fixture, and power-support device body sprites. It is separate from furniture, hacking / work devices, cable visuals, room shell layers, UI icons, player sprites, and FX overlays.

This document does not add the actual atlas PNG, does not create a JSON / CSV / `.tres` mapping file, and does not wire appliance visuals into `QuarterviewGameplaySandbox`, `QuarterviewRoomShellPrototype`, Main, or DAY 1.

## Atlas File

Future atlas file:

```text
res://assets/rooms/quarterview/atlases/qv_appliances_atlas.png
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
- Appliance / life-support device body only
- No player sprite
- No UI labels or text
- No room shell floor / wall / window / foreground
- No furniture body
- No hacking / work device body
- No cable-only sprites

## Atlas Role

`qv_appliances_atlas.png` is a future atlas candidate for managing fridge, microwave, air conditioner, fluorescent light, UPS, and similar living-device body sprites in one image.

Godot can later use `AtlasTexture`, region rect data, and a Resource / JSON / CSV mapping layer to cut out each region.

This task only defines the rules. It does not create the atlas image or the mapping file.

## LivingDeviceDefinition Relationship

`LivingDeviceDefinition` owns the data model for living appliances and life-support devices. The appliance atlas mapping is only a visual representation candidate.

Connection candidates:

- `living_device_key` <-> `LivingDeviceDefinition.device_key`
- `room_object_key` <-> `LivingDeviceDefinition.room_object_key`
- `device_type` <-> `LivingDeviceDefinition.device_type`
- `power_model` <-> `LivingDeviceDefinition.power_model`
- `visual_state` <-> future active / inactive / failed visual state

Examples:

```text
fridge_base
- living_device_key: fridge
- room_object_key: fridge
- device_type: continuous
- power_model: continuous
- visual_state: base

microwave_idle
- living_device_key: microwave
- room_object_key: microwave
- device_type: instant
- power_model: instant
- visual_state: idle

aircon_wall_unit
- living_device_key: aircon
- room_object_key: aircon
- device_type: environment
- power_model: continuous
- visual_state: base

fluorescent_light_on
- living_device_key: fluorescent_light
- room_object_key: fluorescent_light
- device_type: background_fixture
- power_model: dedicated_circuit
- visual_state: on

ups_unit
- living_device_key: ups
- room_object_key: ups
- device_type: storage
- power_model: storage
- visual_state: base
```

`LivingDeviceDefinition.gd` is not changed by this document. Actual data wiring belongs to a future mapping layer.

## Region Key Naming

Region keys use:

- `snake_case`
- lowercase
- appliance key + state / variation
- suffix when state exists
- no temporary numbers
- no `final`, `new`, or `tmp`

Good examples:

- `fridge_base`
- `fridge_active`
- `fridge_failed`
- `microwave_idle`
- `microwave_active`
- `aircon_wall_unit`
- `aircon_active`
- `fluorescent_light_off`
- `fluorescent_light_on`
- `ups_unit`
- `ups_charging`
- `ups_low`

Bad examples:

- `sprite1`
- `item_001`
- `appliance2_final_new`
- `tmp_fridge`
- `image_05`
- `object_a`

State / variation suffix candidates:

- `_base`
- `_idle`
- `_active`
- `_off`
- `_on`
- `_failed`
- `_low`
- `_charging`
- `_damaged`
- `_small`
- `_wall_unit`

This document does not create variation sprites.

## Mapping Schema

Future mapping records should include the following fields. This task does not create JSON, CSV, `.tres`, `AtlasTexture`, or any other mapping resource.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `region_key` | `String` | Atlas region identifier | `fridge_base` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/rooms/quarterview/atlases/qv_appliances_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `pivot_x` | `float` | Sprite pivot x | `TBD` |
| `pivot_y` | `float` | Sprite pivot y | `TBD` |
| `anchor_type` | `String` | Placement anchor | `bottom_center` |
| `default_z_index` | `int` | Default display order | `34` |
| `living_device_key` | `String` | `LivingDeviceDefinition` key | `fridge` |
| `room_object_key` | `String` | `RoomObjectDefinition` key | `fridge` |
| `appliance_category` | `String` | Appliance category | `food_storage` |
| `device_type` | `String` | `LivingDeviceDefinition.device_type` candidate | `continuous` |
| `power_model` | `String` | `LivingDeviceDefinition.power_model` candidate | `continuous` |
| `visual_state` | `String` | Visual state | `base` |
| `collision_hint` | `String` | Collision candidate | `static_blocker` |
| `interaction_hint` | `String` | Interaction candidate | `inspect_or_toggle` |
| `occlusion_hint` | `String` | Foreground / player relation candidate | `behind_player` |
| `notes` | `String` | Notes | `candidate only` |

Example candidate record:

```text
region_key: fridge_base
atlas_path: res://assets/rooms/quarterview/atlases/qv_appliances_atlas.png
rect: TBD
pivot: bottom_center
anchor_type: bottom_center
default_z_index: 34
living_device_key: fridge
room_object_key: fridge
appliance_category: food_storage
device_type: continuous
power_model: continuous
visual_state: base
collision_hint: static_blocker
interaction_hint: inspect_or_toggle
occlusion_hint: behind_player
notes: candidate only
```

## Future Mapping Format Candidates

### Resource

Candidate paths:

```text
godot/scripts/resources/AtlasRegionDefinition.gd
godot/resources/rooms/quarterview/atlases/qv_appliances_atlas_regions.tres
```

Pros:

- Editable in Godot inspector
- Consistent with the Resource pipeline
- Easy to connect to `LivingDeviceDefinition`

Cons:

- Bulk region editing can be tedious

### JSON

Candidate path:

```text
godot/assets/rooms/quarterview/atlases/qv_appliances_atlas_regions.json
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
godot/assets/rooms/quarterview/atlases/qv_appliances_atlas_regions.csv
```

Pros:

- Easy spreadsheet editing

Cons:

- Weak support for state variation or nested metadata

Current recommendation:

- Keep this document as the source of criteria for now.
- Leave Resource / JSON open as likely future candidates.
- Decide after the actual atlas exists and the number of appliance regions / state variations is known.

## Appliance Categories

Category candidates:

- `food_storage`
- `food_heating`
- `environment_control`
- `lighting_fixture`
- `power_storage`
- `maintenance`
- `wall_fixture`
- `utility`

Examples:

| Region Key | Category |
| --- | --- |
| `fridge_base` | `food_storage` |
| `microwave_idle` | `food_heating` |
| `aircon_wall_unit` | `environment_control` |
| `fluorescent_light_off` | `lighting_fixture` |
| `ups_unit` | `power_storage` |
| `wall_vent` | `wall_fixture` |
| `breaker_box_candidate` | `utility` |

## Appliance / Furniture / Work Device / Cable Split

### `qv_appliances_atlas.png` Includes

- fridge
- microwave
- aircon
- fluorescent light
- UPS, if treated as life-support / power-storage appliance
- wall vent
- simple utility fixture
- cooking unit candidate
- breaker box candidate

### `qv_appliances_atlas.png` Excludes

- bed
- desk
- chair
- shelf
- cabinet
- rug
- plant pot
- laptop
- phone
- charger
- NODE-17
- communication device
- speaker / audio hacking device
- signal booster
- outlet / plug / cable
- room shell floor / wall / window / foreground
- UI icons
- player sprite

Other atlas candidates:

- `qv_furniture_atlas.png`
- `qv_work_devices_atlas.png`
- `qv_props_atlas.png`
- `qv_cable_atlas.png`
- `qv_fx_atlas.png`

Speaker is not an appliance. It is a hacking / audio-analysis device candidate and should not be placed in the appliances atlas.

Fluorescent light is closer to a background fixture than a plug-in appliance, but it can be tracked through `qv_appliances_atlas.png` or a future fixture atlas because it is also a `LivingDeviceDefinition` candidate.

UPS can be treated as power storage / support. Whether it belongs in `qv_appliances_atlas.png` or `qv_work_devices_atlas.png` should be decided later. This document keeps it as an appliances-atlas candidate only.

Appliance body regions should keep strong glow, flicker, warning, and spark effects separate. Those localized effects may be mapped through `qv_fx_atlas.png` instead of being baked into appliance bodies.

Appliance body sprites should not include loose cable / plug detail unless it is inseparable from the object silhouette. Cable visuals are deferred to `qv_cable_atlas.png`.

## Pivot And Anchor Criteria

Default placement rules:

- Floor-standing appliances use `bottom_center`.
- Wall-mounted appliances use `wall_center` or `top_center`.
- Ceiling / upper-wall fixtures use `ceiling_or_wall_fixture`.
- Microwave-like objects that may sit on a desk or counter use `on_surface`.
- Visual pivot, collision, and interaction range are separate.
- State variations must keep the same anchor.

Device candidates:

```text
fridge:
- anchor_type = bottom_center

microwave:
- anchor_type = on_surface or bottom_center
- if placed on desk/counter, parent / placement rule needs a separate check

aircon:
- anchor_type = wall_center or top_center

fluorescent_light:
- anchor_type = ceiling_or_wall_fixture
- dedicated circuit candidate, not direct outlet slot

ups:
- anchor_type = bottom_center
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

Appliance default:

```text
default_z_index = 34
```

Exceptions:

- Wall-mounted aircon: above back wall, below player, z-index `20` to `35` candidate.
- Fluorescent light: high wall / ceiling fixture candidate; glow is separated into lighting overlay or FX.
- Microwave on desk: may need to render above the parent furniture; parent furniture composition must be checked.
- Fridge: floor-standing large appliance that can overlap with the player; Y-sort candidate.

Y-sort candidates:

- If tall appliance / player overlap becomes frequent, use `YSort` or y-position-based z-index.
- MVP can start with fixed z-index plus foreground occluder.
- If player position needs tuning, keep visual anchor and collision separate.

## State Variation Criteria

State candidates:

- `base`
- `off`
- `on`
- `idle`
- `active`
- `failed`
- `damaged`
- `charging`
- `low`
- `open`
- `closed`

Device state candidates:

```text
fridge:
- base
- active
- failed
- open / closed as later candidates

microwave:
- idle
- active
- finished candidate

aircon:
- off
- active
- failed

fluorescent_light:
- off
- on
- flicker candidate

ups:
- base
- charging
- low
- failed
```

This document only defines naming rules. It does not create state sprites.

## Lighting And FX Split

The appliances atlas should contain appliance bodies, not full-room lighting or one-off FX.

Allowed in appliance body sprites:

- fridge body
- microwave body
- aircon body
- fluorescent fixture body
- UPS body
- small indicator lights when they are part of the body

Split into FX / lighting layers:

- fluorescent light affecting the whole room
- aircon wind / dust effect
- microwave running glow
- fridge interior light
- UPS warning flash
- broken spark / flicker
- whole-room reflection

Other visual candidates:

- `qv_fx_atlas.png`
- `qv_room_static_lighting_overlay.png`
- `qv_room_neon_reflection_overlay.png`

## Example Mapping Table

Coordinates are intentionally `TBD`. Do not treat this table as final atlas data.

| region_key | living_device_key | room_object_key | category | device_type | power_model | visual_state | rect | anchor | z | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fridge_base` | `fridge` | `fridge` | `food_storage` | `continuous` | `continuous` | `base` | `TBD` | `bottom_center` | `34` | candidate only |
| `microwave_idle` | `microwave` | `microwave` | `food_heating` | `instant` | `instant` | `idle` | `TBD` | `on_surface` | `34` | placed on counter / desk candidate |
| `aircon_wall_unit` | `aircon` | `aircon` | `environment_control` | `environment` | `continuous` | `base` | `TBD` | `wall_center` | `34` | Fan replacement candidate |
| `fluorescent_light_on` | `fluorescent_light` | `fluorescent_light` | `lighting_fixture` | `background_fixture` | `dedicated_circuit` | `on` | `TBD` | `ceiling_or_wall_fixture` | `34` | no outlet slot candidate |
| `ups_unit` | `ups` | `ups` | `power_storage` | `storage` | `storage` | `base` | `TBD` | `bottom_center` | `34` | support / power storage candidate |

## Pre-Application Checklist

- [ ] Atlas PNG has transparent background.
- [ ] Regions do not overlap.
- [ ] Each region rect fully contains the sprite.
- [ ] Appliance edges are not cropped.
- [ ] `region_key` uses `snake_case`.
- [ ] `living_device_key` / `room_object_key` relationship is documented.
- [ ] Pivot / anchor is clear.
- [ ] Appliance, furniture, work-device, and cable categories are not mixed.
- [ ] State variations keep stable anchors.
- [ ] Glow / FX are not over-baked into appliance body sprites.
- [ ] Room shell perspective matches.
- [ ] Player scale matches.
- [ ] Foreground occluder / lighting overlay does not conflict.

## Future Application Order

1. Prepare final `qv_appliances_atlas.png` asset.
2. Add PNG to the atlas path.
3. Write region key and rect list.
4. Decide mapping format: Resource, JSON, or CSV.
5. Create `AtlasTexture` or region loader prototype.
6. Create `QuarterviewAppliancesAtlasPrototype`.
7. Check every region visually.
8. Review links to `LivingDeviceDefinition` and `RoomObjectDefinition`.
9. Test appliance placement in `QuarterviewGameplaySandbox`.
10. Check state variation / lighting / FX separation.

## Non-Goals

This document does not:

- Add actual PNG assets
- Generate or resize images
- Create `AtlasTexture`
- Create JSON / CSV / `.tres` mapping files
- Modify scenes
- Modify `LivingDeviceDefinition.gd`
- Modify `DeviceDefinition.gd`
- Modify `RoomObjectDefinition.gd`
- Wire appliance art into `QuarterviewGameplaySandbox`
- Change Main / DAY 1
