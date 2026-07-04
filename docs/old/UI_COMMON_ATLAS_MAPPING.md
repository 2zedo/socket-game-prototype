# UI Common Atlas Mapping

## Purpose

This document defines future region mapping rules for `ui_common_atlas.png`.

The atlas is a candidate for shared UI visual parts used across CONCENT screens: panels, modal frames, button states, icons, meters, badges, dividers, prompt frames, tabs, cursor markers, and close-button visuals. It is not imported into Godot yet and is not connected to Main / DAY 1 UI, Phone UI, Outlet UI, Result UI, PrototypeHub, QuarterviewGameplaySandbox, or HackingActionPrototype.

Coordinates and 9-slice margins stay `TBD` until the actual PNG exists.

## Atlas File

Future atlas file:

```text
ui_common_atlas.png
```

Expected future Godot path:

```text
res://assets/ui/common/atlases/ui_common_atlas.png
```

Source / reference candidates:

```text
res://assets/ui/common/atlases/source/
res://assets/ui/common/atlases/reference/
```

Format criteria:

- PNG.
- RGBA / transparent background.
- Common UI visual parts only.
- No room shell background.
- No character sprite.
- No furniture / appliance / work-device sprite.
- No hacking arena tile / enemy / avatar / object sprite.
- No full screenshot UI mockup.
- No text baked into regions when avoidable.
- Region names and 9-slice margins are documented separately.

This task does not create the folders, PNG, `AtlasTexture`, `StyleBoxTexture`, Theme Resource, JSON, CSV, `.tres`, or any mapping file.

## Atlas Role

`ui_common_atlas.png` is a candidate for UI pieces that repeat across room UI, hacking UI, prototype UI, modal UI, and status UI.

Gameplay-specific persistent HUD elements such as power, time, battery, Trace, HP, timer, warning chips, and status chips belong to the separate `ui_hud_atlas.png` workflow documented in `docs/UI_HUD_ATLAS_MAPPING.md`.

Phone-specific frames, app tiles, message bubbles, notifications, and phone screen parts belong to the separate `ui_phone_atlas.png` workflow documented in `docs/UI_PHONE_ATLAS_MAPPING.md`.

Outlet-specific socket slots, device cards, drag / drop highlights, and outlet power-state visuals belong to the separate `ui_outlet_atlas.png` workflow documented in `docs/UI_OUTLET_ATLAS_MAPPING.md`.

Result-specific summary cards, log entries, reward rows, report badges, and day / mission result panels belong to the separate `ui_result_log_atlas.png` workflow documented in `docs/UI_RESULT_LOG_ATLAS_MAPPING.md`.

Dialogue-specific panels, nameplates, choice buttons, portrait frames, dialogue tails, and continue indicators belong to the separate `ui_dialogue_atlas.png` workflow documented in `docs/UI_DIALOGUE_ATLAS_MAPPING.md`.

Device-specific icons may be separated into the `ui_device_icons_atlas.png` workflow documented in `docs/UI_DEVICE_ICONS_ATLAS_MAPPING.md`; `ui_common_atlas.png` keeps generic warning / info / close / prompt icons.

Owns:

- Panel frame.
- Modal frame.
- Button base / state visuals.
- Small status chips.
- Icons.
- Meter frame / fill.
- Divider.
- Badge.
- Prompt frame.
- Close / tab / button visual parts.

Does not own:

- Actual localized text.
- UI logic.
- Phone / Outlet / Result screen layout.
- Room shell art.
- Character sprites.
- Game objects.
- Hacking arena visuals.
- Kenney raw input prompt icon pack.

This document defines criteria only. It does not apply the atlas to any UI.

## UI Category Candidates

UI categories are broad region families.

```text
panel
modal
button
icon
meter
badge
divider
prompt
tab
cursor
warning
status_chip
frame
background_tile
```

Examples:

| ui_key | category |
| --- | --- |
| `panel_frame_base` | `panel` |
| `modal_panel_base` | `modal` |
| `button_base` | `button` |
| `button_hover` | `button` |
| `icon_power` | `icon` |
| `icon_battery` | `icon` |
| `meter_frame_thin` | `meter` |
| `meter_fill_power` | `meter` |
| `badge_connected` | `badge` |
| `prompt_frame_small` | `prompt` |
| `divider_line_thin` | `divider` |
| `tab_button_active` | `tab` |

