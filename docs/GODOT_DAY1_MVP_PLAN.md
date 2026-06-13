# Godot DAY 1 MVP Plan

## Purpose

Define the smallest Godot implementation that proves the core `CONCENT / 전력 부족의 시대` loop: limited power, object interaction, feedback, and day completion.

## MVP Success Criteria

- The player can enter the main room scene.
- Current power is visible.
- The player can interact with a small set of room objects.
- Confirmed choices spend power.
- Choices are blocked when power is insufficient.
- Each choice gives clear dialogue or event feedback.
- The day can end.
- A simple result summary appears after the day ends.

## Required Systems

- Power state
- Power display
- Interactable objects
- Spend/cancel choice
- Insufficient power message
- Dialogue feedback
- Day end
- Result summary

## DAY 1 Object List

The initial object list should stay small and match `docs/DAY1_CONTENT_BRIEF.md`:

- Light
- Laptop
- Fan
- Charger
- Communication device

## Suggested Temporary Power Costs

These are placeholder MVP values. Store them in a Godot Resource (`.tres`) or data file when practical instead of hard-coding them into scene logic.

- Starting power: `10 units`
- Light: `1 unit`
- Laptop: `3 units`
- Fan: `2 units`
- Charger: `2 units`
- Communication device: `4 units`

## Minimum Flags / State To Track

- `current_power`
- `used_light`
- `checked_laptop`
- `used_fan`
- `charged_device`
- `sent_or_received_signal`
- `day_ended`

## Current Implementation Status

- `SurvivalState.gd` now owns temporary DAY 1 power units, object costs, use flags, and result-summary data.
- `Apartment.gd` now exposes the five DAY 1 interactables: Light, Laptop, Fan, Charger, and Communication device.
- `Player.gd` and `project.godot` already support keyboard top-down movement through WASD and arrow input actions.
- `Apartment.gd` tracks the nearest interactable by player proximity, so `E` only opens interaction UI near an object.
- `Main.gd` now routes nearby interactables through a simple `E: use / ESC: cancel` confirmation flow and pauses Yui while the modal panel is open.
- `InteractionPanel.gd` supports context-specific footer text for use/cancel prompts.
- `SurvivalHUD.tscn` has enough status label space to show current DAY 1 power and use records.
- `Apartment.gd` now includes a bed/rest interactable that opens an explicit `End Day` confirmation through the same proximity `E` model.
- `SurvivalState.gd` exposes `end_current_day()` so the explicit rest interaction can enter the existing result summary flow.
- Temporary action costs still live in script constants and should move to a Resource or data file after in-editor validation.

## Suggested Godot Files To Inspect First

- `godot/scenes/Main.tscn`
- `godot/scripts/Main.gd`
- `godot/scripts/SurvivalState.gd`
- `godot/scripts/OutletMode.gd`

Start implementation from these existing files. Before adding new systems, identify what they already handle for room flow, state, and outlet/power behavior.

## Implementation Order

1. Inspect the current Godot scene and script structure.
2. Identify the existing owner of power/state data.
3. Compare current behavior against `docs/DAY1_CONTENT_BRIEF.md`.
4. Define where temporary power costs and object data should live.
5. Wire a readable power display to the existing state.
6. Add or refine the interactable flow for spend/cancel choices.
7. Add insufficient power feedback.
8. Add simple dialogue feedback for successful choices.
9. Add day-end trigger and result summary.
10. Validate the loop in the Godot main scene.

## Out Of Scope For Now

- DAY 2+ content
- Save/load
- Multiple endings
- Complex relationship or NPC systems
- Full Phaser feature parity
- Web prototype changes
