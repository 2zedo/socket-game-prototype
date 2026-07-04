# Quarterview Room Image Fixed Spec

## 1. Purpose

이 문서는 `CONCENT / 전력 부족의 시대`에서 앞으로 게임에 넣을 쿼터뷰 방 이미지를 생성하거나 검수할 때 사용할 고정 기준이다.

지금까지 방 이미지가 흔들린 핵심 원인은 카메라, 방 크기, 캐릭터 크기, 오브젝트 비율, 문 위치, 색감 기준을 수치로 고정하지 않은 상태에서 감성 위주로 생성했기 때문이다. 이 문서는 다음 이미지 생성 전에 먼저 잠그는 baseline이다.

Scope:

- 이미지 생성 / 콘티 검수 / room art pass 기준이다.
- Godot scene, collision, interaction, Resource, gameplay 구현 지시가 아니다.
- 현재 `QuarterviewMain`에 즉시 적용한다는 뜻이 아니다.
- 기존 Main / DAY1 / `project.godot`를 변경하지 않는다.
- 실제 PNG 생성, import, atlas mapping, scene wiring은 별도 작업에서만 한다.

Relationship:

- `docs/CONCENT_PROJECT_IDENTITY.md`가 상위 정체성 문서다.
- 이 문서는 그중 room image generation에 필요한 고정 수치와 금지사항을 구체화한다.
- 기존 한 방짜리 blockout / temporary background와 충돌하는 항목은 "future room image generation baseline"으로만 본다.

## 2. Global Fixed Rules

| 항목 | 고정 기준 |
| --- | --- |
| Final output | `1920x1080` |
| Scene type | 2D quarterview / in-game concept image |
| Room count | 2 rooms: living space, work + power space |
| Connection | 두 방은 같은 집 내부로 자연스럽게 연결되어야 한다 |
| Shared rules | 같은 카메라 각도, 같은 도트풍, 같은 캐릭터 디자인, 같은 비율 체계 |

The two rooms:

1. Living space
2. Work space + power space

## 3. Camera Rules

- Keep `1920x1080`.
- Use the current quarterview direction: visible room corners, cutaway / isometric-like interior.
- Do not use an overly top-down angle.
- Some outer wall / room corner should be visible.
- The full room structure must be readable, but objects must remain identifiable.
- Living space should feel slightly wider and more relaxed.
- Work space should feel more compact and functional.

Zoom target:

- The character must not be tiny.
- The character must not be as large as the bed.
- The room layout, object silhouettes, and interaction candidates should be legible at once.

## 4. Character Scale Rules

The character is the primary scale anchor. Room size, object size, and camera zoom should be derived from the character.

| Item | On-screen size |
| --- | ---: |
| Character height | `150-165px` |
| Character width | `65-80px` |

Character style:

- Use the user's current pixel / dot-style Yui design direction.
- Proportion: about `2.5-3 heads`.
- Do not make her chubby, squat, or short-stubby.

Object ratio checks:

- Character height should be about `0.55-0.62x` of bed length.
- Character must clearly be taller than the refrigerator.
- Character must never look smaller than the microwave.
- Character should feel naturally scaled against dining chairs.

## 5. World And Tone Rules

Core mood:

- Lower-grid residential space.
- Resource shortage.
- Near future, but not luxury high-tech.
- Old / recycled structure plus practical future efficiency.
- Tidy, organized poverty rather than dirty ruin.
- Yui's small personal taste may appear, but useless decorative clutter should not.

Keywords:

- Reused structure
- Practicality
- Clean but poor
- Organized by Yui's personality
- Small traces of taste / longing for the outside world

Forbidden:

- American motel mood
- Penthouse mood
- Final-boss laboratory
- Factory / dental clinic / villain hideout exaggeration
- Decorative useless props spam

## 6. Living Space

The living space is larger than the work space and slightly rectangular.

Primary uses:

- Entrance
- Kitchen
- Dining
- Rest
- Sleep

Internal zones:

- Entrance / kitchen side
- Bed / rest side

These zones should not be fully separated by a wall. Use a low partition, shelf partition, translucent curtain, mesh divider, or simple temporary divider so the space feels separated without becoming two separate rooms.

Required objects:

- Entrance door
- Bed
- Small kitchen: sink, refrigerator, microwave
- Small two-person dining table
- Two chairs
- Small cabinet or shelf
- Living light / indirect light
- A few small decorations, not many

Remove / avoid:

- Low living-room table
- Heavy work equipment
- Large communication equipment
- Factory-like power equipment
- UPS / batteries / tool piles

Suggested layout:

| Area | Placement |
| --- | --- |
| Lower-left / left-lower wall | Entrance door |
| Top or upper-left | Bed zone |
| Upper-right | Kitchen |
| Center to mid-right | Two-person dining table |
| Between entrance/kitchen and bed | Partition / shelf divider |

Living space visible floor target:

| Item | Target |
| --- | --- |
| Visible floor width | `1180-1280px` |
| Visible floor depth | `680-760px` |
| Feeling | Wider than work space, more relaxed |

Object size targets:

| Object | On-screen size | Placement rule |
| --- | ---: | --- |
| Bed | `270-320w / 150-190h` | Not right next to entrance; inside bed zone |
| Bedside table | `55-75w / 45-60h` | Beside bed |
| Refrigerator | `95-120w / 150-190h` | Kitchen zone |
| Microwave | `60-85w / 40-55h` | On refrigerator or shelf |
| Sink block | `180-240w / 80-110h` | Kitchen wall side |
| Two-person table | `150-200w / 90-120h` | Center or mid-right |
| Dining chair | `45-60w / 70-90h` each | Two chairs |
| Partition / shelf divider | `180-260w / 100-160h` | Visual separation only |

Allowed small decorations:

- Mug
- Memo board
- One or two small sea / horizon posters
- One small plant
- A few organized books or notes

Yui personality notes:

- Organized and tidy.
- Almost no useless luxury goods.
- Some longing for the outside world is visible.
- The room must not become a beach-themed room.

## 7. Work Space + Power Space

The work space is smaller than the living space and slightly rectangular.

Primary uses:

- Hacking entry device
- Signal / communication adjustment
- Power distribution

Mood:

- Not a hacker laboratory.
- Quiet personal work room plus power control room.
- No window.
- No laptop / big monitor setup as the center.

Core device:

- `NAVI LINK` hacking entry device.
- A functional setting-chair / setting-desk style unit connected to NAVI LINK.
- It must not look like a dental chair.
- It should read as "a functional interface device used while seated to prepare connection."

Required objects:

- Internal connecting door
- NAVI LINK setting device
- One small communication equipment set
- Wall-mounted power control panel
- Organized cable / signal distribution area
- Small auxiliary work surface
- A few wall notes / panels

Remove / avoid:

- Window
- Laptop
- Generic office desk setup
- Chair plus many monitors
- Factory-scale giant panel
- Villain laboratory device
- UPS / large battery / tool storage mood
- Useless decorative boxes

Suggested layout:

| Area | Placement |
| --- | --- |
| Left wall, middle-upper | Door connected to living space |
| Right or upper-right | NAVI LINK setting device |
| Upper-left to top wall | Power control panel |
| Center to lower area | Movement path |
| Right / top wall portions | Communication equipment |

Work space visible floor target:

| Item | Target |
| --- | --- |
| Visible floor width | `980-1100px` |
| Visible floor depth | `600-680px` |
| Feeling | Compact and functional |

Object size targets:

| Object | On-screen size | Placement rule |
| --- | ---: | --- |
| NAVI LINK full unit | `260-340w / 220-300h` | Main device; most important object |
| Setting chair / mount | Included in NAVI LINK unit | Avoid dental-chair silhouette |
| Power control panel | `140-220w / 120-180h` | Wall-mounted |
| Small communication rack | `90-140w / 120-190h` | One set only |
| Signal adjustment console | `110-170w / 70-110h` | Wall side or auxiliary surface |
| Wall memo / panel | `80-140w / 60-100h` | Small amount only |

## 8. Door Placement Rules

The two rooms must feel physically connected.

Living space:

- Entrance door: lower-left or left-lower wall.
- Internal door to work space: right wall, middle-upper.

Work space:

- Internal door from living space: left wall, middle-upper.

This means:

```text
Living space right-wall door
-> Work space left-wall door
```

Additional rules:

- Do not place windows near the connecting door.
- Avoid impossible layouts where a door opens directly into an outside view.
- Keep walkable passage around the connecting door.

## 9. Palette Rules

Overall palette:

- Avoid dull brown / American motel tones.
- Avoid luxury interior tones.
- Base: light neutral colors + worn industrial materials + small cyan/electric accents.

Shared materials:

| Area | Base color | Notes |
| --- | --- | --- |
| Walls | warm light gray, dusty ivory, off-white gray | old industrial panel / painted surface, not cheap wallpaper |
| Floor | light gray-white, pale concrete tile, pale resin floor | no wood floor |
| Metal frame | charcoal / gunmetal | worn but maintained |
| Lighting | warm white + small cyan accents | both lived-in and near-future |

Living objects:

| Object | Recommended color |
| --- | --- |
| Bed frame | dark gray metal or dark brown metal |
| Bedding | muted blue-gray, olive gray, dark charcoal |
| Refrigerator | worn off-white / light gray |
| Microwave | matte gray |
| Kitchen counter | off-white / light stone gray |
| Dining table | light gray top + dark frame |
| Chair | black frame + desaturated cushion |
| Partition | black frame + translucent / mesh / light gray panel |

Work / power objects:

| Object | Recommended color |
| --- | --- |
| NAVI LINK setting device | gunmetal / dark blue-black / dark charcoal |
| Accent lines | cyan / electric blue |
| Power panel | matte gray + small safety marks |
| Communication equipment | charcoal / black-gray / weak orange or cyan LEDs |
| Wall panels | light gray / pale metal white |

## 10. Window Rules

| Room | Window | Rule |
| --- | --- | --- |
| Living space | Allowed | Small or medium; lower-grid feeling |
| Work space | Forbidden | No window |

Living space window view:

- Do not show a penthouse-style open skyline.
- Prefer close exterior walls, nearby buildings, pipes, signs, narrow city layers.
- Use limited city light through nearby structures.
- The view should feel constrained and lower-grid.

Forbidden:

- Wide open night skyline
- Luxury high-rise view
- A window next to the work-space connecting door

## 11. NAVI LINK Hacking Entry Device

Concept:

- Replace laptop / monitor-centered hacking with a head-mounted or neural-link NAVI LINK entry device.
- Yui sits and prepares connection.
- Hacking mode is entered through NAVI proxy logic, not by visually walking into cyberspace from the room.

Work space composition:

- Main unit: setting chair + mount / connection fixture.
- Support devices: small status panel, signal adjustment device, power control link.

Avoid:

- Three-monitor hacker desk.
- Gaming hacker desk.
- Large office chair plus large desk.
- Overly arched dental-chair machine.

Desired tone:

- Near-future personal neural connection device.
- Expensive but old.
- Carefully maintained with limited resources.

## 12. Summary Of Hard Bans

- Bed right next to entrance.
- Both connecting doors placed on the same apparent side.
- Window in work space.
- Wood floor.
- Low living-room table.
- Factory mood.
- Final-boss laboratory.
- Penthouse night view.
- Excess clutter.
- American motel colors.
- Luxury hotel furniture.
- Character scaled close to bed size.
- Character smaller than microwave.

## 13. Prompt Core

Use this as the short fixed baseline when asking for the next image:

```text
1920x1080 fixed, same-camera pixel-art quarterview, keep the provided Yui character proportions, living space is larger and tidy lower-grid housing with bed away from entrance, kitchen / dining / bed zones softly separated by partition, work space is smaller with no window and centered on a NAVI LINK entry device plus power and signal control, the two rooms connect via living-space right wall door to work-space left wall door, use light gray-white floor and restrained near-future industrial materials, avoid clutter, factory mood, villain lab mood, motel colors, luxury furniture, and impossible door/window placement.
```

## 14. Implementation Boundary

This document does not create or modify:

- `QuarterviewMain.tscn`
- `QuarterviewRoom.tscn`
- `RoomObjectDefinition`
- Godot collision / interaction data
- PNG files
- `.import` files
- atlas mappings
- production Main / DAY1 flow

When real art is generated later, apply it through the existing asset policy:

- place art under `godot/assets/art/`
- keep gameplay collision / interaction data separate
- stage only relevant image / import files
- do not stage unrelated addon, `.uid`, or import files
