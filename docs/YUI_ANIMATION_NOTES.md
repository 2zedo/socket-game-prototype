# Yui Animation Notes

## Yui Character Animation Pass 1

This pass replaces the single Yui player draw call with directional idle/walk sprite animations. It does not change movement, collision, proximity interaction, power logic, multitap logic, or End Day flow.

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

## Scale And Pivot

- Source PNG size: `1024x1536`.
- `Visual` scale: `0.045`.
- `Visual` position: `Vector2(0, -34)`.
- This keeps Yui close to the previous `48x64` screen footprint and places the origin near the feet so collision and interaction detection stay stable.

## Animation Speed

- Walk animation speed: `5 fps`.
- Idle animations use one frame.

## Current Issues

- Walk frames are temporary and may need replacement or timing adjustment after Godot editor review.
- The current pivot/scale should be checked in the room against furniture and prompts.
- No 8-direction animation exists; diagonal movement intentionally resolves to the stronger cardinal axis.
