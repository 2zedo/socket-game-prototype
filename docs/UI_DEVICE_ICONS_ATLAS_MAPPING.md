# UI Device Icons Atlas Mapping

This document defines future region mapping rules for `ui_device_icons_atlas.png`.

The atlas is a candidate for small UI device icons used across HUD, Phone UI, Outlet UI, Result / Log UI, mission selection, and debug / sandbox displays.

It is not imported into Godot yet and is not connected to Main / DAY 1 UI, Phone UI, Outlet UI, HUD, Result UI, QuarterviewGameplaySandbox, `DeviceDefinition`, `LivingDeviceDefinition`, `RoomObjectDefinition`, or `HackingMissionDefinition`.

This task does not create the folders, PNG, `AtlasTexture`, `TextureRect`, Theme Resource, JSON, CSV, `.tres`, mapping file, icon UI scene, Control node, or gameplay wiring.

## Atlas File

Future atlas filename:

```text
ui_device_icons_atlas.png
```

Future Godot path:

```text
res://assets/ui/device_icons/atlases/ui_device_icons_atlas.png
```

Future source / reference candidates:

```text
res://assets/ui/device_icons/atlases/source/
res://assets/ui/device_icons/atlases/reference/
```

Expected file format:

- PNG.
- RGBA / transparent background.
- Small UI device icons only.
- No room object body sprite.
- No appliance body sprite.
- No work device body sprite.
- No cable / plug physical body sprite.
- No full UI panel / button / card.
- No localization text baked into icons.
- No room shell background.
- No character sprite.
- No hacking arena tile, enemy, avatar, object, or FX sprite.
- Icon regions should be readable at small sizes.

These paths are future candidates only. This pass does not create them.

## Atlas Role

`ui_device_icons_atlas.png` is a candidate for small symbols that represent device types in UI.

Owns:

- Laptop, Phone, Charger, Communication Device, NODE-17, Speaker, and Signal Booster UI icons.
- Fridge, Microwave, Air Conditioner, Fluorescent Light, and UPS UI icons.
- Outlet, power strip, plug, and power-management UI icon candidates.
- Unknown, locked, warning, and broken device state icon candidates.
- Device icons that can be reused by HUD, Phone UI, Outlet UI, Result / Log UI, and mission UI.

Does not own:

- Device body sprites placed in the room.
- Actual cable / plug room sprites.
- Outlet UI slot / card visuals.
- Phone UI card / frame visuals.
- HUD meter / frame visuals.
- Actual device state calculation.
- Actual connected / active logic.
- Localization text.

This pass only defines the criteria. It does not create the atlas or mapping file.

## Relationship To Room Visual Atlases

### `qv_work_devices_atlas.png`

Owns:

- Physical room sprites for laptop, phone, NODE-17, speaker, signal booster, communication device, and similar work / hacking objects.

### `qv_appliances_atlas.png`

Owns:

- Physical room sprites for fridge, microwave, air conditioner, fluorescent light, UPS, and similar living / life-support objects.

### `qv_cable_atlas.png`

Candidate owner for:

- Physical room cable, plug, adapter, and power-strip body sprites.

### `ui_device_icons_atlas.png`

Owns:

- Small UI symbols for device cards, mission requirements, result logs, status chips, and tooltips.
- Device identity icons, not room object bodies.

Separation rules:

- If it is a physical object placed in the room, it belongs to a `qv_*` atlas.
- If it is a small UI symbol representing a device, it belongs to `ui_device_icons_atlas.png`.
- Outlet UI slot / card frame visuals belong to `ui_outlet_atlas.png`.
- Generic warning / info / power icons belong to `ui_common_atlas.png`.
- Device-specific icons belong to `ui_device_icons_atlas.png`.

## Relationship To UI Atlases

### `ui_common_atlas.png`

Owns:

- Common panel, button, modal, and generic icon parts.
- Generic power, warning, info, close, and prompt frame icons.

### `ui_hud_atlas.png`

Owns:

- Persistent HUD frame, meter, and status-chip visuals.

### `ui_phone_atlas.png`

Owns:

- Phone UI-specific frame, card, message, and notification visuals.

### `ui_outlet_atlas.png`

Owns:

- Outlet UI-specific slot, device-card frame, drag / drop state, and power meter visuals.

