# UI Visual Implementation Notes

## DAY 1 Visual Design Pass 1

This pass reshapes the Godot DAY 1 MVP from a test-board layout toward a dark one-room survival adventure presentation. It does not add new game systems.

## DAY 1 Visual Design Pass 2

This pass responds to in-editor screenshots from Visual Design Pass 1. It keeps the same systems, but reduces the remaining primitive/test-board feeling in the room, HUD, prompts, interaction panel, multitap overlay, and result screen.

## DAY 1 Visual Pass 3

This pass responds to in-editor screenshots showing multitap card overlap, unclear slot occupancy, next-day connection visual desync, and remaining room-layout roughness.

## P0 PNG Asset Application Pass 1

This pass applies the first repo-local PNG assets to the existing Godot DAY 1 MVP without changing the power loop, proximity interaction model, End Day flow, or `SurvivalState.gd` source of truth.

## Improved Screens

- Exploration: darker apartment frame, lived-in room layout, weaker warm light, clearer object placement, smaller proximity prompt.
- HUD: left-side survival log and power panel style instead of debug/test labels.
- Interaction: dimmed room backdrop, right-side object information panel, bottom Yui comment panel.
- Multitap: dark power-management overlay with unified daily power, current load, outlet usage, and muted device cards.
- Result: survival record wording and diary/log tone instead of score-board presentation.
- P0 art pass: applies PNGs to the player, portrait, room underlay, key interactables, fluorescent glow, HUD power icon, interaction/dialogue backplates, multitap slots, plugs, and connection badges.

## Pass 2 Adjustments

- Exploration: reduced oversized circular light pools, darkened wall/floor contrast, and hid persistent object labels/status text during normal movement.
- HUD: made the survival log panel more readable, added a compact text power bar, and moved the control hint into a safer bottom bar.
- Prompt/labels: default object state text is no longer drawn over the room; proximity prompt remains the main exploration affordance.
- Interaction: added internal panel dividers, button-like `E`/`ESC` controls, lighter dim strength, and a Yui portrait placeholder in the dialogue panel.
- Multitap: shifted to a clearer two-column card layout, darkened outlet slots, simplified card text, and separated status memo text from the device cards.
- Result: widened the record panel, split content into survival-record sections, added a snapshot placeholder, and styled the `SPACE` footer as a button.

## Pass 3 Adjustments

- Multitap: separated connected-device cards from outlet slots; slots now show only occupancy highlights and small device labels.
- Slot data: Laptop and Communication device use `2` outlet slots, with `SurvivalState.gd` as the source of truth.
- Sync: continuing to the next day preserves powered devices and recalculates room visual connection state from `SurvivalState`.
- Room layout: moved the charger away from the laptop desk area and added blockers for non-interactive door/shelf/window features.
- Cable readability: adjusted cable bends per connected object to reduce visual tangling.
- Asset preparation: added folders for environment art, object art, portraits, UI icons, panel skins, fonts, themes, and future device data.

## P0 PNG Pass Adjustments

- Asset paths are centralized in `godot/scripts/ui/AssetPaths.gd`.
- `Player.gd` draws `yui_player_idle_back.png` as the current idle back-facing sprite.
- `Apartment.gd` draws `room_floor_base.png` and `room_wall_base.png` under the existing primitive layout.
- The light interactable now uses the fluorescent room-light PNGs and sits near the upper room/ceiling area rather than reading as a desk lamp.
- `fluorescent_glow.png` is drawn only after the light action is used.
- `Interactable.gd` maps object states to PNGs:
  - Light: off/on fluorescent light
  - Laptop: off/on
  - Fan: off/on
  - Phone/charger: normal, recharge, charging, charged
  - Communication device: off/on
  - Power strip: empty/connected
- `InteractionPanel.gd` uses UI panel PNGs as low-alpha backplates and fills the portrait area with the Yui portrait PNG.
- `OutletMode.gd` uses outlet slot, plug, badge, and plug icon PNGs while preserving slot/load calculations from `SurvivalState.gd`.
- `SurvivalHUD.gd` adds the power icon PNG next to the power panel area.

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

- Bed, desk, window, door, shelf, rug, and small clutter still use primitive drawing.
- Room floor/wall art is a scaled underlay, not a fully sliced final environment.
- Interaction and dialogue panel art is intentionally subtle so Korean text remains readable.
- Result panel still uses drawn panels and a snapshot placeholder.
- Multitap device cards still use drawn rectangles and text, with PNG badges/plugs layered in.
- No external art assets were imported.

## Next Visual Tasks

- Replace remaining furniture primitives with controlled object sprites or simple `.tscn` object scenes.
- Tune PNG scale/position after in-editor screenshots.
- Tighten panel spacing after in-editor screenshot review.
- Add subtle Light2D/CanvasModulate if it does not hurt readability.
- Move device/object presentation data into resources after the loop is manually validated.
- Continue screenshot-based spacing checks for the multitap overlay and result screen at the target resolution.
- Add state-specific object polish for connected-but-unused versus used/on visuals.
