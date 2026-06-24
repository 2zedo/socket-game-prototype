# 쿼터뷰 Room / 기존 Apartment 기능 대응표

## 목적

이 문서는 기존 탑뷰 `Apartment` / `Main` 기능을 나중에 쿼터뷰 Room으로 옮길 때 누락을 막기 위한 대응표다.

현재 구현을 바로 바꾸는 문서가 아니다. `Main` / DAY 1은 아직 Golden Path로 유지한다. 실제 연결은 `QuarterviewGameplaySandbox` 같은 별도 sandbox에서 먼저 검증한 뒤 Main 교체 여부를 결정한다.

`QuarterviewRoomPrototype`은 최종 쿼터뷰 시점 검증용이 아니라 object / interaction contract prototype이다. 현재 object 정의의 source of truth는 `godot/resources/rooms/quarterview/objects/*.tres`의 `RoomObjectDefinition` Resource다.

실제 기능 이식은 `docs/ROOM_SCENE_CONTRACT.md`의 signal / method 기준을 따라 `QuarterviewGameplaySandbox`에서 먼저 연결한다.

## 현재 구현 요약

- 현재 본게임 방 화면은 탑뷰 `Apartment` 기반이다.
- `Main.gd`가 modal, input, UI routing의 중심이다.
- `SurvivalState.gd`가 전력, 시간, connected / active 상태, Phone 배터리, Result 데이터의 source of truth다.
- `Apartment.gd`는 기존 방 오브젝트, collision, interaction, wire overlay, nearest object 처리를 담당한다.
- `InteractionPanel`, `OutletMode`, `PhoneUI`, `DayResultPanel`은 기존 `Main` 흐름에 연결되어 있다.
- `QuarterviewRoomPrototype`은 실제 기능 연결이 아니라 object registry, prompt, panel, Resource contract를 확인한다.
- `HackingActionPrototype`은 아직 Laptop과 연결되지 않은 독립 prototype이다.

## 핵심 기능 대응표

