# Asset Pipeline

## Purpose

Prepare the Godot project to replace primitive placeholders with controlled art assets without changing the DAY 1 power-loop structure.

## Folder Structure

- `godot/assets/art/environment/`: room background, wall/floor overlays, window and door environment pieces.
- `godot/assets/art/objects/`: bed, desk, laptop, lamp, fan, charger, communication device, multitap, and cable sprites.
- `godot/assets/art/portraits/`: Yui portrait and later character cut-ins.
- `godot/assets/ui/icons/`: power, device, status, result, and control icons.
- `godot/assets/ui/panels/`: reusable panel skins, frames, diary/log paper textures, and button backplates.
- `godot/assets/ui/fonts/`: approved `.ttf` or `.otf` fonts.
- `godot/themes/`: Godot Theme resources for shared UI styling.
- `godot/resources/devices/`: current `.tres` DAY 1 device definitions and gameplay tuning data.

## Needed Art Assets

- Room background
- Wall/floor overlay
- Bed
- Desk
- Laptop
- Desk lamp
- Fan
- Charger / phone
- Communication device
- Multitap / power strip
- Cable segments
- Door
- Window
- Yui player sprite
- Yui portrait
- UI icons
- UI panel skins
- Font files

## Recommended File Formats

- General objects and backgrounds: `.png` or `.webp`
- Transparent-background objects: `.png`
- UI icons: `.png`, or `.svg` only after confirming Godot import behavior for the target version
- Fonts: `.ttf` or `.otf`
- Godot scenes: `.tscn`
- Godot data resources: `.tres`

## Replacement Targets

- Current `Apartment.gd` uses `room_floor_base.png` and `room_wall_base.png` as underlay art while preserving existing collision and primitive furniture.
- `ApartmentInteractable` now maps key DAY 1 objects to P0 PNG state textures through `AssetPaths.gd`.
- 쿼터뷰 전환용 아트는 `docs/QUARTERVIEW_ART_ASSET_PLAN.md`를 기준으로 별도 관리한다. 쿼터뷰 방은 한 장 배경보다 room layer, atlas, spritesheet, visual mapping Resource 후보를 우선 검토한다.
- Quarterview room shell layers will use a same-canvas `1920x1080` PNG workflow. Detailed layer, path, z-index, and import planning is documented in `docs/QUARTERVIEW_ROOM_SHELL_LAYER_PLAN.md`.
- Quarterview furniture will use an atlas + region mapping workflow. Detailed mapping criteria are documented in `docs/QV_FURNITURE_ATLAS_REGION_MAPPING.md`.
- Quarterview appliances will use a separate atlas + region mapping workflow from furniture and work devices. Detailed mapping criteria are documented in `docs/QV_APPLIANCES_ATLAS_REGION_MAPPING.md`.
- Quarterview work / hacking devices will use a separate atlas + region mapping workflow from furniture, appliances, and cables. Detailed mapping criteria are documented in `docs/QV_WORK_DEVICES_ATLAS_REGION_MAPPING.md`.
- Quarterview localized FX will use a separate `qv_fx_atlas.png` mapping workflow from device bodies, appliances, furniture, cable sprites, and full-room lighting overlays. Detailed mapping criteria are documented in `docs/QV_FX_ATLAS_REGION_MAPPING.md`.
- `qv_props_atlas.png` and `qv_cable_atlas.png` are intentionally deferred detail / polish atlases. They should not block room shell, Yui, furniture, appliance, work device, or FX pipeline validation; backlog criteria are documented in `docs/QV_PROPS_AND_CABLE_ATLAS_BACKLOG.md`.
- Hacking arena tiles will use a separate `hack_arena_tiles_atlas.png` mapping workflow from quarterview room assets and localized room FX. Detailed mapping criteria are documented in `docs/HACK_ARENA_TILES_ATLAS_REGION_MAPPING.md`.
- Hacking avatar spritesheets will use a transparent PNG 4-direction workflow, separate from Yui quarterview room sprites and hacking arena tiles. Detailed criteria are documented in `docs/HACK_AVATAR_SPRITESHEET_IMPORT_GUIDE.md`.
- Hacking enemies will use a separate `hack_enemies_atlas.png` mapping workflow from player avatar, projectiles, FX, and arena tiles. Detailed mapping criteria are documented in `docs/HACK_ENEMIES_ATLAS_REGION_MAPPING.md`.
- Hacking interactable / objective objects will use a separate `hack_objects_atlas.png` mapping workflow from arena tiles, enemies, avatar, projectiles, and FX. Detailed mapping criteria are documented in `docs/HACK_OBJECTS_ATLAS_REGION_MAPPING.md`.
- Window city view PNGs require same-canvas export and should keep wall frames and interior lighting separate from the city-view layer; criteria are documented in `docs/QUARTERVIEW_WINDOW_CITY_VIEW_GUIDE.md`.
- Foreground occluder PNGs require transparent same-canvas exports and alpha edge cleanup before Godot import; criteria are documented in `docs/QUARTERVIEW_FOREGROUND_OCCLUDER_GUIDE.md`.
- Static lighting overlays require same-canvas transparent exports. Shadow / glow may need separate overlay files if one blend mode is not enough; criteria are documented in `docs/QUARTERVIEW_STATIC_LIGHTING_OVERLAY_GUIDE.md`.
- Yui quarterview character spritesheets will use a transparent PNG spritesheet workflow with fixed 4-direction row order and foot-anchor alignment. Detailed criteria are documented in `docs/YUI_QV_SPRITESHEET_IMPORT_GUIDE.md`.
- Bed, desk, window, door, shelf, fan, multitap, charger/phone, and communication device should remain separate replaceable objects rather than one flattened background image.
- Cable visuals should become modular cable segment sprites or Line2D-based scenes so connected/off states can update dynamically.
- The Yui portrait placeholder in `InteractionPanel.tscn` is filled at runtime with `godot/assets/art/portraits/yui/yui_portrait_neutral.png`.
- HUD and multitap power/plug icons are loaded from `godot/assets/art/ui/icons/`.
- Interaction and dialogue panel art is used as low-alpha TextureRect backplates so text remains readable.
- DAY 1 device name, load, slot count, hourly drain, and Result flag live in `.tres` resources under `godot/resources/devices/`.
- Adapter textures, connected offsets, and scale tuning remain separate from gameplay Resources and are not part of this data move.

