# UI Dialogue Atlas Mapping

This document defines future region mapping rules for `ui_dialogue_atlas.png`.

The atlas is a candidate for CONCENT dialogue-specific UI parts: Yui monologue, room object lines, THE GRID system messages, hacking radio / system snippets, choice UI, and dialogue history visuals.

It is not imported into Godot yet and is not connected to Main / DAY 1, dialogue systems, story flags, object interactions, QuarterviewGameplaySandbox, HackingActionPrototype, Phone UI, or Result UI.

This task does not create the folders, PNG, `AtlasTexture`, `StyleBoxTexture`, Theme Resource, JSON, CSV, `.tres`, mapping file, Dialogue UI scene, Control node, or dialogue data Resource.

## Atlas File

Future atlas filename:

```text
ui_dialogue_atlas.png
```

Future Godot path:

```text
res://assets/ui/dialogue/atlases/ui_dialogue_atlas.png
```

Future source / reference candidates:

```text
res://assets/ui/dialogue/atlases/source/
res://assets/ui/dialogue/atlases/reference/
```

Expected file format:

- PNG.
- RGBA / transparent background.
- Dialogue UI-specific visual parts only.
- No localization text baked into regions.
- No full screenshot UI mockup.
- No room shell background.
- No character body sprite.
- No furniture, appliance, or work-device sprite.
- No hacking arena tile, enemy, avatar, object, or FX sprite.
- No third-party raw input prompt icons directly mixed in.
- Region names and 9-slice margins are documented separately.

These paths are future candidates only. This pass does not create them.

## Atlas Role

`ui_dialogue_atlas.png` is a candidate for visual parts that specifically support dialogue, narration, system messages, speaker presentation, choices, and dialogue history.

Owns:

- Dialogue panel frame.
- Speaker nameplate.
- Narration panel.
- System message panel.
- Thought / inner monologue panel.
- Speaker portrait frame.
- Choice button states.
- Continue indicator.
- Dialogue history / log entry card.
- Warning / emphasis / branch marker.
- Dialogue tail.
- Dialogue-specific divider / frame.
- Dialogue-specific close or control icon candidates.

Does not own:

- Actual dialogue text.
- Actual localization data.
- Actual dialogue parser.
- Actual story flag logic.
- Actual choice branching logic.
- Generic button / panel / modal visuals as a whole.
- Gameplay HUD.
- Phone / Outlet / Result screen layout.
- Room shell.
- Character body sprite.
- Game object sprite.

## Relationship To Other UI Atlases

### `ui_common_atlas.png`

Owns:

- Common panel.
- Common modal.
- Common button state.
- Common tab.
- Common icon.
- Common prompt frame.

Dialogue-specific panels, nameplates, choice buttons, portrait frames, dialogue tails, and continue indicators belong to `ui_dialogue_atlas.png`.

### `ui_hud_atlas.png`

Owns:

- Persistent in-play HUD frame.
- Power / time / battery / Trace / HP / timer meter.
- Gameplay status badge.
- Warning chip.

Dialogue text boxes and choices are not persistent HUD status. They belong to `ui_dialogue_atlas.png` unless they become compact always-on status elements.

### `ui_phone_atlas.png`

Owns:

- Phone UI-specific frame.
- Phone app tile.
- Phone message bubble.
- Phone notification card.
- Phone mission / log card.

Phone message visuals may stay in `ui_phone_atlas.png`. A future bridge may reuse dialogue styling only when a Phone message is replayed as dialogue or dialogue history.

### `ui_result_log_atlas.png`

Owns:

- Day result screen.
- Mission result screen.
- Log entry card.
- Reward / story / device / power report card.

Dialogue history cards may visually relate to result logs, but live dialogue panels, choices, nameplates, portrait frames, and continue indicators belong to `ui_dialogue_atlas.png`.

### `ui_dialogue_atlas.png`

Owns:

- Real-time dialogue box.
- Monologue / narration box.
- Choice UI.
- Speaker nameplate.
- Speaker portrait frame.
- Dialogue continue indicator.
- Dialogue history / log visual candidates.

Separation rules:

- If a region is a generic button, panel, modal, tab, or prompt frame, it belongs to `ui_common_atlas.png`.
- If a region persistently communicates gameplay state during room or hacking play, it belongs to `ui_hud_atlas.png`.
- If a region is used only inside the Phone UI screen, it belongs to `ui_phone_atlas.png`.
- If a region represents day / mission / reward / story result cards, it belongs to `ui_result_log_atlas.png`.
- If a region presents character dialogue, monologue, choices, system lines, speaker identity, or dialogue flow controls, it belongs to `ui_dialogue_atlas.png`.

## Dialogue UI Category Candidates

Use categories to keep atlas regions grouped by UI role.

| Region Key | Category |
| --- | --- |
| `dialogue_panel_frame` | `dialogue_panel` |
| `dialogue_narration_panel` | `narration_panel` |
| `dialogue_system_panel` | `system_panel` |
| `dialogue_thought_panel` | `thought_panel` |
| `dialogue_nameplate` | `nameplate` |
| `dialogue_speaker_portrait_frame` | `portrait_frame` |
| `dialogue_speaker_portrait_frame_active` | `portrait_frame` |
| `dialogue_choice_button_base` | `choice_button` |
| `dialogue_choice_button_hover` | `choice_button` |
| `dialogue_choice_button_selected` | `choice_button` |
| `dialogue_choice_button_disabled` | `choice_button` |
| `dialogue_continue_indicator` | `continue_indicator` |
| `dialogue_auto_icon` | `control_icon` |
| `dialogue_skip_icon` | `control_icon` |
| `dialogue_history_button` | `control_icon` |
| `dialogue_log_entry_card` | `history_entry` |
| `dialogue_emphasis_marker` | `marker` |
| `dialogue_warning_marker` | `marker` |
| `dialogue_branch_marker` | `marker` |
| `dialogue_tail_left` | `tail` |
| `dialogue_tail_right` | `tail` |
| `dialogue_inner_divider` | `divider` |
| `dialogue_close_button_idle` | `close_button` |

Category candidates:

- `dialogue_panel`
- `narration_panel`
- `system_panel`
- `thought_panel`
- `nameplate`
- `portrait_frame`
- `choice_button`
- `continue_indicator`
- `history_entry`
- `marker`
- `divider`
- `tail`
- `close_button`
- `control_icon`

## Region Key Naming

Region keys must be stable. They should describe UI function rather than current artwork.

Rules:

- Use lowercase `snake_case`.
- Start with `dialogue`.
- Prefer `dialogue + role + state / variation`.
- Use suffixes for states.
- Do not use temporary numbers or file-export names.
- Do not bake text content into the key.
- Do not use `final`, `new`, `tmp`, or screenshot names.

Good examples:

```text
dialogue_panel_frame
dialogue_narration_panel
dialogue_system_panel
dialogue_thought_panel
dialogue_nameplate
dialogue_speaker_portrait_frame
dialogue_speaker_portrait_frame_active
dialogue_choice_button_base
dialogue_choice_button_hover
dialogue_choice_button_selected
dialogue_choice_button_disabled
dialogue_continue_indicator
dialogue_auto_icon
dialogue_skip_icon
dialogue_history_button
dialogue_log_entry_card
dialogue_emphasis_marker
dialogue_warning_marker
dialogue_branch_marker
dialogue_tail_left
dialogue_tail_right
dialogue_inner_divider
dialogue_close_button_idle
```

Bad examples:

```text
dialogue1
image_001
final_textbox_new
tmp_box
red_warning_text
screenshot_part_a
```

State / variation suffix candidates:

- `_base`
- `_active`
- `_inactive`
- `_hover`
- `_pressed`
- `_selected`
- `_disabled`
- `_warning`
- `_danger`
- `_system`
- `_narration`
- `_thought`
- `_important`
- `_small`
- `_large`
- `_compact`

This pass does not create actual UI assets.

## Region Mapping Schema