### `ui_result_log_atlas.png`

Owns:

- Result / log card, report row, reward row, and story / device / power report visuals.

### `ui_device_icons_atlas.png`

Owns:

- Small device-type icons that can be referenced inside the above UI screens.
- Symbols that can be associated with `device_key`, `living_device_key`, `room_object_key`, or `mission_device_key`.

Separation rules:

- If a region answers "which device is this?", it belongs to `ui_device_icons_atlas.png`.
- If a region answers "what UI frame / card / slot is this?", it belongs to that screen-specific UI atlas.
- If a region is a generic warning, info, or close icon, it belongs to `ui_common_atlas.png`.

## Device Icon Category Candidates

Use categories to group device icons by broad system role.

| Icon Key | Category |
| --- | --- |
| `icon_device_laptop` | `work_device` |
| `icon_device_phone` | `phone_device` |
| `icon_device_charger` | `power_device` |
| `icon_device_communication` | `communication_device` |
| `icon_device_node17` | `mystery_device` |
| `icon_device_speaker` | `audio_device` |
| `icon_device_signal_booster` | `signal_device` |
| `icon_device_ups` | `storage_device` |
| `icon_device_fridge` | `living_appliance` |
| `icon_device_microwave` | `living_appliance` |
| `icon_device_aircon` | `living_appliance` |
| `icon_device_fluorescent_light` | `lighting_fixture` |
| `icon_device_power_strip` | `outlet_power` |
| `icon_device_outlet` | `outlet_power` |
| `icon_device_unknown` | `unknown` |
| `icon_device_locked` | `status_overlay` |
| `icon_device_warning` | `status_overlay` |
| `icon_device_broken` | `status_overlay` |

Category candidates:

- `work_device`
- `phone_device`
- `communication_device`
- `mystery_device`
- `audio_device`
- `signal_device`
- `power_device`
- `living_appliance`
- `lighting_fixture`
- `storage_device`
- `outlet_power`
- `status_overlay`
- `unknown`

## Icon Key Naming

Icon keys must be stable. They should follow device identity rather than current artwork.

Rules:

- Use lowercase `snake_case`.
- Use the `icon_device_` prefix.
- Match the device key where possible.
- Use suffixes for state variations.
- Do not use temporary numbers or file-export names.
- Do not name icons after text labels.
- Avoid `final`, `new`, `tmp`, and screenshot-style names.

Good examples:

```text
icon_device_laptop
icon_device_laptop_active
icon_device_phone
icon_device_phone_low
icon_device_charger
icon_device_communication
icon_device_node17
icon_device_node17_locked
icon_device_speaker
icon_device_signal_booster
icon_device_ups
icon_device_ups_low
icon_device_fridge
icon_device_microwave
icon_device_aircon
icon_device_fluorescent_light
icon_device_outlet
icon_device_power_strip
icon_device_unknown
icon_device_warning
icon_device_broken
```

Bad examples:

```text
device1
icon_001
laptop_final_new
tmp_phone
red_warning_text
screenshot_part_a
```

State / variation suffix candidates:

- `_base`
- `_active`
- `_inactive`
- `_connected`
- `_disconnected`
- `_charging`
- `_low`
- `_warning`
- `_broken`
- `_locked`
- `_unlocked`
- `_unknown`
- `_disabled`

This pass does not create actual icon assets.

## Region Mapping Schema

Future mapping data may be stored as a Resource, JSON, or CSV. This pass only defines the schema.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `icon_key` | `String` | Device icon identifier | `icon_device_laptop` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/ui/device_icons/atlases/ui_device_icons_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `icon_size` | `String` | Baseline size candidate | `32x32` |
| `category` | `String` | Device icon category | `work_device` |
| `visual_state` | `String` | Display state | `base` |
| `device_key` | `String` | `DeviceDefinition` key candidate | `laptop` |
| `living_device_key` | `String` | `LivingDeviceDefinition` key candidate | `fridge` |
| `room_object_key` | `String` | `RoomObjectDefinition` key candidate | `laptop` |
| `mission_device_key` | `String` | `HackingMissionDefinition` required / recommended key candidate | `laptop` |
| `default_modulate` | `String` | Default color modulation | `#FFFFFF` |
| `default_alpha` | `float` | Default alpha | `1.0` |
| `scale_policy` | `String` | Scale candidate | `keep_aspect` |
| `target_context` | `String` | Candidate UI context | `outlet_ui` |
| `usage_hint` | `String` | Usage description | `device card icon` |
| `notes` | `String` | Notes | `candidate only` |