## Region Key Naming

`ui_key` identifies a future UI atlas region.

Rules:

- Use lowercase `snake_case`.
- Use UI role + state / variation.
- Use suffixes for button, tab, warning, and size states.
- Name by function / role, not by baked text content.
- Do not use temporary number-only keys.
- Do not use `final`, `new`, `tmp`, or screenshot-export names.

Good examples:

```text
panel_frame_base
panel_frame_dark
modal_panel_base
button_base
button_hover
button_pressed
button_disabled
close_button_idle
close_button_hover
icon_power
icon_battery
icon_signal
icon_warning
icon_credit
meter_frame_thin
meter_fill_power
meter_fill_battery
badge_connected
badge_disconnected
prompt_frame_small
tab_button_active
tab_button_inactive
```

Bad examples:

```text
ui1
image_001
final_button_new
tmp_panel
blue_box
korean_text_button
screenshot_part_a
```

State / variation suffix candidates:

```text
_base
_dark
_light
_idle
_hover
_pressed
_disabled
_active
_inactive
_warning
_danger
_success
_small
_large
_thin
_thick
```

## Region Mapping Schema

Future mapping metadata may use Resource, JSON, CSV, or another explicit format. This task only documents the schema.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `ui_key` | `String` | UI region identifier | `panel_frame_base` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/ui/common/atlases/ui_common_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `category` | `String` | UI category | `panel` |
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
| `scale_policy` | `String` | Stretch / keep / tile candidate | `stretch_9slice` |
| `target_control` | `String` | Godot Control candidate | `PanelContainer` |
| `theme_role` | `String` | Theme role candidate | `panel` |
| `usage_context` | `String` | Screen candidate | `common` |
| `notes` | `String` | Notes | `candidate only` |

All coordinate and margin fields remain `TBD` until the atlas exists.

## 9-Slice Criteria

Panels and buttons need scalable regions. 9-slice should preserve corners and border thickness while allowing the center to stretch.

9-slice candidates:

```text
panel_frame_base
modal_panel_base
small_panel_base
button_base
button_hover
button_pressed
button_disabled
tab_button_active
tab_button_inactive
prompt_frame_small
meter_frame_thin
```

Non-9-slice candidates:

```text
icon_power
icon_battery
icon_signal
icon_warning
icon_credit
badge_connected
badge_disconnected
close_button_idle
```

Notes:

- `divider_line_thin` may use tile / stretch behavior separately.
- Corners should not distort.
- Border thickness should stay visually stable.
- Center areas can stretch.
- Margin values are `TBD` until the actual atlas exists.

Godot application candidates:

```text
StyleBoxTexture
TextureRect 9-slice
Theme Resource panel / button style
```

This task does not create `StyleBoxTexture`, TextureRect nodes, or Theme Resources.

## Button / Tab State Criteria

Button state candidates:

```text
base
hover
pressed
disabled
selected
warning
```

Required button candidates:

```text
button_base
button_hover
button_pressed
button_disabled
```

Tab candidates:

```text
tab_button_active
tab_button_inactive
tab_button_hover
```

Close button candidates:

```text
close_button_idle
close_button_hover
close_button_pressed
```

State regions for the same control should keep the same region size and 9-slice margins. UI should not jump when a button changes state.

## Icon Criteria

Common icon candidates:

```text
icon_power
icon_battery
icon_time
icon_signal
icon_warning
icon_info
icon_credit
icon_device
icon_phone
icon_laptop
icon_outlet
icon_trace
icon_mission
icon_close
```

Criteria:

- Prefer clear silhouettes and limited colors.
- Use icons only when meaning is readable faster than text.
- Icons must remain readable at small sizes.
- Do not bake Korean, Japanese, English, or any other text into icons.
- Avoid decorative icons that imply unavailable features.

