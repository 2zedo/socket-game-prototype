# Asset Application Notes

## P0 PNG Asset Application Pass 1

This pass applies the first in-repository PNG art assets to the existing Godot DAY 1 MVP while preserving the current gameplay loop.

## Direct Reference Asset Application Pass

This pass copies the current reference map and YUI files into the Godot project and uses them directly for runtime apartment/player art.

## YUI Scale And Fringe Cleanup Pass

This pass updates only the active Yui player sprite processing and display scale. It does not change the map background, object placement, UI panels, interaction logic, power logic, or day/result systems.

## YUI-1 Replacement Pass

This pass replaces the active player sprite source with `docs/reference/yui-1.png`. It does not change the map background, object placement, UI panels, interaction logic, power logic, or day/result systems.

## YUI Direction Alignment Cleanup Pass

This pass updates only the generated active Yui walk sheet from `docs/reference/yui-1.png`. It does not change the map background, object placement, UI panels, interaction logic, power logic, day/result systems, or runtime display scale.

## YUI Back Silhouette Preservation Pass

This pass updates only the back-facing row of the generated active Yui walk sheet. It keeps the `docs/reference/yui-1.png` fourth-row fixed-grid cells intact, preserves their original alpha channel, and does not change the map background, object placement, UI panels, interaction logic, power logic, day/result systems, runtime display scale, or the front/left/right frame pixels.

## YUI Back Row Scale Adjustment Pass

This pass updates only the completed back-facing `96x96` frames by scaling them to `96%` inside the same canvas. It keeps the foot baseline fixed, adds more top headroom, and does not change the map background, object placement, UI panels, interaction logic, power logic, day/result systems, runtime display scale, or the front/left/right frame pixels.

## YUI Fixed Source Back Row Copy Pass

This pass replaces the previous scale-only back-facing treatment with a transparent `1256x1256` fixed-grid source and `314x314` back-cell copy path. It keeps the map background, object placement, UI panels, interaction logic, power logic, day/result systems, runtime display scale, and the front/down, left, and right rows unchanged.

## Fix Multitap Asset And Wire Sync Pass

This pass applies the provided `docs/reference/Fix/` multitap assets directly and adds dynamic map wire overlays. It does not recreate or modify the source images, does not add fridge wiring, and keeps the existing player, object placement, interaction flow, day/result systems, and non-multitap UI logic unchanged.

## Fix Multitap Adapter And Wire Endpoint Follow-up

This follow-up keeps the same multitap systems and does not add gameplay. It preserves the no-wire base map as the apartment background, keeps `map_reference_all_wires.jpeg` as reference-only source material, tightens adapter insertion presentation, and splits the Laptop map wire into floor and desk overlay sprites so the desk segment can draw above the map layer.

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
- `godot/assets/art/maps/apartment/map_base_no_wires.png`
- `godot/assets/art/maps/apartment/wires/wire_fan.png`
- `godot/assets/art/maps/apartment/wires/wire_communication.png`
- `godot/assets/art/maps/apartment/wires/wire_laptop.png`
- `godot/assets/art/maps/apartment/wires/wire_laptop_desk.png`
- `godot/assets/art/maps/apartment/wires/wire_charger.png`
- `godot/assets/art/maps/apartment/wires/wire_lamp.png`
- `godot/assets/art/objects/powerstrip/powerstrip_4slot.png`
- `godot/assets/art/objects/powerstrip/adapters/adapter_1_fan.png`
- `godot/assets/art/objects/powerstrip/adapters/adapter_2_comm.png`
- `godot/assets/art/objects/powerstrip/adapters/adapter_2slot_laptop-Photoroom.png`
- `godot/assets/art/objects/powerstrip/adapters/adapter_3_charger.png`
- `godot/assets/art/objects/powerstrip/adapters/adapter_4_lamp.png`
- `godot/assets/art/ui/panels/ui_panel_dialogue.png`
- `godot/assets/art/ui/panels/ui_panel_interaction.png`
- `godot/assets/art/ui/icons/icon_power.png`
- `godot/assets/art/ui/icons/icon_plug.png`
- `godot/assets/art/ui/badges/badge_connected.png`
- `godot/assets/art/ui/badges/badge_disconnected.png`

