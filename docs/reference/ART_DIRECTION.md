# Art Direction Reference

## Role

This is the current reference for room image generation, visual scale, atlas policy, and temporary art boundaries.

## Core Visual Identity

CONCENT's room art should read as tidy lower-grid housing under resource pressure.

Use:

- light gray-white floors
- worn industrial panels
- gunmetal / charcoal frames
- limited warm white lighting
- small cyan / electric accents
- compact appliances
- practical devices
- organized cable / module systems

Avoid:

- wood floor as default
- American motel tones
- luxury hotel / penthouse furniture
- villain lab
- factory floor
- clutter spam
- wide open skyline

## Fixed Room Image Spec

The next room image generation baseline:

| Item | Rule |
| --- | --- |
| Output | `1920x1080` |
| Camera | quarterview / cutaway room, not too top-down |
| Room count | 2 connected rooms |
| Room 1 | larger living space |
| Room 2 | smaller work + power space |
| Character height | `150-165px` |
| Character width | `65-80px` |

Character scale rules:

- Yui is the scale anchor.
- Character height is about `0.55-0.62x` of bed length.
- Character must be clearly taller than refrigerator.
- Character must not look smaller than microwave.

## Living Space Image Rules

Living space is larger and slightly rectangular.

Required:

- entrance door
- bed
- small kitchen: sink, refrigerator, microwave
- two-person dining table
- two chairs
- small cabinet / shelf
- living light / indirect light
- a few small personal objects

Layout:

- entrance: lower-left / left-lower wall
- bed: top or upper-left, away from entrance
- kitchen: upper-right
- dining table: center to mid-right
- partition: between entrance/kitchen and bed zone

Visible floor target:

- width `1180-1280px`
- depth `680-760px`

Object target sizes:

| Object | Size |
| --- | ---: |
| Bed | `270-320w / 150-190h` |
| Bedside table | `55-75w / 45-60h` |
| Refrigerator | `95-120w / 150-190h` |
| Microwave | `60-85w / 40-55h` |
| Sink block | `180-240w / 80-110h` |
| Dining table | `150-200w / 90-120h` |
| Dining chair | `45-60w / 70-90h` |
| Partition | `180-260w / 100-160h` |

Living space bans:

- low living-room table
- heavy hacking equipment
- large communication equipment
- factory power equipment
- UPS / battery / tool piles

## Work + Power Space Image Rules

Work space is smaller and slightly rectangular.

Required:

- internal connecting door
- NAVI LINK setting device
- one small communication set
- wall-mounted power control panel
- organized cable / signal distribution
- small auxiliary work surface
- a few wall notes / panels

Layout:

- door from living space: left wall, middle-upper
- NAVI LINK device: right or upper-right
- power control panel: upper-left to top wall
- movement path: center to lower area
- communication equipment: right / top wall portions

Visible floor target:

- width `980-1100px`
- depth `600-680px`

Object target sizes:

| Object | Size |
| --- | ---: |
| NAVI LINK full unit | `260-340w / 220-300h` |
| Power control panel | `140-220w / 120-180h` |
| Small communication rack | `90-140w / 120-190h` |
| Signal adjustment console | `110-170w / 70-110h` |
| Wall memo / panel | `80-140w / 60-100h` |

Work space bans:

- window
- laptop-centered setup
- generic office desk
- many monitors
- factory-scale panel
- villain laboratory
- dental-chair silhouette
- tool storage / battery pile mood

## Door Rules

The two rooms must connect logically:

```text
Living space right-wall middle-upper door
-> Work space left-wall middle-upper door
```

Rules:

- entrance door belongs to living space lower-left / left-lower wall.
- connecting doors need clear walking space.
- no window next to connecting door.
- no "door opens into outside view" contradiction.

## Window Rules

Living space:

- window allowed.
- view should show nearby structures, pipes, signs, close city layers.
- lower-grid constrained view.

Work space:

- no window.

Ban:

- penthouse skyline
- wide open night view

## NAVI LINK Visual Rules

NAVI LINK replaces laptop / monitor-centered hacking as the future entry image.

It should look like:

- near-future personal neural connection device
- expensive but old
- carefully maintained
- seated functional interface

It should not look like:

- dental chair
- villain experiment device
- gaming desk
- three-monitor hacker station

## Room Shell / Layer Policy

Room shell images are not atlases. They are same-canvas transparent layers.

Common candidates:

- floor base
- back wall
- side wall
- foreground occluders
- window city view
- static lighting overlay

Rules:

- same canvas size and origin
- same camera angle
- transparent PNG
- no characters, UI, text, or labels
- requested layer only

## Atlas Policy

Most atlas mapping docs are archived as historical planning. Current rule:

- Do not create a new atlas unless explicitly requested.
- Small devices and UI parts can use atlas regions.
- Room shell layers are not atlases.
- Collision / interaction data must stay separate from image alpha.
- Generated art remains temporary until approved and wired.

Current temporary generated assets include:

- Yui quarterview idle / walk spritesheets.
- Work devices atlas candidate.
- UI phone atlas candidate.
- UI power board atlas candidate.

## Prompt Core

Use this short baseline for future room image prompts:

```text
1920x1080 fixed, same-camera pixel-art quarterview, keep the provided Yui character proportions, living space is larger and tidy lower-grid housing with bed away from entrance, kitchen / dining / bed zones softly separated by partition, work space is smaller with no window and centered on a NAVI LINK entry device plus power and signal control, the two rooms connect via living-space right wall door to work-space left wall door, use light gray-white floor and restrained near-future industrial materials, avoid clutter, factory mood, villain lab mood, motel colors, luxury furniture, and impossible door/window placement.
```

## Art Non-Goals

- Do not overwrite current room background without explicit task.
- Do not regenerate Yui spritesheets without explicit task.
- Do not stage unrelated `.import` / `.uid` files.
- Do not connect art directly to production gameplay state.
