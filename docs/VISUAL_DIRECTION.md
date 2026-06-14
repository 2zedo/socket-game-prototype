# Visual Direction

## Overall Mood

The visual direction is a quiet survival mood in a power-starved city. The images suggest a dark, narrow apartment life where every working device feels valuable. The tone should be lonely, tense, and grounded, but not an exaggerated horror game.

Use the references as mood and design guidance, not as exact implementation requirements. The first priority remains a playable Godot DAY 1 MVP before art polish.

## Room / Environment Direction

- Small one-room apartment with visible daily-life clutter.
- Worn walls, old outlets, exposed cords, power strips, and improvised electronics.
- Night, blackout, weak lamp light, window light, and small device glow should carry the atmosphere.
- The room should feel lived in by Yui: laptop, charger, fan, communication device, notes, mug, cables, and survival supplies.
- Environmental details should support gameplay readability: the player should quickly understand which objects can spend power.

## UI Direction

- UI should feel like a diary, survival log, power management panel, or apartment notice sheet.
- Use restrained panels, thin borders, icon labels, and readable status blocks.
- Power choices should feel serious and resource-based, not flashy.
- Dialogue UI can combine character presence with the room background, but should stay readable and compact for the MVP.
- Separate UI by state. Exploration, interaction, multitap management, and result summary should not all appear at once.
- Exploration should show only the room, compact survival/power HUD, nearby prompt, and minimal controls.
- Interaction should dim the room and show object information plus a short Yui comment.
- Multitap should read as an in-world power connection panel, not a detached arcade minigame.
- Result summary should read as a survival log or diary entry, not a scoreboard.

## Visual Design Pass 1 Notes

- The first Godot visual pass uses only primitives, labels, panels, and simple drawn icons.
- The room should now bias toward a dark one-room apartment: bed, desk/laptop, window, door, shelf, fan, charger, communication device, and power strip.
- The current implementation still uses placeholders. It is meant to communicate direction, not final art quality.
- Future passes should refine spacing, sprites, portraits, lighting, and readability after manual Godot screenshots.

## Color / Tone Direction

- Prefer dark gray, worn black, muted beige, brown, dust, and low warm light.
- Use small highlights for electricity, warnings, active devices, and important choices.
- Avoid saturated arcade colors as the default.
- The palette should remain calm and legible even when the scene is dark.

## Object Design Direction

- Power strip, outlets, plugs, and cables are core visual symbols.
- Devices should look old, practical, and slightly worn: light, laptop, fan, charger, communication device.
- The delivery robot should feel utilitarian and service-worn rather than cute or toy-like.
- Management office and Grid elements should feel bureaucratic, distant, and system-like.
- Object visuals should help players understand power cost, active state, and risk.

## What To Avoid

- Do not recreate the images pixel-for-pixel.
- Do not treat the images as final art requirements.
- Avoid bright arcade-like visuals.
- Avoid heavy horror presentation that overwhelms the grounded survival tone.
- Avoid overbuilding the entire DAY 1~12 story before DAY 1 is playable.
- Avoid spending early implementation time on polish that does not support the core power loop.

## Visual Similarity Guardrail

- The game uses top-down 2D movement and proximity `E` interaction, but it must not look like a clone of existing top-down survival or management games.
- Among Us is only a control-model reference for top-down movement and nearby interaction. It is not a visual, UI, color, character, or room-layout reference.
- Treat games like `Break the Animal Prison` and other top-down pixel survival/facility-management games as anti-references.
- Avoid prison, institution, facility-management, restaurant/order-card, and bright pixel life-sim moods.
- Avoid generic task-list survival HUDs, card-choice layouts, resource bars, and facility-grid compositions that directly recall existing indie management games.
- Do not copy the screen composition, UI placement, card layout, or room hierarchy of existing games.
- The screen should communicate: a small isolated apartment, power shortage, blackout, outlets, multi-taps, worn electronics, weak light, and Yui's quiet survival routine.
- UI should feel like a power panel, survival log, laptop screen, apartment notice, or subdued dialogue layer rather than a task-management dashboard.

## How To Use These References In Future Tasks

- Use the images to guide mood, UI restraint, object selection, and room atmosphere.
- In implementation tasks, start with readable placeholders that match the direction loosely.
- When choosing colors or UI layout, prioritize clarity and DAY 1 playability first.
- Save higher-detail character art, robot art, environment polish, and panel styling for later polish passes.
- During implementation reviews, check that the result still reads as `a one-room power-shortage story` rather than `a facility/task-management game`.
