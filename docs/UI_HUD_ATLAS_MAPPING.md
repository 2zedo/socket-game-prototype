# UI HUD Atlas Mapping

## Purpose

This document defines future region mapping rules for `ui_hud_atlas.png`.

The atlas is a candidate for gameplay HUD parts that are visible during play or updated frequently: power, phone battery, time, DAY badge, warnings, active / connected device badges, Grid Credit candidates, hacking Trace / HP / mission timer, objective markers, and small notifications.

It is not imported into Godot yet and is not connected to Main / DAY 1 UI, QuarterviewGameplaySandbox, HackingActionPrototype, PrototypeHub, Phone UI, Outlet UI, or Result UI.

Coordinates, 9-slice margins, safe-area offsets, and value bindings stay `TBD` until the actual PNG and HUD implementation exist.

## Atlas File

Future atlas file:

```text
ui_hud_atlas.png
```

Expected future Godot path:

```text
res://assets/ui/hud/atlases/ui_hud_atlas.png
```

Source / reference candidates:

```text
res://assets/ui/hud/atlases/source/
res://assets/ui/hud/atlases/reference/
```

Format criteria:

- PNG.
- RGBA / transparent background.
- HUD-specific UI parts only.
- No room shell background.
- No character sprite.
- No furniture / appliance / work-device sprite.
- No hacking arena tile / enemy / avatar / object / FX sprite.
- No full screenshot UI mockup.
- No localization text baked into regions.
- No third-party raw input prompt icons directly mixed in.
- Region names, meter behavior, chip behavior, badge behavior, and safe-area expectations are documented separately.

This task does not create the folders, PNG, `AtlasTexture`, `StyleBoxTexture`, Theme Resource, JSON, CSV, `.tres`, Control node, HUD scene, or mapping file.

## Atlas Role

`ui_hud_atlas.png` is a candidate for CONCENT's persistent or frequently visible gameplay status UI.

Owns:

- Gameplay top / bottom HUD frames.
- Power / battery / time / DAY / warning display parts.
- Connected / active device status badges.
- Grid Credit display candidates.
- Hacking mission Trace / HP / timer / objective visual candidates.
- Small notification chips.
- HUD meter frame / fill regions.
- HUD warning banner regions.

Does not own:

- Common panel / button / modal visuals.
- Phone / Outlet / Result internal screen layout.
- Actual value calculation.
- Actual HUD script logic.
- Localization text.
- Room shell art.
- Character sprites.
- Game object sprites.
- Hacking arena visuals.
- Kenney raw input prompt icon pack.

This document defines criteria only. It does not apply the atlas to any UI.

## Relationship To `ui_common_atlas`

`ui_common_atlas.png` owns generic UI parts:

- Common panel.
- Modal frame.
- Button states.
- Tab states.
- Common icon.
- Common meter frame / fill.
- Common badge.
- Prompt frame.

`ui_hud_atlas.png` owns gameplay HUD parts:

- Persistent gameplay HUD frames.
- HUD status chips.
- HUD warnings.
- Room HUD meters.
- Hacking HUD meters.
- DAY / time / power / battery / Trace / mission status visuals.
- Compact visuals tuned for HUD layout.

Phone screen-specific UI components belong to `ui_phone_atlas.png`, even if they display similar values such as battery, signal, warning, mission, or Grid Credit state.

Separation rules:

- If a region is used as a generic button, panel, modal, tab, or dialog piece, it belongs to `ui_common_atlas.png`.
- If a region persistently communicates gameplay state during room or hacking play, it belongs to `ui_hud_atlas.png`.
- If Phone / Outlet / Result internal UI grows too specific, it may need a later screen-specific atlas.
- HUD warning banners belong to `ui_hud_atlas.png`; modal / dialog warning frames belong to `ui_common_atlas.png`.

## HUD Category Candidates

HUD categories are broad region families.

```text
hud_frame
status_chip
resource_meter
warning
alert_banner
day_time
device_status
credit
mission_status
trace
hp
timer
objective
notification
icon
```

Examples:

| hud_key | category |
| --- | --- |
| `hud_top_bar_frame` | `hud_frame` |
| `hud_status_chip_frame` | `status_chip` |
| `hud_power_meter_frame` | `resource_meter` |
| `hud_power_meter_fill` | `resource_meter` |
| `hud_low_power_warning` | `warning` |
| `hud_day_badge` | `day_time` |
| `hud_device_connected_badge` | `device_status` |
| `hud_credit_chip` | `credit` |
| `hud_trace_meter_frame` | `trace` |
| `hud_hp_meter_frame` | `hp` |
| `hud_mission_timer_frame` | `timer` |
| `hud_objective_marker` | `objective` |
| `hud_alert_banner` | `alert_banner` |

