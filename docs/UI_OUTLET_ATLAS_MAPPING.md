# UI Outlet Atlas Mapping

## Purpose

This document defines future region mapping rules for `ui_outlet_atlas.png`.

The atlas is a candidate for Outlet / Power management UI-specific visual parts: outlet panel frames, socket slot states, device cards, connected / active badges, slot-count badges, drag ghost frames, drop highlights, power / drain meters, warning chips, and outlet-specific headers / tabs / dividers.

It is not imported into Godot yet and is not connected to Main / DAY 1 `OutletMode`, QuarterviewGameplaySandbox Outlet panel, PrototypeHub, `SurvivalState`, or `DeviceDefinition` resources.

Coordinates, 9-slice margins, Outlet screen areas, socket states, and future value bindings stay `TBD` until the actual PNG and UI implementation exist.

## Atlas File

Future atlas file:

```text
ui_outlet_atlas.png
```

Expected future Godot path:

```text
res://assets/ui/outlet/atlases/ui_outlet_atlas.png
```

Source / reference candidates:

```text
res://assets/ui/outlet/atlases/source/
res://assets/ui/outlet/atlases/reference/
```

Format criteria:

- PNG.
- RGBA / transparent background.
- Outlet / Power UI-specific visual parts only.
- No room shell background.
- No character sprite.
- No furniture / appliance / work-device sprite body.
- No physical cable atlas body.
- No hacking arena visual.
- No full screenshot UI mockup.
- No localization text baked into regions.
- No third-party raw input prompt icons directly mixed in.
- Region names and 9-slice margins are documented separately.

This task does not create the folders, PNG, `AtlasTexture`, `StyleBoxTexture`, Theme Resource, JSON, CSV, `.tres`, Control node, Outlet UI scene, or mapping file.

## Atlas Role

`ui_outlet_atlas.png` is a candidate for Outlet / Power management UI screen-specific visual parts.

Owns:

- Outlet UI panel frame.
- Socket slot visuals.
- Device card visuals.
- Connected / disconnected / active badges.
- 1-slot / 2-slot display badges.
- Drag ghost / drop highlight visuals.
- Power meter / drain meter visuals.
- Overload / warning chip visuals.
- Outlet-specific tab / header / divider visuals.
- Outlet-specific status visuals.

Does not own:

- Actual device connection logic.
- Actual active / inactive calculation.
- Actual `SurvivalState` value changes.
- Actual `DeviceDefinition` values.
- Physical room cable / plug sprite bodies.
- Common button / panel / modal visuals.
- Gameplay HUD visuals.
- Phone / Result screen visuals.
- Localization text.

This document defines criteria only. It does not apply the atlas to any UI.

## Relationship To Other Atlases

### `ui_common_atlas.png`

Owns:

- Common panel.
- Common modal.
- Common button states.
- Common tabs.
- Common icons.
- Common prompt frame.

### `ui_hud_atlas.png`

Owns:

- Persistent gameplay HUD frames.
- Power / time / battery / Trace / HP / timer meters.
- Warning chips.
- Gameplay status badges.

### `ui_outlet_atlas.png`

Owns:

- Outlet UI screen parts.
- Socket slot states.
- Device cards.
- Drag / drop highlights.
- Connection state badges.
- Outlet-specific meters / warnings.
- Outlet-specific layout elements.

### `qv_cable_atlas.png`

Future candidate for:

- Physical cable / plug / adapter sprites visible inside the room.
- Power strip physical body.
- Wall cable runs.
- Charger cable visuals.

Separation rules:

- If a visual manages power connection inside the UI screen, it belongs to `ui_outlet_atlas.png`.
- If a visual is a physical cable / plug sprite in the room, it belongs to future `qv_cable_atlas.png`.
- If a region is a generic button, panel, modal, tab, or dialog piece, it belongs to `ui_common_atlas.png`.
- If a region persistently communicates gameplay state outside the outlet screen, it belongs to `ui_hud_atlas.png`.
- Outlet device cards may reference `ui_device_icons_atlas.png` for device identity icons, while outlet slot, card, drag / drop, and power-management visuals remain in `ui_outlet_atlas.png`.

## Outlet UI Category Candidates

Outlet UI categories are broad region families.

```text
outlet_panel
outlet_header
socket_slot
device_card
device_badge
connection_badge
drag_drop
meter
warning
divider
tab
icon
close_button
status_chip
```

Examples:

| outlet_ui_key | category |
| --- | --- |
| `outlet_panel_frame` | `outlet_panel` |
| `outlet_header_bar` | `outlet_header` |
| `outlet_socket_slot_empty` | `socket_slot` |
| `outlet_socket_slot_connected` | `socket_slot` |
| `outlet_device_card_base` | `device_card` |
| `outlet_device_slot_2_badge` | `device_badge` |
| `outlet_connected_badge` | `connection_badge` |
| `outlet_drop_valid_highlight` | `drag_drop` |
| `outlet_power_meter_frame` | `meter` |
| `outlet_overload_warning` | `warning` |
| `outlet_tab_button_active` | `tab` |

## Region Key Naming

`outlet_ui_key` identifies a future Outlet UI atlas region.

Rules:

- Use lowercase `snake_case`.
- Use `outlet` + role + state / variation.
- Split meter frame and fill regions.
- Use suffixes for socket, device card, badge, drag, drop, and warning states.
- Name by function / role, not by baked text content.
- Do not use temporary number-only keys.
- Do not use `final`, `new`, `tmp`, or screenshot-export names.

Good examples:

```text
outlet_panel_frame
outlet_header_bar
outlet_socket_slot_empty
outlet_socket_slot_hover
outlet_socket_slot_connected
outlet_socket_slot_blocked
outlet_socket_slot_warning
outlet_device_card_base
outlet_device_card_active
outlet_device_card_inactive
outlet_device_card_disabled
outlet_device_card_warning
outlet_device_slot_1_badge
outlet_device_slot_2_badge
outlet_connected_badge
outlet_disconnected_badge
outlet_active_badge
outlet_inactive_badge
outlet_drag_ghost_frame
outlet_drop_valid_highlight
outlet_drop_invalid_highlight
outlet_power_meter_frame
outlet_power_meter_fill
outlet_drain_meter_frame
outlet_drain_meter_fill
outlet_warning_chip
outlet_overload_warning
outlet_close_button_idle
```

Bad examples:

```text
outlet1
image_001
final_outlet_new
tmp_socket
red_warning_text
screenshot_part_a
```

State / variation suffix candidates:

```text
_base
_empty
_hover
_connected
_disconnected
_active
_inactive
_blocked
_warning
_danger
_disabled
_valid
_invalid
_low
_full
_idle
_pressed
```

## Region Mapping Schema

Future mapping metadata may use Resource, JSON, CSV, or another explicit format. This task only documents the schema.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `outlet_ui_key` | `String` | Outlet UI region identifier | `outlet_socket_slot_connected` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/ui/outlet/atlases/ui_outlet_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `category` | `String` | Outlet UI category | `socket_slot` |
| `visual_state` | `String` | Visual state | `connected` |
| `nine_slice` | `bool` | Whether 9-slice is expected | `true` |
| `margin_left` | `int` | 9-slice left margin | `TBD` |
| `margin_top` | `int` | 9-slice top margin | `TBD` |
| `margin_right` | `int` | 9-slice right margin | `TBD` |
| `margin_bottom` | `int` | 9-slice bottom margin | `TBD` |
| `min_width` | `int` | Minimum display width | `TBD` |
| `min_height` | `int` | Minimum display height | `TBD` |
| `default_modulate` | `String` | Default color modulation | `#FFFFFF` |
| `default_alpha` | `float` | Default alpha | `1.0` |
| `scale_policy` | `String` | Stretch / keep / clip candidate | `stretch_9slice` |
| `outlet_area` | `String` | Outlet screen area candidate | `socket_grid` |
| `target_control` | `String` | Godot Control candidate | `PanelContainer` |
| `usage_context` | `String` | Screen candidate | `outlet_mode` |
| `value_binding_hint` | `String` | Future value source candidate | `device_connected` |
| `interaction_hint` | `String` | Interaction candidate | `drop_device` |
| `device_state_hint` | `String` | `DeviceDefinition` / `SurvivalState` state candidate | `connected` |
| `notes` | `String` | Notes | `candidate only` |

All coordinate and margin fields remain `TBD` until the atlas exists.

This task does not create JSON, CSV, `.tres`, or any mapping file.

## 9-Slice Criteria

Outlet UI panels, cards, slots, drag frames, and warning chips may need resizing while preserving visual corners and borders.

9-slice candidates:

```text
outlet_panel_frame
outlet_header_bar
outlet_socket_slot_empty
outlet_socket_slot_hover
outlet_socket_slot_connected
outlet_socket_slot_blocked
outlet_device_card_base
outlet_device_card_active
outlet_device_card_inactive
outlet_device_card_disabled
outlet_drag_ghost_frame
outlet_drop_valid_highlight
outlet_drop_invalid_highlight
outlet_warning_chip
outlet_overload_warning
outlet_tab_button_active
outlet_tab_button_inactive
```

Non-9-slice candidates:

```text
outlet_power_meter_fill
outlet_drain_meter_fill
outlet_device_slot_1_badge
outlet_device_slot_2_badge
outlet_close_button_idle
outlet_divider_line
```

Badge frames such as `outlet_connected_badge` and `outlet_disconnected_badge` may be 9-slice if they need variable width.

Criteria:

- Corners should not warp when resized.
- Border thickness should remain stable.
- Slot / card visuals should survive layout changes.
- Device card state variants should keep matching size and margins.
- Margin values are finalized after actual atlas creation.
- This document keeps all margins as `TBD`.

This task does not create `StyleBoxTexture` or Theme Resource files.

## Outlet Screen Area Candidates

`outlet_area` candidates:

```text
panel_frame
header
socket_grid
device_list
device_card
power_summary
warning_area
drag_overlay
footer
tab_area
debug_area
```

Examples:

| outlet_ui_key | outlet_area |
| --- | --- |
| `outlet_panel_frame` | `panel_frame` |
| `outlet_socket_slot_empty` | `socket_grid` |
| `outlet_device_card_base` | `device_list` |
| `outlet_power_meter_frame` | `power_summary` |
| `outlet_overload_warning` | `warning_area` |
| `outlet_drag_ghost_frame` | `drag_overlay` |

This task does not change the actual `OutletMode.tscn` layout.

## Slot / Socket State Criteria

Socket `visual_state` candidates:

```text
empty
hover
connected
blocked
warning
invalid
disabled
```

Examples:

- `outlet_socket_slot_empty`: `empty`
- `outlet_socket_slot_hover`: `hover`
- `outlet_socket_slot_connected`: `connected`
- `outlet_socket_slot_blocked`: `blocked`
- `outlet_socket_slot_warning`: `warning`

Slot UI criteria:

- 1-slot and 2-slot devices should be visually distinct.
- 2-slot devices should clearly occupy two adjacent slots.
- `connected` and `active` are separate concepts.
- `connected` means plugged into the outlet.
- `active` means actually running / consuming power.
- Socket visuals are future candidates for `SurvivalState` values; this task does not wire them.

## Device Card State Criteria

Device card `visual_state` candidates:

```text
base
available
connected
active
inactive
disabled
warning
dragging
selected
```

Examples:

- `outlet_device_card_base`: `base`
- `outlet_device_card_active`: `active`
- `outlet_device_card_inactive`: `inactive`
- `outlet_device_card_disabled`: `disabled`
- `outlet_device_card_warning`: `warning`

Device card display candidates:

- Device display name.
- Slot count.
- Drain value.
- Connected badge.
- Active badge.
- Warning badge.
- Short description.

Text should not be baked into image regions. Device names, drain values, and status labels should remain `Label` text.

## Drag / Drop Visual Criteria

Candidate regions:

```text
outlet_drag_ghost_frame
outlet_drop_valid_highlight
outlet_drop_invalid_highlight
outlet_socket_slot_hover
outlet_socket_slot_blocked
```

State candidates:

```text
dragging
valid_drop
invalid_drop
blocked
occupied
```

Criteria:

- Valid and invalid drop states should be immediately readable.
- 2-slot device drag should show the affected slot range when possible.
- Drag ghost may be slightly transparent compared to the original device card.
- Invalid state should not rely only on color; shape, icon, border, or pattern differences are candidates.
- Actual drag / drop logic remains in UI script work, not in this mapping document.

## Meter / Summary Criteria

Meter candidates:

```text
outlet_power_meter_frame
outlet_power_meter_fill
outlet_drain_meter_frame
outlet_drain_meter_fill
outlet_overload_meter_frame_candidate
outlet_overload_meter_fill_candidate
```

Criteria:

- Split frame and fill.
- Use clip or scale behavior for fill candidates.
- Power and drain should be visually distinguishable.
- Warning / critical states may use separate fill regions or `modulate`.
- Actual value binding belongs to UI script logic.
- Meter animation is a later Tween / AnimationPlayer candidate.