## P0 Applied Assets

- Yui player: `godot/assets/art/characters/yui/yui_player_idle_back.png`
- Yui directional animation: idle/walk PNGs under `godot/assets/art/characters/yui/idle/` and `godot/assets/art/characters/yui/walk/`
- Yui portrait: `godot/assets/art/portraits/yui/yui_portrait_neutral.png`
- Room underlay: `godot/assets/art/environment/room/room_floor_base.png`, `godot/assets/art/environment/room/room_wall_base.png`
- Fluorescent room light: `fluorescent_light_off.png`, `fluorescent_light_on.png`, `fluorescent_glow.png`
- DAY 1 objects: laptop, fan, phone/charger, communication device, and power strip PNG state variants
- Multitap UI: outlet slot, plug, connected/disconnected badge, and plug icon PNGs
- UI: dialogue panel, interaction panel, and power icon PNGs

## Suggested Object Sizes

These are starting points for the current 1280x720 MVP layout and should be adjusted after import tests.

- Room background: `930x586` or larger source art scaled to the current room rect
- Bed: about `180x115`
- Desk: about `210x80`
- Laptop: about `120x70`
- Fluorescent room light: about `140x60`, positioned near the room ceiling/top wall rather than on the desk
- Fan: about `80x95`
- Charger / phone: about `75x45`
- Communication device: about `120x75`
- Multitap / power strip: about `150x45`
- Yui player sprite: about `48x64`
- Yui directional source sprites: currently `1024x1536`, scaled in `Player.tscn` to about the previous `48x64` footprint
- Yui portrait: about `128x128` minimum
- UI icons: `32x32` and `64x64` source variants

## State Variants

Assets that need state variants:

- Laptop: disconnected, connected, used/on
- Desk lamp: disconnected, connected/off, on
- Fan: disconnected, connected/off, on
- Charger / phone: disconnected, connected, charged/used
- Communication device: disconnected, connected, signal/used
- Multitap: empty, partially occupied, full
- Cable segments: inactive/dim and active/electric
- Yui player: `idle_down`, `idle_up`, `idle_left`, `idle_right`, `walk_down`, `walk_up`, `walk_left`, `walk_right`

Current phone mapping:

- `phone_normal.png`: default phone state
- `phone_recharge.png`: low-power / needs charge state
- `phone_charging.png`: connected to the multitap but not yet used
- `phone_charged.png`: charger action used today

## Rules And Warnings

- Do not use external copyrighted assets without permission.
- Track installed Asset Library packages and license evidence in `docs/THIRD_PARTY_ASSET_INVENTORY.md` before wiring them into scenes or UI.
- Track Git LFS adoption criteria and large-asset handling in `docs/GIT_LFS_ASSET_POLICY.md`; do not run `git lfs track` or modify `.gitattributes` outside a dedicated LFS task.
- Do not import the concept images directly as the game background.
- Avoid solving the whole room as one flat image; keep objects replaceable so power and connection states can change visually.
- Do not commit Godot import cache folders or local editor cache output.
- Godot `.uid` files should be committed when they correspond to real tracked resources.
- Keep the playable DAY 1 loop readable before doing high-detail art polish.
