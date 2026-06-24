# Quarterview Foreground Occluder Guide

## 목적

이 문서는 `qv_room_foreground_occluders.png`를 실제 Godot scene에 적용하기 전에, 쿼터뷰 room shell의 foreground occluder layer가 무엇을 담당하고 무엇을 담당하지 않는지 고정하기 위한 기준이다.

이번 문서는 실제 PNG 에셋 적용 작업이 아니다. `QuarterviewRoomShellPrototype`, `QuarterviewGameplaySandbox`, 기존 Main / DAY 1, `Apartment`, `SurvivalState` 흐름은 변경하지 않는다.

## Foreground Occluder 정의

Foreground occluder는 player / object / device보다 앞에 그려져야 하는 정적 시각 요소다. 방 구조의 앞쪽 가림 효과를 담당하며, 같은 canvas 기준의 PNG layer로 관리한다.

명확히 구분한다:

| 항목 | 역할 | 기준 |
| --- | --- | --- |
| Foreground occluder | 앞쪽 벽, 기둥, 난간, 프레임처럼 시야를 가리는 정적 구조물 | player / object 앞에 그려지는 visual layer |
| Collision | player 이동을 막는 논리적 영역 | 별도 `CollisionShape2D` / data로 관리 |
| Interactable object | bed, laptop, phone, power, fridge처럼 player가 선택할 수 있는 object | foreground occluder에 넣지 않음 |
| Lighting overlay | 빛, 그림자, 분위기, 네온 반사 | foreground occluder에 넣지 않음 |

`qv_room_foreground_occluders.png`는 collision이나 interaction 판정을 담당하지 않는다. visual occlusion과 gameplay collision은 비슷한 위치를 가질 수 있지만 같은 데이터로 취급하지 않는다.

## 파일 기준

기준 파일:

```text
qv_room_foreground_occluders.png
```

예상 경로:

```text
res://assets/rooms/quarterview/shell/qv_room_foreground_occluders.png
```

| File | Purpose | Canvas | Transparency | Expected z-index | Notes |
| --- | --- | --- | --- | --- | --- |
| `qv_room_foreground_occluders.png` | 앞쪽 벽 / 프레임 / 기둥 / 난간 등 player / object를 가리는 정적 구조물 | `1920x1080` same-canvas | transparent required | `80` | collision source로 사용하지 않음 |

기준:

- PNG로 제작한다.
- `1920x1080` same-canvas를 유지한다.
- transparent background가 필수다.
- floor / back wall / side wall / window layer와 origin이 같아야 한다.
- player / object보다 위에 표시한다.
- UI보다 아래에 표시한다.

## 포함할 것

- 플레이어보다 앞에 보여야 하는 앞쪽 벽 일부
- 방 전면 프레임
- 앞쪽 기둥 / 파이프 / 배관
- 화면 아래쪽 턱 또는 난간
- 욕실 / 현관 쪽 앞쪽 문틀 일부
- static room shell에 속하고 움직이지 않는 구조물
- player / object를 부분적으로 가려도 gameplay 이해를 방해하지 않는 요소

## 제외할 것

- bed / desk / laptop / phone / power / fridge / microwave / aircon 같은 interactable object
- player sprite
- dynamic object
- highlight / selection outline
- collision polygon
- shadow only overlay
- lighting / glow / neon reflection
- UI panel
- label text
- debug guide
- room object clickable area

Interactable object를 foreground occluder에 넣으면 나중에 상태 변경, hover, highlight, interaction 처리가 어려워진다. 움직이거나 상태가 바뀔 수 있는 것은 별도 object layer 또는 atlas로 관리한다.

## Godot 적용 기준

후보 노드 구조:

```text
QuarterviewRoomShellPrototype
  WorldRoot
    RoomShellRoot
      FloorLayer
      BackWallLayer
      SideWallLayer
      WindowCityViewLayer
      FurnitureLayer
      DeviceLayer
      PlayerLayer
      ObjectHighlightLayer
      ForegroundOccluderLayer
      LightingOverlayLayer
    ReferenceGuideRoot
  UILayer
```

`ForegroundOccluderLayer` 기준:

- `z-index: 80`
- player / object / device보다 위
- lighting overlay보다 아래, 또는 lighting overlay 정책에 따라 조정
- UI보다 아래
- input / collision 없음
- mouse filter / input pick 없음
- `Sprite2D`면 `centered=false`, `position=(0, 0)`, `scale=(1, 1)`
- `TextureRect`면 floor / back / side layer와 같은 rect / anchor / stretch 정책 사용

## z-index 초안