This task does not create `TextureProgressBar` nodes.

## Value Binding Candidates

`SurvivalState` candidates:

```text
current_power
max_power
active_power_drain
connected_device_keys
active_device_keys
device_connected
device_active
device_slot_count
power_warning_state
overload_warning_state
```

`DeviceDefinition` candidates:

```text
device_key
display_name
outlet_slots
drain_per_game_hour
result_flag_key
```

UI interaction candidates:

```text
selected_device_key
dragged_device_key
hovered_slot_index
valid_drop
invalid_drop_reason
selected_socket_index
```

These names are future binding hints only. This task does not connect `SurvivalState`, `DeviceDefinition`, or `OutletMode`.

## Relationship To Existing OutletMode

The current `OutletMode.tscn` and `OutletMode.gd` are part of the existing Main / DAY 1 flow. The current implementation uses script drawing, slot hitboxes, draggable adapters, LED masking, and `SurvivalState` connection data.

`ui_outlet_atlas.png` does not immediately replace `OutletMode`.

This task does not:

- Modify `OutletMode.tscn`.
- Modify `OutletMode.gd`.
- Modify `Main.gd` Outlet routing.
- Modify `SurvivalState` connected / active logic.
- Modify `DeviceDefinition.gd`.
- Modify device `.tres` values.
- Modify QuarterviewGameplaySandbox Outlet panel.

Future connection candidate:

```text
ui_outlet_atlas mapping
-> Outlet UI visual parts
-> StyleBoxTexture / TextureRect / Theme candidates
-> existing OutletMode visual replacement
-> sandbox outlet panel visual replacement
-> future outlet / power UI polish
```

Visual replacement should be tested in sandbox or a dedicated viewer before replacing the existing Main / DAY 1 Outlet UI.

## Other Atlas Separation

### `ui_outlet_atlas.png` Includes

- Outlet UI panel.
- Socket slot visuals.
- Device card visuals.
- Connected / active badges.
- Slot-count badges.
- Drag ghost / drop highlights.
- Outlet-specific meters.
- Outlet warning chips.
- Outlet tab / header / footer visuals.

### `ui_outlet_atlas.png` Excludes

- Generic button / panel / modal.
- Gameplay HUD frame / meter.
- Phone UI layout.
- Result UI layout.
- Physical cable / plug room sprites.
- Power strip body in the room.
- Room shell.
- Character sprite.
- Game object sprite.
- Hacking arena assets.
- Localization text.
- Kenney raw input prompt icons.

Other atlas candidates:

```text
ui_common_atlas.png
ui_hud_atlas.png
ui_phone_atlas.png
ui_result_atlas.png
qv_cable_atlas.png
qv_fx_atlas.png
```

## UI Tone

Outlet UI visual criteria:

- Power management information should be readable immediately.
- Connected / active / disabled / warning states must be clearly distinct.
- 1-slot / 2-slot difference should be intuitive.
- The tone should feel like THE GRID's industrial / management-system interface.
- The interface should be dark, restrained, and cyber without becoming loud arcade UI.
- Readability and operation should beat decoration.
- Cable-like drawings should not make the management UI messy.
- Text should be rendered with Labels, not baked into images.
- Slot and device card information should remain readable on smaller screens.

## Example Mapping

The following table is only a schema example. Rects and margins are placeholders and must not be treated as final coordinates.

