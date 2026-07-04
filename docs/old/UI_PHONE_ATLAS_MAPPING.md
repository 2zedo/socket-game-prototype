# UI Phone Atlas Mapping

## Purpose

This document defines future region mapping rules for `ui_phone_atlas.png`.

The atlas is a candidate for Phone UI-specific visual parts used by CONCENT's phone screen: device frame, screen background, status bar, app tiles, list items, message bubbles, notification cards, mission cards, log cards, battery / signal / charge icons, warning states, and empty-state panels.

It is not imported into Godot yet and is not connected to Main / DAY 1 Phone UI, QuarterviewGameplaySandbox Phone panel, PrototypeHub, `SurvivalState`, `GridCreditState`, `HackingMissionDefinition`, or story flags.

Coordinates, 9-slice margins, Phone screen areas, and future value bindings stay `TBD` until the actual PNG and UI implementation exist.

## Atlas File

Future atlas file:

```text
ui_phone_atlas.png
```

Expected future Godot path:

```text
res://assets/ui/phone/atlases/ui_phone_atlas.png
```

Source / reference candidates:

```text
res://assets/ui/phone/atlases/source/
res://assets/ui/phone/atlases/reference/
```

Format criteria:

- PNG.
- RGBA / transparent background.
- Phone UI-specific visual parts only.
- No room shell background.
- No character sprite.
- No furniture / appliance / work-device sprite.
- No hacking arena tile / enemy / avatar / object / FX sprite.
- No full screenshot UI mockup.
- No localization text baked into regions.
- No third-party raw input prompt icons directly mixed in.
- Region names and 9-slice margins are documented separately.

This task does not create the folders, PNG, `AtlasTexture`, `StyleBoxTexture`, Theme Resource, JSON, CSV, `.tres`, Control node, Phone UI scene, or mapping file.

## Atlas Role

`ui_phone_atlas.png` is a candidate for Phone UI screen-specific visual parts.

Owns:

- Phone UI device frame.
- Phone screen background.
- Status bar.
- App tile.
- Message bubble.
- Notification card.
- Phone-specific tab / nav.
- Phone-specific list item.
- Phone battery / signal / charge icons.
- Phone mission / log card.
- Phone warning state.
- Phone empty-state panel.

Does not own:

- Common button / panel / modal visuals.
- Gameplay HUD.
- Result screen visuals.
- Outlet UI visuals.
- Actual Phone UI logic.
- Actual battery calculation.
- Actual notification / message data.
- Localization text.
- Room shell art.
- Character sprites.
- Game object sprites.
- Hacking arena visuals.
- Kenney raw input prompt icon pack.

This document defines criteria only. It does not apply the atlas to any UI.

## Relationship To Other UI Atlases

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

### `ui_phone_atlas.png`

Owns:

- Phone UI-specific device frame.
- Phone screen area.
- Phone app tile.
- Phone message bubble.
- Phone notification card.
- Phone-specific list / card / nav visuals.
- Phone UI internal status presentation.

Separation rules:

- If a region is used as a generic button, panel, modal, tab, or dialog piece, it belongs to `ui_common_atlas.png`.
- If a region persistently communicates gameplay state during room or hacking play, it belongs to `ui_hud_atlas.png`.
- If a region is only used inside the Phone UI screen, it belongs to `ui_phone_atlas.png`.
- Phone UI can still reuse generic button regions from `ui_common_atlas.png` when a button is not phone-specific.
- Phone UI may reference `ui_device_icons_atlas.png` for device / status entries, while phone-specific frames, cards, message bubbles, and notification visuals remain in `ui_phone_atlas.png`.
- Phone HUD battery icons and Phone screen battery icons may be unified later, but duplicated or shared ownership should be reviewed before actual application.

## Phone UI Category Candidates

Phone UI categories are broad region families.

```text
phone_frame
phone_screen
phone_status_bar
phone_header
phone_nav
phone_tab
app_tile
list_item
message_bubble
notification_card
mission_card
log_card
icon
warning
empty_state
divider
scroll_panel
close_button
```

Examples:

| phone_ui_key | category |
| --- | --- |
| `phone_device_frame` | `phone_frame` |
| `phone_screen_base` | `phone_screen` |
| `phone_status_bar` | `phone_status_bar` |
| `phone_app_tile_base` | `app_tile` |
| `phone_message_bubble_in` | `message_bubble` |
| `phone_message_bubble_out` | `message_bubble` |
| `phone_notification_card_warning` | `notification_card` |
| `phone_mission_card_base` | `mission_card` |
| `phone_log_card_base` | `log_card` |
| `phone_battery_icon_low` | `icon` |
| `phone_signal_icon_weak` | `icon` |
| `phone_bottom_nav_base` | `phone_nav` |

## Region Key Naming

`phone_ui_key` identifies a future Phone UI atlas region.

Rules:

- Use lowercase `snake_case`.
- Use `phone` + role + state / variation.
- Use suffixes when state or size variations exist.
- Name by function / role, not by baked text content.
- Do not use temporary number-only keys.
- Do not use `final`, `new`, `tmp`, or screenshot-export names.

Good examples:

```text
phone_device_frame
phone_screen_base
phone_status_bar
phone_header_bar
phone_bottom_nav_base
phone_app_tile_base
phone_app_tile_active
phone_app_tile_disabled
phone_list_item_base
phone_message_bubble_in
phone_message_bubble_out
phone_notification_card_base
phone_notification_card_warning
phone_mission_card_base
phone_log_card_base
phone_battery_icon_full
phone_battery_icon_low
phone_battery_icon_charging
phone_signal_icon_strong
phone_signal_icon_weak
phone_warning_icon
phone_empty_state_panel
phone_divider_line
phone_close_button_idle
```

Bad examples:

```text
phone1
image_001
final_phone_new
tmp_card
red_warning_text
screenshot_part_a
```

State / variation suffix candidates:

```text
_base
_active
_inactive
_disabled
_selected
_unread
_read
_warning
_critical
_low
_full
_charging
_strong
_weak
_empty
_small
_large
_idle
_hover
_pressed
```

## Region Mapping Schema

Future mapping metadata may use Resource, JSON, CSV, or another explicit format. This task only documents the schema.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `phone_ui_key` | `String` | Phone UI region identifier | `phone_notification_card_warning` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/ui/phone/atlases/ui_phone_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `category` | `String` | Phone UI category | `notification_card` |
| `visual_state` | `String` | Visual state | `warning` |
| `nine_slice` | `bool` | Whether 9-slice is expected | `true` |
| `margin_left` | `int` | 9-slice left margin | `TBD` |
| `margin_top` | `int` | 9-slice top margin | `TBD` |
| `margin_right` | `int` | 9-slice right margin | `TBD` |
| `margin_bottom` | `int` | 9-slice bottom margin | `TBD` |
| `min_width` | `int` | Minimum display width | `TBD` |
| `min_height` | `int` | Minimum display height | `TBD` |
| `default_modulate` | `String` | Default color modulation | `#FFFFFF` |
| `default_alpha` | `float` | Default alpha | `1.0` |
| `scale_policy` | `String` | Stretch / keep / tile candidate | `stretch_9slice` |
| `phone_screen_area` | `String` | Phone screen area candidate | `main_content` |
| `target_control` | `String` | Godot Control candidate | `PanelContainer` |
| `usage_context` | `String` | Screen candidate | `phone_notifications` |
| `value_binding_hint` | `String` | Future value source candidate | `phone_low_battery_warning` |
| `interaction_hint` | `String` | Interaction candidate | `open_notification` |
| `notes` | `String` | Notes | `candidate only` |

All coordinate and margin fields remain `TBD` until the atlas exists.

This task does not create JSON, CSV, `.tres`, or any mapping file.

## 9-Slice Criteria

Phone UI cards, list items, screen panels, and navigation bars may need resizing while preserving visual corners and borders.

9-slice candidates:

```text
phone_device_frame
phone_screen_base
phone_header_bar
phone_bottom_nav_base
phone_app_tile_base
phone_app_tile_active
phone_list_item_base
phone_notification_card_base
phone_notification_card_warning
phone_mission_card_base
phone_log_card_base
phone_empty_state_panel
phone_scroll_panel
```

Non-9-slice candidates:

```text
phone_battery_icon_full
phone_battery_icon_low
phone_battery_icon_charging
phone_signal_icon_strong
phone_signal_icon_weak
phone_warning_icon
phone_divider_line
phone_close_button_idle
```

Criteria:

- Corners should not warp when resized.
- Border thickness should remain stable.
- Center area may stretch.
- Card / list item regions should support different text lengths.
- State variants for the same card or tile should keep matching size and margins.
- Margin values are finalized after actual atlas creation.
- This document keeps all margins as `TBD`.

