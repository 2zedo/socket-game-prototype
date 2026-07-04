# Art Direction Reference

## Role

This is the current reference for CONCENT in-game room images, quarterview scale, material direction, room layout logic, atlas policy, and temporary art boundaries.

The current focus is not final asset integration. It is a stable visual target for future room image generation and review.

## Current Image Baseline

Use these rules for new in-game room sample images:

- Output must be `1920x1080`, fixed `16:9`.
- View is 2D quarterview / light isometric cutaway.
- Camera should be slightly farther back than the cramped sample direction.
- Avoid high top-view and avoid close-up camera.
- The full room must fit inside the screen with visible margins.
- Walkable floor area must be readable.
- Interior walls must look like interior walls, not exterior concrete walls.
- Avoid charcoal / gray / cyan-only palettes.
- Object scale must be rebalanced around Yui's actual in-game readable size.
- Spaces must feel like real living / working rooms, not decorative concept sets.
- Doors, partitions, and living routes must connect logically.
- The room image should reveal the Act 1 play loop at a glance: power rationing, portable Phone / DM access, anonymous job traces, PIP-03 support, NAVI LINK preparation, and constrained lower-grid living.

## Latest Sample Review Policy

The latest living-space sample is broadly accepted as a base direction.

Preserve:

- overall living-space layout and design direction
- Yui's current character scale
- the main living-space zones: bed, entrance, dining, kitchen, internal connecting door
- the cleaner color/design direction compared to earlier drafts

Next image revisions should be micro-adjustments, not a redesign.

Primary fixes:

- reduce most furniture / props by about `8-15%`
- keep Yui scale unchanged and rebalance objects around her
- pull the camera back one small step while preserving the same quarterview angle
- make the room slightly more compact after object shrink, so it does not become empty
- lower / shrink related architecture proportionally: floor footprint, wall height, door size, partition height / width, and spacing
- add a slightly darker, chill night mood without losing the warm lived-in room identity

Do not break the accepted layout while chasing a new mood.

## Camera / Proportion Revision Rule

When a generated sample feels close but oversized:

1. Keep Yui size.
2. Reduce large objects first.
3. Reduce doors / partitions / wall height to match.
4. Slightly reduce room footprint if the floor becomes too empty.
5. Pull camera back by zooming out slightly, not by changing to a top-view angle.

The desired result is a small real one-person living space that feels compact, usable, and readable, not a toy room and not a huge staged apartment.

## Scale Anchor

Yui is the visual scale anchor.

Current target Yui size on the room image:

| Item | Target |
| --- | ---: |
| Height | `118-132px` |
| Width | `44-52px` |
| Body ratio | slim `2.5-3` heads |

Object target sizes:

| Object | Target |
| --- | ---: |
| Entrance door height | `180-205px` |
| Internal connecting door height | `170-195px` |
| Bed length | `210-240px` |
| Bed width | `110-135px` |
| Refrigerator height | `125-145px` |
| Microwave height | `40-52px` |
| Two-person dining tabletop | `105-125px` |
| Shoe cabinet height | `45-60px` |
| Low partition height | Yui waist to below chest |
| Mesh / curtain sleep partition | taller than Yui, below ceiling |

Dining chairs should not overpower Yui. Chair backs should land below Yui's chest.

## Material Direction

### Floor

Wood floor is forbidden as the default room floor.

Use:

- bright gray-white resin floor
- light gray concrete tile
- industrial composite panels
- clean indoor floor finish

Avoid:

- warehouse floor
- rough outdoor concrete
- motel wood floor
- dark plank floor

### Wall

Walls must read as indoor finish, not exterior walls.

Use:

- light gray interior panels
- warm ivory-gray painted walls
- off-white walls with panel seams
- lightly worn but managed interior wall finish

Avoid:

- exposed exterior concrete
- prison wall
- military facility wall
- ruin / abandoned building wall

## Color Strategy

Do not rely on charcoal, gray, and cyan only.

