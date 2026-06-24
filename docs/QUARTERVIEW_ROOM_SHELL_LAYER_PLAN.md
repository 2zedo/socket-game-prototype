# 쿼터뷰 Room Shell Layer 적용 계획

## 목적

이 문서는 쿼터뷰 방의 room shell 이미지를 실제 Godot scene에 적용하기 전에, 파일명, 경로, layer 구조, z-index, import 설정, 적용 순서를 고정하기 위한 계획이다.

이번 문서는 실제 PNG 에셋 적용 작업이 아니다. `QuarterviewGameplaySandbox`, `QuarterviewPerspectiveBlockout`, 기존 Main / DAY 1, `Apartment`, `SurvivalState` 흐름은 변경하지 않는다.

## 기본 원칙

- 모든 room shell layer는 `1920x1080` 기준으로 제작한다.
- 모든 shell layer는 같은 canvas, 같은 origin, 같은 방 기준 좌표를 공유한다.
- Godot에서는 각 layer를 동일 위치에 겹쳐 배치한다.
- floor, wall, window, foreground occluder, lighting overlay를 분리한다.
- player, furniture, interactable object, UI는 shell layer와 책임을 분리한다.
- 이미지 생성 결과를 그대로 production asset으로 쓰지 않을 수 있다. 필요하면 수동 cleanup, paintover, slicing을 거친다.
- layer 간 perspective가 어긋나면 Godot에서 억지로 맞추지 말고 원본 layer를 수정한다.

## Room Shell Layer 목록

| File | Purpose | Transparent | Expected z-index | Notes |
| --- | --- | --- | --- | --- |
| `qv_room_floor_base.png` | 바닥 기본 레이어 | partially or full canvas | `0` | player / furniture 아래에 위치한다. 완전 top-down 사각형이 아니라 쿼터뷰 바닥 축을 유지한다. |
| `qv_room_walls_back.png` | 뒤쪽 벽 | partially transparent | `10` | 창문, 작업 구역, 후면 구조의 기준이 된다. |
| `qv_room_walls_side.png` | 좌 / 우 측면 벽 | partially transparent | `15` | cutaway room 감각을 만들되 앞쪽 시야를 막지 않는다. |
| `qv_room_window_city_view.png` | 창밖 THE GRID 도시 뷰 | partially transparent | `12` | 벽 안쪽 창 영역에만 표시한다. 차가운 외부 네온 기준 레이어다. |
| `qv_room_foreground_occluders.png` | 앞쪽 벽, 기둥, 가림 요소 | transparent | `80` | player / object 일부를 가릴 수 있다. occlusion 테스트의 핵심 레이어다. |
| `qv_room_static_lighting_overlay.png` | 고정 조명 / 분위기 오버레이 | transparent | `90` | blend / add / modulate 정책은 실제 적용 시 결정한다. |

`qv_room_window_city_view.png` is the visual-only city view seen through the room window. It should usually sit behind the wall / window frame layer and below player / object layers. It must not contain interior wall frames, interactable objects, collision data, or room lighting overlays. Detailed criteria are documented in `docs/QUARTERVIEW_WINDOW_CITY_VIEW_GUIDE.md`.

`qv_room_foreground_occluders.png` is a visual-only static occlusion layer. It should sit above player / object layers but below lighting / UI. It must not contain interactable objects or collision data. Detailed criteria are documented in `docs/QUARTERVIEW_FOREGROUND_OCCLUDER_GUIDE.md`.

### 선택 후보

| File | Purpose | Transparent | Expected z-index | Notes |
| --- | --- | --- | --- | --- |
| `qv_room_shadow_overlay.png` | 고정 그림자 / 접지감 보강 | transparent | `5` | floor 위, furniture / player 아래 후보. |
| `qv_room_neon_reflection_overlay.png` | 창밖 네온 반사 | transparent | `88` | lighting overlay보다 아래 또는 같은 그룹 후보. |
| `qv_room_interaction_hint_overlay.png` | 아트 레벨의 상호작용 힌트 후보 | transparent | `50` | 실제 gameplay prompt와 혼동하지 않게 주의한다. |
| `qv_room_collision_reference.png` | collision / walkable 기준 확인용 | transparent | debug only | 실제 게임 표시용이 아니라 제작 참고용 후보. |

## Godot 노드 구조 후보