## Not Applied

- None of the requested P0 PNG paths are intentionally left unused.
- The direct reference map pass no longer needs separate primitive fallback drawing for bed, desk, window, door, shelf, rug, and clutter in the apartment view.
- `docs/reference/Fix/map_reference_all_wires.jpeg` is reference-only for wire routing and is not drawn as the runtime apartment map.
- Refrigerator wiring from the all-wires reference is intentionally excluded from the current multitap connection targets.

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
- Fix multitap UI:
  - Base strip: `powerstrip_4slot.png`
  - Fan adapter: `adapter_1_fan.png`
  - Communication adapter: `adapter_2_comm.png`
  - Laptop adapter: `adapter_2slot_laptop-Photoroom.png`
  - Charger adapter: `adapter_3_charger.png`
  - Lamp adapter: `adapter_4_lamp.png`

## Scale And Position Notes

- `apartment_map_reference.png` is copied from `docs/reference/map.png` and displayed directly as the apartment background at the original aspect ratio.
- `yui_source_sheet.png` is copied from `docs/reference/YUI.png`.
- `yui_1_source_sheet.png` is copied from `docs/reference/yui-1.png` and is now the active player sprite source copy.
- `yui_walk_4dir_rgba.png` is generated from `yui_1_source_sheet.png` with transparent background, 4 rows, 4 columns, and `96x96` frames.
- The active generated sheet now fits all 16 frames to a shared visible height of `78px`, a shared foot baseline at `y = 90`, and a centered x-axis near `x = 48`.
- The right-facing row is generated by mirroring the left-facing row because the right-facing source row has inconsistent crop extent and made Yui appear smaller in-game.
- Previous back-facing artifacts were caused by auto-trim / bbox crop / alpha-threshold crop style processing that let the rear frames' top silhouette be damaged before runtime.
- The back-facing row is now copied from a transparent `1256x1256` fixed-grid source that uses `314x314` cells; the active back row does not use bbox calculation, trim, alpha crop, visible top/bottom calculation, recentering, or back-row scale normalization.
- `docs/reference/yui-1.png` is `1254x1254`, so the script builds the transparent `1256x1256` working grid first, copies the original back-facing pixels into the fourth-row `314x314` cells, then resizes each whole cell into the final `96x96` frame with nearest filtering. The character silhouette inside the cell is not cropped or redrawn.
- The generated back row has visible top `6`, visible bottom `89-90`, and is pixel-identical to the transparent `1256x1256` fixed-grid cell copy result saved in validation images.
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
- `docs/reference/Fix/map_base_no_wires.png` is copied to `godot/assets/art/maps/apartment/map_base_no_wires.png` and is now the apartment background, so no device wires appear by default.
- `docs/reference/Fix/map_reference_all_wires.jpeg` remains in `docs/reference/Fix/` as the all-wire reference map. It is not drawn as the runtime background.
- Runtime wire overlays are independent PNG sprites under `godot/assets/art/maps/apartment/wires/`:
  - `wire_fan.png`
  - `wire_communication.png`
  - `wire_laptop.png`
  - `wire_laptop_desk.png`
  - `wire_charger.png`
  - `wire_lamp.png`
- Dynamic map wires are separate `Sprite2D` overlay nodes named `WireFan`, `WireCommunication`, `WireLaptopFloor`, `WireLaptopDesk`, `WireCharger`, and `WireLamp`.
- Wire visibility is synced from the shared power strip connection state in `SurvivalState.gd`; disconnected devices hide their corresponding wire node.
- Wire overlays are dark physical wires, not glowing power lines. The Laptop uses separate floor and desk segments so the final desk-to-laptop portion can draw above the map.
- Laptop remains a 2-slot adapter in the multitap UI and visually spans the adjacent slot area.
- Fan, communication device, charger, and lamp are 1-slot adapters.
- Connecting adapters updates outlet load/current connected devices, but it does not spend the DAY 1 action power budget until the matching object is used.