| Layer | Suggested z-index | Notes |
| --- | --- | --- |
| `FloorLayer` | `0` | 방 바닥 기준 |
| `BackWallLayer` | `10` | 뒤쪽 벽 |
| `WindowCityViewLayer` | `12` | 창밖 도시 뷰 |
| `SideWallLayer` | `15` | 측면 벽 |
| `FurnitureLayer` | `30` | 침대, 책상, 냉장고 같은 큰 가구 후보 |
| `DeviceLayer` | `35` | 노트북, Phone, COMM, NODE-17 같은 장치 후보 |
| `PlayerLayer` | `40` | Yui player 기준 |
| `ObjectHighlightLayer` | `50` | hover / interaction highlight 후보 |
| `ForegroundOccluderLayer` | `80` | player / object를 가리는 전면 구조물 |
| `LightingOverlayLayer` | `90` | 방 전체 분위기 overlay |
| `InteractionDebugLayer` | `100` | debug range / collision / label 표시 후보 |
| `UILayer` | `1000` | room shell과 완전히 분리된 UI |

실제 값은 나중 적용 시 조정할 수 있다. 다만 foreground occluder가 너무 많은 영역을 가리면 player / object 인지가 떨어지므로, 중요한 interactable object의 중심, label, prompt를 가리지 않게 한다.

## Collision / Navigation과의 관계

- `qv_room_foreground_occluders.png`는 visual layer다.
- player collision / navigation / interactable range는 별도 `CollisionShape2D` / `Area2D` / data로 관리한다.
- foreground occluder의 alpha 영역을 collision source로 자동 변환하지 않는다.
- 가려지는 영역과 이동 불가능 영역은 비슷할 수 있지만 반드시 같은 데이터는 아니다.
- 욕실 / 현관 / 침대 / 책상 주변 이동 범위는 별도 blockout / collision 작업에서 조정한다.

## Object Visibility 기준

- player 발 위치는 보이지 않아도 되지만, 몸 전체가 장시간 완전히 가려지면 안 된다.
- interact prompt `[E]` 또는 input icon은 occluder보다 위에 표시한다.
- object highlight는 occluder보다 위에 둘지 아래에 둘지 추후 결정한다.
- 기본 후보는 `ObjectHighlightLayer` z-index `50`, `ForegroundOccluderLayer` z-index `80`이다.
- highlight가 occluder에 가려져 불편하면 highlight 전용 top layer를 별도로 둔다.
- panel / UI는 항상 occluder보다 위에 둔다.

## Art 제작 기준

- same-canvas `1920x1080`을 유지한다.
- transparent background가 필수다.
- floor / back / side와 perspective가 정확히 맞아야 한다.
- occluder edge에 흰색 / 검은색 halo가 생기지 않게 alpha cleanup이 필요하다.
- 그림자만 있는 요소는 shadow overlay로 분리한다.
- 빛 / 네온 반사는 lighting 또는 reflection overlay로 분리한다.
- 오브젝트 자체는 occluder에 합치지 않는다.
- 너무 큰 전면 벽으로 gameplay 영역을 과도하게 가리지 않는다.

## 적용 전 Checklist

- [ ] `1920x1080`인지 확인
- [ ] 투명 배경인지 확인
- [ ] floor / back / side layer와 origin이 맞는지 확인
- [ ] player / object 주요 위치를 과도하게 가리지 않는지 확인
- [ ] interactable object가 PNG에 합쳐져 있지 않은지 확인
- [ ] collision source로 오해될 내용이 없는지 확인
- [ ] label / text가 들어가지 않았는지 확인
- [ ] alpha edge halo가 없는지 확인
- [ ] foreground layer만 켰을 때 포함 요소가 명확한지 확인
- [ ] all layers on 상태에서 depth가 자연스러운지 확인

## Prototype 적용 순서 후보

실제 적용은 별도 작업에서 진행한다.

1. `qv_room_foreground_occluders.png` asset 준비
2. asset path에 추가
3. `QuarterviewRoomShellPrototype`에 `ForegroundOccluderLayer` 추가
4. layer visibility toggle에 `4`번 키 추가
5. z-index `80`으로 표시
6. floor / back / side와 alignment 확인
7. player / object placeholder와 가림 정도 확인
8. alpha edge / visibility 문제 기록
9. 필요 시 원본 PNG 수정
10. 이후 lighting overlay 적용 검토

## Non-goals

- 실제 PNG asset 추가
- placeholder PNG 생성
- 이미지 생성 / 변환 / 리사이즈
- `.import` 파일 생성 / 수정
- Godot scene layer 적용
- z-index 실제 scene 반영
- collision / navigation / hitbox 수정
- `RoomObjectDefinition` 값 수정
- Main / DAY 1 / `Apartment` / `SurvivalState` 변경