| Existing Feature | Current Source | Current Object / Key | Quarterview Object Key | Quarterview Role | Required UI / State Call | Migration Target | Migration Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Bed / End Day | `Apartment.gd`, `Main.gd`, `SurvivalState.gd` | `bed`, `interaction_type=end_day` | `bed` | `manual_end_day` | `InteractionPanel.open(...)`, `SurvivalState.end_current_day()`, `DayResultPanel.open(result)` | sandbox first | `sandbox_candidate` | Bed primary action으로 수동 하루 종료 확인을 연결할 후보. `02:00` 자동 종료는 object interaction과 별개로 유지한다. |
| 02:00 Auto End | `SurvivalState._update_time()`, `Main._on_day_time_limit_reached()` | object 없음 | object 없음 | n/a | dialogue-only `InteractionPanel`, `SurvivalState.end_current_day()` | sandbox first | `current_main_only` | 시간 한계는 방 오브젝트가 아니라 clock / modal routing 흐름이다. |
| Laptop | `Apartment.gd`, `Main.gd`, `SurvivalState.gd`, `DeviceDefinition` | `laptop`, `day1_action_key=laptop` | `laptop` | `laptop_job` | 현재는 active toggle. 장기적으로 work UI 또는 hacking entry 후보 | later sandbox | `sandbox_candidate` | `Laptop -> HackingActionPrototype` 연결은 아직 금지. 별도 작업에서 검증한다. |
| Power Strip / Outlet | `Apartment.gd`, `Main.gd`, `OutletMode.gd`, `SurvivalState.gd` | `power_strip` | `power` | `power_management` | `OutletMode.open(survival_state)`, `set_powerstrip_slot_occupancy(...)`, `set_powered_devices(...)` | sandbox first | `sandbox_candidate` | 기존 Outlet UI 유지 후보. wire overlay는 쿼터뷰에서 별도 cable visual 검토 필요. |
| Phone / Charger | `Main.gd`, `PhoneUI.gd`, `SurvivalState.gd`, `DeviceDefinition` | `Tab` Phone UI, `charger` active device | `phone` | `phone_charge` 또는 `phone_status` | `PhoneUI.set_open(...)`, `SurvivalState.toggle_day1_action_active("charger")` | sandbox first | `sandbox_candidate` | `Tab` Phone UI는 유지 후보. phone object primary로 Phone UI를 열지는 sandbox에서 판단한다. |
| Communication Device | `Apartment.gd`, `SurvivalState.gd`, `DeviceDefinition` | `communication_device` | `comm` | `communication` | active toggle, Result flag `sent_or_received_signal` | later sandbox | `sandbox_candidate` | 해킹 의뢰, 외부 신호, NODE-17 연계 후보. 현재 DeviceDefinition 값은 유지한다. |
| Light / Lamp / Fluorescent | `Apartment.gd`, `SurvivalState.gd`, `DeviceDefinition` | `light` | 미정: `fluorescent_light` 또는 background fixture | `background_structure` 또는 `background_life_hint` | 현재는 active toggle. 장기적으로 기본 설비 후보 | design decision first | `blocked_by_design_decision` | 현재 1-slot 장치와 장기 형광등 기본 설비 방향이 충돌한다. 이번 문서에서 정책만 기록한다. |
| Fan / Air Conditioner | `Apartment.gd`, `SurvivalState.gd`, `DeviceDefinition` | `fan` | `aircon` | `living_appliance` | 현재는 Fan active toggle. 장기 AC는 미구현 | design decision first | `blocked_by_design_decision` | 현재 Fan은 유지. 장기 방향은 AC 교체 검토지만 실제 Fan 제거 / AC 구현은 별도 작업이다. |
| Fridge | 미구현 | 없음 | `fridge` | `living_appliance` | future survival state or upkeep logic | future sandbox | `future_candidate` | 생활 유지 장치 후보. 식량 / 컨디션 / 비용 리스크는 아직 본 구현 아님. |
| Microwave | 미구현 | 없음 | `microwave` | `living_appliance` | future instant power spend / time advance | future sandbox | `future_candidate` | 순간 소비 장치 후보. 식사 / 컨디션 회복은 아직 본 구현 아님. |
| NODE-17 | 미구현 | 없음 | `node17` | `mystery_device` | future story flag / signal state | future sandbox | `future_candidate` | 메인 미스터리 장치. Laptop / Hacking / Communication과 장기 연계한다. |
| Speaker | 미구현 | 없음 | `speaker` | `audio_hacking_device` | future audio log / signal analysis UI | future sandbox | `future_candidate` | 장식품이 아니라 해킹 활동 관련 오디오 장비다. 작업 구역 배치 기준이다. |
| UPS / Backup Battery | 미구현 | 없음 | `ups` | `support_device` | future charge / storage state | future sandbox | `future_candidate` | 오늘 전력을 나중을 위해 저장하는 시스템 후보. 본 구현 아님. |
| Signal Booster | 미구현 | 없음 | `signal_booster` | `support_device` 후보 | future hacking condition / signal quality | future sandbox | `future_candidate` | 해킹 미션 조건, 신호 품질, 추적률, 추가 데이터 노드 연계 후보. |
| Door | `Apartment.gd` visual / collision context | 직접 기능 대상 아님 | `door` | `background_structure` | 없음 | no gameplay migration | `prototype_contract_ready` | 생활 구조 암시용. 현관 직접 기능 구현 대상 아님. |
| Bathroom Door | `Apartment.gd` visual / collision context | 직접 기능 대상 아님 | `bathroom_door` | `background_structure` | 없음 | no gameplay migration | `prototype_contract_ready` | 욕실 내부를 크게 보여주지 않고 문 / 환기구 등으로 암시한다. “화장실” 텍스트 라벨은 금지. |
| Room Object Definitions | `QuarterviewRoomPrototype.gd`, `RoomObjectDefinition` | 이전 inline registry | `*.tres` object resources | per object | `RoomObjectDefinition` load / validate | contract reuse | `resource_defined` | 현재 `QuarterviewRoomPrototype`은 Resource를 읽어 placeholder, prompt, panel을 구성한다. |

## UI 대응표