Future mapping data may be stored as a Resource, JSON, or CSV. This pass only defines the schema.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `dialogue_ui_key` | `String` | Dialogue UI region identifier | `dialogue_choice_button_selected` |
| `atlas_path` | `String` | Atlas PNG path | `res://assets/ui/dialogue/atlases/ui_dialogue_atlas.png` |
| `rect_x` | `int` | Region start x in atlas | `TBD` |
| `rect_y` | `int` | Region start y in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `category` | `String` | Dialogue UI category | `choice_button` |
| `visual_state` | `String` | Display state | `selected` |
| `nine_slice` | `bool` | Whether 9-slice should be used | `true` |
| `margin_left` | `int` | 9-slice left margin | `TBD` |
| `margin_top` | `int` | 9-slice top margin | `TBD` |
| `margin_right` | `int` | 9-slice right margin | `TBD` |
| `margin_bottom` | `int` | 9-slice bottom margin | `TBD` |
| `min_width` | `int` | Minimum display width | `TBD` |
| `min_height` | `int` | Minimum display height | `TBD` |
| `default_modulate` | `String` | Default color modulation | `#FFFFFF` |
| `default_alpha` | `float` | Default alpha | `1.0` |
| `scale_policy` | `String` | Stretch / keep candidate | `stretch_9slice` |
| `dialogue_area` | `String` | Dialogue screen area candidate | `choice_list` |
| `target_control` | `String` | Godot Control candidate | `Button` |
| `usage_context` | `String` | Candidate screen / flow | `room_dialogue` |
| `speaker_context_hint` | `String` | Speaker / source candidate | `yui` |
| `value_binding_hint` | `String` | Future data binding candidate | `dialogue_choice_state` |
| `interaction_hint` | `String` | Future interaction candidate | `select_choice` |
| `notes` | `String` | Notes | `candidate only` |

No mapping file is created in this pass.

## 9-Slice Criteria

Dialogue UI often changes size based on text length, language, and choice count. Regions that stretch with text should be prepared for 9-slice / patch margins.

9-slice candidates:

- `dialogue_panel_frame`
- `dialogue_narration_panel`
- `dialogue_system_panel`
- `dialogue_thought_panel`
- `dialogue_nameplate`
- `dialogue_speaker_portrait_frame`
- `dialogue_choice_button_base`
- `dialogue_choice_button_hover`
- `dialogue_choice_button_selected`
- `dialogue_choice_button_disabled`
- `dialogue_log_entry_card`

Non-9-slice candidates:

- `dialogue_continue_indicator`
- `dialogue_auto_icon`
- `dialogue_skip_icon`
- `dialogue_emphasis_marker`
- `dialogue_warning_marker`
- `dialogue_branch_marker`
- `dialogue_tail_left`
- `dialogue_tail_right`
- `dialogue_inner_divider`
- `dialogue_close_button_idle`

Conditional:

- `dialogue_history_button` can be non-9-slice if icon-only.
- `dialogue_history_button` can be 9-slice if it becomes an icon + label button.

Rules:

- Corners must not distort.
- Border thickness must stay stable.
- Panels must survive longer localized text.
- Choice button states must share the same size and margins.
- Margins are finalized only after the actual atlas is produced.
- All margin values remain `TBD` in this document.

This pass does not create `StyleBoxTexture` or Theme Resources.

## Dialogue Area Candidates

`dialogue_area` describes where the region is likely used in a future dialogue layout.

Candidates:

- `bottom_dialogue`
- `center_modal_dialogue`
- `narration_area`
- `system_message_area`
- `thought_area`
- `speaker_name_area`
- `portrait_area`
- `choice_list`
- `history_log`
- `control_area`
- `floating_bubble`

Examples:

| Region Key | Dialogue Area |
| --- | --- |
| `dialogue_panel_frame` | `bottom_dialogue` |
| `dialogue_narration_panel` | `narration_area` |
| `dialogue_system_panel` | `system_message_area` |
| `dialogue_thought_panel` | `thought_area` |
| `dialogue_nameplate` | `speaker_name_area` |
| `dialogue_speaker_portrait_frame` | `portrait_area` |
| `dialogue_choice_button_base` | `choice_list` |
| `dialogue_log_entry_card` | `history_log` |

