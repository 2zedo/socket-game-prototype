# DAY 1 Content Brief

## DAY 1 Purpose

DAY 1 is the tutorial and core loop proof. It should teach the player that power is limited, objects have costs, choices produce feedback, and the day ends with a simple summary.

Do not overload DAY 1 with many events. The goal is a playable power-choice loop, not full story delivery.

## Player Situation

Yui is alone in a small apartment during a power shortage. The room is dark, old electronics still work inconsistently, and the player must decide which devices deserve limited power.

The first day should feel quiet and practical: learn the room, test devices, notice the power limit, and understand that comfort, information, and survival compete with each other.

## Starting Power Assumption

- Temporary starting power: `10 units`
- Temporary object costs should later move into a Godot Resource (`.tres`) or data file.
- The exact values are placeholders for MVP testing and balance.

## Initial Interactable Objects

### Light

- Gameplay purpose: teaches that power can improve room safety/readability.
- Suggested power cost: `1 unit`
- Sample feedback/dialogue direction: "The room softens under the weak light. It will not last forever."
- Possible result flag: `used_light`

### Laptop

- Gameplay purpose: introduces information gathering and the Grid mystery.
- Suggested power cost: `3 units`
- Sample feedback/dialogue direction: "Old logs flicker on the screen. Some entries mention Grid."
- Possible result flag: `checked_laptop`

### Fan

- Gameplay purpose: introduces comfort/survival tradeoff.
- Suggested power cost: `2 units`
- Sample feedback/dialogue direction: "The fan turns slowly. The air moves, but the meter drops."
- Possible result flag: `used_fan`

### Charger

- Gameplay purpose: introduces practical survival maintenance.
- Suggested power cost: `2 units`
- Sample feedback/dialogue direction: "The phone battery crawls upward. It feels like buying time."
- Possible result flag: `charged_device`

### Communication Device

- Gameplay purpose: introduces outside contact and the management office / delivery robot thread.
- Suggested power cost: `4 units`
- Sample feedback/dialogue direction: "A broken signal cuts through. Someone is still broadcasting notices."
- Possible result flag: `sent_or_received_signal`

## Day End Condition

- MVP option: the day ends when the player chooses `End Day`.
- Current implementation direction: use a bed/rest point in the room as the explicit `End Day` interactable.
- The bed/rest point should use the same top-down proximity + `E` confirmation model as power objects.
- Optional later condition: the day can also end when power reaches `0` or all core interactions are resolved.
- The first implementation should prefer an explicit `End Day` action for clarity.

## Result Summary Direction

The summary should be short and readable:

- Remaining power
- Objects used
- Any important flags
- One line of narrative consequence
- Prompt to continue or return to the room

## Out Of Scope

- DAY 2+ content
- Delivery robot gameplay beyond a hint or signal reference
- Management office quest chain
- Grid revelation
- Save/load
- Multiple endings
- Complex relationship system
- Full visual polish
- Web prototype changes
