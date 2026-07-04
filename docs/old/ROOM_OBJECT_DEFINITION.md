# RoomObjectDefinition

## 목적

`RoomObjectDefinition`은 쿼터뷰 Room 오브젝트의 `key`, `zone`, `role`, `future_source`, `visual_state`, position, size, collision, interaction 정보를 Godot `Resource`로 관리하기 위한 데이터 구조다.

`QuarterviewRoomPrototype`의 기존 inline registry 값은 `RoomObjectDefinition` `.tres` 파일로 이동했다. 현재 prototype은 이 Resource들을 읽어 placeholder, prompt, panel 정보를 구성한다.

## Script Path

- `res://scripts/resources/RoomObjectDefinition.gd`

## 필드 설명

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `key` | `String` | 안정적인 내부 오브젝트 key | `laptop` |
| `display_name` | `String` | UI / prompt 표시명 | `Laptop` |
| `zone` | `String` | 방 안 구역 | `work` |
| `role` | `String` | gameplay / interaction 역할 | `laptop_job` |
| `future_source` | `String` | 향후 Apartment / Main 대응 기준 | `apartment_laptop` |
| `visual_state` | `String` | 향후 atlas / overlay 상태 key | `on` |
| `layer` | `String` | blockout / scene 배치 layer 후보 | `ObjectLayer` |
| `position` | `Vector2` | 기본 blockout 위치 | `Vector2(748, 238)` |
| `size` | `Vector2` | blockout visual 크기 | `Vector2(74, 36)` |
| `sort_y` | `int` | prototype depth ordering 기준값 | `356` |
| `color` | `Color` | placeholder blockout 색 | `Color(0.08, 0.12, 0.15, 1.0)` |
| `thickness` | `float` | pseudo 3D placeholder 두께 | `7.0` |
| `blocks` | `bool` | collision 후보 여부 | `true` |
| `interactable` | `bool` | `E` prompt / panel 후보 여부 | `true` |
| `interaction_position` | `Vector2` | prompt / interaction range 중심점 | `Vector2(748, 360)` |
| `interaction_radius` | `float` | 상호작용 거리 후보 | `96.0` |
| `collision_size` | `Vector2` | collision 크기 override. `Vector2.ZERO`이면 `size` 사용 | `Vector2.ZERO` |
| `blocker_rect` | `Rect2` | prototype collision rect 후보 | `Rect2(620, 222, 300, 122)` |
| `primary_action_label` | `String` | primary action label override | `Open Work` |
| `inspect_action_label` | `String` | inspect action label | `Inspect` |

## Zone 후보

- `entrance`
- `living`
- `work`
- `kitchen`
- `power`
- `utility`
- `background`

## Role 후보

- `manual_end_day`
- `laptop_job`
- `phone_status`
- `phone_charge`
- `power_management`
- `communication`
- `mystery_device`
- `audio_hacking_device`
- `living_appliance`
- `support_device`
- `background_life_hint`
- `background_structure`

## Visual State 후보

- `idle`
- `off`
- `on`
- `active`
- `charging`
- `signal`
- `disabled`

## Helper 함수

| Function | Purpose |
| --- | --- |
| `get_collision_size()` | `collision_size`가 `Vector2.ZERO`이면 `size`를 반환한다. |
| `get_interaction_position()` | `interaction_position`이 `Vector2.ZERO`이면 `position`을 반환한다. |
| `has_blocker_rect()` | `blocker_rect`가 실제 크기를 갖는지 확인한다. |
| `is_valid_definition()` | `key`, `display_name`, `zone`, `role`이 비어 있지 않은지 최소 검증한다. |
| `get_debug_summary()` | `key`, `zone`, `role`, `future_source`, `visual_state`를 한 줄로 요약한다. |
| `get_primary_label()` | `primary_action_label` override가 없으면 `role` 기반 기본 label을 반환한다. |

## 기본 Primary Label

| Role | Default Primary Label |
| --- | --- |
| `manual_end_day` | `Rest / End Day` |
| `laptop_job` | `Open Work` |
| `power_management` | `Open Power` |
| `communication` | `Check Signal` |
| `mystery_device` | `Inspect NODE` |
| `phone_status` | `Open Phone` |
| `phone_charge` | `Check Charge` |
| `audio_hacking_device` | `Check Audio` |
| `living_appliance` | `Inspect Appliance` |
| `support_device` | `Inspect Device` |
| `background_structure` | `Inspect` |
| `background_life_hint` | `Inspect` |
| default | `Interact` |

## 현재 작업과 다음 작업 구분

현재 작업:

- `RoomObjectDefinition` Resource class 추가
- 필드, 상수, helper 문서화
- `godot/resources/rooms/quarterview/objects/*.tres` 생성
- 기존 `QuarterviewRoomPrototype` inline registry 값을 Resource 파일로 이동
- `QuarterviewRoomPrototype`이 Resource를 읽어 object placeholder를 구성

다음 작업:

- Resource 기반 object contract를 실제 쿼터뷰 Room 이식 시 재사용할 수 있는지 검증
- 필요하면 visual mapping Resource나 atlas region mapping과 연결
- Main / DAY 1 기능 이식 여부는 별도 작업에서 판단

## 기존 Prototype과의 관계

`QuarterviewRoomPrototype`은 현재 object / interaction contract prototype이다.
`RoomObjectDefinition`은 이 contract의 source of truth를 script 내부 dictionary에서 Resource 파일로 옮기기 위한 구조다.

이번 작업에서는 실제 Main / DAY 1 이식, Phone / Outlet / Result 연결, 해킹 액션 연결, 최종 쿼터뷰 아트 적용을 하지 않는다.

## Visual Atlas Mapping

`RoomObjectDefinition` may later reference furniture atlas region keys through a separate mapping layer.
`RoomObjectDefinition` itself should not directly store raw atlas rect coordinates at this stage.

Furniture atlas region naming, pivot / anchor, z-index, and mapping schema criteria are documented in `docs/QV_FURNITURE_ATLAS_REGION_MAPPING.md`.

`RoomObjectDefinition` may also later reference work-device atlas region keys through a separate mapping layer.
Room object resources should still avoid storing raw atlas rect coordinates directly.

Work-device atlas region naming, state variation, mission-device links, pivot / anchor, and z-index criteria are documented in `docs/QV_WORK_DEVICES_ATLAS_REGION_MAPPING.md`.
