# Hack Avatar Spritesheet Import Guide

## Purpose

This document defines future import criteria for the hacking mission player avatar spritesheets.

The hacking avatar is separate from Yui's quarterview room sprite. It represents Yui's cyber-space avatar, cursor, or infiltration form inside hacking missions. This task does not add PNG files, does not create `SpriteFrames`, does not create a `CharacterBody2D` scene, and does not change `HackingActionPrototype`, `HackingPerspectiveBlockout`, Main, or DAY 1.

## Target Files

Required candidate files:

```text
hack_avatar_idle_4dir.png
hack_avatar_walk_4dir.png
```

Deferred candidate files:

```text
hack_avatar_dash_4dir.png
hack_avatar_hurt_4dir.png
hack_avatar_interact_4dir.png
hack_avatar_extract_4dir.png
hack_avatar_down_4dir.png
```

Expected future asset paths:

```text
res://assets/hacking/avatar/hack_avatar_idle_4dir.png
res://assets/hacking/avatar/hack_avatar_walk_4dir.png
```

Deferred path candidates:

```text
res://assets/hacking/avatar/hack_avatar_dash_4dir.png
res://assets/hacking/avatar/hack_avatar_hurt_4dir.png
res://assets/hacking/avatar/hack_avatar_interact_4dir.png
```

Source / reference candidates:

```text
res://assets/hacking/avatar/source/
res://assets/hacking/avatar/reference/
```

Do not create these folders or PNG files during this documentation pass.

## Avatar Role

`hack_avatar` is the player-controlled visual inside hacking mission space.

Role:

- Yui's playable representation in cyber space.
- A cyber avatar / cursor / intruder candidate rather than her physical body.
- A movement, dodge, hurt, and interaction animation target for `3/4 top-down` hacking action.
- A future visual candidate for `HackingPrototypePlayer`.

Not role:

- room Yui living sprite
- Main / DAY 1 player sprite
- enemy sprite
- projectile sprite
- hit / damage FX
- UI cursor
- fantasy dungeon hero

The hacking avatar should not read as a fantasy warrior. It should read as cyber infiltration, data avatar, or a simplified hacking-mode version of Yui.

## Style Direction

- Hacking missions are cyber / network arenas, not fantasy dungeons.
- `hack_avatar` should feel connected to Yui without being the same room-life sprite.
- Dark hoodie, compact silhouette, data-line accents, and light cyber details are candidates.
- Avoid armor, swords, wizard robes, class-job fantasy language, or heroic dungeon-adventurer styling.
- The viewpoint target is `3/4 top-down`, not pure crown-view top-down.
- Direction and state must remain readable at small gameplay scale.
- The avatar should be easy to track against cyber floor / grid / hazard tiles.

## Four-Direction Row Order

Use the same row order as the Yui quarterview spritesheet guide.

| Direction key | Meaning | Row |
| --- | --- | ---: |
| `down` | front-facing / toward camera | `0` |
| `up` | back-facing / away from camera | `1` |
| `left` | moving / standing left | `2` |
| `right` | moving / standing right | `3` |

If an existing temporary hacking player asset uses a different order, do not change it in this task. Final import sheets should follow this order.

## Basic Spritesheet Criteria

Format criteria:

- PNG
- RGBA / transparent background
- same character scale across all directions
- same cell size across all frames
- no background
- no UI label / text inside the sprite
- no strong room shadow baked into the character
- no arena tile baked into the character
- no projectile / weapon FX baked into base movement frames
- all frames aligned by foot anchor or avatar center anchor

Visual criteria:

- supports `3/4 top-down` hacking arena readability
- clearly separates down, up, left, and right
- keeps silhouette readable over cyber floor / grid tiles
- keeps scale stable between idle, walk, dash, hurt, and interact candidates

## Frame Layout

### `hack_avatar_idle_4dir.png`

Candidate criteria:

- 4 rows
- 1-2 frames per direction
- row order: down, up, left, right
- same cell width / cell height
- future animations: `idle_down`, `idle_up`, `idle_left`, `idle_right`

MVP criteria:

- 1 frame per direction is allowed.
- 2 frames per direction is preferred if subtle data flicker or breathing is useful.

### `hack_avatar_walk_4dir.png`

Candidate criteria:

- 4 rows
- minimum 2 frames per direction
- preferred 4 frames per direction
- row order: down, up, left, right
- same cell width / cell height
- future animations: `walk_down`, `walk_up`, `walk_left`, `walk_right`

