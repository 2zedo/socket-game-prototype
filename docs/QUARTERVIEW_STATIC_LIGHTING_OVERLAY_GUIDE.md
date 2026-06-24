# Quarterview Static Lighting Overlay Guide

## 목적

이 문서는 `qv_room_static_lighting_overlay.png`를 실제 Godot scene에 적용하기 전에, 쿼터뷰 room shell의 정적 조명 / 그림자 / 분위기 overlay가 무엇을 담당하고 무엇을 담당하지 않는지 고정하기 위한 기준이다.

이번 문서는 실제 PNG 에셋 적용 작업이 아니다. `QuarterviewRoomShellPrototype`, `QuarterviewGameplaySandbox`, 기존 Main / DAY 1, `Apartment`, `SurvivalState` 흐름은 변경하지 않는다.

## Static Lighting Overlay 정의

Static lighting overlay는 방 전체에 고정적으로 얹히는 조명 / 그림자 / 분위기용 시각 레이어다. 같은 canvas 기준의 PNG layer로 관리하며, player, object, collision, UI, interactable state, 실제 전력 계산을 담당하지 않는다.

명확히 구분한다:

| 항목 | 역할 | 기준 |
| --- | --- | --- |
| Static lighting overlay | 고정 분위기 조명, 부드러운 shadow / vignette, 창문 주변 약한 glow, 실내 작업등 분위기, 네온 반사 후보 | 기본 밤 분위기용 visual overlay |
| Window city view | 창밖 THE GRID 도시 / 네온 / 구조물 자체 | window layer가 담당 |
| Foreground occluder | player / object 앞을 가리는 앞쪽 벽 / 기둥 / 프레임 | occluder layer가 담당 |
| Interactable object | bed, laptop, phone, power, fridge처럼 선택 가능한 object | static overlay에 넣지 않음 |
| Dynamic lighting | 전력 상태, 시간대, 장치 on/off에 따라 바뀌는 조명 | future dynamic overlay / shader / animation 후보 |
| Collision / navigation | 이동 가능 / 불가능 영역 | lighting overlay와 무관 |

`qv_room_static_lighting_overlay.png`는 실제 gameplay light source나 전력 시스템으로 사용하지 않는다.

## 파일 기준

기준 파일:

```text
qv_room_static_lighting_overlay.png
```

예상 경로:

```text
res://assets/rooms/quarterview/shell/qv_room_static_lighting_overlay.png
```

| File | Purpose | Canvas | Transparency | Expected z-index | Notes |
| --- | --- | --- | --- | --- | --- |
| `qv_room_static_lighting_overlay.png` | 방 전체의 고정 조명 / 그림자 / 분위기 overlay | `1920x1080` same-canvas | transparent required | `90` | 실제 전력 / 조명 시스템과 연결하지 않음 |

기준:

- PNG로 제작한다.
- `1920x1080` same-canvas를 유지한다.
- transparent background가 필수다.
- floor / back wall / side wall / window / foreground layer와 origin이 같아야 한다.
- room visual layer 중 높은 z-index에 둔다.
- UI보다 아래에 표시한다.
- input / collision 없음.
- 실제 gameplay light source로 사용하지 않는다.

## z-index / Layer Order 기준

기본 권장 구조:

| Layer | Suggested z-index | Notes |
| --- | --- | --- |
| `FloorLayer` | `0` | 방 바닥 기준 |
| `WindowCityViewLayer` | `8` | 창틀 뒤에 보이는 도시 뷰 후보 |
| `BackWallLayer` | `10` | 뒤쪽 벽 / 창틀 / 프레임 |
| `SideWallLayer` | `15` | 측면 벽 |
| `FurnitureLayer` | `30` | 침대, 책상, 냉장고 같은 큰 가구 후보 |
| `DeviceLayer` | `35` | 노트북, Phone, COMM, NODE-17 같은 장치 후보 |
| `PlayerLayer` | `40` | Yui player 기준 |
| `ObjectHighlightLayer` | `50` | hover / interaction highlight 후보 |
| `ForegroundOccluderLayer` | `80` | player / object를 가리는 전면 구조물 |
| `StaticLightingOverlayLayer` | `90` | 방 전체 분위기 overlay |
| `InteractionDebugLayer` | `100` | debug range / collision / label 표시 후보 |
| `UILayer` | `1000` | room shell과 완전히 분리된 UI |

중요 기준:

- static lighting overlay는 보통 player / object / foreground 위에 얹혀 전체 분위기를 만든다.
- UI는 lighting overlay 영향을 받으면 안 되므로 `UILayer`는 항상 위에 둔다.
- interaction prompt나 debug guide가 어두워지면 안 되므로 prompt / debug layer는 lighting overlay보다 위에 둘 수 있다.
- object highlight가 overlay에 묻히면 highlight 전용 top layer를 별도로 둔다.
- foreground occluder의 명암도 overlay 영향을 받는 것이 자연스러우면 lighting overlay를 foreground보다 위에 둔다.
- foreground가 항상 선명해야 한다면 foreground를 lighting보다 위에 두는 후보도 유지한다.

### 후보 A: Lighting Overlay Above All Room Visuals

```text
ForegroundOccluderLayer: 80
StaticLightingOverlayLayer: 90
```

추천 기준:

- 방 전체 분위기를 하나의 overlay로 통일한다.
- foreground까지 같은 조명 톤을 받게 한다.
- 현재 기본 권장안이다.

### 후보 B: Foreground Above Lighting Overlay

```text
StaticLightingOverlayLayer: 75
ForegroundOccluderLayer: 80
```

추천 기준:

- foreground 프레임 / 기둥이 항상 또렷해야 한다.
- overlay가 앞쪽 구조물을 너무 흐리게 만든다.

실제 asset 적용 후 시인성에 따라 후보 A/B 중 하나를 선택한다.

## 포함할 것

- 실내 작업등의 따뜻한 빛 분위기
- 방 가장자리의 약한 비네팅
- 바닥 / 벽에 얹히는 부드러운 그림자
- 창문 주변의 약한 차가운 glow
- THE GRID 네온이 실내에 살짝 반사된 느낌
- 깊이감을 위한 가벼운 ambient shadow
- 고정된 시간대 / 기본 방 분위기를 나타내는 정적 효과

## 제외할 것

- 창밖 도시 자체
- 창틀 / 벽 / 가구 / 기둥 같은 구조물 본체
- bed / laptop / phone / power / fridge 같은 object 본체
- player sprite
- interaction prompt
- UI panel
- debug label
- collision polygon
- 선택 highlight
- 장치 on/off에 따라 바뀌어야 하는 빛
- 시간대에 따라 바뀌어야 하는 빛
- 너무 강한 glow / bloom
- 큰 글자 / 로고 / 텍스트

Static lighting overlay에 object 본체나 구조물을 섞으면 나중에 상태 변화, object 교체, occlusion 조정이 어려워진다. 동적으로 바뀌어야 하는 빛은 static overlay에 넣지 말고 dynamic overlay 후보로 분리한다.

## THE GRID 조명 디자인 기준

방 방향성:

- THE GRID 하층 주거구의 좁은 1인실
- 유이는 하층민 출신이지만 방은 작고 정돈되어 있음
- 실내는 따뜻한 작업등 / 생활감
- 창밖은 차갑고 거대한 THE GRID 네온
- 생활보다 작업 우선의 해커 방
- 더러운 슬럼보다 제한된 공간을 실용적으로 쓰는 느낌

Lighting 기준:

- 실내 중심은 따뜻한 amber / yellow 계열이다.
- 창문 근처와 외곽은 차가운 cyan / blue / purple 계열 후보다.
- 너무 화려한 cyberpunk glow보다 낮은 조도와 작업등 중심을 우선한다.
- player / object를 가릴 정도로 어둡게 만들지 않는다.
- interactable object가 배경에 묻히지 않도록 contrast를 유지한다.
- UI에는 영향을 주지 않는다.
- static overlay는 기본 밤 분위기 기준으로 둔다.
- 시간대 / 정전 / 장치 상태 변화는 별도 dynamic layer 후보로 남긴다.

## Blend / Alpha 정책

- 기본은 transparent PNG + normal alpha blend 후보다.
- 그림자 / 비네팅이 강한 경우 multiply / modulate 계열 별도 shadow overlay를 고려한다.
- glow / 네온 반사가 강한 경우 add 계열 별도 glow / reflection overlay를 고려한다.
- 한 PNG에 shadow와 glow를 모두 넣으면 blend 조정이 어려워질 수 있다.
- 초기 단계에서는 `qv_room_static_lighting_overlay.png` 하나로 시작하되, 필요 시 아래처럼 분리한다.

미래 분리 후보:

```text
qv_room_static_lighting_overlay.png
qv_room_shadow_overlay.png
qv_room_neon_reflection_overlay.png
```

역할:

| File | Purpose | Blend 후보 |
| --- | --- | --- |
| `qv_room_static_lighting_overlay.png` | 기본 분위기 명암 | normal alpha |
| `qv_room_shadow_overlay.png` | 비네팅 / 그림자 중심 | multiply / modulate |
| `qv_room_neon_reflection_overlay.png` | 창밖 네온 반사 / glow | add / mix |

이번 작업에서는 위 파일들을 만들지 않는다.

## Godot 적용 기준

후보 노드 구조:

```text
QuarterviewRoomShellPrototype
  WorldRoot
    RoomShellRoot
      FloorLayer
      WindowCityViewLayer
      BackWallLayer
      SideWallLayer
      FurnitureLayer
      DeviceLayer
      PlayerLayer
      ForegroundOccluderLayer
      StaticLightingOverlayLayer
    ReferenceGuideRoot
  UILayer
```

`StaticLightingOverlayLayer` 기준:

- room visual 위쪽에 표시한다.
- UI 아래에 둔다.
- input / collision 없음.
- mouse filter / input pick 없음.
- `Sprite2D`면 `centered=false`, `position=(0, 0)`, `scale=(1, 1)`.
- `TextureRect`면 floor / back / side layer와 같은 rect / anchor / stretch 정책 사용.
- modulate alpha 조정이 가능해야 한다.
- hidden / missing 상태에서도 prototype이 깨지지 않아야 한다.

적용 시 opacity 후보:

```text
default_alpha: 0.6 ~ 1.0
debug toggle: overlay on/off 확인
numeric key: layer visibility toggle 후보
```

이번 작업에서는 실제 scene에 적용하지 않는다.

## Dynamic Lighting과의 분리 기준

`StaticLightingOverlay`에 들어가는 것:

- 항상 켜져 있는 기본 밤 분위기
- 기본 실내 어둠
- 기본 창문 glow
- 변하지 않는 작업등 느낌

Dynamic lighting 후보로 남길 것:

- 전등 on / off
- 정전
- 노트북 화면 glow on / off
- phone 화면 glow
- 에어컨 / 냉장고 상태 표시등
- 시간대 변화
- 이벤트 / 경보 / 해킹 실패 시 붉은 경고등
- 전력 부족 상태의 flicker

`qv_room_static_lighting_overlay.png`는 기본 상태만 담당한다. 상태에 따라 달라지는 효과는 나중에 separate overlay 또는 shader / `AnimationPlayer`로 처리한다.

## 적용 전 Checklist

- [ ] `1920x1080`인지 확인
- [ ] transparent PNG인지 확인
- [ ] floor / back / side / window / foreground layer와 origin이 맞는지 확인
- [ ] player / object를 과도하게 어둡게 만들지 않는지 확인
- [ ] interactable object가 배경에 묻히지 않는지 확인
- [ ] UI / prompt / debug text에 overlay가 적용되지 않는지 확인
- [ ] 창밖 도시 view와 glow가 중복되지 않는지 확인
- [ ] shadow와 glow를 하나의 blend로 제어하기 어려우면 분리 후보를 기록
- [ ] alpha edge / halo가 없는지 확인
- [ ] all layers on 상태에서 실내 따뜻함 / 창밖 차가움 대비가 자연스러운지 확인
- [ ] overlay만 껐을 때 room shell 구조가 여전히 읽히는지 확인

## Prototype 적용 순서 후보

실제 적용은 별도 작업에서 진행한다.

1. `qv_room_static_lighting_overlay.png` asset 준비
2. asset path에 추가
3. `QuarterviewRoomShellPrototype`에 `StaticLightingOverlayLayer` 추가
4. layer visibility toggle에 `5`번 또는 `L` 키 추가
5. z-index 후보 A/B 중 실제 asset에 맞게 선택
6. alpha / modulate 기본값 조정
7. floor / back / side / window / foreground와 alignment 확인
8. player / object placeholder 시인성 확인
9. shadow / glow 분리가 필요한지 기록
10. 이후 dynamic lighting 정책 검토

## Non-goals

- 실제 PNG asset 추가
- placeholder PNG 생성
- 이미지 생성 / 변환 / 리사이즈
- `.import` 파일 생성 / 수정
- Godot scene layer 적용
- z-index 실제 scene 반영
- blend mode 실제 scene 반영
- collision / navigation / hitbox 수정
- `RoomObjectDefinition` 값 수정
- Main / DAY 1 / `Apartment` / `SurvivalState` 변경