No mapping file is created in this pass.

## Icon Size Criteria

Candidate sizes:

- `16x16`
- `24x24`
- `32x32`
- `48x48`
- `64x64`

Guidelines:

- Default candidate: `32x32`.
- HUD and small badges: `16x16` or `24x24`.
- Phone / Outlet device cards: `32x32` or `48x48`.
- Result / Log card rows: `32x32`.
- Mission required / recommended device display: `24x24` or `32x32`.

Open decisions:

- Whether to draw multiple icon sizes or scale one higher-resolution icon is decided during actual UI application.
- Laptop, phone, fridge, aircon, and similar silhouettes must remain distinguishable at small sizes.
- Icons should not contain text.

## State Variation Criteria

`visual_state` candidates:

- `base`
- `active`
- `inactive`
- `connected`
- `disconnected`
- `charging`
- `low`
- `warning`
- `broken`
- `locked`
- `unlocked`
- `disabled`
- `unknown`

Device-specific candidates:

| Device | State Candidates |
| --- | --- |
| `laptop` | `base`, `active`, `warning` |
| `phone` | `base`, `charging`, `low` |
| `node17` | `base`, `locked`, `warning` |
| `ups` | `base`, `charging`, `low`, `broken` |
| `communication` | `base`, `connected`, `disconnected` |
| `signal_booster` | `base`, `active`, `warning` |

State variants should keep the same size and visual center. If state expression becomes complex, prefer a base icon plus status overlay badge candidate.

## Base Icon + Status Overlay Policy

There are two future implementation options.

### Candidate A: State-Specific Icon Region

Example:

```text
icon_device_phone
icon_device_phone_low
icon_device_phone_charging
```

Pros:

- Simple to display.
- Allows fully designed per-state icons.

Cons:

- More atlas regions.
- Atlas grows when states increase.

### Candidate B: Base Icon + Status Overlay Badge

Example:

```text
icon_device_phone + icon_status_low
icon_device_laptop + icon_status_active
```

Pros:

- More reusable.
- Fewer base device regions.

Cons:

- Requires UI composition logic.
- May become visually crowded at small sizes.

Current recommendation:

- MVP uses base icons first.
- Critical states such as `warning`, `low`, and `locked` can be separate icons or overlay candidates.
- Avoid too many state variations until the real UI context is known.

This pass does not create overlay icons.

## `DeviceDefinition` Connection Criteria

`DeviceDefinition` remains the source for DAY 1 device gameplay data. Device icon mapping can reference it, but does not replace it.

Connection candidates:

- `device_key`
- `display_name`
- `outlet_slots`
- `drain_per_game_hour`
- `result_flag_key`

Examples:

```text
device_key = laptop
-> icon_device_laptop

device_key = charger
-> icon_device_charger

device_key = communication
-> icon_device_communication
```

This pass does not modify `DeviceDefinition.gd` or existing `.tres` values.

## `LivingDeviceDefinition` Connection Criteria

`LivingDeviceDefinition` is a future Resource contract for living appliances and life-support devices. Device icons may later reference its keys.

Connection candidates:

- `living_device_key`
- `room_object_key`
- `device_type`
- `power_model`

Examples:

```text
living_device_key = fridge
-> icon_device_fridge

living_device_key = microwave
-> icon_device_microwave

living_device_key = aircon
-> icon_device_aircon

living_device_key = fluorescent_light
-> icon_device_fluorescent_light

living_device_key = ups
-> icon_device_ups
```

This pass does not modify `LivingDeviceDefinition.gd` and does not create living device `.tres` files.

## `RoomObjectDefinition` Connection Criteria

`RoomObjectDefinition` owns room object keys, roles, future source links, and visual-state candidates. UI device icons can reference those keys for prompts, sandbox debug, cards, and future tooltips.

Connection candidates:

- `room_object_key`
- `role`
- `future_source`
- `visual_state`

Examples:

```text
room_object_key = node17
role = mystery_device
-> icon_device_node17

room_object_key = speaker
role = audio_hacking_device
-> icon_device_speaker

room_object_key = power
role = power_management
-> icon_device_outlet or icon_device_power_strip
```

