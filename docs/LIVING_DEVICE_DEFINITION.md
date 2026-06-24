# LivingDeviceDefinition

## 목적

`LivingDeviceDefinition`은 쿼터뷰 Room의 생활 가전 / 생활 유지 장치를 Godot `Resource`로 관리하기 위한 데이터 구조다.

이 Resource는 냉장고, 전자레인지, 에어컨, 형광등, UPS 같은 장기 후보가 어떤 방 오브젝트와 연결될지, 어떤 전력 모델을 가질지, 하루 루프에서 어떤 생활 효과 후보를 가질지 기록하기 위한 준비 단계다.

이번 작업에서는 `LivingDeviceDefinition` class와 테스트만 추가한다. 실제 `.tres` 생활 장치 Resource는 만들지 않고, `SurvivalState`, `OutletMode`, `PhoneUI`, `Result`, Main / DAY 1 흐름에도 연결하지 않는다.

## Script Path

- `res://scripts/resources/LivingDeviceDefinition.gd`

## DeviceDefinition과의 차이

| Resource | 현재 역할 | 예시 | 연결 상태 |
| --- | --- | --- | --- |
| `DeviceDefinition` | 현재 DAY 1 멀티탭 장치의 이름, 슬롯, 부하, 시간당 소비, Result flag를 소유한다. | Laptop, Charger, Communication Device, Fan, Light | `SurvivalState` / `OutletMode` / Result 흐름에 사용 중 |
| `LivingDeviceDefinition` | 장기 생활 가전 / 생활 유지 장치의 전력 모델, 생활 효과, Result 후보 문구를 정의하기 위한 구조다. | Fridge, Microwave, Air Conditioner, Fluorescent Light, UPS | 아직 Main / DAY 1에 연결하지 않음 |

`LivingDeviceDefinition`은 `DeviceDefinition`을 대체하지 않는다. 기존 DAY 1 장치 Resource 값은 그대로 유지하고, 생활 장치 확장이나 QuarterviewGameplaySandbox 단계에서 별도로 검증한다.

## 필드 설명

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `device_key` | `String` | 생활 장치의 안정적인 내부 key | `fridge` |
| `display_name` | `String` | UI / debug 표시명 | `Fridge` |
| `description` | `String` | 장치 기획 설명 | `Keeps food preserved overnight.` |
| `room_object_key` | `String` | 대응할 `RoomObjectDefinition.key` 후보 | `fridge` |
| `device_type` | `String` | 장치 분류 | `continuous` |
| `power_model` | `String` | 전력 처리 방식 | `continuous` |
| `required_power_device_key` | `String` | 향후 필요할 `DeviceDefinition` key 후보 | `charger` |
| `uses_outlet_slot` | `bool` | 멀티탭 slot을 쓰는지 여부 후보 | `false` |
| `uses_dedicated_circuit` | `bool` | 벽 전원 / 전용 회로 사용 후보 | `true` |
| `drain_per_game_hour` | `float` | 지속 소비 후보값 | `0.5` |
| `instant_power_cost` | `float` | 1회 사용 즉시 소비 후보값 | `0.7` |
| `use_duration_game_minutes` | `float` | 1회 사용 시 경과 시간 후보 | `15.0` |
| `comfort_delta` | `float` | 편안함 변화 후보 | `1.0` |
| `fatigue_delta` | `float` | 피로 변화 후보 | `-0.5` |
| `focus_delta` | `float` | 집중력 변화 후보 | `0.5` |
| `food_preservation_delta` | `float` | 식량 보존 변화 후보 | `1.0` |
| `can_be_toggled` | `bool` | 켜고 끌 수 있는지 여부 후보 | `true` |
| `can_fail` | `bool` | 고장 / 실패 상태 후보 여부 | `false` |
| `requires_maintenance` | `bool` | 유지보수 후보 여부 | `false` |
| `result_flag_key` | `String` | 향후 Result 기록 key 후보 | `fridge_kept_on` |
| `active_result_text` | `String` | 켜져 있었을 때 Result 후보 문장 | `The fridge stayed cold.` |
| `inactive_result_text` | `String` | 꺼져 있었을 때 Result 후보 문장 | `The fridge was left off.` |

## Device Type 후보

- `continuous`: 냉장고 / 에어컨처럼 지속적으로 관리되는 생활 장치
- `instant`: 전자레인지처럼 짧은 순간에 전력을 쓰는 장치
- `storage`: UPS처럼 전력이나 상태를 저장하는 장치
- `environment`: 온도 / 공기 / 생활 환경에 영향을 주는 장치
- `background_fixture`: 형광등처럼 방 기본 설비에 가까운 장치
- `support`: 생활 또는 해킹 작업을 보조하는 장치