This task does not create `StyleBoxTexture` or Theme Resource files.

## Phone UI State Criteria

Phone UI state candidates:

```text
normal
low_battery
charging
no_signal
weak_signal
unread
read
warning
critical
disabled
selected
active
inactive
```

State visual candidates:

```text
phone_battery_icon_full
phone_battery_icon_low
phone_battery_icon_charging
phone_signal_icon_strong
phone_signal_icon_weak
phone_signal_icon_none
phone_notification_card_warning
phone_app_tile_disabled
phone_app_tile_active
phone_message_bubble_unread_candidate
```

State variants should keep the same size, anchor, and 9-slice margins where they swap into the same UI slot. If sizes vary, the Phone UI will visually jump.

## Phone Screen Area Candidates

`phone_screen_area` candidates:

```text
device_frame
status_bar
header
app_grid
main_content
notification_list
message_thread
mission_list
log_view
settings_view
bottom_nav
overlay_warning
```

Examples:

| phone_ui_key | phone_screen_area |
| --- | --- |
| `phone_status_bar` | `status_bar` |
| `phone_app_tile_base` | `app_grid` |
| `phone_notification_card_base` | `notification_list` |
| `phone_message_bubble_in` | `message_thread` |
| `phone_mission_card_base` | `mission_list` |
| `phone_log_card_base` | `log_view` |
| `phone_bottom_nav_base` | `bottom_nav` |

This task does not change the actual `PhoneUI.tscn` layout.

## Value Binding Candidates

Phone UI value candidates:

```text
phone_battery
phone_charging_state
phone_signal_strength
phone_low_battery_warning
phone_unread_count
phone_notification_count
phone_message_count
phone_mission_available_count
grid_credit
survival_day
survival_time
active_device_count
connected_device_count
hacking_mission_status
story_flag_updates
```

These names are future binding hints only. This task does not connect `SurvivalState`, `GridCreditState`, `HackingMissionDefinition`, or story flags.

## Usage Context Candidates

`usage_context` candidates:

```text
phone_home
phone_notifications
phone_messages
phone_missions
phone_logs
phone_settings
phone_status
phone_warning_overlay
sandbox_phone_panel
```

Examples:

- `phone_app_tile_base`: `phone_home`
- `phone_notification_card_warning`: `phone_notifications` / `phone_warning_overlay`
- `phone_mission_card_base`: `phone_missions`
- `phone_log_card_base`: `phone_logs`
- `phone_battery_icon_low`: `phone_status` / `phone_warning_overlay`

## Relationship To Existing PhoneUI

The current `PhoneUI.tscn` is part of the existing Main / DAY 1 flow and uses a simple panel and labels. QuarterviewGameplaySandbox also has a sandbox-only Phone panel.

`ui_phone_atlas.png` does not immediately replace either UI.

This task does not:

- Modify `PhoneUI.tscn`.
- Modify `PhoneUI.gd`.
- Modify `Main.gd` Phone routing.
- Modify `SurvivalState` phone battery logic.
- Modify QuarterviewGameplaySandbox Phone panel.

Future connection candidate:

```text
ui_phone_atlas mapping
-> Phone UI visual parts
-> StyleBoxTexture / TextureRect / Theme candidates
-> existing PhoneUI visual replacement
-> sandbox phone panel visual replacement
-> future phone apps / messages / missions / logs screen
```

Visual replacement should be tested in sandbox or a dedicated viewer before replacing the existing Main / DAY 1 Phone UI.

## Future Phone App Candidates

Phone app candidates:

```text
status
messages
missions
logs
power_hint
settings
unknown_signal
grid_credit
```

This task does not implement app logic. It only defines visual region naming and mapping criteria for possible app tiles and screen parts.

## Other Atlas Separation

### `ui_phone_atlas.png` Includes

- Phone device frame.
- Phone screen background.
- Phone status bar.
- Phone app tile.
- Phone message bubble.
- Phone notification card.
- Phone mission / log card.
- Phone bottom nav.
- Phone battery / signal / charge icons.
- Phone warning visuals.

### `ui_phone_atlas.png` Excludes

