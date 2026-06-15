# Yui Animation Notes

## Yui Character Animation Pass 1

This pass replaces the single Yui player draw call with directional idle/walk sprite animations. It does not change movement, collision, proximity interaction, power logic, multitap logic, or End Day flow.

## Yui Sprite Sheet Specification Pass

This pass uses `docs/reference/YUI Sprite Sheet.png` as the implementation specification for in-game scale and animation behavior. It keeps player movement and interaction logic unchanged.

## Direct YUI Source Sheet Pass

This pass uses `docs/reference/YUI.png` as the player sprite source. It preserves movement, collision, proximity interaction, power logic, multitap logic, and End Day flow.

## YUI Scale And Fringe Cleanup Pass

This pass updates only the active Yui sprite sheet cleanup and visual display size. It preserves movement, collision, proximity interaction, power logic, map layout, UI panels, multitap logic, and End Day flow.

## YUI-1 Replacement Pass

This pass replaces the active player sprite source with `docs/reference/yui-1.png`. It preserves movement, collision, proximity interaction, power logic, map layout, UI panels, multitap logic, and End Day flow.

## YUI Direction Alignment Cleanup Pass

This pass regenerates the active `yui-1` walk sheet to fix directional alignment only. It preserves movement, collision, proximity interaction, power logic, map layout, UI panels, multitap logic, runtime display scale, and End Day flow.

## YUI Up Headroom Cleanup Pass

This pass repairs only the up/back-facing row headroom in the generated active `yui-1` walk sheet. It preserves movement, collision, proximity interaction, power logic, map layout, UI panels, multitap logic, runtime display scale, and the front/left/right frame pixels.

## Applied Idle PNGs

- `godot/assets/art/characters/yui/idle/yui_idle_down.png`
- `godot/assets/art/characters/yui/idle/yui_idle_up.png`
- `godot/assets/art/characters/yui/idle/yui_idle_left.png`
- `godot/assets/art/characters/yui/idle/yui_idle_right.png`

## Applied Walk PNGs

- `godot/assets/art/characters/yui/yui_1_source_sheet.png`
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
- `yui_walk_4dir_rgba.png` is now the active player sprite sheet and is generated from `docs/reference/yui-1.png`.
- Older directional walk PNG paths remain in `AssetPaths.gd` as legacy/fallback references.

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

- Original active source sheet: `docs/reference/yui-1.png`, `1254x1254`, RGBA.
- Godot source copy: `godot/assets/art/characters/yui/yui_1_source_sheet.png`.
- Processed sheet: `384x384`, RGBA.
- Frame size: `96x96`.
- Source character fit height inside each frame: `78px`.
- Shared foot baseline inside each frame: `y = 90`.
- `Visual` scale: `Vector2(1.45, 1.45)`.
- `Visual` position: `Vector2(0, -61)`.
- `Visual` texture filter: nearest.
- Collision radius: `11`.
- Interaction radius: `54`.
- This makes Yui read much larger in the room while keeping the origin near the feet so collision and interaction detection stay stable.

## Animation Speed

- Walk animation speed: `7.5 fps`.
- Walk cycle: 4 frames per direction, targeting the reference note's roughly `120-150ms` frame timing.
- Idle animations use one frame.

## Current Issues

- The processed YUI sheet uses `docs/reference/yui-1.png`, not the older `docs/reference/YUI.png` checkerboard source.
- Runtime screenshot saved at `docs/validation/yui_1_runtime_screenshot00000000.png`.
- Directional runtime screenshots saved at:
  - `docs/validation/yui_direction_front.png`
  - `docs/validation/yui_direction_back.png`
  - `docs/validation/yui_direction_left.png`
  - `docs/validation/yui_direction_right.png`
- Up-direction headroom screenshots saved at:
  - `docs/validation/yui_up_idle_headroom.png`
  - `docs/validation/yui_up_walk_headroom.png`
- Automated frame inspection confirms all 16 generated frames use visible height `78`, bottom baseline `89`, and center x near `48`.
- Automated pixel comparison confirms front, left, and right rows are unchanged from the previous committed sheet; only the up/back-facing row changed.
- Manual movement input should still be checked in-editor for all four directions because the automated screenshots force idle direction animations.
- No 8-direction animation exists; diagonal movement intentionally resolves to the stronger cardinal axis.

## Processing Script

- `tools/process_yui_sprite_sheet.py`
- Copies `docs/reference/yui-1.png` to `godot/assets/art/characters/yui/yui_1_source_sheet.png`.
- Removes very low-alpha source noise from `yui-1`.
- Normalizes all 16 frames to `96x96`.
- Aligns every frame to the same centered x position and foot baseline.
- Preserves crop padding around hair, lower body, and shoes so the back-facing head and feet do not clip.
- Mirrors the left-facing source row for the right-facing row because the source right row has inconsistent crop extent and made that direction appear smaller.
- Repairs only the back-facing head top with a small dark-pixel cap so the top of the head no longer appears cut flat.
- Preserves the original source character art instead of redrawing or replacing Yui.
