# RoomObjectDefinition

## 목적

`RoomObjectDefinition`은 쿼터뷰 Room 오브젝트의 `key`, `zone`, `role`, `future_source`, `visual_state`, position, size, collision, interaction 정보를 Godot `Resource`로 관리하기 위한 데이터 구조다.

이 작업은 기존 `QuarterviewRoomPrototype` registry를 바로 대체하지 않는다. 현재는 Resource class와 필드 계약만 추가하고, 다음 단계에서 기존 registry 데이터를 점진적으로 `.tres` 파일로 이전한다.

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
| `blocks` | `bool` | collision 후보 여부 | `true` |
| `interactable` | `bool` | `E` prompt / panel 후보 여부 | `true` |
| `interaction_radius` | `float` | 상호작용 거리 후보 | `96.0` |
| `collision_size` | `Vector2` | collision 크기 override. `Vector2.ZERO`이면 `size` 사용 | `Vector2.ZERO` |
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
- 기존 `QuarterviewRoomPrototype` registry 유지
- 실제 `.tres` object resource 생성 안 함

다음 작업:

- Quarterview Object Registry Resource화
- 기존 registry 데이터를 `RoomObjectDefinition` `.tres` 파일로 이전
- 후보 경로: `res://resources/rooms/quarterview/objects/*.tres`
- `QuarterviewRoomPrototype`이 Resource를 읽도록 변경

## 기존 Prototype과의 관계

`QuarterviewRoomPrototype`은 현재 object / interaction contract prototype이다.
`RoomObjectDefinition`은 이 contract를 Resource화하기 위한 준비 단계다.

이번 작업에서는 실제 Main / DAY 1 이식, Phone / Outlet / Result 연결, 해킹 액션 연결, 최종 쿼터뷰 아트 적용을 하지 않는다.