| UI / Modal | Current Owner | Current Trigger | Quarterview Trigger Candidate | Sandbox Step | Notes |
| --- | --- | --- | --- | --- | --- |
| `InteractionPanel` | `Main.gd`, `InteractionPanel.gd` | `Apartment.interaction_requested`, `E`, mouse click | `RoomObjectDefinition.role` 기반 primary action | 3 | 기존 본게임 interaction modal. Prototype `ObjectInteractionPanel`과 다르다. |
| `OutletMode` | `Main.gd`, `OutletMode.gd` | `power_strip` interaction | `power` / `power_management` primary action | 6 | 기존 UI 유지 후보. 쿼터뷰 cable visual은 별도 검토한다. |
| `PhoneUI` | `Main.gd`, `PhoneUI.gd` | `Tab` / `open_phone` | `Tab` 유지, 또는 `phone` primary action 후보 | 5 | 현재 status view only. object click과 Tab 동작의 우선순위는 sandbox에서 확인한다. |
| `DayResultPanel` | `Main.gd`, `DayResultPanel.gd` | `SurvivalState.day_ended` | Bed manual end 또는 auto end 후 표시 | 9 | Result 계산 로직은 기존 `SurvivalState` 유지. |
| 자동 `02:00` dialogue-only modal | `Main.gd`, `InteractionPanel.gd`, `SurvivalState.gd` | `SurvivalState.day_time_limit_reached` | sandbox clock event | 8 | object interaction과 별개. modal pause와 입력 routing을 유지해야 한다. |
| Battery warning HUD | `Main.gd`, `SurvivalHUD.gd`, `SurvivalState.gd` | `phone_battery_warning` signal | 기존 HUD 또는 sandbox HUD 후보 | later | `0%` Phone UI 정책과 threshold rearm 구조 유지. |
| Test Mode overlay | `Main.gd`, `SurvivalHUD.gd`, `Apartment.gd`, `OutletMode.gd` | `P`, `F1`, debug keys | sandbox 전용 최소 overlay 후보 | 10 | Main Test Mode와 prototype debug overlay를 섞지 않는다. |
| Prototype `ObjectInteractionPanel` | `QuarterviewRoomPrototype.gd` | prototype에서 가까운 object + `E` | sandbox 기능 연결 전 contract 확인 | contract only | no-op panel. 본게임 `InteractionPanel` 대체물이 아니다. |

## 상태 / 로직 대응표

| State / Logic | Current Source | Quarterview Reuse Plan | Migration Risk | Test Coverage |
| --- | --- | --- | --- | --- |
| `SurvivalState` | `godot/scripts/SurvivalState.gd` | sandbox에서도 source of truth로 재사용 | Main modal routing과 분리할 때 회귀 위험 | `godot/test/unit/test_survival_state.gd` 일부 covered by GUT |
| `DeviceDefinition` Resource | `godot/scripts/resources/DeviceDefinition.gd`, `godot/resources/devices/*.tres` | 장치 이름, 슬롯, 부하, drain, Result flag 유지 | Fan / Light 장기 정책과 충돌 가능 | GUT device value test |
| `RoomObjectDefinition` Resource | `godot/scripts/resources/RoomObjectDefinition.gd`, `godot/resources/rooms/quarterview/objects/*.tres` | 쿼터뷰 object key / role / 위치 / interaction 후보 재사용 | 본게임 데이터와 prototype blockout 값이 섞일 수 있음 | Not covered by GUT |
| connected / active 분리 | `SurvivalState`, `OutletMode`, `Main` | 그대로 유지 | object primary action이 connection 없이 active를 켜면 안 됨 | GUT connected / active test |
| hourly drain | `SurvivalState.get_active_power_drain_per_game_hour()` | 그대로 유지 | DAY 시간 / modal pause와 엮일 때 drift 위험 | GUT active drain test |
| clock pause by modal | `Main._sync_player_movement_with_modal_state()`, `SurvivalState.set_clock_paused_by_modal()` | sandbox modal에도 동일 정책 적용 | UI overlay 중 시간이 흐르는 회귀 위험 | GUT modal pause test |
| phone battery threshold | `SurvivalState._set_battery()` | 그대로 유지 | charging 중 warning suppression 유지 필요 | GUT battery warning test |
| `02:00` auto end | `SurvivalState._update_time()`, `Main._on_day_time_limit_reached()` | object와 분리해 유지 | Result 역행 / modal overlap 위험 | Manual / startup only |
| Result history | `SurvivalState._calculate_day_result()`, `DayResultPanel` | 기존 result dictionary 유지 | 쿼터뷰 object key와 DAY1 action key 혼동 위험 | Manual / existing flow |
| Test Mode debug actions | `Main.gd`, `SurvivalHUD.gd` | sandbox 최소 이식 후보 | prototype debug `D`와 Main Test Mode `P` 혼동 위험 | Manual |
| Prototype SFX helper | `PrototypeSfx.gd` | prototype / sandbox 단계에서만 사용 | 본게임 SFX 정책으로 오해하지 않기 | Manual |
| Prototype Input Prompt helper | `PrototypeInputPrompts.gd` | prototype / sandbox 단계에서만 사용 | Main UI 확정으로 오해하지 않기 | Manual |

