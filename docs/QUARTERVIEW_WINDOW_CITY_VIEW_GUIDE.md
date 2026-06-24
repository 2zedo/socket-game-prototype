# Quarterview Window City View Guide

## 목적

이 문서는 `qv_room_window_city_view.png`를 실제 Godot scene에 적용하기 전에, 쿼터뷰 room shell의 창밖 THE GRID 도시 뷰 레이어가 무엇을 담당하고 무엇을 담당하지 않는지 고정하기 위한 기준이다.

이번 문서는 실제 PNG 에셋 적용 작업이 아니다. `QuarterviewRoomShellPrototype`, `QuarterviewGameplaySandbox`, 기존 Main / DAY 1, `Apartment`, `SurvivalState` 흐름은 변경하지 않는다.

## Window City View 정의

Window city view는 방 안의 창문 너머로 보이는 THE GRID 내부 도시, 구조물, 네온 조명, 원거리 시설을 표현하는 정적 배경 레이어다. wall frame 안쪽에 보이는 외부 시각 정보만 담당하며, 같은 canvas 기준의 PNG layer로 관리한다.

명확히 구분한다:

| 항목 | 역할 | 기준 |
| --- | --- | --- |
| Window city view | 창문 너머 도시 / 구조물 / 네온 / 원거리 실루엣 | wall frame 뒤 또는 window opening 안쪽의 visual layer |
| Back wall / side wall | 창틀, 벽면, 창문 프레임, 실내 구조물 | wall shell layer가 담당 |
| Lighting overlay | 실내 조명, 네온 반사, glow, 그림자, 비네팅 | 별도 overlay로 관리 |
| Foreground occluder | player / object 앞을 가리는 앞쪽 벽 / 기둥 / 프레임 | window view와 분리 |
| Interactable object | bed, laptop, phone, power, fridge처럼 player가 선택할 수 있는 object | window view에 넣지 않음 |
| Collision / navigation | 이동 가능 / 불가능 영역 | window city view와 무관 |

`qv_room_window_city_view.png`는 player, object, collision, UI, lighting overlay를 담당하지 않는다.

## 파일 기준

기준 파일:

```text
qv_room_window_city_view.png
```

예상 경로:

```text
res://assets/rooms/quarterview/shell/qv_room_window_city_view.png
```

| File | Purpose | Canvas | Transparency | Expected z-index | Notes |
| --- | --- | --- | --- | --- | --- |
| `qv_room_window_city_view.png` | 창밖 THE GRID 도시 / 네온 / 원거리 구조물 | `1920x1080` same-canvas | visible window area outside transparent | `8` or `12` depending wall frame policy | collision source로 사용하지 않음 |

기준:

- PNG로 제작한다.
- `1920x1080` same-canvas를 유지한다.
- transparent background 또는 window area 외부 투명 처리를 사용한다.
- floor / back wall / side wall layer와 origin이 같아야 한다.
- window frame 뒤 또는 window opening 안쪽에 표시한다.
- player / object보다 아래에 표시한다.
- wall frame과 충돌하지 않게 배치한다.
- UI보다 아래에 표시한다.

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
| `LightingOverlayLayer` | `90` | 방 전체 분위기 overlay |
| `InteractionDebugLayer` | `100` | debug range / collision / label 표시 후보 |
| `UILayer` | `1000` | room shell과 완전히 분리된 UI |

핵심은 창밖 도시가 창틀 뒤에 있고, 실내 오브젝트와 player보다 아래에 있다는 점이다. lighting overlay는 window glow / reflection과 별도로 관리한다.

### 후보 A: Window View Behind Wall Frame

```text
WindowCityViewLayer: 8
BackWallLayer: 10
```

추천 기준:

- back wall PNG에 창틀 / 프레임이 포함되어 있다.
- window city view는 창문 구멍 뒤에 보이기만 한다.
- 현재 기본 권장안이다.

### 후보 B: Window View Embedded Above Back Wall

```text
BackWallLayer: 10
WindowCityViewLayer: 12
SideWallLayer: 15
```

추천 기준:

- back wall PNG에 창문 구멍 / 프레임이 완전히 분리되어 있지 않다.
- window view를 별도 mask / clip으로 제어해야 한다.
- 기존 `QUARTERVIEW_ROOM_SHELL_LAYER_PLAN.md`의 `WindowCityViewLayer: 12`는 이 후보에 해당할 수 있다.

실제 asset slicing 결과에 따라 후보 A/B 중 하나를 선택한다.

## 포함할 것

- THE GRID 내부 도시의 원거리 네온
- 차가운 청색 / 보라색 계열의 외부 조명
- 수직 도시 구조물 실루엣
- 멀리 보이는 방공호형 도시 구조
- 하층 주거구의 통로 / 배관 / 관리 시설 암시
- 작고 흐릿한 광고판 / 신호등 느낌의 빛
- 내부 공간과 대비되는 차가운 외부 분위기
- 창문 영역 안에서만 보이는 원거리 배경

## 제외할 것

- 실내 벽 / 창틀 / 프레임
- 실내 furniture / device / object
- player sprite
- collision polygon
- interaction label
- UI panel
- 전면 occluder
- 실내 조명 glow
- 방 안쪽 그림자
- 큰 글자 로고 / 텍스트
- 너무 구체적인 외부 캐릭터 / 군중 / 차량
- 실제 바깥 자연 풍경

