# UI Result Log Atlas Mapping

## Purpose

This document defines future region mapping rules for `ui_result_log_atlas.png`.

The atlas is a candidate for Result / Log UI-specific visual parts used by day result summaries, power reports, device usage logs, hacking mission results, reward rows, Grid Credit rows, story logs, event logs, warning entries, and empty-state panels.

It is not imported into Godot yet and is not connected to Main / DAY 1 `DayResultPanel`, QuarterviewGameplaySandbox, HackingActionPrototype, PrototypeHub, `SurvivalState`, `GridCreditState`, `HackingMissionDefinition`, save / load, or story flags.

Coordinates, 9-slice margins, result areas, severity states, and future value bindings stay `TBD` until the actual PNG and UI implementation exist.

## Atlas File

Future atlas file:

```text
ui_result_log_atlas.png
```

Expected future Godot path:

```text
res://assets/ui/result_log/atlases/ui_result_log_atlas.png
```

Source / reference candidates:

```text
res://assets/ui/result_log/atlases/source/
res://assets/ui/result_log/atlases/reference/
```

Format criteria:

- PNG.
- RGBA / transparent background.
- Result / Log UI-specific visual parts only.
- No room shell background.
- No character sprite.
- No furniture / appliance / work-device sprite.
- No hacking arena tile / enemy / avatar / object / FX sprite.
- No full screenshot UI mockup.
- No localization text baked into regions.
- No third-party raw input prompt icons directly mixed in.
- Region names and 9-slice margins are documented separately.

This task does not create the folders, PNG, `AtlasTexture`, `StyleBoxTexture`, Theme Resource, JSON, CSV, `.tres`, Control node, Result UI scene, or mapping file.

## Atlas Role

`ui_result_log_atlas.png` is a candidate for day result, mission result, record log, and reward summary screen visual parts.

Owns:

- Result UI panel frame.
- Result header / banner.
- Summary card.
- Stat row.
- Power report card.
- Device usage log card.
- Warning / success / fail / neutral badge.
- Reward row.
- Grid Credit row candidate.
- Story log card.
- Hacking mission result card.
- Day stamp badge.
- Log entry card.
- Log category chip.
- Empty-state panel.

Does not own:

- Common button / panel / modal visuals.
- Gameplay HUD visuals.
- Phone UI layout.
- Outlet UI layout.
- Actual result calculation.
- Actual day advance.
- Actual save / load.
- Actual reward granting.
- Localization text.
- Room shell art.
- Character sprites.
- Game object sprites.
- Hacking arena visuals.

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
- Gameplay status badges.
- Warning chips.

### `ui_phone_atlas.png`

Owns:

- Phone UI-specific frame.
- Phone app tile.
- Phone message bubble.
- Phone notification card.
- Phone mission / log card.

### `ui_result_log_atlas.png`

Owns:

- Day result screens.
- Mission result screens.
- Event / story / device / power log cards.
- Reward / penalty / warning / success / fail summary visuals.
- UI for reading recorded outcomes.

Separation rules:

- If a region is used as a generic button, panel, modal, tab, or dialog piece, it belongs to `ui_common_atlas.png`.
- If a region persistently communicates gameplay state during room or hacking play, it belongs to `ui_hud_atlas.png`.
- If a region is used inside the Phone UI screen, it belongs to `ui_phone_atlas.png`.
- If a region represents day / mission / log result cards, rows, or badges, it belongs to `ui_result_log_atlas.png`.
- Result screens can still reuse generic continue-button visuals from `ui_common_atlas.png`.
- Result and log cards may reference `ui_device_icons_atlas.png` for device usage entries, while result / log card frames, report rows, reward rows, and state badges remain in `ui_result_log_atlas.png`.

## Result / Log UI Category Candidates

Result / Log UI categories are broad region families.

```text
result_panel
result_header
summary_card
stat_row
power_report
device_log
mission_log
story_log
reward
grid_credit
warning
success
failure
neutral
day_stamp
score_chip
log_panel
log_entry
log_category
empty_state
divider
```

Examples:

| result_ui_key | category |
| --- | --- |
| `result_panel_frame` | `result_panel` |
| `result_header_banner` | `result_header` |
| `result_summary_card` | `summary_card` |
| `result_power_report_card` | `power_report` |
| `result_device_log_card` | `device_log` |
| `result_mission_log_card` | `mission_log` |
| `result_story_log_card` | `story_log` |
| `result_reward_row` | `reward` |
| `result_grid_credit_row` | `grid_credit` |
| `result_warning_entry` | `warning` |
| `result_success_badge` | `success` |
| `result_fail_badge` | `failure` |
| `log_entry_card` | `log_entry` |
| `log_category_chip` | `log_category` |