- Generic button / panel / modal.
- Gameplay HUD frame / meter.
- Outlet UI layout.
- Result UI layout.
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
ui_outlet_atlas.png
ui_result_atlas.png
qv_fx_atlas.png
hack_fx_atlas.png
```

## UI Tone

Phone UI visual criteria:

- It should feel like a practical lower-city THE GRID terminal.
- It should feel slightly worn and utilitarian rather than like a clean modern smartphone.
- It should use a dark, restrained cyber interface.
- Message, notification, battery, and signal states should be readable quickly.
- It should not look like loud mobile SNS or gacha UI.
- It should not overpower the room art.
- Text should be rendered with Labels, not baked into images.
- Small screen layouts should remain identifiable.

## Example Mapping

The following table is only a schema example. Rects and margins are placeholders and must not be treated as final coordinates.

| phone_ui_key | category | screen_area | state | nine_slice | rect | margins | target_control | value_binding_hint | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `phone_device_frame` | `phone_frame` | `device_frame` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | outer device frame |
| `phone_screen_base` | `phone_screen` | `main_content` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | phone screen background |
| `phone_status_bar` | `phone_status_bar` | `status_bar` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `phone_battery` | status bar |
| `phone_header_bar` | `phone_header` | `header` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | app header |
| `phone_app_tile_base` | `app_tile` | `app_grid` | `base` | `true` | `TBD` | `TBD` | `Button / PanelContainer` | `none` | phone app tile |
| `phone_app_tile_active` | `app_tile` | `app_grid` | `active` | `true` | `TBD` | `TBD` | `Button / PanelContainer` | `none` | selected app tile |
| `phone_list_item_base` | `list_item` | `main_content` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | generic list item |
| `phone_message_bubble_in` | `message_bubble` | `message_thread` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `phone_message_count` | incoming message |
| `phone_message_bubble_out` | `message_bubble` | `message_thread` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `phone_message_count` | outgoing message |
| `phone_notification_card_warning` | `notification_card` | `notification_list` | `warning` | `true` | `TBD` | `TBD` | `PanelContainer` | `phone_low_battery_warning` | warning notification |
| `phone_mission_card_base` | `mission_card` | `mission_list` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `phone_mission_available_count` | mission card |
| `phone_log_card_base` | `log_card` | `log_view` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `story_flag_updates` | log card |
| `phone_battery_icon_low` | `icon` | `status_bar` | `low` | `false` | `TBD` | `none` | `TextureRect` | `phone_battery` | battery icon |
| `phone_signal_icon_weak` | `icon` | `status_bar` | `weak` | `false` | `TBD` | `none` | `TextureRect` | `phone_signal_strength` | signal icon |
| `phone_bottom_nav_base` | `phone_nav` | `bottom_nav` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | bottom nav |
| `phone_empty_state_panel` | `empty_state` | `main_content` | `empty` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | empty screen |

## Pre-Application Checklist

Before applying actual Phone atlas regions:

- Confirm the atlas PNG has a transparent background.
- Confirm Phone UI regions do not overlap incorrectly.
- Confirm every `phone_ui_key` uses lowercase `snake_case`.
- Confirm 9-slice and non-9-slice regions are separated.
- Confirm card / list / app tile state variants keep matching size and margins.
- Confirm icons do not include baked text.
- Confirm notification / message / mission cards can be composed without localization text baked into images.
- Confirm `ui_common_atlas.png` / `ui_hud_atlas.png` responsibilities are not mixed into `ui_phone_atlas.png`.
- Confirm Phone UI does not look like loud SNS or gacha UI.
- Confirm battery / signal / warning states read at small size.
- Confirm sandbox can test visual replacement before replacing existing `PhoneUI.tscn`.

## Future Application Order

Suggested future order:

1. Prepare final `ui_phone_atlas.png` asset.
2. Add PNG at the atlas path.
3. Write `phone_ui_key` and rect / margin list.
4. Choose mapping format: Resource, JSON, or CSV.
5. Create Phone atlas region viewer prototype.
6. Test a few frame / card regions in the sandbox Phone panel.
7. Review existing `PhoneUI.tscn` visual replacement.
8. Review separate phone home / notifications / messages / missions screens.
9. Review battery / signal / warning state visuals.
10. Review actual `SurvivalState`, `GridCreditState`, `HackingMissionDefinition`, and story flag wiring separately.

This task stops at documentation. It does not create PNG assets, import metadata, mapping files, Theme / StyleBox resources, Phone UI scenes, Control nodes, or gameplay wiring.
