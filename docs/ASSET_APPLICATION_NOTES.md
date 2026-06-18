# Asset Application Notes

## Active Runtime Assets

- Apartment base map: `godot/assets/art/maps/apartment/map_base_no_wires.png`
- Yui source: `docs/reference/yui-1.png`
- Yui runtime sheet: `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`
- Yui portrait: `godot/assets/art/portraits/yui/yui_portrait_neutral.png`
- Multitap: `godot/assets/art/objects/powerstrip/powerstrip_4slot.png`
- Adapter images: `godot/assets/art/objects/powerstrip/adapters/`
- Device wire overlays: `godot/assets/art/maps/apartment/wires/`

## Current Asset Mapping

- Fan, Communication Device, Charger, and Light/Lamp currently use one-slot adapter images.
- Laptop uses the two-slot adapter image and two adjacent outlet slots.
- Laptop wire rendering is split into floor and desk segments.
- Wire overlays are visual-only and follow connection state owned by `SurvivalState.gd`.
- `map_reference_all_wires.jpeg` is reference material and is not the runtime apartment background.

## Light Asset Decision Required

- Current runtime implementation uses `adapter_4_lamp.png` and `wire_lamp.png` as a connected one-slot device.
- Existing room art and naming also describe the object as a fluorescent ceiling light.
- If it remains a built-in fluorescent light, the adapter and wire assets should stop representing gameplay connection state.
- If it remains part of the multitap puzzle, rename it to `스탠드 조명` or `작업등` and keep the one-slot adapter mapping.

## Processing

- `tools/process_yui_sprite_sheet.py` regenerates the active Yui sheet from `docs/reference/yui-1.png`.
- The back-facing row uses the fixed source-grid copy path documented in the archived notes.
- Existing source-side `.png.import` and script `.uid` metadata should follow the repository's tracked metadata policy.
- `.godot/` imported textures, shader cache, and editor cache must not be committed.

## Remaining Asset Risks

- Adapter insertion masking needs in-editor review.
- Laptop desk-wire and some device endpoints may need small alignment adjustments.
- Communication Device world art remains less suitable than its UI-preview presentation.
- No new asset should replace a current runtime reference without updating this document and the relevant visual notes.

## Archive

- Previous application and processing history: `docs/old/ASSET_APPLICATION_NOTES_20260619.md`
