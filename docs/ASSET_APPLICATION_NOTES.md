# Asset Application Notes

## P0 PNG Asset Application Pass 1

This pass applies the first in-repository PNG art assets to the existing Godot DAY 1 MVP while preserving the current gameplay loop.

## Direct Reference Asset Application Pass

This pass copies the current reference map and YUI files into the Godot project and uses them directly for runtime apartment/player art.

## YUI Scale And Fringe Cleanup Pass

This pass updates only the active Yui player sprite processing and display scale. It does not change the map background, object placement, UI panels, interaction logic, power logic, or day/result systems.

## YUI-1 Replacement Pass

This pass replaces the active player sprite source with `docs/reference/yui-1.png`. It does not change the map background, object placement, UI panels, interaction logic, power logic, or day/result systems.

## Applied PNGs

- `godot/assets/art/maps/apartment/apartment_map_reference.png`
- `godot/assets/art/characters/yui/yui_1_source_sheet.png`
- `godot/assets/art/characters/yui/yui_source_sheet.png`
- `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`
- `godot/assets/art/characters/yui/yui_player_idle_back.png`
- `godot/assets/art/portraits/yui/yui_portrait_neutral.png`
- `godot/assets/art/environment/room/room_floor_base.png`
- `godot/assets/art/environment/room/room_wall_base.png`
- `godot/assets/art/objects/light/fluorescent_light_off.png`
- `godot/assets/art/objects/light/fluorescent_light_on.png`
- `godot/assets/art/overlays/lighting/fluorescent_glow.png`
- `godot/assets/art/objects/laptop/laptop_off.png`
- `godot/assets/art/objects/laptop/laptop_on.png`
- `godot/assets/art/objects/fan/fan_off.png`
- `godot/assets/art/objects/fan/fan_on.png`
- `godot/assets/art/objects/phone/phone_normal.png`
- `godot/assets/art/objects/phone/phone_recharge.png`
- `godot/assets/art/objects/phone/phone_charging.png`
- `godot/assets/art/objects/phone/phone_charged.png`
- `godot/assets/art/objects/comm_device/comm_device_off.png`
- `godot/assets/art/objects/comm_device/comm_device_on.png`
- `godot/assets/art/objects/powerstrip/powerstrip_empty.png`
- `godot/assets/art/objects/powerstrip/powerstrip_connected.png`
- `godot/assets/art/objects/outlet/outlet_slot_empty.png`
- `godot/assets/art/objects/outlet/outlet_slot_active.png`
- `godot/assets/art/objects/outlet/plug_1slot.png`
- `godot/assets/art/objects/outlet/plug_2slot.png`
- `godot/assets/art/ui/panels/ui_panel_dialogue.png`
- `godot/assets/art/ui/panels/ui_panel_interaction.png`
- `godot/assets/art/ui/icons/icon_power.png`
- `godot/assets/art/ui/icons/icon_plug.png`
- `godot/assets/art/ui/badges/badge_connected.png`
- `godot/assets/art/ui/badges/badge_disconnected.png`

## Not Applied

- None of the requested P0 PNG paths are intentionally left unused.
- The direct reference map pass no longer needs separate primitive fallback drawing for bed, desk, window, door, shelf, rug, and clutter in the apartment view.

## Filename Corrections

Some incoming P0 PNG files had accidental double-dot filenames. They were renamed to match the documented Godot paths:

- `powerstrip_connected..png` -> `powerstrip_connected.png`
- `outlet_slot_active..png` -> `outlet_slot_active.png`
- `plug_1slot..png` -> `plug_1slot.png`
- `plug_2slot..png` -> `plug_2slot.png`
- `ui_panel_interaction..png` -> `ui_panel_interaction.png`

## Object Mapping

- Fluorescent light:
  - Off: `fluorescent_light_off.png`
  - Used/on: `fluorescent_light_on.png`
  - Glow: `fluorescent_glow.png`
  - Note: this is treated as a room fluorescent light near the upper wall/ceiling, not a desk lamp.
- Laptop:
  - Before use: `laptop_off.png`
  - After use: `laptop_on.png`
- Fan:
  - Before use: `fan_off.png`
  - After use: `fan_on.png`
- Phone/charger:
  - Default: `phone_normal.png`
  - Low remaining power: `phone_recharge.png`
  - Connected but not used: `phone_charging.png`
  - Used today: `phone_charged.png`
- Communication device:
  - Before use: `comm_device_off.png`
  - After use: `comm_device_on.png`
- Power strip:
  - No connected devices: `powerstrip_empty.png`
  - One or more connected devices: `powerstrip_connected.png`

## Scale And Position Notes

- `apartment_map_reference.png` is copied from `docs/reference/map.png` and displayed directly as the apartment background at the original aspect ratio.
- `yui_source_sheet.png` is copied from `docs/reference/YUI.png`.
- `yui_1_source_sheet.png` is copied from `docs/reference/yui-1.png` and is now the active player sprite source copy.
- `yui_walk_4dir_rgba.png` is generated from `yui_1_source_sheet.png` with transparent background, 4 rows, 4 columns, and `96x96` frames.
- The older `docs/reference/YUI.png` / `yui_source_sheet.png` automatic checkerboard cutout is no longer used for the active player display.
- P0 object images are large source PNGs, so current implementation scales them inside the existing interactable draw rects.
- Yui player art now uses `yui_walk_4dir_rgba.png` through `AnimatedSprite2D` / `AtlasTexture` frames instead of generated placeholder drawing.
- Yui's active display scale is handled in `godot/scenes/Player.tscn` through the `Visual` `AnimatedSprite2D`; collision and interaction shapes remain separate.
- The fluorescent light interactable moved to the upper room area and uses a wider, shallow draw rect.
- Room wall/floor PNGs remain in the project, but the apartment view now draws `apartment_map_reference.png` directly.
- UI panel PNGs are low-alpha backplates so text readability remains the first priority.
- Laptop, fan, charger, communication device, and power strip world display sizes were adjusted again to match the `map ui` object proportions.
- Apartment-view cable visuals now come from `apartment_map_reference.png`; dynamic cable drawing is not called in the direct map pass.
- The direct map pass hides current world object placeholders; the visible furniture, devices, and cables come from `apartment_map_reference.png`.

## Remaining Art Issues

- The `yui-1` runtime screenshot was captured at `docs/validation/yui_1_runtime_screenshot00000000.png`.
- Manual directional movement should still be checked in-editor because the screenshot capture does not press movement keys.
- Interaction hotspots should be checked against the visible objects in the map background.
- The result panel does not yet use a dedicated final diary/log skin.
- Multitap device cards are still drawn UI cards; only slots, plugs, badges, and icons use PNGs.
- In-editor screenshots are needed to tune scale, alignment, prompt overlap, and panel readability.

## Processing Scripts

- `tools/process_yui_sprite_sheet.py`
  - Input: `docs/reference/yui-1.png`
  - Source copy: `godot/assets/art/characters/yui/yui_1_source_sheet.png`
  - Output: `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`
  - Purpose: normalizes the `yui-1` 4x4 RGBA sheet into matching `96x96` cells, removes very low-alpha source noise, keeps all frames on a shared foot baseline, and keeps Yui's source art as the player sprite.