실제 적용 시 목표 구조 후보는 아래와 같다.

```text
QuarterviewRoomShell
  RoomShellRoot
    FloorLayer
    FloorShadowOverlay
    BackWallLayer
    WindowCityViewLayer
    SideWallLayer
    FurnitureLayer
    DeviceLayer
    PlayerLayer
    ObjectHighlightLayer
    ForegroundOccluderLayer
    LightingOverlayLayer
    InteractionDebugLayer
  UILayer
```

- 이번 작업에서는 scene을 만들거나 수정하지 않는다.
- 위 구조는 실제 적용 시의 목표 구조다.
- player, interactable object, foreground occluder, UI는 서로 다른 책임을 가진다.
- UI는 room shell layer와 분리한다.
- `QuarterviewPerspectiveBlockout`의 시점 검증 결과와 `QuarterviewGameplaySandbox`의 기능 연결 구조를 섞지 않는다.

## z-index 정책 초안

| Layer | Suggested z-index | Notes |
| --- | --- | --- |
| `FloorLayer` | `0` | 방 바닥 기준. |
| `FloorShadowOverlay` | `5` | 고정 그림자 후보. |
| `BackWallLayer` | `10` | 뒤쪽 벽. |
| `WindowCityViewLayer` | `12` | 창밖 도시 뷰. |
| `SideWallLayer` | `15` | 측면 벽. |
| `FurnitureLayer` | `30` | 침대, 책상, 냉장고 같은 큰 가구 후보. |
| `DeviceLayer` | `35` | 노트북, Phone, COMM, NODE-17 같은 장치 후보. |
| `PlayerLayer` | `40` | Yui player 기준. |
| `ObjectHighlightLayer` | `50` | hover / interaction highlight 후보. |
| `ForegroundOccluderLayer` | `80` | player / object를 가릴 수 있는 전면 요소. |
| `LightingOverlayLayer` | `90` | 방 전체 분위기 overlay. |
| `InteractionDebugLayer` | `100` | debug range / collision / label 표시 후보. |
| `UILayer` | `1000` | room shell과 완전히 분리된 UI. |

실제 값은 Godot 적용 시 조정할 수 있다. 다만 foreground occluder와 lighting overlay는 room 안의 object보다 위쪽에 있어야 하며, UI는 room shell z-index 정책 바깥에 둔다.

## 좌표 / Canvas 기준

- 모든 room shell PNG는 `1920x1080` 기준이다.
- 모든 shell layer는 동일한 origin을 공유한다.
- Godot에서는 각 `Sprite2D` 또는 `TextureRect`를 같은 position에 둔다.
- layer별 이미지가 서로 crop되거나 scale이 다르면 안 된다.
- 배경만 따로 확대 / 축소하지 않는다.
- player / object 위치는 room shell 기준 좌표에 맞춰 별도로 배치한다.

Godot 적용 후보:

- `Sprite2D` 사용 시 `centered=false` 또는 일관된 offset 정책을 사용한다.
- `TextureRect` 사용 시 full rect 기준 anchor를 사용한다.
- 둘 중 하나로 통일한다.
- 실제 적용 전 어떤 방식을 쓸지는 별도 적용 작업에서 결정한다.

## Import 설정 후보

실제 PNG 추가 후 아래 설정을 확인한다.

- Filter: `nearest` 또는 프로젝트 art style에 맞는 filter
- Mipmaps: off
- Compression: lossless 또는 VRAM compressed 여부는 실제 파일 크기를 보고 결정
- Repeat: disabled
- Premultiplied alpha 여부 확인
- transparent PNG edge fringe 확인

이번 문서 작업에서는 실제 `.import` 파일을 생성하거나 수정하지 않는다.

주의:

- layer edge에 흰색 / 검은색 halo가 생기면 alpha cleanup이 필요하다.
- 투명 PNG가 겹칠 때 조명 overlay의 blend mode를 별도 확인한다.
- import 설정은 실제 PNG가 들어온 뒤 파일 크기와 아트 스타일을 보고 확정한다.

## Asset Path 후보

실제 파일을 넣을 후보 경로:

```text
godot/assets/rooms/quarterview/shell/
```

예상 파일:

```text
godot/assets/rooms/quarterview/shell/qv_room_floor_base.png
godot/assets/rooms/quarterview/shell/qv_room_walls_back.png
godot/assets/rooms/quarterview/shell/qv_room_walls_side.png
godot/assets/rooms/quarterview/shell/qv_room_window_city_view.png
godot/assets/rooms/quarterview/shell/qv_room_foreground_occluders.png
godot/assets/rooms/quarterview/shell/qv_room_static_lighting_overlay.png
```

선택 후보:

```text
godot/assets/rooms/quarterview/shell/references/
godot/assets/rooms/quarterview/shell/source/
godot/assets/rooms/quarterview/shell/export/
```

이번 작업에서는 위 폴더나 PNG 파일을 실제로 만들지 않는다. 현재 repo에는 기존 `godot/assets/art/environment/room/` 등 P0용 경로가 있지만, 쿼터뷰 room shell은 별도 future path로 분리할 후보로 둔다.

## Floor Base 적용 Prototype

`qv_room_floor_base.png` 적용은 먼저 `res://scenes/prototypes/QuarterviewRoomShellPrototype.tscn`에서 검증한다.

- prototype은 `res://assets/rooms/quarterview/shell/qv_room_floor_base.png`를 runtime에서 로드한다.
- `qv_room_walls_back.png`와 `qv_room_walls_side.png`도 floor base 다음 단계로 같은 prototype에서 검증한다.
- back wall과 side wall은 floor base와 같은 `1920x1080` canvas, 같은 origin, 같은 scale 정책을 공유해야 한다.
- asset이 있으면 `1920x1080` image size와 expected canvas match 여부를 표시한다.
- asset이 없으면 missing placeholder와 expected path를 표시한다.
- 현재 이 prototype은 floor / back wall / side wall까지 확인하며, window, occluder, lighting layer는 실제로 로드하지 않는다.

## 이미지 생성 / 편집 파이프라인

1. room concept 확정
2. `1920x1080` 기준 shell layer 생성
3. 각 layer가 같은 canvas인지 확인
4. 투명 배경 / alpha edge 확인
5. 실제 Godot asset path에 추가
6. import 설정 확인
7. `QuarterviewPerspectiveBlockout` 또는 별도 `RoomShellPrototype`에 layer 적용
8. player / object 위치 조정
9. foreground occlusion 확인
10. lighting overlay 강도 조정

이미지 생성 결과는 production asset이 아니라 시작점일 수 있다. perspective, edge, alpha, object separation이 어긋나면 Godot scene에서 보정하기보다 원본 layer를 다시 정리한다.

## 쿼터뷰 방 디자인 기준

자세한 art direction은 `docs/QUARTERVIEW_ROOM_DIRECTION.md`를 따른다. 이 문서에서는 room shell layer 적용에 필요한 기준만 요약한다.

- THE GRID 하층 주거구의 좁은 1인실
- 하층민 출신이지만 뒷세계 해커 / 정보 노동으로 어느 정도 벌이가 있어 작지만 정돈된 방
- 생활보다 작업 우선
- 실내는 따뜻한 작업등, 창밖은 차가운 THE GRID 네온
- 스피커는 장식이 아니라 해킹 / 음향 분석 장비
- 식물은 많지 않고 작은 화분 하나 정도만 허용
- 욕실 / 현관은 직접 라벨링하지 않고 문, 타일, 환기구, 수건 등으로 암시
- 더러운 슬럼보다 제한된 공간을 실용적으로 쓰는 느낌

## 실제 적용 순서 후보

1. room shell layer PNG 준비
2. asset path에 shell layer 추가
3. `RoomShellPrototype.tscn` 또는 `QuarterviewPerspectiveBlockout`에 layer 적용
4. import 설정 확인
5. z-index / occluder 확인
6. player / object anchor 조정
7. `RoomObjectDefinition`과 object 위치 대응
8. `QuarterviewGameplaySandbox`로 기능 연결 검토

이번 작업이 끝나도 실제 적용은 하지 않는다. 실제 PNG 추가, import 설정, scene layer 적용, collision / object 위치 조정은 별도 작업으로 진행한다.

## 이번 단계에서 하지 않는 것

- PNG 에셋 추가
- asset folder 생성
- `.import` 파일 생성 / 수정
- Godot scene 수정
- z-index 실제 scene 반영
- collision / hitbox 수정
- `RoomObjectDefinition` 값 수정
- Main / DAY 1 / `Apartment` / `SurvivalState` 변경
