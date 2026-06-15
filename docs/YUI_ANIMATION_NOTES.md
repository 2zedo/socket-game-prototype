# Yui Animation Notes

## Yui Character Animation Pass 1

This pass replaces the single Yui player draw call with directional idle/walk sprite animations. It does not change movement, collision, proximity interaction, power logic, multitap logic, or End Day flow.

## Yui Sprite Sheet Specification Pass

This pass uses `docs/reference/YUI Sprite Sheet.png` as the implementation specification for in-game scale and animation behavior. It keeps player movement and interaction logic unchanged.

## Applied Idle PNGs

- `godot/assets/art/characters/yui/idle/yui_idle_down.png`
- `godot/assets/art/characters/yui/idle/yui_idle_up.png`
- `godot/assets/art/characters/yui/idle/yui_idle_left.png`
- `godot/assets/art/characters/yui/idle/yui_idle_right.png`

## Applied Walk PNGs

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
- Walk files are temporary; later PNG replacement should keep the same filenames or update `AssetPaths.gd`.

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
- The current in-game Yui sprite is generated at runtime as a 32x48 pixel-style texture so the silhouette reads closer to the reference sheet than the previous full-body illustration PNGs.
- The generated sprite keeps black hair, dark hoodie, light inner shirt, dark pants, boots, side bag/patch detail, front/side/back facing differences, and a foot-centered pivot.

## Scale And Pivot

- Source PNG size: `1024x1536`.
- Runtime generated sprite size: `32x48`.
- `Visual` scale: `1.35`.
- `Visual` position: `Vector2(0, -31)`.
- Collision radius: `11`.
- Interaction radius: `54`.
- This keeps Yui smaller against the rebuilt apartment layout and places the origin near the feet so collision and interaction detection stay stable.

## Animation Speed

- Walk animation speed: `7.5 fps`.
- Walk cycle: 4 generated frames per direction, targeting the reference note's roughly `120-150ms` frame timing.
- Idle animations use one frame.

## Current Issues

- The generated pixel sprites are implementation placeholders based on the sheet proportions; hand-authored final sprite art should eventually replace them.
- The current pivot/scale should be checked in the room against furniture and prompts.
- No 8-direction animation exists; diagonal movement intentionally resolves to the stronger cardinal axis.