Kenney Input Prompts are separate third-party prompt-icon assets. Do not copy Kenney raw prompt icons into `ui_common_atlas.png`. If needed, `ui_common_atlas.png` can provide a prompt frame while the key image itself comes from the input prompt asset workflow.

## Meter / Gauge Criteria

Meter candidates:

```text
meter_frame_power
meter_fill_power
meter_frame_battery
meter_fill_battery
meter_frame_trace
meter_fill_trace
meter_frame_time
meter_fill_time
```

Criteria:

- Separate frame from fill.
- Consider modulation for fill colors instead of baking many color variants.
- Power, battery, Trace, and time are common enough to share meter logic.
- Fill can use stretch, clip, or progress-bar behavior.
- Actual value binding belongs to UI script, not atlas data.

This task does not create meter Controls.

## Badge / Prompt / Divider Criteria

Badge candidates:

```text
badge_connected
badge_disconnected
badge_active
badge_warning
badge_locked
badge_unlocked
```

Prompt candidates:

```text
prompt_frame_small
prompt_frame_medium
prompt_frame_warning
```

Divider candidates:

```text
divider_line_thin
divider_line_glow
divider_line_dim
```

Criteria:

- Badges should be visually distinct from interactive buttons.
- Prompt frames should not include the raw key icon.
- Divider lines should be subtle enough not to dominate room or hacking visuals.
- Prompt frames can wrap Kenney input prompt icons, but should not absorb them into the common atlas.

## Usage Context

Usage context candidates:

```text
common
phone_ui
outlet_ui
result_ui
prototype_hub
quarterview_sandbox
hacking_ui
mission_select
debug_overlay
```

Examples:

```text
panel_frame_base:
- common

icon_battery:
- phone_ui / common

icon_power:
- outlet_ui / common

icon_trace:
- hacking_ui

modal_panel_base:
- result_ui / mission_select / common
```

Common atlas does not force every screen into one visual file forever. If a screen develops a large specialized UI set, a separate atlas remains an option.

## Theme / StyleBox Application Candidates

### Candidate A: Theme Resource

```text
godot/resources/ui/concent_theme.tres
```

Pros:

- Central Button / Panel / Label style management.
- Strong consistency across screens.

Cons:

- More setup up front.
- Easy to overfit before UI direction is stable.

### Candidate B: Individual StyleBoxTexture Resources

```text
godot/resources/ui/styleboxes/panel_frame_base.tres
godot/resources/ui/styleboxes/button_base.tres
```

Pros:

- Can apply only the pieces needed for a prototype.
- Easy to review one control at a time.

Cons:

- Can increase resource-file count.

### Candidate C: Script Mapping Loader

```text
ui_common_atlas mapping file
-> TextureRect / StyleBoxTexture construction
```

Pros:

- Keeps atlas metadata explicit.
- Useful if region count grows.

Cons:

- Too much infrastructure for the current stage.

Current recommendation:

- Keep this document as the source of criteria.
- Leave StyleBoxTexture as an early application candidate.
- Move toward a Theme Resource after UI tone and states stabilize.

This task does not create Theme, StyleBox, or loader resources.

## Separation From Other Atlases

### `ui_common_atlas.png` Includes

- UI frame.
- Modal frame.
- Button state.
- Tab state.
- Icon.
- Meter frame / fill.
- Badge.
- Prompt frame.
- Divider.
- Close button.

### `ui_common_atlas.png` Excludes

- Room shell layer.
- Quarterview furniture / appliance / work-device / cable / FX body.
- Yui character sprite.
- Hacking arena tile.
- Hacking avatar / enemy / object / projectile / FX body.
- Full mockup screenshot.
- Localization text.
- Kenney third-party input prompt raw icons.
- Large illustrated background.

Other atlas candidates:

```text
qv_furniture_atlas.png
qv_appliances_atlas.png
qv_work_devices_atlas.png
qv_fx_atlas.png
hack_arena_tiles_atlas.png
hack_enemies_atlas.png
hack_objects_atlas.png
hack_fx_atlas.png
```

## UI Tone Criteria

CONCENT UI should support a dark, quiet, information-heavy survival adventure rather than a bright arcade interface.