## Region Key Naming

`hud_key` identifies a future HUD atlas region.

Rules:

- Use lowercase `snake_case`.
- Use `hud` + role + state / variation.
- Split meter frame and fill regions.
- Use suffixes when state or size variations exist.
- Name by function / role, not by baked text content.
- Do not use temporary number-only keys.
- Do not use `final`, `new`, `tmp`, or screenshot-export names.

Good examples:

```text
hud_top_bar_frame
hud_bottom_bar_frame
hud_status_chip_frame
hud_power_meter_frame
hud_power_meter_fill
hud_battery_meter_frame
hud_battery_meter_fill
hud_trace_meter_frame
hud_trace_meter_fill
hud_hp_meter_frame
hud_hp_meter_fill
hud_day_badge
hud_time_frame
hud_warning_chip
hud_low_power_warning
hud_device_connected_badge
hud_device_active_badge
hud_credit_chip
hud_objective_marker
hud_mission_timer_frame
hud_mission_timer_fill
hud_alert_banner
```

Bad examples:

```text
hud1
image_001
final_hud_new
tmp_bar
red_warning_text
screenshot_part_a
```

State / variation suffix candidates:

```text
_base
_active
_inactive
_warning
_danger
_critical
_success
_low
_empty
_full
_small
_large
_room
_hacking
```

## Region Mapping Schema

Future mapping metadata may use Resource, JSON, CSV, or another explicit format. This task only documents the schema.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `hud_key` | `String` | HUD region identifier | `hud_power_meter_frame` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/ui/hud/atlases/ui_hud_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `category` | `String` | HUD category | `resource_meter` |
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
| `scale_policy` | `String` | Stretch / clip / keep candidate | `clip_fill` |
| `anchor_slot` | `String` | Screen placement candidate | `top_left` |
| `safe_area_policy` | `String` | Safe area handling candidate | `respect_safe_area` |
| `priority` | `int` | Display priority candidate | `50` |
| `target_context` | `String` | Screen candidate | `quarterview_room` |
| `value_binding_hint` | `String` | Future value source candidate | `survival_power` |
| `update_policy` | `String` | Future refresh policy | `on_signal` |
| `target_control` | `String` | Godot Control candidate | `TextureProgressBar` |
| `theme_role` | `String` | Theme role candidate | `hud_power_meter` |
| `notes` | `String` | Notes | `candidate only` |

All coordinate and margin fields remain `TBD` until the atlas exists.

This task does not create JSON, CSV, `.tres`, or any mapping file.

## HUD Context Candidates

`target_context` candidates:

```text
common_hud
quarterview_room
day1_main
phone_overlay
outlet_overlay
hacking_arena
mission_select
debug_hud
prototype_only
```

### Quarterview Room HUD Candidates

Future room HUD may show:

- DAY.
- Time.
- Power.
- Phone battery.
- Active devices.
- Warning.
- Grid Credit candidate.
- Small objective / next-action candidate.

### Hacking Arena HUD Candidates

Future hacking HUD may show:

- HP.
- Trace.
- Mission timer.
- Objective status.
- Extraction progress.
- Warning / alarm.
- Success / fail transition candidates.

This task does not create or connect actual HUD UI.

## Value Binding Candidates

Room / DAY candidates:

```text
survival_day
survival_time
survival_power
survival_power_drain
phone_battery
active_device_count
connected_device_count
low_power_warning
phone_low_battery_warning
grid_credit
next_action_hint
```

Hacking candidates:

```text
hacking_hp
hacking_trace
hacking_timer
hacking_objective_state
hacking_extraction_progress
hacking_enemy_alert
hacking_alarm_state
hacking_mission_state
```

These names are future binding hints only. This task does not connect `SurvivalState`, `GridCreditState`, `HackingActionPrototype`, or any mission data.

## 9-Slice Criteria

HUD frames, chips, and banners may need resizing while keeping readable corners and borders.

9-slice candidates:

```text
hud_top_bar_frame
hud_bottom_bar_frame
hud_status_chip_frame
hud_warning_chip
hud_alert_banner
hud_credit_chip
hud_day_badge
hud_time_frame
hud_mission_timer_frame
hud_power_meter_frame
hud_battery_meter_frame
hud_trace_meter_frame
hud_hp_meter_frame
```

Non-9-slice candidates:

```text
hud_power_meter_fill
hud_battery_meter_fill
hud_trace_meter_fill
hud_hp_meter_fill
hud_objective_marker
small icons
warning icons
```

Criteria:

- Corners should not warp when resized.
- Border thickness should remain stable.
- Center area may stretch.
- Fill regions express values through clip / stretch behavior.
- Margin values are finalized after actual atlas creation.
- This document keeps all margins as `TBD`.

This task does not create `StyleBoxTexture` or Theme Resource files.

## Meter / Gauge Criteria

Meter candidates:

```text
hud_power_meter_frame
hud_power_meter_fill
hud_battery_meter_frame
hud_battery_meter_fill
hud_trace_meter_frame
hud_trace_meter_fill
hud_hp_meter_frame
hud_hp_meter_fill
hud_mission_timer_frame
hud_mission_timer_fill
```

Criteria:

- Split frame and fill.
- Use clip or scale behavior for fill candidates.
- Prefer `modulate` for warning / critical color when possible instead of baking many color variants.
- Keep separate warning / critical fill regions only when readability requires it.
- Actual value binding belongs to UI script logic.
- Meter animation is a later Tween / AnimationPlayer candidate.

This task does not create `TextureProgressBar` nodes.

## Warning / Alert Criteria

Warning candidates:

```text
hud_warning_chip
hud_low_power_warning
hud_phone_low_warning
hud_trace_warning
hud_alarm_warning
hud_critical_banner
hud_device_error_badge
```

Criteria:

- Warnings must be clear without covering too much of the screen.
- Low / warning / critical states should be distinguishable.
- Flashing effects should be animation / FX / UI logic, not baked into the atlas.
- Warning text should not be baked into images.
- Localization remains separate in production UI.

## Safe Area / Anchor Criteria

`anchor_slot` candidates:

```text
top_left
top_center
top_right
bottom_left
bottom_center
bottom_right
left_center
right_center
floating_near_target
```

`safe_area_policy` candidates:

```text
respect_safe_area
ignore_safe_area_debug_only
fixed_margin
adaptive_margin
```

Criteria:

- Consider desktop and mobile screen bounds.
- HUD should not hide room / player / object readability.
- Hacking HUD should not hurt action readability.
- Warning banners are temporary display candidates.
- Debug HUD and production HUD remain separate.
- Safe area and aspect ratio behavior must be verified in the actual UI implementation pass.

## Update Policy Criteria

`update_policy` candidates:

```text
static
on_signal
every_frame
on_timer_tick
on_value_changed
on_mission_state_changed
debug_only
```

Criteria:

- Power / time / battery are signal or tick candidates.
- Trace / HP are value-changed candidates.
- Objective state is a mission-state-changed candidate.
- Decorative HUD elements are static candidates.
- Use `every_frame` only when necessary.

This task does not create update logic.

## Other Atlas Separation

### `ui_hud_atlas.png` Includes

- Gameplay HUD frames.
- Status chips.
- Power / battery / Trace / HP / timer meters.
- HUD warning chips.
- DAY / time badges.
- Mission objective marker.
- HUD notification frame.
- Active / connected device badges.

### `ui_hud_atlas.png` Excludes

- Modal panel.
- Generic button.
- General-purpose dialog frame.
- Phone UI full-screen parts.
- Outlet UI full-screen parts.
- Result UI full-screen parts.
- Room shell.
- Character sprite.
- Game object sprite.
- Hacking arena tile / enemy / avatar / object / FX sprite.
- Localization text.
- Kenney raw input prompt icons.

Other atlas candidates:

```text
ui_common_atlas.png
ui_phone_atlas.png
ui_outlet_atlas.png
ui_result_atlas.png
qv_fx_atlas.png
hack_fx_atlas.png
```

## UI Tone

HUD visual criteria:

- Information should be readable quickly.
- The tone should feel like THE GRID's industrial / management-system interface.
- The interface should be dark, restrained, and cyber without becoming loud arcade UI.
- HUD should not overpower room or hacking visuals.
- Warnings should be clear without making the screen messy.
- Small mobile layouts should remain identifiable.
- Debug HUD and production HUD should be visually distinguishable.
- HUD prioritizes function over decoration.

## Example Mapping

The following table is only a schema example. Rects and margins are placeholders and must not be treated as final coordinates.