Physical room sprites remain in `qv_work_devices_atlas.png`, `qv_appliances_atlas.png`, `qv_furniture_atlas.png`, or related room atlases. `ui_device_icons_atlas.png` is UI symbol-only.

## `HackingMissionDefinition` Connection Criteria

`HackingMissionDefinition` may later use device icon mapping for mission requirement displays.

Connection candidates:

- `required_device_keys`
- `recommended_device_keys`
- `mission_type`
- `objective_type`

Examples:

```text
required_device_keys = ["laptop"]
-> icon_device_laptop

recommended_device_keys = ["speaker"]
-> icon_device_speaker

recommended_device_keys = ["signal_booster"]
-> icon_device_signal_booster
```

This pass does not modify `HackingMissionDefinition.gd` and does not implement mission select UI.

## Target Context Candidates

`target_context` describes where an icon may appear.

Candidates:

- `hud`
- `phone_ui`
- `outlet_ui`
- `result_log_ui`
- `mission_select`
- `quarterview_sandbox`
- `debug_overlay`
- `tooltip`

Examples:

- `icon_device_laptop`: `outlet_ui`, `mission_select`, `result_log_ui`
- `icon_device_phone`: `hud`, `phone_ui`, `result_log_ui`
- `icon_device_node17`: `mission_select`, `phone_ui`, `story_log`
- `icon_device_fridge`: `result_log_ui`, `future_living_device_ui`
- `icon_device_ups`: `outlet_ui`, `mission_select`, `result_log_ui`

## Icon Style Criteria

Device icons should fit CONCENT's subdued cyber survival interface.

Style rules:

- Keep icons dark, restrained, and readable.
- Prefer recognizable silhouette over dense detail.
- Prioritize readability at small sizes.
- Do not put text inside icons.
- Warning / state should not rely only on color; shape or overlay candidates should be considered.
- Icons should not look like downscaled room object body sprites.
- Icons are UI symbols. Room sprites are separate assets.
- Speaker must read as an `audio_hacking_device`, not a decoration.
- NODE-17 should feel like a mystery / story device, distinct from ordinary appliances.

## Atlas Separation

### `ui_device_icons_atlas.png` Includes

- Device type icons.
- Living appliance icons.
- Work device icons.
- Mystery device icons.
- Audio device icons.
- Signal / power / support device icons.
- Unknown / broken / locked device icon candidates.

### `ui_device_icons_atlas.png` Excludes

- Generic warning / info / close icon.
- UI panel / button / card / frame.
- Room object body sprite.
- Appliance / work device physical sprite.
- Cable / plug physical sprite.
- Room shell.
- Character sprite.
- Hacking arena asset.
- Localization text.
- Kenney raw input prompt icons.

Related atlas candidates:

```text
ui_common_atlas.png
ui_hud_atlas.png
ui_phone_atlas.png
ui_outlet_atlas.png
ui_result_log_atlas.png
ui_dialogue_atlas.png
qv_work_devices_atlas.png
qv_appliances_atlas.png
qv_cable_atlas.png
```

## Example Mapping

Coordinates are placeholders. They must stay `TBD` until the real atlas exists.