MVP criteria:

- 2 frames per direction are acceptable.
- 4+ frames can be considered after movement feel is validated.

### `hack_avatar_dash_4dir.png`

Deferred candidate:

- 4 rows
- 1-3 frames per direction
- future animations: `dash_down`, `dash_up`, `dash_left`, `dash_right`
- final use depends on whether hacking movement uses dash, roll, or hop feedback

### `hack_avatar_hurt_4dir.png`

Deferred candidate:

- 4 rows or 1 universal row
- future animations: `hurt_down`, `hurt_up`, `hurt_left`, `hurt_right`
- if directional hurt is too expensive, a common hurt animation is acceptable

Sheet size formula:

```text
sheet_width = cell_width * frames_per_direction
sheet_height = cell_height * 4
```

Example:

```text
96x128 cell, 4 frames per direction:
sheet = 384x512
```

Actual cell size is not locked in this task.

## Cell Size, Pivot, And Anchor

### Cell Size

- Every frame uses the same `cell_width` / `cell_height`.
- Idle and walk should use the same cell size when possible.
- Dash / hurt should also keep the same cell size if possible.
- Keep avatar placement stable against the chosen anchor.
- Add enough transparent padding so hood, arms, and cyber accents are not clipped.

### Pivot / Anchor

Candidate A: bottom-center foot anchor

- `CharacterBody2D.position` represents the feet / bottom center.
- Natural for a humanoid `3/4` avatar.
- Easier to reason about overlap with arena obstacles.

Candidate B: center anchor

- Useful if the avatar is more abstract / cursor-like.
- Easier to match projectile origin, dash vector, and collision radius.

Current recommendation:

- Use bottom-center if the avatar is humanoid.
- Use center if the avatar becomes an abstract cyber cursor.
- Start with bottom-center, then adjust after `HackingPerspectiveBlockout` scale checks.

Future Godot structure candidate:

```text
HackAvatarPlayer
  CharacterBody2D
    VisualRoot
      AnimatedSprite2D
      ShadowOrGlowSprite
    CollisionShape2D
    Hurtbox
    InteractionAnchor
    DebugAnchorLayer
```

This task does not create these nodes.

## Godot Import Setting Candidates

Candidate import settings:

```text
Texture type: 2D Texture
Compression: Lossless
Mipmaps: Off
Repeat: Disabled
Filter:
  - Nearest candidate for pixel / low-res sprite
  - Linear candidate for painterly / soft sprite
Fix Alpha Border: On candidate
Premultiplied Alpha: Off candidate
Detect 3D: Off
```

Notes:

- Do not create or edit `.import` files in this task.
- Import settings are finalized only after actual assets exist.
- If transparent edge halo appears, review alpha cleanup and Fix Alpha Border.
- Filter policy should match `hack_arena_tiles_atlas.png`, enemy sprites, projectile sprites, and hacking FX.

## Animation Naming

Required animation names:

```text
idle_down
idle_up
idle_left
idle_right
walk_down
walk_up
walk_left
walk_right
```

Deferred animation names:

```text
dash_down
dash_up
dash_left
dash_right
hurt_down
hurt_up
hurt_left
hurt_right
interact_down
interact_up
interact_left
interact_right
extract_down
extract_up
extract_left
extract_right
downed
success
fail
```

This document does not create a `SpriteFrames` Resource.

## Relationship To HackingActionPrototype

`HackingActionPrototype` is the current control, state, and feedback prototype. `hack_avatar` spritesheets are future visual candidates for replacing or extending the current placeholder `HackingPrototypePlayer` visual.

Not done in this task:

- no `HackingPrototypePlayer.gd` edit
- no `HackingActionPrototype.tscn` edit
- no player visual replacement
- no dash / roll / hop animation wiring
- no hurt animation wiring
- no mission result wiring

Future connection candidate:

```text
HackingPrototypePlayer movement direction
-> AnimatedSprite2D animation selection
-> idle / walk / dash / hurt animations
-> HackingActionPrototype state feedback
```

## Relationship To HackingPerspectiveBlockout

`HackingPerspectiveBlockout` is the visual blockout for hacking viewpoint and scale. `hack_avatar` should be checked there before replacing the gameplay prototype visual.

Check:

- avatar remains readable over arena tiles
- down / up / left / right directions are clear
- obstacle / wall scale feels correct
- avatar is distinct from projectile and enemy visuals
- avatar does not look exactly like room Yui
- avatar does not read like a fantasy character

## Relationship To Hack Arena Tiles

- `hack_avatar` renders above `hack_arena_tiles_atlas.png` tile bodies.
- Tile size and avatar cell size should be checked together.
- If default tile size is `96x96`, avatar cells may start from `96x128` or `128x160` candidates.
- Actual cell size depends on tile size, camera zoom, projectile readability, and enemy readability.
- Avatar collision can be smaller than the visual sprite.
- Arena walls / obstacles should not hide the avatar too much.

Layer candidates:

| Layer | z-index |
| --- | ---: |
| `ArenaFloorLayer` | `0` |
| `ArenaFloorFxLayer` | `5` |
| `ArenaWallLayer` | `10` |
| `ArenaObstacleLayer` | `20` |
| `ArenaHazardLayer` | `25` |
| `ArenaObjectiveLayer` | `30` |
| `EnemyLayer` | `40` |
| `PlayerLayer` | `45` |
| `ProjectileLayer` | `50` |
| `HitFxLayer` | `60` |
| `ArenaOverlayFxLayer` | `70` |
| `DebugLayer` | `100` |
| `UILayer` | `1000` |

## Enemy / Projectile / FX Split

`hack_avatar` spritesheets include:

- avatar body idle
- avatar body walk
- avatar body dash / hurt / interact candidates

`hack_avatar` spritesheets exclude:

- enemy sprite
- projectile sprite
- hit slash / impact FX
- trace warning FX
- extraction beam
- data scan line
- full-screen glitch
- UI cursor
- arena tile
- room Yui quarterview sprite

Other asset candidates:

```text
hack_enemies_atlas.png
hack_projectile_atlas.png
hack_fx_atlas.png
hack_arena_tiles_atlas.png
```

Do not bake too much attack / hit / state FX into body animation. Movement sprites, attack visuals, projectiles, and FX should remain separable.

`hack_avatar` silhouettes should remain visually distinct from enemies defined through `hack_enemies_atlas.png`.

## Collision And Gameplay Separation

- `hack_avatar` spritesheets are visual assets.
- Actual collision is owned by `HackingPrototypePlayer` or a future player controller.
- Visual cell size and collision size can differ.
- Hurtbox / hitbox can be separate `Area2D` nodes.
- Dash / roll / hop gameplay should not be locked 1:1 to animation frames.
- Animation is feedback; state machine and gameplay judgment stay in script.

## Pre-Application Checklist

- [ ] PNG uses transparent background.
- [ ] Row order is down / up / left / right.
- [ ] Frame count matches the chosen sheet criteria.
- [ ] Every frame has the same cell size.
- [ ] Anchor does not jitter across frames.
- [ ] Idle / walk / dash / hurt avatar scale is consistent.
- [ ] Down / up / left / right remain readable in cyber arena perspective.
- [ ] Up / back direction reads as a `3/4` back view, not pure crown view.
- [ ] Alpha edge halo is absent.
- [ ] Avatar position does not pop between frames.
- [ ] Avatar is not too large or too small over hack arena tiles.
- [ ] Avatar is distinct from enemies, projectiles, and FX.
- [ ] Avatar does not look like a fantasy dungeon hero.
- [ ] Avatar relates to room Yui but has a distinct hacking-mode role.

## Future Application Order

1. Prepare final `hack_avatar_idle_4dir.png` / `hack_avatar_walk_4dir.png` assets.
2. Add PNGs to the expected asset path.
3. Check import settings.
4. Create `SpriteFrames` Resource.
5. Create `HackAvatarPlayer` visual prototype.
6. Connect idle / walk animation names.
7. Tune pivot / anchor.
8. Check scale / readability in `HackingPerspectiveBlockout`.
9. Review replacing `HackingActionPrototype` player visual.
10. Review dash / hurt / interact animation additions.

## Non-Goals

- Do not add PNG assets.
- Do not create `SpriteFrames`.
- Do not create `HackAvatarPlayer` scene.
- Do not change `HackingActionPrototype`.
- Do not change `HackingPrototypePlayer.gd`.
- Do not change `HackingPerspectiveBlockout`.
- Do not edit collision, hurtbox, hitbox, or gameplay state.
- Do not wire avatar animation to mission result, Grid Credit, Main, or DAY 1.