## Region Key Naming

`result_ui_key` identifies a future Result / Log UI atlas region.

Rules:

- Use lowercase `snake_case`.
- Use `result` or `log` + role + state / variation.
- Use suffixes when state or size variations exist.
- Name by function / role, not by baked text content.
- Do not use temporary number-only keys.
- Do not use `final`, `new`, `tmp`, or screenshot-export names.

Good examples:

```text
result_panel_frame
result_header_banner
result_summary_card
result_stat_row_base
result_power_report_card
result_device_log_card
result_mission_log_card
result_story_log_card
result_reward_row
result_grid_credit_row
result_warning_entry
result_success_badge
result_fail_badge
result_neutral_badge
result_day_stamp_badge
result_score_chip
log_panel_frame
log_entry_card
log_entry_unread_badge
log_category_chip
log_empty_state_panel
log_divider_line
```

Bad examples:

```text
result1
image_001
final_result_new
tmp_log
red_text_card
screenshot_part_a
```

State / variation suffix candidates:

```text
_base
_active
_inactive
_warning
_danger
_success
_fail
_neutral
_unread
_read
_new
_completed
_failed
_small
_large
_compact
```

## Region Mapping Schema

Future mapping metadata may use Resource, JSON, CSV, or another explicit format. This task only documents the schema.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `result_ui_key` | `String` | Result / Log UI region identifier | `result_power_report_card` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/ui/result_log/atlases/ui_result_log_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `category` | `String` | Result / Log UI category | `power_report` |
| `visual_state` | `String` | Visual state | `base` |
| `nine_slice` | `bool` | Whether 9-slice is expected | `true` |
| `margin_left` | `int` | 9-slice left margin | `TBD` |
| `margin_top` | `int` | 9-slice top margin | `TBD` |
| `margin_right` | `int` | 9-slice right margin | `TBD` |
| `margin_bottom` | `int` | 9-slice bottom margin | `TBD` |
| `min_width` | `int` | Minimum display width | `TBD` |
| `min_height` | `int` | Minimum display height | `TBD` |
| `default_modulate` | `String` | Default color modulation | `#FFFFFF` |
| `default_alpha` | `float` | Default alpha | `1.0` |
| `scale_policy` | `String` | Stretch / keep candidate | `stretch_9slice` |
| `result_area` | `String` | Result screen area candidate | `power_summary` |
| `target_control` | `String` | Godot Control candidate | `PanelContainer` |
| `usage_context` | `String` | Screen candidate | `day_result` |
| `value_binding_hint` | `String` | Future value source candidate | `active_power_drain` |
| `log_category_hint` | `String` | Log category candidate | `power` |
| `severity_hint` | `String` | Severity candidate | `neutral` |
| `notes` | `String` | Notes | `candidate only` |

All coordinate and margin fields remain `TBD` until the atlas exists.

This task does not create JSON, CSV, `.tres`, or any mapping file.

## 9-Slice Criteria

Result / Log UI panels, cards, and rows may need resizing while preserving visual corners and borders.

9-slice candidates:

```text
result_panel_frame
result_header_banner
result_summary_card
result_stat_row_base
result_power_report_card
result_device_log_card
result_mission_log_card
result_story_log_card
result_reward_row
result_grid_credit_row
result_warning_entry
log_panel_frame
log_entry_card
log_category_chip
log_empty_state_panel
```

Non-9-slice candidates:

```text
result_success_badge
result_fail_badge
result_neutral_badge
log_divider_line
small icon-like markers
```

`result_day_stamp_badge` and `result_score_chip` may be 9-slice if they need variable width.

Criteria:

- Corners should not warp when resized.
- Border thickness should remain stable.
- Card / list row visuals should support different text lengths.
- State variants for the same badge or card should keep matching size and margins.
- Margin values are finalized after actual atlas creation.
- This document keeps all margins as `TBD`.

This task does not create `StyleBoxTexture` or Theme Resource files.

## Result Area Candidates

`result_area` candidates:

```text
header
day_summary
power_summary
battery_summary
device_summary
mission_summary
reward_summary
grid_credit_summary
story_log
warning_log
event_log
footer
empty_state
```

Examples:

| result_ui_key | result_area |
| --- | --- |
| `result_header_banner` | `header` |
| `result_summary_card` | `day_summary` |
| `result_power_report_card` | `power_summary` |
| `result_device_log_card` | `device_summary` |
| `result_mission_log_card` | `mission_summary` |
| `result_reward_row` | `reward_summary` |
| `result_grid_credit_row` | `grid_credit_summary` |
| `result_story_log_card` | `story_log` |
| `result_warning_entry` | `warning_log` |