## Remaining Art Issues

- The `yui-1` runtime screenshot was captured at `docs/validation/yui_1_runtime_screenshot00000000.png`.
- Directional runtime screenshots were captured at:
  - `docs/validation/yui_direction_front.png`
  - `docs/validation/yui_direction_back.png`
  - `docs/validation/yui_direction_left.png`
  - `docs/validation/yui_direction_right.png`
- Up-direction silhouette validation screenshots were captured at:
  - `docs/validation/yui_up_idle_headroom.png`
  - `docs/validation/yui_up_walk_headroom.png`
  - `docs/validation/yui_up_walk_headroom_01.png`
  - `docs/validation/yui_up_walk_headroom_02.png`
- Fixed source-cell back-row validation images were captured at:
  - `docs/validation/yui_fixed_1256_back_row_source.png`
  - `docs/validation/yui_back_row_enlarged.png`
  - `docs/validation/yui_back_source_vs_final_compare.png`
  - `docs/validation/yui_runtime_back_idle.png`
  - `docs/validation/yui_runtime_back_walk_01.png`
  - `docs/validation/yui_runtime_back_walk_02.png`
  - `docs/validation/yui_runtime_front.png`
  - `docs/validation/yui_runtime_right.png`
- Multitap UI and dynamic wire validation images were captured at:
  - `docs/validation/powerstrip_ui_empty_inserted.png`
  - `docs/validation/powerstrip_ui_single_inserted.png`
  - `docs/validation/powerstrip_ui_laptop_inserted.png`
  - `docs/validation/powerstrip_ui_laptop_lamp_charger_inserted.png`
  - `docs/validation/map_wires_none.png`
  - `docs/validation/map_wires_fan_only.png`
  - `docs/validation/map_wires_multiple.png`
  - `docs/validation/map_wires_after_disconnect.png`
  - `docs/validation/map_wires_laptop_charger_complete.png`
  - `docs/validation/map_wires_lamp_laptop_complete.png`
  - `docs/validation/map_wires_laptop_charger_lamp_complete.png`
  - `docs/validation/map_laptop_split_wire_fixed_only.png`
  - `docs/validation/map_laptop_split_wire_anchor_compare.png`
  - `docs/validation/map_laptop_split_wire_with_lamp_charger.png`
- Godot runtime validation for the dynamic wire sync is still required because no Godot executable was available in this environment.
- Manual directional movement should still be checked in-editor because the screenshot capture forces direction animations but does not press movement keys.
- Interaction hotspots should be checked against the visible objects in the map background.
- The result panel does not yet use a dedicated final diary/log skin.
- Multitap adapters now use the provided PNGs in both the bottom available list and the connected-slot view, but socket insertion masking still needs in-editor visual review.
- The Laptop wire desk segment may still need endpoint/anchor tuning after in-editor screenshots.
- In-editor screenshots are needed to tune scale, alignment, prompt overlap, and panel readability.

## Processing Scripts

- `tools/process_yui_sprite_sheet.py`
  - Input: `docs/reference/yui-1.png`
  - Source copy: `godot/assets/art/characters/yui/yui_1_source_sheet.png`
  - Output: `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`
  - Purpose: normalizes the non-back rows of the `yui-1` 4x4 RGBA sheet into matching `96x96` cells, keeps non-back frames on a shared foot baseline, mirrors the left row for the right-facing row to avoid the bad source crop, and copies the back-facing row from transparent `1256x1256` / `314x314` fixed source cells without bbox, trim, alpha crop, visible top/bottom recentering, or scale-normalization logic.