Window city view에 창틀이나 실내 벽을 포함하면 back wall layer와 겹쳐 관리가 어려워진다. 도시 빛 자체는 window layer에 들어갈 수 있지만, 실내에 비치는 glow / reflection은 lighting overlay로 분리하는 것이 좋다.

## THE GRID 디자인 기준

방 방향성:

- THE GRID 하층 주거구의 좁은 1인실
- 유이는 하층민 출신이지만 방은 작고 정돈되어 있음
- 실내는 따뜻한 작업등 / 생활감
- 창밖은 차갑고 거대한 THE GRID 네온
- 바깥 세계가 아니라 도시 내부의 통제된 공간 느낌
- 방 안의 따뜻함과 창밖의 차가움이 대비되어야 함

Window city view 기준:

- 너무 아름다운 야경보다 압박감 있는 인공 도시를 우선한다.
- 자연 풍경은 금지한다.
- 초고층 스카이라인보다 방공호형 / 수직 구획 / 하층 시설 느낌을 우선한다.
- 창밖이 너무 밝아 실내 object를 압도하지 않게 한다.
- 시각적 디테일은 많아도 interactable object보다 주목도가 낮아야 한다.
- 멀리 있는 느낌을 위해 살짝 흐림 / 저채도 / 낮은 contrast 후보를 검토한다.
- 네온은 차갑게, 실내 작업등은 따뜻하게 대비한다.

## Alpha / Mask / Crop 기준

- same-canvas `1920x1080`을 유지한다.
- 창문 밖으로 보이는 영역 외에는 투명 처리하는 것을 기본 후보로 한다.
- 창틀 / 벽이 back wall layer에 있으면 window city view는 그 뒤에 깔린다.
- window view가 창문 영역 밖으로 새면 안 된다.
- edge halo가 생기면 alpha cleanup이 필요하다.
- 창문 마스크를 별도 PNG로 만들지, back wall alpha로 가릴지는 실제 적용 때 결정한다.
- 현재 기준은 별도 mask file 없이 same-canvas transparent PNG로 시작한다.

미래 mask 후보:

```text
qv_room_window_mask.png
```

이번 작업에서는 mask 파일을 만들지 않는다.

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
      LightingOverlayLayer
    ReferenceGuideRoot
  UILayer
```

`WindowCityViewLayer` 기준:

- player / object / device보다 아래
- wall frame과 맞는 z-index
- input / collision 없음
- mouse filter / input pick 없음
- `Sprite2D`면 `centered=false`, `position=(0, 0)`, `scale=(1, 1)`
- `TextureRect`면 floor / back / side layer와 같은 rect / anchor / stretch 정책 사용
- hidden / missing 상태에서도 prototype이 깨지지 않아야 함

## Lighting Overlay와의 분리 기준

`WindowCityViewLayer`에 들어가는 것:

- 창밖 도시 자체
- 원거리 네온 간판 / 조명
- 창문 너머 구조물

`LightingOverlayLayer`에 들어가는 것:

- 실내 벽 / 바닥에 비치는 네온 반사
- 창문 주변 glow
- 실내 작업등 빛
- 방 전체 분위기 조명
- 그림자 / 비네팅

Window city view가 너무 강한 glow를 자체 포함하면 조명 조절이 어려워진다. 실내 반사는 별도 overlay로 빼는 것이 나중에 시간대 / 전력 상태 / 조명 상태 변화에 유리하다.

## 적용 전 Checklist

- [ ] `1920x1080`인지 확인
- [ ] floor / back / side layer와 origin이 맞는지 확인
- [ ] 창문 영역 밖으로 도시 이미지가 새지 않는지 확인
- [ ] 창틀 / 벽이 window layer에 섞이지 않았는지 확인
- [ ] 자연 풍경이 아닌 THE GRID 내부 도시 느낌인지 확인
- [ ] 실내 object보다 주목도가 과하지 않은지 확인
- [ ] 네온 glow가 lighting overlay와 중복되지 않는지 확인
- [ ] alpha edge halo가 없는지 확인
- [ ] wall frame 뒤에 자연스럽게 보이는지 확인
- [ ] window layer만 켰을 때 포함 요소가 명확한지 확인
- [ ] all layers on 상태에서 실내 / 외부 대비가 자연스러운지 확인

## Prototype 적용 순서 후보

실제 적용은 별도 작업에서 진행한다.

1. `qv_room_window_city_view.png` asset 준비
2. asset path에 추가
3. `QuarterviewRoomShellPrototype`에 `WindowCityViewLayer` 추가
4. layer visibility toggle에 `4`번 또는 `W` 키 추가
5. z-index 후보 A/B 중 실제 asset에 맞게 선택
6. floor / back / side와 alignment 확인
7. 창틀 뒤에 자연스럽게 보이는지 확인
8. glow / reflection이 과하면 lighting overlay로 분리
9. 필요 시 원본 PNG 수정
10. 이후 foreground occluder / lighting overlay 적용 검토

## Non-goals

- 실제 PNG asset 추가
- placeholder PNG 생성
- 이미지 생성 / 변환 / 리사이즈
- mask PNG 생성
- `.import` 파일 생성 / 수정
- Godot scene layer 적용
- z-index 실제 scene 반영
- collision / navigation / hitbox 수정
- `RoomObjectDefinition` 값 수정
- Main / DAY 1 / `Apartment` / `SurvivalState` 변경