| hud_key | category | context | value_binding_hint | state | nine_slice | rect | margins | anchor_slot | target_control | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `hud_top_bar_frame` | `hud_frame` | `common_hud` | `none` | `base` | `true` | `TBD` | `TBD` | `top_center` | `PanelContainer` | top HUD container |
| `hud_power_meter_frame` | `resource_meter` | `quarterview_room` | `survival_power` | `base` | `true` | `TBD` | `TBD` | `top_left` | `TextureProgressBar` | power frame |
| `hud_power_meter_fill` | `resource_meter` | `quarterview_room` | `survival_power` | `base` | `false` | `TBD` | `none` | `top_left` | `TextureProgressBar` | power fill |
| `hud_battery_meter_frame` | `resource_meter` | `quarterview_room` | `phone_battery` | `base` | `true` | `TBD` | `TBD` | `top_left` | `TextureProgressBar` | phone battery frame |
| `hud_battery_meter_fill` | `resource_meter` | `quarterview_room` | `phone_battery` | `base` | `false` | `TBD` | `none` | `top_left` | `TextureProgressBar` | phone battery fill |
| `hud_day_badge` | `day_time` | `quarterview_room` | `survival_day` | `base` | `true` | `TBD` | `TBD` | `top_left` | `PanelContainer` | day display |
| `hud_time_frame` | `day_time` | `quarterview_room` | `survival_time` | `base` | `true` | `TBD` | `TBD` | `top_left` | `PanelContainer` | time display |
| `hud_warning_chip` | `warning` | `common_hud` | `warning_state` | `warning` | `true` | `TBD` | `TBD` | `top_center` | `PanelContainer` | warning chip |
| `hud_credit_chip` | `credit` | `quarterview_room` | `grid_credit` | `base` | `true` | `TBD` | `TBD` | `top_right` | `PanelContainer` | future economy display |
| `hud_trace_meter_frame` | `trace` | `hacking_arena` | `hacking_trace` | `base` | `true` | `TBD` | `TBD` | `top_right` | `TextureProgressBar` | trace frame |
| `hud_trace_meter_fill` | `trace` | `hacking_arena` | `hacking_trace` | `base` | `false` | `TBD` | `none` | `top_right` | `TextureProgressBar` | trace fill |
| `hud_hp_meter_frame` | `hp` | `hacking_arena` | `hacking_hp` | `base` | `true` | `TBD` | `TBD` | `top_left` | `TextureProgressBar` | HP frame |
| `hud_hp_meter_fill` | `hp` | `hacking_arena` | `hacking_hp` | `base` | `false` | `TBD` | `none` | `top_left` | `TextureProgressBar` | HP fill |
| `hud_mission_timer_frame` | `timer` | `hacking_arena` | `hacking_timer` | `base` | `true` | `TBD` | `TBD` | `top_center` | `TextureProgressBar` | mission timer |
| `hud_objective_marker` | `objective` | `hacking_arena` | `hacking_objective_state` | `active` | `false` | `TBD` | `none` | `top_center` | `TextureRect` | objective status |
| `hud_alert_banner` | `alert_banner` | `common_hud` | `alert_state` | `warning` | `true` | `TBD` | `TBD` | `top_center` | `PanelContainer` | temporary alert |

## Pre-Application Checklist

Before applying actual HUD atlas regions:

- Confirm `ui_hud_atlas.png` exists at the documented path.
- Confirm all HUD regions display without cropping.
- Confirm meter frame / fill alignment.
- Confirm 9-slice margins preserve corners and borders.
- Confirm warning / status chips are readable on room and hacking backgrounds.
- Confirm HUD respects safe area assumptions.
- Confirm room HUD does not hide interactable objects.
- Confirm hacking HUD does not hide action readability.
- Confirm localization text is not baked into HUD images.
- Confirm Kenney input prompt icons remain separate unless intentionally wrapped by a HUD prompt frame.
- Confirm `ui_common_atlas.png` and `ui_hud_atlas.png` responsibilities are not mixed.
- Confirm no Main / DAY 1 gameplay value is changed by visual application.

## Future Application Order

Suggested future order:

1. Prepare final `ui_hud_atlas.png` asset.
2. Add PNG at the atlas path.
3. Write `hud_key` and rect / margin list.
4. Choose mapping format: Resource, JSON, or CSV.
5. Create HUD atlas region viewer prototype.
6. Apply room HUD mock.
7. Apply hacking HUD mock.
8. Verify power / battery / time / Trace / HP meter display.
9. Verify warning / alert chip readability.
10. Review actual `SurvivalState`, `GridCreditState`, and `HackingActionPrototype` wiring separately.

This task stops at documentation. It does not create PNG assets, import metadata, mapping files, Theme / StyleBox resources, HUD scenes, Control nodes, or gameplay wiring.