## Wire / Cable 표시 대응

- 기존 `Apartment`는 `SurvivalState.powered_devices`와 connected state에 따라 map wire overlay를 표시한다.
- 쿼터뷰에서는 기존 2D map wire overlay를 그대로 쓰기 어렵다.
- 장기적으로는 `qv_cable_atlas` 또는 cable node 기반 시각화가 필요할 수 있다.
- connected state 자체는 계속 `SurvivalState` 기준으로 유지한다.
- 이번 작업에서는 cable visual, wire overlay, connected sync를 구현하지 않는다.

## Sandbox 이식 순서 후보

각 단계는 `Main` / DAY 1을 직접 수정하지 않고 sandbox에서 먼저 검증한다.

1. `QuarterviewGameplaySandbox` 생성: 기존 Main을 건드리지 않고 쿼터뷰 기능 연결 실험용 scene을 만든다.
2. Room scene contract / signal 연결: `RoomObjectDefinition` key와 `role`을 신호로 내보내는 구조를 검증한다.
3. `InteractionPanel` 연결: prototype `ObjectInteractionPanel`이 아니라 기존 본게임 panel을 sandbox에서 호출한다.
4. Bed -> End Day confirmation 연결: `bed` / `manual_end_day` primary action을 수동 하루 종료 확인으로 연결한다.
5. Phone UI 연결: `Tab` 유지와 `phone` object primary action 후보를 함께 검토한다.
6. Power -> `OutletMode` 연결: `power` / `power_management` primary action에서 기존 Outlet UI를 연다.
7. active / connected visual sync 연결: `SurvivalState.powered_devices`와 active state를 쿼터뷰 표시로 반영한다.
8. `02:00` auto end 연결: object와 무관한 clock event, dialogue-only modal, pause 정책을 검증한다.
9. Result 연결: `SurvivalState.day_ended` -> `DayResultPanel` 흐름을 sandbox에서 확인한다.
10. Test Mode 최소 연결: collision / interaction / state 확인용만 sandbox에 붙인다.
11. Laptop -> Hacking prototype 연결: 별도 작업으로 `laptop_job`에서 해킹 미션 진입 후보를 검증한다.
12. Main 교체 여부 판단: sandbox가 충분히 안정된 뒤 기존 탑뷰 Main 대체 여부를 결정한다.

## Migration Status 분류

- `current_main_only`: 현재 Main / Apartment에서만 동작한다.
- `prototype_contract_ready`: object key / role / UI contract는 준비되어 있지만 실제 기능 연결은 없다.
- `resource_defined`: `RoomObjectDefinition` 또는 `DeviceDefinition` Resource로 정의되어 있다.
- `sandbox_candidate`: sandbox에서 먼저 기능 연결을 검증할 후보이다.
- `future_candidate`: 장기 후보이며 당장 구현하지 않는다.
- `blocked_by_design_decision`: 설계 결정이 먼저 필요하다.

## 위험 요소

- Main과 prototype 기능을 섞으면 DAY 1 Golden Path 회귀 위험이 크다.
- 기존 `godot/scripts/Apartment.gd` local change가 unrelated 상태로 남아 있으므로 staging 때 주의해야 한다.
- Light / Lamp 정책이 미정이다.
- Fan -> Air Conditioner 정책이 미정이다.
- 기존 wire overlay를 쿼터뷰에서 어떻게 표현할지 미정이다.
- UI modal routing을 Main에서 sandbox로 옮길 때 입력 충돌 가능성이 있다.
- SFX / Input Prompt는 prototype용이며 본게임 확정 UI / 오디오 정책이 아니다.

## 아직 구현하지 말 것

- Main scene 교체
- 쿼터뷰 Room 본 이식
- `QuarterviewGameplaySandbox` 생성
- Phone / Outlet / Result 실제 연결
- NODE-17 구현
- Fridge / Microwave / AC 구현
- Fan 제거
- Light 정책 변경
- Laptop -> Hacking Action 연결
- 기존 wire overlay를 쿼터뷰 cable로 교체
- 실제 쿼터뷰 아트 적용