| outlet_ui_key | category | area | state | nine_slice | rect | margins | target_control | value_binding_hint | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `outlet_panel_frame` | `outlet_panel` | `panel_frame` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | main outlet panel |
| `outlet_header_bar` | `outlet_header` | `header` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | outlet header |
| `outlet_socket_slot_empty` | `socket_slot` | `socket_grid` | `empty` | `true` | `TBD` | `TBD` | `PanelContainer` | `device_connected` | empty slot |
| `outlet_socket_slot_hover` | `socket_slot` | `socket_grid` | `hover` | `true` | `TBD` | `TBD` | `PanelContainer` | `hovered_slot_index` | hover state |
| `outlet_socket_slot_connected` | `socket_slot` | `socket_grid` | `connected` | `true` | `TBD` | `TBD` | `PanelContainer` | `device_connected` | connected slot |
| `outlet_socket_slot_blocked` | `socket_slot` | `socket_grid` | `blocked` | `true` | `TBD` | `TBD` | `PanelContainer` | `invalid_drop_reason` | blocked slot |
| `outlet_device_card_base` | `device_card` | `device_list` | `base` | `true` | `TBD` | `TBD` | `Button / PanelContainer` | `device_key` | device card |
| `outlet_device_card_active` | `device_card` | `device_list` | `active` | `true` | `TBD` | `TBD` | `Button / PanelContainer` | `device_active` | active device card |
| `outlet_device_card_disabled` | `device_card` | `device_list` | `disabled` | `true` | `TBD` | `TBD` | `Button / PanelContainer` | `device_connected` | disabled card |
| `outlet_device_slot_1_badge` | `device_badge` | `device_card` | `base` | `false` | `TBD` | `none` | `TextureRect` | `outlet_slots` | 1-slot badge |
| `outlet_device_slot_2_badge` | `device_badge` | `device_card` | `base` | `false` | `TBD` | `none` | `TextureRect` | `outlet_slots` | 2-slot badge |
| `outlet_connected_badge` | `connection_badge` | `device_card` | `connected` | `true` | `TBD` | `TBD` | `PanelContainer` | `device_connected` | connected badge |
| `outlet_active_badge` | `connection_badge` | `device_card` | `active` | `true` | `TBD` | `TBD` | `PanelContainer` | `device_active` | active badge |
| `outlet_drag_ghost_frame` | `drag_drop` | `drag_overlay` | `dragging` | `true` | `TBD` | `TBD` | `PanelContainer` | `dragged_device_key` | drag ghost |
| `outlet_drop_valid_highlight` | `drag_drop` | `socket_grid` | `valid` | `true` | `TBD` | `TBD` | `PanelContainer` | `valid_drop` | valid drop |
| `outlet_drop_invalid_highlight` | `drag_drop` | `socket_grid` | `invalid` | `true` | `TBD` | `TBD` | `PanelContainer` | `invalid_drop_reason` | invalid drop |
| `outlet_power_meter_frame` | `meter` | `power_summary` | `base` | `true` | `TBD` | `TBD` | `TextureProgressBar` | `current_power` | power frame |
| `outlet_power_meter_fill` | `meter` | `power_summary` | `base` | `false` | `TBD` | `none` | `TextureProgressBar` | `current_power` | power fill |
| `outlet_drain_meter_frame` | `meter` | `power_summary` | `base` | `true` | `TBD` | `TBD` | `TextureProgressBar` | `active_power_drain` | drain frame |
| `outlet_warning_chip` | `warning` | `warning_area` | `warning` | `true` | `TBD` | `TBD` | `PanelContainer` | `power_warning_state` | warning chip |
| `outlet_overload_warning` | `warning` | `warning_area` | `danger` | `true` | `TBD` | `TBD` | `PanelContainer` | `overload_warning_state` | overload warning |

## Pre-Application Checklist

Before applying actual Outlet atlas regions:

- Confirm the atlas PNG has a transparent background.
- Confirm Outlet UI regions do not overlap incorrectly.
- Confirm every `outlet_ui_key` uses lowercase `snake_case`.
- Confirm 9-slice and non-9-slice regions are separated.
- Confirm socket slot state variants keep matching size and margins.
- Confirm device card state variants keep matching size and margins.
- Confirm 1-slot and 2-slot badges are clear.
- Confirm connected / active / disabled / warning states are distinct.
- Confirm drag / drop valid and invalid states do not rely only on color.
- Confirm power / drain meter frame and fill regions are split.
- Confirm localization text is not baked into images.
- Confirm `qv_cable_atlas.png` responsibility is not mixed into `ui_outlet_atlas.png`.
- Confirm sandbox can test visual replacement before replacing existing `OutletMode.tscn`.

## Future Application Order

Suggested future order:

1. Prepare final `ui_outlet_atlas.png` asset.
2. Add PNG at the atlas path.
3. Write `outlet_ui_key` and rect / margin list.
4. Choose mapping format: Resource, JSON, or CSV.
5. Create Outlet atlas region viewer prototype.
6. Test a few frame / slot / card regions in the sandbox Outlet panel.
7. Review existing `OutletMode.tscn` visual replacement.
8. Review slot / device card / drag-drop state visuals.
9. Review power / drain meter visuals.
10. Review actual `SurvivalState`, `DeviceDefinition`, and `OutletMode` wiring separately.

This task stops at documentation. It does not create PNG assets, import metadata, mapping files, Theme / StyleBox resources, Outlet UI scenes, Control nodes, or gameplay wiring.
