# 쿼터뷰 오브젝트 계약

## 목적

이 문서는 `QuarterviewRoomPrototype`의 오브젝트 registry와 기존 탑뷰 Apartment 기능을 나중에 연결할 때의 기준을 정리한다.

현재 문서는 기능 이식 계획이 아니라, 실제 연결 전에 object key, zone, role, future source, visual state를 흔들리지 않게 고정하기 위한 계약이다.

## Object Key 표

| key | zone | role | future_source | visual_state 후보 | 구현 상태 |
| --- | --- | --- | --- | --- | --- |
| `door` | `entrance` | `background_structure` | `none` | `idle` | `background_hint` |
| `bathroom_door` | `utility` | `background_structure` | `none` | `idle` | `background_hint` |
| `bed` | `living` | `manual_end_day` | `apartment_bed` | `idle` | `existing_apartment_equivalent` |
| `desk` | `work` | `support_device` | `future_desk` | `idle` | `prototype_only` |
| `laptop` | `work` | `laptop_job` | `apartment_laptop` | `off`, `on` | `existing_apartment_equivalent` |
| `phone` | `living` | `phone_charge` | `apartment_phone_or_charger` | `idle`, `charging` | `existing_apartment_equivalent` |
| `power` | `power` | `power_management` | `apartment_outlet` | `idle`, `active` | `existing_apartment_equivalent` |
| `comm` | `work` | `communication` | `apartment_communication` | `off`, `on`, `signal` | `existing_apartment_equivalent` |
| `node17` | `work` | `mystery_device` | `future_node17` | `off`, `on`, `signal` | `future_candidate` |
| `speaker` | `work` | `audio_hacking_device` | `future_audio_hacking` | `off`, `on` | `future_candidate` |
| `fridge` | `kitchen` | `living_appliance` | `future_fridge` | `idle`, `active` | `future_candidate` |
| `microwave` | `kitchen` | `living_appliance` | `future_microwave` | `idle`, `active` | `future_candidate` |
| `aircon` | `utility` | `living_appliance` | `future_aircon` | `off`, `on` | `future_candidate` |
| `ups` | `power` | `support_device` | `future_ups` | `idle`, `charging`, `active` | `future_candidate` |
| `signal_booster` | `work` | `support_device` | `future_signal_booster` | `off`, `on`, `signal` | `future_candidate` |
| `shelf` | `background` | `background_life_hint` | `future_room_prop` | `idle` | `background_hint` |
| `small_table` | `living` | `background_life_hint` | `future_room_prop` | `idle` | `background_hint` |

## 구현 상태 기준

- `prototype_only`: 쿼터뷰 구도 확인을 위해 prototype에만 있는 구조 또는 소품이다.
- `existing_apartment_equivalent`: 기존 탑뷰 Apartment에 대응되는 기능 또는 오브젝트가 있다.
- `future_candidate`: 장기 방향 문서에는 있으나 아직 기존 DAY 1 기능으로 구현되지 않은 후보이다.
- `background_hint`: 생활 구조를 암시하지만 직접 기능 이식 대상은 아닌 배경 오브젝트이다.

## Registry 사용 기준

- `key`는 내부 식별자다. 화면 표시명이나 최종 에셋 이름이 바뀌어도 쉽게 바꾸지 않는다.
- `display_name`은 prototype 화면 라벨과 prompt에 쓰는 표시명이다.
- `zone`은 방 안 배치 구역을 나타낸다.
- `role`은 나중에 기존 Apartment 기능이나 신규 기능을 연결할 때의 의미를 나타낸다.
- `future_source`는 기존 탑뷰 기능 또는 장기 후보와의 연결 힌트다.
- `visual_state`는 현재 표시 상태의 placeholder key다.

## Prototype Interaction Action 기준

`QuarterviewRoomPrototype`의 object interaction panel은 `role`을 기준으로 Primary button label을 고른다.
이 label은 실제 기능 연결이 아니라 UX 흐름 확인용 placeholder다.

| role | Primary label | 실제 연결 후보 |
| --- | --- | --- |
| `manual_end_day` | `Rest / End Day` | 기존 Bed 수동 하루 종료 흐름 |
| `laptop_job` | `Open Work` | 해킹 미션 선택 또는 작업 UI |
| `phone_status` | `Check Phone` | 기존 Phone UI |
| `phone_charge` | `Charge` | Phone 충전 흐름 |
| `power_management` | `Open Power` | 기존 Outlet UI |
| `communication` | `Check Signal` | 의뢰 / 신호 확인 UI |
| `mystery_device` | `Inspect NODE` | NODE-17 story flag |
| `audio_hacking_device` | `Enable Audio` | 해커모드 오디오 정보 시스템 |
| `living_appliance` | `Use Appliance` | 냉장고 / 전자레인지 / 에어컨 |
| `support_device` | `Use Device` | 보조 장치 |
| `background_life_hint` | `Inspect` | 생활 배경 조사 |
| `background_structure` | `Inspect` | 구조물 조사 |

현재 prototype에서는 Primary / Inspect / Close button만 제공하며, Primary와 Inspect는 no-op 로그만 출력한다.

## 금지 사항

- object key를 화면 표시명 기준으로 바꾸지 않는다.
- `visual_state`를 실제 이미지 파일명과 1:1로 고정하지 않는다.
- 실제 에셋은 atlas region 또는 overlay로 교체 가능하게 둔다.
- 기존 Main에 연결하기 전까지 prototype registry는 prototype 전용으로 유지한다.
- 이 문서를 근거로 Main scene 교체, Phone / Outlet / Result 연결, NODE-17 구현, 해킹 액션 연결을 바로 진행하지 않는다.