This pass does not create an actual Dialogue UI layout.

## Usage Context Candidates

`usage_context` should describe where the dialogue region appears.

Candidates:

- `room_dialogue`
- `yui_monologue`
- `object_interaction`
- `system_message`
- `hacking_radio`
- `hacking_mission_dialogue`
- `phone_message_bridge`
- `result_log_replay`
- `tutorial`
- `debug_dialogue`

Examples:

- `dialogue_panel_frame`: `room_dialogue`, `object_interaction`
- `dialogue_narration_panel`: `yui_monologue`, `tutorial`
- `dialogue_system_panel`: `system_message`, `the_grid_announcement`
- `dialogue_choice_button_base`: `room_dialogue`, `mission_choice`, `tutorial`
- `dialogue_log_entry_card`: `result_log_replay`, `debug_dialogue`

## Speaker / Source Context

`speaker_context_hint` should describe the speaker or source candidate without baking names into images.

Candidates:

- `yui`
- `system`
- `the_grid`
- `unknown_signal`
- `node17`
- `phone_contact`
- `mission_operator`
- `inner_thought`
- `tutorial`
- `debug`

Rules:

- Yui monologue uses `yui` or `inner_thought`.
- THE GRID notice / warning uses `system` or `the_grid`.
- NODE-17 or unidentified signal uses `node17` or `unknown_signal`.
- Phone messages and live dialogue remain separate unless a future bridge intentionally connects them.
- Hacking mission short communications can use `hacking_radio` usage context with `mission_operator` speaker context.
- Speaker display text is a Label, not baked into the atlas.

## Value Binding Candidates

Dialogue UI may later bind to dialogue data, story state, object interactions, mission state, or tutorial steps.

Future binding candidates:

- `dialogue_line_key`
- `speaker_key`
- `speaker_display_name`
- `speaker_portrait_key`
- `dialogue_text`
- `dialogue_speed`
- `dialogue_state`
- `current_choice_index`
- `choice_count`
- `choice_enabled`
- `choice_selected`
- `auto_mode_enabled`
- `skip_available`
- `history_available`
- `story_flag_key`
- `object_key`
- `mission_key`
- `tutorial_step_key`

This pass does not connect to a dialogue system, story flag system, mission system, or object interaction flow.

## Dialogue State Criteria

`visual_state` should describe the visual behavior of a region.

Candidates:

- `base`
- `active`
- `inactive`
- `hover`
- `pressed`
- `selected`
- `disabled`
- `warning`
- `system`
- `narration`
- `thought`
- `important`
- `unread`
- `read`
- `complete`

Examples:

- `dialogue_choice_button_base`: `base`
- `dialogue_choice_button_hover`: `hover`
- `dialogue_choice_button_selected`: `selected`
- `dialogue_choice_button_disabled`: `disabled`
- `dialogue_system_panel`: `system`
- `dialogue_thought_panel`: `thought`
- `dialogue_warning_marker`: `warning`

State variants should keep the same size, anchor policy, and 9-slice margins. If state variants change size, the UI will visibly jump.

## Speaker / Narration / System / Thought / Choice Split

Dialogue UI needs several related but distinct presentation modes.

| Mode | Purpose | Visual Direction | Example Context |
| --- | --- | --- | --- |
| Speaker dialogue | A visible speaker talks | grounded dialogue panel + nameplate / portrait frame | Yui talks to herself, contact line |
| Narration | Environmental or story narration | quieter panel, less character-specific | room observation, tutorial narration |
| System message | THE GRID / machine / interface notice | colder, managed, warning-capable | power warning, GRID alert |
| Thought | Yui inner monologue | restrained, personal, not dramatic | anxiety, planning, memory |
| Choice | Player selects a response / action | readable list, clear hover / selected / disabled states | room decision, mission choice |

These modes can share underlying 9-slice logic, but they should not all look identical. The player should understand source and urgency quickly.

## Future Dialogue Data Candidates

Potential future Resource / data classes:

- `DialogueLineDefinition.gd`
- `DialogueChoiceDefinition.gd`
- `DialogueSequenceDefinition.gd`