This task does not change the actual `DayResultPanel.tscn` layout.

## Usage Context Candidates

`usage_context` candidates:

```text
day_result
mission_result
story_log
device_log
power_log
reward_log
phone_log_view
debug_result
sandbox_result_mock
```

Examples:

- `result_power_report_card`: `day_result` / `power_log`
- `result_mission_log_card`: `mission_result` / `phone_log_view`
- `result_story_log_card`: `story_log`
- `result_grid_credit_row`: `day_result` / `reward_log`
- `log_entry_card`: `story_log` / `device_log` / `phone_log_view`

## Value Binding Candidates

DAY / `SurvivalState` candidates:

```text
survival_day
day_start_time
day_end_time
final_power
power_used
active_power_drain
phone_battery_end
connected_device_count
active_device_count
low_power_warning_count
phone_low_battery_warning_count
end_reason
slept_early
slept_late
```

Device candidates:

```text
device_key
device_display_name
device_connected
device_active
device_drain
device_result_flag
device_usage_summary
```

Hacking candidates:

```text
mission_key
mission_display_name
mission_success
mission_failure_reason
trace_final
hacking_reward_grid_credit
reward_info_keys
story_flags_unlocked
```

Grid Credit candidates:

```text
grid_credit_delta
grid_credit_current
grid_credit_lifetime_earned
grid_credit_lifetime_spent
```

Story / Log candidates:

```text
story_log_key
story_log_title
story_log_body
story_flag_key
event_log_category
event_log_severity
```

These names are future binding hints only. This task does not connect `SurvivalState`, `GridCreditState`, `HackingMissionDefinition`, story flags, or Result data.

## Severity / Result State Criteria

`severity_hint` candidates:

```text
info
neutral
success
warning
danger
failure
new
important
```

`visual_state` candidates:

```text
base
success
fail
warning
neutral
unread
read
new
completed
failed
locked
unlocked
```

Examples:

- `result_success_badge`: `severity_hint = success`
- `result_fail_badge`: `severity_hint = failure`
- `result_warning_entry`: `severity_hint = warning`
- `log_entry_unread_badge`: `visual_state = unread`
- `result_story_log_card`: `severity_hint = important`

State variants should keep the same size, anchor, and 9-slice margins where they swap into the same UI slot. If sizes vary, Result / Log UI will visually jump.

## Relationship To Existing DayResultPanel

The current `DayResultPanel.tscn` is part of the existing Main / DAY 1 result flow and uses a panel, labels, and runtime text builders.

`ui_result_log_atlas.png` does not immediately replace `DayResultPanel`.

This task does not:

- Modify `DayResultPanel.tscn`.
- Modify `DayResultPanel.gd`.
- Modify `Main.gd` result routing.
- Modify `SurvivalState` day result calculation.
- Implement Result history.
- Implement save / load.
- Modify QuarterviewGameplaySandbox result flow.

Future connection candidate:

```text
ui_result_log_atlas mapping
-> Result UI visual parts
-> StyleBoxTexture / TextureRect / Theme candidates
-> existing DayResultPanel visual replacement
-> sandbox result mock visual replacement
-> future day result / mission result / story log screen
```

Visual replacement should be tested in sandbox or a dedicated viewer before replacing the existing Main / DAY 1 Result UI.

## Future Result / Log Screen Candidates

Future screen candidates:

```text
day_result_summary
power_usage_report
device_usage_report
phone_battery_report
hacking_mission_result
reward_summary
grid_credit_report
story_log_update
event_log_history
warning_history
```

This task does not implement any new screen. It only defines visual region naming and mapping criteria for possible Result / Log UI parts.

## Other Atlas Separation

### `ui_result_log_atlas.png` Includes

- Result panel frame.
- Result summary card.
- Stat row.
- Power / device / mission / story log card.
- Reward row.
- Grid Credit row.
- Success / fail / warning / neutral badge.
- Log entry card.
- Log category chip.
- Empty-state panel.

### `ui_result_log_atlas.png` Excludes

