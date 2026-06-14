# UI Visual Implementation Notes

## DAY 1 Visual Design Pass 1

This pass reshapes the Godot DAY 1 MVP from a test-board layout toward a dark one-room survival adventure presentation. It does not add new game systems.

## DAY 1 Visual Design Pass 2

This pass responds to in-editor screenshots from Visual Design Pass 1. It keeps the same systems, but reduces the remaining primitive/test-board feeling in the room, HUD, prompts, interaction panel, multitap overlay, and result screen.

## Improved Screens

- Exploration: darker apartment frame, lived-in room layout, weaker warm light, clearer object placement, smaller proximity prompt.
- HUD: left-side survival log and power panel style instead of debug/test labels.
- Interaction: dimmed room backdrop, right-side object information panel, bottom Yui comment panel.
- Multitap: dark power-management overlay with unified daily power, current load, outlet usage, and muted device cards.
- Result: survival record wording and diary/log tone instead of score-board presentation.

## Pass 2 Adjustments

- Exploration: reduced oversized circular light pools, darkened wall/floor contrast, and hid persistent object labels/status text during normal movement.
- HUD: made the survival log panel more readable, added a compact text power bar, and moved the control hint into a safer bottom bar.
- Prompt/labels: default object state text is no longer drawn over the room; proximity prompt remains the main exploration affordance.
- Interaction: added internal panel dividers, button-like `E`/`ESC` controls, lighter dim strength, and a Yui portrait placeholder in the dialogue panel.
- Multitap: shifted to a clearer two-column card layout, darkened outlet slots, simplified card text, and separated status memo text from the device cards.
- Result: widened the record panel, split content into survival-record sections, added a snapshot placeholder, and styled the `SPACE` footer as a button.

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
- Interaction and result panels reserve space for later portrait, item art, and room snapshot art, but no final art is included.
- No external art assets were imported.
- Multitap cards still use drawn rectangles and text rather than final device illustrations.

## Next Visual Tasks

- Replace key room objects with consistent placeholder sprites or simple `.tscn` object scenes.
- Add a proper Yui portrait/cut-in placeholder for dialogue.
- Tighten panel spacing after in-editor screenshot review.
- Add subtle Light2D/CanvasModulate if it does not hurt readability.
- Move device/object presentation data into resources after the loop is manually validated.
- Continue screenshot-based spacing checks for the multitap overlay and result screen at the target resolution.