Potential fields:

- `dialogue_key`
- `speaker_key`
- `text_key`
- `emotion_key`
- `portrait_key`
- `voice_hint`
- `choices`
- `next_key`
- `required_story_flags`
- `set_story_flags`
- `related_object_key`
- `related_mission_key`

This pass does not create these scripts or Resources.

## Relationship To Existing Systems

This pass does not implement:

- Dialogue system.
- `DialogueLineDefinition`.
- Story flags.
- Object interaction text routing.
- Hacking mission dialogue routing.
- Phone message UI bridge.
- Result log replay.

Future candidates:

```text
Room object interaction
-> dialogue sequence
-> ui_dialogue_atlas visual

Hacking mission state
-> radio/system message
-> ui_dialogue_atlas visual

Phone message / log
-> ui_phone_atlas or ui_dialogue_atlas bridge

Result story log
-> ui_result_log_atlas replay or dialogue history
```

Current individual art such as `res://assets/art/ui/panels/ui_panel_dialogue.png` can remain a current applied asset. It is not the same thing as the future atlas workflow described here.

## UI Tone

Dialogue UI must support both Yui's private voice and THE GRID's impersonal system pressure.

Tone rules:

- THE GRID system messages should feel industrial, administrative, and cold.
- Yui monologue should feel restrained and readable rather than overly dramatic visual-novel styling.
- System messages should feel controlled and managerial.
- NODE-17 / unknown signal messages can feel unstable and unidentified.
- Text readability comes first.
- Dialogue UI should not cover room or hacking readability more than necessary.
- Text is never baked into images; it stays in Label / RichTextLabel or future localization data.
- Choices must be quickly distinguishable.
- Mobile / small viewport readability must be considered.

## Atlas Separation

### `ui_dialogue_atlas.png` Includes

- Dialogue panel.
- Narration panel.
- System message panel.
- Thought panel.
- Speaker nameplate.
- Portrait frame.
- Choice button.
- Continue indicator.
- Dialogue history entry.
- Dialogue marker.
- Dialogue tail.

### `ui_dialogue_atlas.png` Excludes