Base colors:

- off-white
- cream gray
- soft gray
- light greige

Distributed accent colors:

- dusty blue / bright navy
- sage green
- warm wood tone
- amber / warm yellow light
- small coral / muted red accents
- muted teal / blue-gray
- purple / cyan / pink reflected city light

Use color through furniture, small objects, practical devices, fabric, doors, and lighting. Do not dump all color into clothing racks or random clutter.

Because Yui is visually dark, furniture and objects need enough mid-tone and light-tone variation so she does not disappear into the background.

## Living Space

### Current Living Sample Status

The current living-space sample can be treated as a layout/design base.

Keep:

- bed zone, entrance zone, dining zone, kitchen zone, and internal connecting door separation
- tidy lived-in direction
- current Yui size
- broad color plan and practical home feeling

Adjust:

- refrigerator, microwave, sink, dining table, chairs, bed, partition, doors, and small shelves should be slightly smaller
- table should read as a small two-person dining table, not a heavy four-person table
- microwave and kitchen appliances should feel reachable by Yui
- partitions should separate zones but not feel oversized or bulky
- room and wall proportions should shrink with the objects
- camera should pull back slightly while keeping the same angle
- lighting should become a calmer nighttime room mood

### Size

The living space is still larger than the work room, but it should be smaller than the previous oversized sample.

Target visible area:

| Axis | Target |
| --- | ---: |
| Width | `1280-1380px` |
| Depth | `650-730px` |

Compared to the prior direction, reduce about:

- width `-160px`
- depth `-80px`

The room should be slightly rectangular, not square.

If object scale is reduced, reduce the room footprint slightly too. Do not leave excessive empty floor just because furniture got smaller.

### Zones

The living room contains:

1. entrance zone
2. sleep zone
3. kitchen / coffee zone
4. dining zone
5. internal connecting door to work room

Act 1 visual cues allowed in living space:

- a small power-ration notice panel or limited outlet indicator on one wall
- a portable Phone charging/resting spot near the bed or dining table
- a tiny Mika DM / message cue only as phone-screen implication, not wall text
- small anonymous-job notification traces only, not a full work board
- a small PIP-03 charging/resting spot near the entrance if it stays subtle

Do not put NAVI LINK, NODE-17, power-board equipment, heavy communication hardware, or hacking rigs in the living space.

### Entrance Zone

Position:

- lower-left or left-front wall side

Rules:

- Use a modest shoe-off entry threshold or shallow entry-tile zone.
- If a raised genkan step reads awkward, reduce it to a small threshold and floor-material change.
- The interior floor should still feel mostly flat and playable.
- Entry should mark outside/inside boundary without a large split-level floor.

Include:

- entrance door
- small mat
- small card reader
- 2-3 pairs of shoes
- small shoe cabinet
- optional inside-side coat stand with olive raincoat, dusty blue bag, or muted scarf
- optional small PIP-03 charging spot, if it reads as a home support-device corner

Do not include:

- bedside-like drawer next to the entrance
- bedside lamp near the entrance
- partition full of books, drawers, or valuables in front of the door
- open valuable storage at the entrance
- coat rack outside the home boundary
- black outerwear that visually duplicates Yui's silhouette

Color:

- entrance door: mid dark brown-gray / gunmetal brown
- card reader: blue-gray with small cyan / white LED
- shoe cabinet: off-white / greige with wood top or muted gray

### Entrance / Sleep Separation

Use a low-height partition between entrance and bed. It must not read as a storage wall full of stealable objects.

Preferred structure:

- entrance side: waist-high closed panel / simple low wall
- sleep side: low shelf-like partition plus thin mesh or soft curtain

Colors:

- lower partition: light greige / warm gray
- mesh frame: gunmetal blue-gray
- curtain: light gray-blue / soft cream gray

### Sleep Zone

Position:

- quiet inner corner
- can be near a window
- not directly beside the entrance

Include:

- bed
- small bedside table
- one warm light
- optional small rug, understated

Colors:

- bed frame: dark blue-gray metal / gunmetal
- blanket: bright navy / dusty blue
- pillow: white / light gray
- bedside table: light wood with dark frame, or soft gray
- light: warm amber

### Kitchen / Coffee Zone

Position:

- right-back / back wall line

Include:

- small refrigerator
- microwave
- small sink
- coffee maker or dripper
- 1-2 mugs
- bean / capsule container
- small tray

Colors:

- refrigerator: off-white / cream gray
- microwave: light gray
- sink top: gray-white
- lower cabinet: blue-gray / muted blue-gray
- coffee maker: deep gray with bronze / silver point
- mugs: sage / cream / dusty blue mix

Mood:

- one-person home with coffee habit
- not a decorated cafe
- practical, small, and routinely used

### Dining Zone

Position:

- center to middle-right
- avoid blocking the movement route

Scale:

- tabletop must be smaller than previous samples
- chairs should be one step smaller
- table must not dominate Yui
- current accepted-sample revision target: reduce table and chairs slightly, not replace them

Colors:

- tabletop: light wood / cream
- frame: dark metal
- chair frame: gunmetal
- chair seat/back accent: sage green or dusty blue

### Living Window

Position:

- one window along the sleep-zone wall

View:

- lower-grid viewpoint
- nearby exterior walls, pipes, adjacent structures, neon reflections
- no distant penthouse skyline

Reflected colors:

- blue
- violet
- pink
- cyan

Curtain:

- light, soft, airy
- light gray-blue / light greige / soft cream gray

### Internal Connecting Door

Position in living room:

- upper-right wall or right-back wall

Rules:

- must not share the exact design language of entrance door
- should read as an interior partition door
- sliding door or light industrial internal door works
- must visibly lead to the work + power room, not to a window or exterior view

Colors:

- deep blue-gray
- muted teal gray
- desaturated olive-gray

## Work + Power Space

### Work Sample Mood Direction

The work + power room should share the same scale system as the accepted living-space sample.

Use:

- same Yui scale
- same quarterview camera angle
- similar wall thickness and material logic
- similar margin / floor readability
- slightly stronger chill night atmosphere than the living room

The second reference mood can influence the work room more strongly:

- darker but not unreadable
- chill cyber night tone
- low-key equipment glow
- cyan / violet / blue status lights
- amber maintenance lamp accents

Do not copy a reference wholesale. The work room must still feel like the other room in the same home.

### Size

The work + power room is smaller than the living room.

Target visible area:

| Axis | Target |
| --- | ---: |
| Width | `1120-1260px` |
| Depth | `600-680px` |

### Connecting Door Logic

This is fixed:

```text
Living room right-upper / right-back internal door
-> Work room left-lower / left-front wall door
```

In the work room image, the connecting door must appear on the lower/front side of the left wall. A random upper-left door is incorrect.

### Room Identity

This room is:

- no bed
- no living appliances
- no window
- personal hacker equipment room + power control room
- slightly data-center orderly
- compact and professional
- the visual home of NAVI LINK, power routing, anonymous job preparation, and later NODE / signal equipment
- darker and more technical than the living space, but still organized and usable

It is not:

- factory
- prison
- villain lab
- torture room
- dental-chair room
- office desk room

### Main Object Priority

The center is not a laptop or monitor desk.

Primary read:

1. NAVI LINK hacking entry device
2. compact power control panel
3. signal / NODE equipment set

Act 1 visual cues:

- job log / anonymous request memo panel near the equipment, kept compact
- NAVI LINK power line or clean cable route to the power panel
- PIP-03 diagnostic / charging port candidate, secondary to NAVI LINK
- later NODE-17 slot candidate, not a fully activated story device

Do not make a normal laptop / monitor desk the center. A small terminal can exist only as a support panel.

### NAVI LINK Device

Direction:

- temple / side-head synchronization based device
- personal professional equipment
- secret but maintained
- compact, stable, precise

Good shapes:

- low stable seat
- small precise synchronization arm near the side of the head
- small status panel nearby
- organized cables on floor
- power / signal panels on surrounding walls

Avoid:

- dental chair
- torture chair
- capsule treatment bed
- exaggerated monitor arms
- scorpion-tail device
- laptop / monitor-centered hacker desk

### Power / Signal Equipment

Power equipment:

- small wall panel
- compact connector board
- organized cables
- small switches
- small status display

Signal / NODE equipment:

- one compact equipment set
- compact communication device
- small record panel or memo board
- one future NODE-17 / signal slot candidate if it stays compact and inactive

Avoid:

- huge server racks
- battery pile
- UPS pile
- factory-scale power room
- box pile
- tool pile

### Work Room Color

The work room can be cooler than the living room, but it must still use varied color.

Base:

- off-white
- light warm gray
- blue-gray
- soft slate

Accent:

- cyan LED
- small violet LED
- blue status indicators
- amber maintenance light
- muted teal panel
- navy / gunmetal equipment
- small olive / sage objects

Avoid all-charcoal, all-gray, all-cyan, and overly gloomy shading.

### Work Room Scale Revision

If the first work-room sample inherits the living-space scale issue:

- reduce equipment / furniture by about `8-15%`
- keep Yui scale unchanged
- reduce room footprint and wall height proportionally
- pull the camera back one small step
- make NAVI LINK readable as a compact professional personal device, not oversized medical furniture

## Interaction Emphasis

Interactive objects should be readable without looking like UI stickers.

Living space emphasis:

- small power-ration notice / outlet-limit panel
- Phone charging/resting spot, while Phone remains portable
- possible PIP-03 charging spot near entrance
- refrigerator
- microwave
- sink
- coffee maker
- dining table
- internal connecting door

Work room emphasis:

- NAVI LINK entry device
- power control panel
- signal / NODE equipment
- compact anonymous job log / record panel
- PIP-03 service / diagnostic port candidate
- internal connecting door

Use:

- slightly stronger value contrast
- slightly higher brightness
- clean silhouette
- organized surrounding space

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
1920x1080 fixed 16:9, 2D quarterview cutaway game room, camera slightly pulled back with comfortable margins and readable walkable floor. Interior walls are off-white / warm gray indoor panels, not exterior concrete. No wood floor; use clean light gray-white resin or composite tile floor. Use varied restrained colors: cream gray, light greige, dusty blue, sage, warm amber, muted teal, small coral, and soft city reflections. Yui scale anchor is 118-132px tall and slim. If revising the accepted living-space sample, keep Yui size and current layout, reduce surrounding objects by 8-15%, adjust room footprint / wall height / door size / partition height with the object scale, and pull the camera back one small step without changing the quarterview angle. Living space is a warm modest real home with a calm chill nighttime mood, modest shoe-off entry threshold, low partition / mesh curtain sleep separation, bed in quiet inner corner, compact kitchen / coffee area, smaller dining table and chairs, small power-ration cue, portable Phone charging/resting cue, possible subtle PIP-03 charging spot, and internal door on upper-right / right-back wall. Work + power space is smaller and professional, slightly darker and more cyber-chill than the living room, with door on lower/front side of left wall, no window, no living appliances, centered on NAVI LINK personal synchronization device, compact power panel, signal / NODE equipment, anonymous job log cue, clean NAVI power line, and possible PIP-03 diagnostic port. Avoid dental chair, torture room, villain lab, factory power room, laptop-centered hacker desk, clutter piles, charcoal-gray-cyan monotony, luxury furniture, motel colors, oversized props, and impossible door placement.
```

## Art Non-Goals

- Do not overwrite current room background without explicit task.
- Do not regenerate Yui spritesheets without explicit task.
- Do not stage unrelated `.import` / `.uid` files.
- Do not connect art directly to production gameplay state.
