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

## Suggested Godot Files To Inspect First

- `godot/scenes/Main.tscn`
- `godot/scripts/Main.gd`
- `godot/scripts/SurvivalState.gd`
- `godot/scripts/OutletMode.gd`

## Implementation Order

1. Inspect the current Godot scene and script structure.
2. Identify the existing owner of power/state data.
3. Define the minimum DAY 1 object list and power costs.
4. Wire a readable power display to the existing state.
5. Add or refine the interactable flow for spend/cancel choices.
6. Add insufficient power feedback.
7. Add simple dialogue feedback for successful choices.
8. Add day-end trigger and result summary.
9. Validate the loop in the Godot main scene.

## Out Of Scope For Now

- DAY 2+ content
- Save/load
- Multiple endings
- Complex relationship or NPC systems
- Full Phaser feature parity
- Web prototype changes