- Generic button / panel / modal.
- Gameplay HUD frame / meter.
- Phone app / message / notification card.
- Outlet slot / device card.
- Result summary / log / reward card.
- Room shell.
- Character body sprite.
- Game object sprite.
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
qv_fx_atlas.png
hack_fx_atlas.png
```

## Example Mapping

Coordinates and margins are placeholders. They must stay `TBD` until the real atlas exists.

| `dialogue_ui_key` | `category` | `area` | `state` | `nine_slice` | `rect` | `margins` | `target_control` | `speaker_context_hint` | `notes` |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `dialogue_panel_frame` | `dialogue_panel` | `bottom_dialogue` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `yui` | default dialogue panel |
| `dialogue_narration_panel` | `narration_panel` | `narration_area` | `narration` | `true` | `TBD` | `TBD` | `PanelContainer` | `inner_thought` | monologue / narration |
| `dialogue_system_panel` | `system_panel` | `system_message_area` | `system` | `true` | `TBD` | `TBD` | `PanelContainer` | `the_grid` | system message |
| `dialogue_thought_panel` | `thought_panel` | `thought_area` | `thought` | `true` | `TBD` | `TBD` | `PanelContainer` | `yui` | inner thought |
| `dialogue_nameplate` | `nameplate` | `speaker_name_area` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `speaker_key` | speaker nameplate |
| `dialogue_speaker_portrait_frame` | `portrait_frame` | `portrait_area` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `speaker_key` | portrait frame |
| `dialogue_speaker_portrait_frame_active` | `portrait_frame` | `portrait_area` | `active` | `true` | `TBD` | `TBD` | `PanelContainer` | `speaker_key` | active speaker |
| `dialogue_choice_button_base` | `choice_button` | `choice_list` | `base` | `true` | `TBD` | `TBD` | `Button` | `choice_enabled` | choice option |
| `dialogue_choice_button_hover` | `choice_button` | `choice_list` | `hover` | `true` | `TBD` | `TBD` | `Button` | `choice_enabled` | hover option |
| `dialogue_choice_button_selected` | `choice_button` | `choice_list` | `selected` | `true` | `TBD` | `TBD` | `Button` | `choice_selected` | selected option |
| `dialogue_choice_button_disabled` | `choice_button` | `choice_list` | `disabled` | `true` | `TBD` | `TBD` | `Button` | `choice_enabled` | disabled option |
| `dialogue_continue_indicator` | `continue_indicator` | `control_area` | `active` | `false` | `TBD` | `none` | `TextureRect` | `dialogue_state` | continue marker |
| `dialogue_auto_icon` | `control_icon` | `control_area` | `active` | `false` | `TBD` | `none` | `TextureRect` | `auto_mode_enabled` | auto icon |
| `dialogue_skip_icon` | `control_icon` | `control_area` | `active` | `false` | `TBD` | `none` | `TextureRect` | `skip_available` | skip icon |
| `dialogue_log_entry_card` | `history_entry` | `history_log` | `base` | `true` | `TBD` | `TBD` | `PanelContainer` | `dialogue_line_key` | dialogue history |
| `dialogue_emphasis_marker` | `marker` | `bottom_dialogue` | `important` | `false` | `TBD` | `none` | `TextureRect` | `dialogue_state` | emphasis marker |
| `dialogue_warning_marker` | `marker` | `system_message_area` | `warning` | `false` | `TBD` | `none` | `TextureRect` | `story_flag_key` | warning marker |
| `dialogue_branch_marker` | `marker` | `choice_list` | `base` | `false` | `TBD` | `none` | `TextureRect` | `choice_count` | branch marker |
| `dialogue_tail_left` | `tail` | `floating_bubble` | `base` | `false` | `TBD` | `none` | `TextureRect` | `speaker_key` | bubble tail left |
| `dialogue_tail_right` | `tail` | `floating_bubble` | `base` | `false` | `TBD` | `none` | `TextureRect` | `speaker_key` | bubble tail right |
| `dialogue_inner_divider` | `divider` | `bottom_dialogue` | `base` | `false` | `TBD` | `none` | `TextureRect` | `none` | inner divider |
| `dialogue_close_button_idle` | `close_button` | `control_area` | `base` | `false` | `TBD` | `none` | `TextureButton` | `dialogue_state` | close button idle |

## Pre-Application Checklist

Before applying actual Dialogue atlas regions:

- Confirm the atlas PNG has a transparent background.
- Confirm Dialogue UI regions do not overlap incorrectly.
- Confirm every `dialogue_ui_key` uses lowercase `snake_case`.
- Confirm 9-slice and non-9-slice regions are separated.
- Confirm dialogue panel and choice button state regions share matching size and margins.
- Confirm speaker nameplate works without baked text.
- Confirm choice buttons do not include localization text.
- Confirm system / narration / thought panels are visually distinct.
- Confirm portrait frames are separated from character portrait images.
- Confirm `ui_common_atlas.png`, `ui_phone_atlas.png`, and `ui_result_log_atlas.png` responsibilities are not mixed into `ui_dialogue_atlas.png`.
- Confirm dialogue UI does not cover too much room or hacking readability.
- Confirm text area remains readable on mobile / small viewports.
- Confirm sandbox dialogue mock can test visuals before implementing the dialogue system.

## Future Application Order

Suggested future order:

1. Prepare final `ui_dialogue_atlas.png` asset.
2. Add PNG at the atlas path.
3. Write `dialogue_ui_key` and rect / margin list.
4. Choose mapping format: Resource, JSON, or CSV.
5. Create Dialogue atlas region viewer prototype.
6. Test a few panel and choice regions in a sandbox dialogue mock panel.
7. Review object interaction dialogue mock connection.
8. Review hacking radio / system message mock connection.
9. Review future `DialogueLineDefinition` design.
10. Review actual Story flag, Mission, and Object interaction wiring separately.

This task stops at documentation. It does not create PNG assets, import metadata, mapping files, Theme / StyleBox resources, Dialogue UI scenes, Control nodes, dialogue data Resources, story flags, or gameplay wiring.
