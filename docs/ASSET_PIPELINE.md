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
- `godot/data/devices/`: future `.tres` device definitions and tuning data.

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

- Current `Apartment.gd` primitive drawing should later be split into a room background plus separate object sprites.
- Bed, desk, window, door, shelf, fan, multitap, charger/phone, and communication device should remain separate replaceable objects rather than one flattened background image.
- Cable visuals should become modular cable segment sprites or Line2D-based scenes so connected/off states can update dynamically.
- The Yui portrait placeholder in `InteractionPanel.tscn` should be replaced with a portrait texture under `godot/assets/art/portraits/`.
- HUD, interaction, multitap, and result icons should come from `godot/assets/ui/icons/`.
- Panel backgrounds and decorative frames should come from `godot/assets/ui/panels/` or a shared Theme under `godot/themes/`.
- Device tuning currently in `SurvivalState.gd` should later move into `.tres` resources under `godot/data/devices/`.

## Suggested Object Sizes

These are starting points for the current 1280x720 MVP layout and should be adjusted after import tests.

- Room background: `930x586` or larger source art scaled to the current room rect
- Bed: about `180x115`
- Desk: about `210x80`
- Laptop: about `120x70`
- Desk lamp: about `64x80`
- Fan: about `80x95`
- Charger / phone: about `75x45`
- Communication device: about `120x75`
- Multitap / power strip: about `150x45`
- Yui player sprite: about `48x64`
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

## Rules And Warnings

- Do not use external copyrighted assets without permission.
- Do not import the concept images directly as the game background.
- Avoid solving the whole room as one flat image; keep objects replaceable so power and connection states can change visually.
- Do not commit Godot import cache folders or local editor cache output.
- Godot `.uid` files should be committed when they correspond to real tracked resources.
- Keep the playable DAY 1 loop readable before doing high-detail art polish.
