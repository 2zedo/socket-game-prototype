# Yui Quarterview Spritesheet Import Guide

## 목적

이 문서는 유이의 쿼터뷰용 4방향 spritesheet를 실제 Godot에 import하기 전에, 파일명, 경로, 방향 순서, frame layout, pivot / foot anchor, import 설정, 적용 순서를 고정하기 위한 기준이다.

이번 문서는 실제 PNG 에셋 적용 작업이 아니다. `AnimatedSprite2D`, `SpriteFrames` Resource, `YuiQuarterviewPlayer`, `QuarterviewGameplaySandbox`, `QuarterviewRoomShellPrototype`, 기존 Main / DAY 1 player visual은 변경하지 않는다.

## 대상 파일명 기준

필수 후보:

```text
yui_qv_idle_4dir.png
yui_qv_walk_4dir.png
```

향후 후보:

```text
yui_qv_shadow.png
yui_qv_emote_overlay.png
yui_qv_work_pose.png
yui_qv_sleep_pose.png
```

예상 asset path:

```text
res://assets/characters/yui/qv/yui_qv_idle_4dir.png
res://assets/characters/yui/qv/yui_qv_walk_4dir.png
```

source / reference 후보:

```text
res://assets/characters/yui/source/
res://assets/characters/yui/reference/
```

이번 작업에서는 위 폴더나 PNG 파일을 실제로 만들지 않는다. 경로는 future path 기준이다.

## Spritesheet 기본 규격

기본 형식:

- PNG
- RGBA / transparent background
- all directions use the same character scale
- all frames use the same cell size
- no background
- no strong room shadow baked into character
- no UI label / text inside sprite
- no cropped hair / feet / hood / arms
- all frames aligned by foot anchor

시점 / 캐릭터 기준:

- 쿼터뷰 방에 맞는 `3/4 top-down` 느낌을 우선한다.
- 정수리만 보이는 top-down sprite가 아니다.
- front / down, back / up, left, right 방향을 구분할 수 있어야 한다.
- 유이의 실루엣은 작아도 읽혀야 한다.
- 검은 후디 / 어두운 실용복 / 차분한 분위기를 유지한다.
- 과한 전투 포즈나 판타지 캐릭터 느낌은 피한다.
- 더러운 슬럼 느낌보다 정돈된 하층 해커 / 정보 노동자 느낌을 우선한다.

## 방향 순서 기준

4방향 row order는 아래 기준으로 고정한다.

| Direction key | Meaning | Row |
| --- | --- | --- |
| `down` | front-facing / toward camera | `0` |
| `up` | back-facing / away from camera | `1` |
| `left` | moving / standing left | `2` |
| `right` | moving / standing right | `3` |

과거 생성된 이미지나 임시 파일의 row order가 다르더라도, 실제 import용 최종 spritesheet는 이 기준으로 맞춘다. 이미 존재하는 asset이 이 기준과 다르면 asset을 수정하지 말고 문서 / 보고에 불일치로 남긴다.

## Frame Layout 기준

### `yui_qv_idle_4dir.png`

후보 기준:

- 4 rows
- 1-2 frames per direction
- row order: down, up, left, right
- same cell width / cell height
- `idle_down`, `idle_up`, `idle_left`, `idle_right` animation으로 import 예정

MVP 기준:

- 1 frame per direction도 허용한다.
- 가능하면 2 frames로 미세한 breathing / weight shift 후보를 둔다.

### `yui_qv_walk_4dir.png`

후보 기준:

- 4 rows
- minimum 2 frames per direction
- preferred 4 frames per direction
- row order: down, up, left, right
- same cell width / cell height
- `walk_down`, `walk_up`, `walk_left`, `walk_right` animation으로 import 예정

MVP 기준:

- 2 frames per direction도 가능하다.
- 실제 조작감 확인 후 4 frames 이상으로 확장할 수 있다.

Sheet formula:

```text
sheet_width = cell_width * frames_per_direction
sheet_height = cell_height * 4
```

예:

```text
128x192 cell, 4 frames per direction:
sheet = 512x768
```

실제 cell size는 이번 작업에서 확정하지 않는다. 위 수치는 계산 예시와 후보 기준이다.

## Cell Size / Pivot / Foot Anchor 기준

### Cell Size

- 모든 frame은 같은 `cell_width` / `cell_height`를 사용한다.
- idle과 walk는 가능하면 같은 cell size를 사용한다.
- frame마다 character 위치가 흔들리지 않게 foot 기준으로 정렬한다.
- hood, hair, foot, arms가 잘리지 않도록 여유 padding을 둔다.

### Pivot / Anchor

기준:

- visual pivot은 bottom-center / foot anchor 기준이다.
- player collision 기준점도 발 위치에 맞춘다.
- sprite 중심이 아니라 발밑 중심이 이동 좌표가 되는 구조를 권장한다.

Godot 적용 후보:

```text
YuiQuarterviewPlayer
  CharacterBody2D
    SpriteRoot
      AnimatedSprite2D
      ShadowSprite
    CollisionShape2D
    InteractionAnchor
```

기준 설명:

- `CharacterBody2D.position` = 발밑 기준
- `AnimatedSprite2D`는 offset으로 발밑이 origin에 오게 조정
- `CollisionShape2D`는 발밑 주변의 작은 capsule / rectangle 후보
- `InteractionAnchor`는 발밑 또는 몸 앞쪽 offset 후보

이번 작업에서는 실제 node를 만들지 않는다.

## Godot Import 설정 후보

후보:

```text
Texture type: 2D Texture
Compression: Lossless
Mipmaps: Off
Repeat: Disabled
Filter:
  - current non-pixel quarterview character candidate: Linear
  - if pixel art is finalized: Nearest
Fix Alpha Border: On candidate
Premultiplied Alpha: Off candidate
Detect 3D: Off
```

주의:

- 실제 `.import` 파일은 이번 작업에서 생성 / 수정하지 않는다.
- 실제 asset 추가 후 import 설정을 확정한다.
- 투명 edge에 halo가 생기면 alpha cleanup 또는 Fix Alpha Border를 확인한다.
- filter 정책은 room shell / object art와 맞춰 결정한다.

## Animation Naming 기준

필수 animation 이름:

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

향후 후보:

```text
use_laptop
use_phone
sleep
sit
interact
surprised
tired
alert
```

이번 작업에서는 `SpriteFrames` Resource를 만들지 않는다. 이름 기준만 고정한다.

## Godot 적용 구조 후보

후보 scene / resource:

```text
godot/resources/characters/yui/yui_qv_spriteframes.tres
godot/scenes/characters/YuiQuarterviewPlayer.tscn
godot/scripts/characters/YuiQuarterviewPlayer.gd
```

후보 node 구조:

```text
YuiQuarterviewPlayer
  CharacterBody2D
    SpriteRoot
      AnimatedSprite2D
      ShadowSprite
    CollisionShape2D
    InteractionAnchor
    DebugAnchorLayer
```

기존 prototype 구조에 맞춰 조정할 수 있다. 이번 작업에서는 위 파일을 만들지 않고 다음 작업 후보로만 문서화한다.

## Room Shell / Foreground Occluder 관계

- 유이 sprite는 room shell floor / wall 위에 표시된다.
- player layer는 furniture / device layer와 z-index 관계를 조정해야 한다.
- foreground occluder는 유이보다 위에 올 수 있다.
- lighting overlay가 유이 위에 얹힐 수 있지만 UI / prompt는 영향받지 않아야 한다.
- 유이가 foreground occluder 뒤에 완전히 가려지는 구간은 최소화해야 한다.
- interact prompt는 유이 / occluder보다 위에 표시하는 후보를 둔다.

z-index 후보:

| Layer | Suggested z-index |
| --- | --- |
| `FloorLayer` | `0` |
| `WindowCityViewLayer` | `8` |
| `BackWallLayer` | `10` |
| `SideWallLayer` | `15` |
| `FurnitureLayer` | `30` |
| `DeviceLayer` | `35` |
| `PlayerLayer` | `40` |
| `ObjectHighlightLayer` | `50` |
| `ForegroundOccluderLayer` | `80` |
| `StaticLightingOverlayLayer` | `90` |
| `InteractionPromptLayer` | `100` |
| `UILayer` | `1000` |

## Style / Character Consistency 기준

- 유이는 THE GRID 하층 출신 2세대 이후 인물이다.
- 뒷세계 해커 / 정보 노동자다.
- 검은 후디 또는 어두운 실용복 후보다.
- 과하게 귀엽거나 판타지 전사처럼 보이면 안 된다.
- 방은 작지만 정돈되어 있고, 유이도 생존형 실용성을 가진 캐릭터여야 한다.
- front / down 방향에서 표정이 너무 과장되지 않아야 한다.
- back / up 방향에서 hood / 머리 / 어깨 실루엣이 읽혀야 한다.
- left / right 방향은 걸음 방향과 몸 기울기가 자연스러워야 한다.

## 적용 전 Checklist

- [ ] PNG transparent background인지 확인
- [ ] row order가 down / up / left / right인지 확인
- [ ] frame count가 문서 기준과 맞는지 확인
- [ ] 모든 frame의 cell size가 같은지 확인
- [ ] 발밑 anchor가 흔들리지 않는지 확인
- [ ] idle / walk 간 character scale이 같은지 확인
- [ ] left / right가 서로 어색하게 뒤집힌 느낌이 아닌지 확인
- [ ] up / back 방향이 정수리뷰가 아니라 쿼터뷰 뒷모습인지 확인
- [ ] down / front 방향이 방 perspective와 맞는지 확인
- [ ] alpha edge halo가 없는지 확인
- [ ] frame 사이에 character 위치가 튀지 않는지 확인
- [ ] room shell 위에서 너무 크거나 작지 않은지 확인
- [ ] foreground occluder 뒤에 들어갔을 때 완전히 사라지지 않는지 확인

## 실제 적용 순서 후보

실제 적용은 별도 작업에서 진행한다.

1. `yui_qv_idle_4dir.png` / `yui_qv_walk_4dir.png` 최종 asset 준비
2. asset path에 PNG 추가
3. import 설정 확인
4. `SpriteFrames` Resource 생성
5. `AnimatedSprite2D` prototype 생성
6. idle / walk animation 이름 연결
7. pivot / foot anchor 조정
8. `QuarterviewPerspectiveBlockout`에서 scale 확인
9. foreground occluder / lighting overlay와 시인성 확인
10. `QuarterviewGameplaySandbox`에 player visual 교체 검토

## Non-goals

- 실제 PNG asset 추가
- 이미지 생성 / 변환 / 리사이즈
- `/mnt/data` 이미지 복사
- `SpriteFrames` `.tres` 생성
- `YuiQuarterviewPlayer` scene 생성
- `.import` 파일 생성 / 수정
- scene player visual 교체
- collision / hitbox 수정
- `RoomObjectDefinition` 값 수정
- `DeviceDefinition` 값 수정
- Main / DAY 1 / `Apartment` / `SurvivalState` 변경