- Generic button / panel / modal.
- Gameplay HUD frame / meter.
- Phone UI app / message / notification cards.
- Outlet UI slot / device cards.
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
ui_outlet_atlas.png
qv_fx_atlas.png
hack_fx_atlas.png
```

## UI Tone

Result / Log UI visual criteria:

- Day results should be calm and readable.
- The tone should feel like THE GRID's management system / work report.
- Success / failure / warning / neutral states should be clear.
- Rewards and losses should be quickly distinguishable.
- Story logs should feel like information-terminal records.
- It should feel more like a management report plus survival log than a loud victory screen.
- Text should be rendered with Labels, not baked into images.
- Cards, rows, and badges should remain readable on smaller screens.

## Example Mapping

The following table is only a schema example. Rects and margins are placeholders and must not be treated as final coordinates.

| result_ui_key | category | area | state | nine_slice | rect | margins | target_control | value_binding_hint | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `result_panel_frame` | `result_panel` | `day_summary` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | main result panel |
| `result_header_banner` | `result_header` | `header` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `survival_day` | result header |
| `result_summary_card` | `summary_card` | `day_summary` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `end_reason` | day summary |
| `result_stat_row_base` | `stat_row` | `day_summary` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `generic_stat` | reusable stat row |
| `result_power_report_card` | `power_report` | `power_summary` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `power_used` | power result |
| `result_device_log_card` | `device_log` | `device_summary` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `device_usage_summary` | device log |
| `result_mission_log_card` | `mission_log` | `mission_summary` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `mission_key` | hacking mission result |
| `result_story_log_card` | `story_log` | `story_log` | `important` | `true` | `TBD` | `TBD` | `PanelContainer` | `story_flag_key` | story update |
| `result_reward_row` | `reward` | `reward_summary` | `success` | `true` | `TBD` | `TBD` | `PanelContainer` | `reward_info_keys` | reward row |
| `result_grid_credit_row` | `grid_credit` | `grid_credit_summary` | `success` | `true` | `TBD` | `TBD` | `PanelContainer` | `grid_credit_delta` | grid credit row |
| `result_warning_entry` | `warning` | `warning_log` | `warning` | `true` | `TBD` | `TBD` | `PanelContainer` | `warning_state` | warning entry |
| `result_success_badge` | `success` | `mission_summary` | `success` | `false` | `TBD` | `none` | `TextureRect` | `mission_success` | success badge |
| `result_fail_badge` | `failure` | `mission_summary` | `fail` | `false` | `TBD` | `none` | `TextureRect` | `mission_success` | fail badge |
| `result_day_stamp_badge` | `day_stamp` | `header` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `survival_day` | day stamp |
| `log_panel_frame` | `log_panel` | `event_log` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | log panel |
| `log_entry_card` | `log_entry` | `event_log` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `event_log_category` | log entry |
| `log_entry_unread_badge` | `log_entry` | `event_log` | `unread` | `false` | `TBD` | `none` | `TextureRect` | `unread_state` | unread badge |
| `log_category_chip` | `log_category` | `event_log` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `event_log_category` | category chip |
| `log_empty_state_panel` | `empty_state` | `empty_state` | `empty` | `true` | `TBD` | `TBD` | `PanelContainer` | `none` | empty state |

## Pre-Application Checklist

Before applying actual Result / Log atlas regions:

- Confirm the atlas PNG has a transparent background.
- Confirm Result / Log UI regions do not overlap incorrectly.
- Confirm every `result_ui_key` uses lowercase `snake_case`.
- Confirm 9-slice and non-9-slice regions are separated.
- Confirm card / row / badge state variants keep matching size and margins.
- Confirm success / fail / warning / neutral states are visually distinct.
- Confirm power / device / mission / story log card roles are not mixed.
- Confirm localization text is not baked into images.
- Confirm `ui_common_atlas.png`, `ui_hud_atlas.png`, `ui_phone_atlas.png`, and `ui_outlet_atlas.png` responsibilities are not mixed into `ui_result_log_atlas.png`.
- Confirm sandbox or mock panel can test visual replacement before replacing existing `DayResultPanel.tscn`.
- Confirm the result screen feels like a THE GRID management report rather than a loud victory screen.

## Future Application Order

Suggested future order:

1. Prepare final `ui_result_log_atlas.png` asset.
2. Add PNG at the atlas path.
3. Write `result_ui_key` and rect / margin list.
4. Choose mapping format: Resource, JSON, or CSV.
5. Create Result / Log atlas region viewer prototype.
6. Test a few card / row / badge regions in a sandbox result mock panel.
7. Review existing `DayResultPanel.tscn` visual replacement.
8. Review separate day result / mission result / story log screens.
9. Review reward / Grid Credit / story flag display.
10. Review actual `SurvivalState`, `GridCreditState`, `HackingMissionDefinition`, and story flag wiring separately.

This task stops at documentation. It does not create PNG assets, import metadata, mapping files, Theme / StyleBox resources, Result UI scenes, Control nodes, or gameplay wiring.