## Power Model 후보

- `continuous`: 켜져 있는 동안 시간당 전력을 소비한다.
- `instant`: 사용 시 즉시 전력을 소비한다.
- `dedicated_circuit`: 멀티탭보다 벽 전원 / 전용 회로가 자연스럽다.
- `passive`: 직접 소비 계산보다 기본 배급 / 배경 설비로 다룬다.
- `storage`: 전력을 저장량으로 전환한다.
- `none`: 현재 전력 모델이 없거나 배경 암시용이다.

## Effect 후보

- `comfort`
- `fatigue`
- `focus`
- `food_preservation`

이 값들은 아직 실제 컨디션 시스템과 연결하지 않는다. 장기적으로 하루 루프 / Result / 생존 압박에서 어떤 효과를 줄지 정리하기 위한 후보 필드다.

## Helper 함수

| Function | Purpose |
| --- | --- |
| `is_valid_definition()` | `device_key`, `display_name`, `room_object_key`, `device_type`, `power_model`과 기본 전력 정책을 검증한다. |
| `get_debug_summary()` | device key, room object key, type, power model, drain, instant cost를 한 줄로 요약한다. |
| `is_continuous()` | 지속 소비 장치 / 전력 모델인지 확인한다. |
| `is_instant()` | 순간 소비 장치 / 전력 모델인지 확인한다. |
| `is_storage()` | 저장 장치 / 저장 전력 모델인지 확인한다. |
| `is_background_fixture()` | 기본 설비 후보인지 확인한다. |
| `uses_direct_outlet()` | 멀티탭 slot 사용 후보인지 확인한다. |
| `uses_room_circuit()` | 벽 전원 / 전용 회로 사용 후보인지 확인한다. |
| `get_power_cost_for_use()` | 즉시 사용 전력 후보값을 반환한다. |
| `get_drain_per_game_hour()` | 시간당 지속 소비 후보값을 반환한다. |
| `get_effect_summary()` | 생활 효과 후보값을 stable key dictionary로 반환한다. |
| `get_result_text(active)` | active / inactive 상태별 Result 후보 문구 또는 fallback 문구를 반환한다. |

## 장치 후보

| Candidate | Room Object Key | Device Type | Power Model | Intended Role | Current Status |
| --- | --- | --- | --- | --- | --- |
| Fridge | `fridge` | `continuous` | `continuous` 또는 `dedicated_circuit` | 식량 보존 / 장기 생활 유지 | candidate only |
| Microwave | `microwave` | `instant` | `instant` | 식사 / 컨디션 회복용 순간 소비 | candidate only |
| Air Conditioner | `aircon` | `environment` | `continuous` 또는 `dedicated_circuit` | 열기 / 피로 / 집중력 관리, Fan 장기 대체 후보 | candidate only |
| Fluorescent Light | `fluorescent_light` 후보 | `background_fixture` | `passive` 또는 `dedicated_circuit` | 기본 설비 / 시간 분위기 연출 | candidate only |
| UPS | `ups` | `storage` | `storage` | 전력 저장 / 비상 보조 | candidate only |

## 현재 작업과 다음 작업 구분

현재 작업:

- `LivingDeviceDefinition` Resource class 추가
- 필드, 상수, helper 문서화
- GUT helper 테스트 추가
- 기존 `DeviceDefinition`, `RoomObjectDefinition`, `SurvivalState`, Main / DAY 1 흐름은 유지

다음 작업 후보:

- 생활 장치 후보별 `.tres` 작성
- QuarterviewGameplaySandbox에서 생활 장치 panel / no-op flow 확인
- 냉장고 / 전자레인지 / 에어컨의 실제 전력 모델과 하루 정산 영향 설계
- `SurvivalState`나 별도 생활 상태 시스템과 연결할지 결정

## 기존 시스템과의 관계

- `SurvivalState`는 현재 DAY 1 전력, 시간, active / connected 상태의 source of truth로 유지한다.
- `RoomObjectDefinition`은 방 오브젝트의 위치, role, prompt, collision 후보를 소유한다.
- `LivingDeviceDefinition`은 장기 생활 장치의 행동, 효과, 전력 모델 후보를 소유한다.
- `room_object_key`는 나중에 `RoomObjectDefinition.key`와 생활 장치 정의를 연결하는 기준이 될 수 있다.

이번 단계에서는 실제 기능 연결, Result 반영, Phone / Outlet UI 연결, 쿼터뷰 Main 교체, 생활 장치 `.tres` 생성을 하지 않는다.