Criteria:

- Avoid mobile gacha UI loudness.
- Keep an industrial / management-system feeling for THE GRID.
- Use restrained cyber interface language.
- Keep state readable at a glance.
- Make warnings clear without cluttering the whole screen.
- Do not let UI overpower room art.
- PrototypeHub and debug UI can prioritize utility.
- Main-game UI should balance information density and atmosphere.

## Example Mapping

Coordinates and margins are intentionally `TBD`.

| ui_key | category | state | nine_slice | rect | margins | target_control | usage_context | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `panel_frame_base` | `panel` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `common` | general panel |
| `modal_panel_base` | `modal` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `result_ui` | modal frame |
| `button_base` | `button` | `base` | `true` | `TBD` | `TBD` | `Button` | `common` | normal button |
| `button_hover` | `button` | `hover` | `true` | `TBD` | `TBD` | `Button` | `common` | hover state |
| `button_pressed` | `button` | `pressed` | `true` | `TBD` | `TBD` | `Button` | `common` | pressed state |
| `button_disabled` | `button` | `disabled` | `true` | `TBD` | `TBD` | `Button` | `common` | disabled state |
| `icon_power` | `icon` | `base` | `false` | `TBD` | `none` | `TextureRect` | `outlet_ui` | power icon |
| `icon_battery` | `icon` | `base` | `false` | `TBD` | `none` | `TextureRect` | `phone_ui` | battery icon |
| `icon_trace` | `icon` | `base` | `false` | `TBD` | `none` | `TextureRect` | `hacking_ui` | trace icon |
| `meter_frame_power` | `meter` | `base` | `true` | `TBD` | `TBD` | `TextureProgressBar` | `outlet_ui` | power meter frame |
| `meter_fill_power` | `meter` | `base` | `false` | `TBD` | `none` | `TextureProgressBar` | `outlet_ui` | power meter fill |
| `badge_connected` | `badge` | `active` | `true` | `TBD` | `TBD` | `Label / Panel` | `outlet_ui` | connected status |
| `badge_disconnected` | `badge` | `inactive` | `true` | `TBD` | `TBD` | `Label / Panel` | `outlet_ui` | disconnected status |
| `prompt_frame_small` | `prompt` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `common` | wraps input prompt icon |

## Pre-Application Checklist

- [ ] Atlas PNG uses transparent background.
- [ ] UI regions do not overlap each other.
- [ ] `ui_key` uses lowercase `snake_case`.
- [ ] 9-slice and non-9-slice regions are separated.
- [ ] Button state regions keep the same size and margins.
- [ ] Icons have no baked text.
- [ ] Meter frame and fill are separated.
- [ ] Kenney raw input prompt icons are not mixed into the atlas.
- [ ] Room / hacking visual atlases are not mixed into the UI atlas.
- [ ] Icons remain readable on dark UI.
- [ ] UI does not cover room art too aggressively.
- [ ] Localization text is not baked into images.

## Future Application Order

1. Prepare final `ui_common_atlas.png` asset.
2. Add PNG to the expected atlas path.
3. Write `ui_key`, rect, and margin list.
4. Decide mapping format: Resource, JSON, CSV, or another explicit file.
5. Create a UI atlas region viewer prototype.
6. Test partial StyleBoxTexture or Theme Resource application.
7. Apply a small button / panel test to PrototypeHub or Sandbox UI.
8. Review common icon / meter use in Phone, Outlet, and Result UI.
9. Test prompt frame composition with Kenney input prompt icons.
10. Consolidate actual UI theme after tone and layout stabilize.

## Non-Goals

- Do not add `ui_common_atlas.png`.
- Do not create mapping JSON / CSV / `.tres`.
- Do not create `Theme`, `StyleBoxTexture`, or `AtlasTexture`.
- Do not modify Main / DAY 1 UI.
- Do not modify Phone UI, Outlet UI, Result UI, PrototypeHub, QuarterviewGameplaySandbox, or HackingActionPrototype.
- Do not place Control nodes or scene UI elements.
- Do not copy Kenney raw input prompt icons into this atlas.
- Do not connect this atlas to any scene.
