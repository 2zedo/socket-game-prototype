# UI Visual Implementation Notes

## DAY 1 Visual Design Pass 1

This pass reshapes the Godot DAY 1 MVP from a test-board layout toward a dark one-room survival adventure presentation. It does not add new game systems.

## DAY 1 Visual Design Pass 2

This pass responds to in-editor screenshots from Visual Design Pass 1. It keeps the same systems, but reduces the remaining primitive/test-board feeling in the room, HUD, prompts, interaction panel, multitap overlay, and result screen.

## DAY 1 Visual Pass 3

This pass responds to in-editor screenshots showing multitap card overlap, unclear slot occupancy, next-day connection visual desync, and remaining room-layout roughness.

## P0 PNG Asset Application Pass 1

This pass applies the first repo-local PNG assets to the existing Godot DAY 1 MVP without changing the power loop, proximity interaction model, End Day flow, or `SurvivalState.gd` source of truth.

## Yui Character Animation Pass 1

This pass replaces the single Yui player texture with directional idle/walk sprite animations while preserving the existing `CharacterBody2D`, collision shape, movement input, and proximity interaction behavior.

## PNG Layout Normalization Pass

This pass responds to latest in-editor screenshots after transparent PNG replacement. It keeps gameplay logic unchanged and focuses on visual scale, position, pivot, z-order, world/UI display separation, and multitap card layout stability.

## Visual Sanity Pass

This pass responds to latest in-editor screenshots where Yui still read too small, several object PNGs read oversized or mismatched, furniture primitives remained too flat, and the multitap overlay still mixed slots and cards too aggressively. It keeps gameplay and power logic unchanged.

## Improved Screens

- Exploration: darker apartment frame, lived-in room layout, weaker warm light, clearer object placement, smaller proximity prompt.
- HUD: left-side survival log and power panel style instead of debug/test labels.
- Interaction: dimmed room backdrop, right-side object information panel, bottom Yui comment panel.
- Multitap: dark power-management overlay with unified daily power, current load, outlet usage, and muted device cards.
- Result: survival record wording and diary/log tone instead of score-board presentation.
- P0 art pass: applies PNGs to the player, portrait, room underlay, key interactables, fluorescent glow, HUD power icon, interaction/dialogue backplates, multitap slots, plugs, and connection badges.
- Yui animation pass: adds directional idle/walk player visuals so Yui changes sprite by movement direction without changing gameplay logic.
- PNG layout normalization: centralizes object display rules, enlarges Yui's visual-only sprite scale, separates world-scale values from future UI-preview values, and moves multitap device cards into a stable grid.
- Visual sanity pass: increases Yui's visual footprint, reduces world object texture dominance, improves bed/desk primitive readability, routes the fluorescent cable less intrusively, and simplifies multitap slot occupancy versus device-card information.

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

## Yui Animation Pass Adjustments

- `Player.tscn` now has an `AnimatedSprite2D` child named `Visual`.
- `Player.gd` builds `SpriteFrames` at runtime from Yui idle/walk PNG paths in `AssetPaths.gd`.
- Walk animations use two frames at `5 fps`.
- Idle animations use one frame.
- The old `yui_player_idle_back.png` remains as a fallback texture.
- Direction uses the stronger movement axis; diagonal movement stays 4-directional for this MVP pass.

## PNG Layout Normalization Adjustments

- `Interactable.gd` now owns per-object presentation rules for `world_size`, `world_offset`, `ui_preview_size`, and `z_index`.
- World display scale and UI preview scale are separated so object PNGs can be tuned differently in the room and in later detail panels.
- Yui's `AnimatedSprite2D` visual scale was increased while keeping the existing collision shape and interaction range.
- Laptop, charger, fan, and communication-device positions/collision sizes were nudged to sit more naturally in the room layout.
- Multitap cards now use a consistent width/height, two-column grid spacing, larger badge padding, and smaller plug tails.
- The outlet slot area now shows occupancy and small labels instead of trying to place detailed cards directly over the slots.
- `comm_device_off.png` and `comm_device_on.png` still appear to be RGB/no-alpha files, so the room display keeps the primitive fallback until those PNGs are re-exported with transparency.

## Visual Sanity Pass Adjustments

- Yui's `AnimatedSprite2D` visual scale was increased from `0.072` to `0.12`, with the visual offset moved upward so the collision body and interaction range remain unchanged while the sprite reads as a character instead of a tiny icon.
- Object world display rules were tightened:
  - Laptop, fan, charger/phone, power strip, and fluorescent light now use smaller, darker `world_size` and `world_modulate` values.
  - UI preview sizes remain separate from world sizes so later detail panels can show clearer object art without inflating the room sprites.
  - Communication device keeps a primitive world fallback even though the PNG now has alpha, because its current perspective/real-product look still clashes with the room view at small scale.
- Desk primitive now has a shadow, inset tabletop, outline, highlight, and reduced clutter so it reads more like furniture.
- Bed primitive now separates mattress, pillow, blanket, shadow, and fold line so it reads as the End Day area.
- Fluorescent glow was reduced and cable routing for the light now follows the room more quietly instead of cutting a bright diagonal through the center.
- Multitap overlay now uses a smaller strip, smaller slot textures, compact connected/available device rows, small short labels on occupied slots, and reduced card text size.
- Laptop and Communication device still depend on `SurvivalState.gd` outlet size data for 2-slot behavior; the visual slot highlight spans the occupied slot group instead of using a full detailed card on top of the strip.

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
- Communication device world art should be remade or adapted for the room perspective; current PNG is better suited to UI preview than world placement.
- The fan and laptop are usable as temporary world sprites, but their perspective still differs from the primitive room and should be reviewed when final object art starts.
- No external art assets were imported.

## Next Visual Tasks

- Replace remaining furniture primitives with controlled object sprites or simple `.tscn` object scenes.
- Tune PNG scale/position and Yui animation pivot after in-editor screenshots.
- Create or adapt a dedicated top-down communication-device world sprite instead of forcing the current preview-like PNG into the room.
- Review whether fan/laptop need dedicated world variants separate from UI preview images.
- Tighten panel spacing after in-editor screenshot review.
- Add subtle Light2D/CanvasModulate if it does not hurt readability.
- Move device/object presentation data into resources after the loop is manually validated.
- Continue screenshot-based spacing checks for the multitap overlay and result screen at the target resolution.
- Add state-specific object polish for connected-but-unused versus used/on visuals.