| `icon_key` | `category` | `device_key` | `living_device_key` | `room_object_key` | `mission_device_key` | `state` | `size` | `rect` | `target_context` | `notes` |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `icon_device_laptop` | `work_device` | `laptop` |  | `laptop` | `laptop` | `base` | `32x32` | `TBD` | `outlet_ui,mission_select` | laptop icon |
| `icon_device_laptop_active` | `work_device` | `laptop` |  | `laptop` | `laptop` | `active` | `32x32` | `TBD` | `outlet_ui` | active laptop |
| `icon_device_phone` | `phone_device` | `phone` |  | `phone` | `phone` | `base` | `32x32` | `TBD` | `hud,phone_ui` | phone icon |
| `icon_device_phone_low` | `phone_device` | `phone` |  | `phone` | `phone` | `low` | `32x32` | `TBD` | `hud,phone_ui` | low battery state |
| `icon_device_charger` | `power_device` | `charger` |  | `charger` | `charger` | `base` | `32x32` | `TBD` | `outlet_ui` | charger icon |
| `icon_device_communication` | `communication_device` | `communication` |  | `comm` | `communication` | `base` | `32x32` | `TBD` | `outlet_ui,mission_select` | communication icon |
| `icon_device_node17` | `mystery_device` | `node17` |  | `node17` | `node17` | `base` | `32x32` | `TBD` | `mission_select,story_log` | mystery device |
| `icon_device_node17_locked` | `mystery_device` | `node17` |  | `node17` | `node17` | `locked` | `32x32` | `TBD` | `mission_select` | locked state |
| `icon_device_speaker` | `audio_device` | `speaker` |  | `speaker` | `speaker` | `base` | `32x32` | `TBD` | `mission_select` | audio hacking device |
| `icon_device_signal_booster` | `signal_device` | `signal_booster` |  | `signal_booster` | `signal_booster` | `base` | `32x32` | `TBD` | `mission_select,outlet_ui` | signal support |
| `icon_device_ups` | `storage_device` | `ups` | `ups` | `ups` | `ups` | `base` | `32x32` | `TBD` | `outlet_ui,result_log_ui` | power storage |
| `icon_device_fridge` | `living_appliance` |  | `fridge` | `fridge` | `fridge` | `base` | `32x32` | `TBD` | `result_log_ui` | fridge icon |
| `icon_device_microwave` | `living_appliance` |  | `microwave` | `microwave` | `microwave` | `base` | `32x32` | `TBD` | `result_log_ui` | microwave icon |
| `icon_device_aircon` | `living_appliance` |  | `aircon` | `aircon` | `aircon` | `base` | `32x32` | `TBD` | `result_log_ui` | aircon icon |
| `icon_device_fluorescent_light` | `lighting_fixture` |  | `fluorescent_light` | `fluorescent_light` | `fluorescent_light` | `base` | `32x32` | `TBD` | `result_log_ui` | fixture icon |
| `icon_device_power_strip` | `outlet_power` |  |  | `power` | `power` | `base` | `32x32` | `TBD` | `outlet_ui,tooltip` | power strip icon |
| `icon_device_outlet` | `outlet_power` |  |  | `power` | `power` | `base` | `32x32` | `TBD` | `outlet_ui,tooltip` | outlet icon |
| `icon_device_unknown` | `unknown` |  |  |  | `unknown` | `unknown` | `32x32` | `TBD` | `debug_overlay` | unknown device |
| `icon_device_warning` | `status_overlay` |  |  |  |  | `warning` | `24x24` | `TBD` | `hud,result_log_ui` | warning overlay candidate |
| `icon_device_broken` | `status_overlay` |  |  |  |  | `broken` | `24x24` | `TBD` | `outlet_ui,result_log_ui` | broken overlay candidate |

## Pre-Application Checklist

Before applying actual Device Icon atlas regions:

- Confirm the atlas PNG has a transparent background.
- Confirm icon regions do not overlap incorrectly.
- Confirm every `icon_key` uses lowercase `snake_case`.
- Confirm `icon_size` assumptions are documented.
- Confirm device types remain readable at small sizes.
- Confirm icons do not contain localization text.
- Confirm `device_key`, `living_device_key`, `room_object_key`, and `mission_device_key` candidates are documented.
- Confirm UI frame / card / meter visuals are not mixed into this atlas.
- Confirm room object body sprites are not mixed into this atlas.
- Confirm warning / low / locked states are not distinguished by color only.
- Confirm Speaker reads as an `audio_hacking_device`, not decoration.
- Confirm NODE-17 is visually distinct from ordinary devices.

## Future Application Order

Suggested future order:

1. Prepare final `ui_device_icons_atlas.png` asset.
2. Add PNG at the atlas path.
3. Write `icon_key` and rect list.
4. Choose mapping format: Resource, JSON, or CSV.
5. Create Device Icon atlas region viewer prototype.
6. Test a few icons in an Outlet UI device-card mock.
7. Review Phone UI, Result Log UI, and Mission Select icon usage.
8. Review `DeviceDefinition`, `LivingDeviceDefinition`, and `RoomObjectDefinition` connections.
9. Decide state overlay policy.
10. Review actual UI atlas integration separately.

This task stops at documentation. It does not create PNG assets, import metadata, mapping files, icon UI scenes, Control nodes, Resources, or gameplay wiring.
