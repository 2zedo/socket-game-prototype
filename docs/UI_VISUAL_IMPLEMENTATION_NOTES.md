# UI Visual Implementation Notes

## DAY 1 Visual Design Pass 1

This pass reshapes the Godot DAY 1 MVP from a test-board layout toward a dark one-room survival adventure presentation. It does not add new game systems.

## Improved Screens

- Exploration: darker apartment frame, lived-in room layout, weaker warm light, clearer object placement, smaller proximity prompt.
- HUD: left-side survival log and power panel style instead of debug/test labels.
- Interaction: dimmed room backdrop, right-side object information panel, bottom Yui comment panel.
- Multitap: dark power-management overlay with unified daily power, current load, outlet usage, and muted device cards.
- Result: survival record wording and diary/log tone instead of score-board presentation.

## Common UI Style

- Added `godot/scripts/ui/UIStyle.gd` for shared colors and simple panel styles.
- Core palette:
  - very dark background
  - translucent brown-gray panels
  - muted beige/brass lines
  - warm off-white text
  - muted yellow electric accent
  - subdued red/green feedback colors

## Still Placeholder

- Room art is still drawn with Godot primitives, not final sprites.
- Yui is still the existing simple player placeholder.
- Object art is still simplified icon/shape drawing.
- Interaction and result panels reserve space for later portrait/item art, but no final art is included.
- No external art assets were imported.

## Next Visual Tasks

- Replace key room objects with consistent placeholder sprites or simple `.tscn` object scenes.
- Add a proper Yui portrait/cut-in placeholder for dialogue.
- Tighten panel spacing after in-editor screenshot review.
- Add subtle Light2D/CanvasModulate if it does not hurt readability.
- Move device/object presentation data into resources after the loop is manually validated.
