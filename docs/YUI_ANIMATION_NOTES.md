# Yui Animation Notes

## Yui Character Animation Pass 1

This pass replaces the single Yui player draw call with directional idle/walk sprite animations. It does not change movement, collision, proximity interaction, power logic, multitap logic, or End Day flow.

## Yui Sprite Sheet Specification Pass

This pass uses `docs/reference/YUI Sprite Sheet.png` as the implementation specification for in-game scale and animation behavior. It keeps player movement and interaction logic unchanged.

## Direct YUI Source Sheet Pass

This pass uses `docs/reference/YUI.png` as the player sprite source. It preserves movement, collision, proximity interaction, power logic, multitap logic, and End Day flow.

## Applied Idle PNGs

- `godot/assets/art/characters/yui/idle/yui_idle_down.png`
- `godot/assets/art/characters/yui/idle/yui_idle_up.png`
- `godot/assets/art/characters/yui/idle/yui_idle_left.png`
- `godot/assets/art/characters/yui/idle/yui_idle_right.png`

## Applied Walk PNGs

- `godot/assets/art/characters/yui/yui_source_sheet.png`
- `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`
- `godot/assets/art/characters/yui/walk/yui_walk_down_01.png`
- `godot/assets/art/characters/yui/walk/yui_walk_down_02.png`
- `godot/assets/art/characters/yui/walk/yui_walk_up_01.png`
- `godot/assets/art/characters/yui/walk/yui_walk_up_02.png`
- `godot/assets/art/characters/yui/walk/yui_walk_left_01.png`
- `godot/assets/art/characters/yui/walk/yui_walk_left_02.png`
- `godot/assets/art/characters/yui/walk/yui_walk_right_01.png`
- `godot/assets/art/characters/yui/walk/yui_walk_right_02.png`

## Fallback Rule

- `godot/assets/art/characters/yui/yui_player_idle_back.png` remains tracked as the emergency fallback texture.
- `Player.gd` uses `AssetPaths.load_texture_or_fallback()` so missing directional/walk files can fall back to an idle texture or the old single back-idle texture.
- `yui_walk_4dir_rgba.png` is now the active player sprite sheet. Older directional walk PNG paths remain in `AssetPaths.gd` as legacy/fallback references.

## Animation Names

- `idle_down`
- `idle_up`
- `idle_left`
- `idle_right`
- `walk_down`
- `walk_up`
- `walk_left`
- `walk_right`

## Runtime Behavior

- Movement input and collision still live on the existing `Player` `CharacterBody2D`.
- The new `AnimatedSprite2D` child named `Visual` handles only the character image.
- Direction uses the stronger axis from the current movement vector.
- When Yui stops, the animation returns to the idle animation matching the last facing direction.
- `Player.gd` builds `SpriteFrames` from `yui_walk_4dir_rgba.png` using `AtlasTexture` regions.
- Sheet layout:
  - Row 1: `walk_down`
  - Row 2: `walk_left`
  - Row 3: `walk_right`
  - Row 4: `walk_up`
- Idle animations use the first frame from each row.

## Scale And Pivot

- Original source sheet: `1254x1254`, no alpha.
- Processed sheet: `256x256`, RGBA.
- Frame size: `64x64`.
- `Visual` scale: default `Vector2(1, 1)`.
- `Visual` position: `Vector2(0, -32)`.
- Collision radius: `11`.
- Interaction radius: `54`.
- This keeps Yui smaller against the rebuilt apartment layout and places the origin near the feet so collision and interaction detection stay stable.

## Animation Speed

- Walk animation speed: `7.5 fps`.
- Walk cycle: 4 frames per direction, targeting the reference note's roughly `120-150ms` frame timing.
- Idle animations use one frame.

## Current Issues

- The processed YUI sheet uses the actual source image, but the transparent background removal and per-frame alignment should be reviewed in Godot.
- The current pivot/scale should be checked in the room against furniture and prompts.
- No 8-direction animation exists; diagonal movement intentionally resolves to the stronger cardinal axis.

## Processing Script

- `tools/process_yui_sprite_sheet.py`
- Removes the baked bright checkerboard background from `yui_source_sheet.png`.
- Normalizes all 16 frames to `64x64`.
- Preserves the original source character art instead of redrawing or replacing Yui.
