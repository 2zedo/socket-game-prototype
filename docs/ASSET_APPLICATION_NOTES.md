# Asset Application Notes

## P0 PNG Asset Application Pass 1

This pass applies the first in-repository PNG art assets to the existing Godot DAY 1 MVP while preserving the current gameplay loop.

## Applied PNGs

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
- Several broader room details still use primitive fallback drawing because no specific P0 sprite exists yet for bed, desk, window, door, shelf, rug, and clutter.

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

- P0 object images are large source PNGs, so current implementation scales them inside the existing interactable draw rects.
- Yui player sprite is now drawn smaller than the previous pass with `Visual` scale `0.052`, so the character reads closer to a top-down pixel-game proportion inside the apartment.
- The fluorescent light interactable moved to the upper room area and uses a wider, shallow draw rect.
- Room wall/floor PNGs are drawn as scaled underlays beneath primitive furniture and existing collision.
- UI panel PNGs are low-alpha backplates so text readability remains the first priority.
- Laptop, fan, charger, communication device, and power strip world display sizes were normalized down for the reference apartment rebuild pass.
- Powered cables are still drawn as lines, but now use bundled dark physical routes instead of glowing electrical feedback.

## Remaining Art Issues

- The room still needs dedicated sprites or scene pieces for bed, desk, window, door, shelf, rug, and clutter.
- Cable visuals are still drawn lines and should later become cleaner modular cable art or refined Line2D paths.
- The result panel does not yet use a dedicated final diary/log skin.
- Multitap device cards are still drawn UI cards; only slots, plugs, badges, and icons use PNGs.
- In-editor screenshots are needed to tune scale, alignment, prompt overlap, and panel readability.
