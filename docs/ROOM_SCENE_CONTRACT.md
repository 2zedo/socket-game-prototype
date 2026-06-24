# Room Scene Contract

## 목적

`RoomSceneContract`는 기존 `Apartment`와 미래 Quarterview Room이 공통으로 맞춰야 할 room scene interface를 정의한다.

현재 `Main` / DAY 1을 바로 변경하지 않는다. 실제 연결은 `QuarterviewGameplaySandbox`에서 먼저 검증한다. 이 문서는 scene 교체 전 누락과 입력 / 상태 충돌을 줄이기 위한 기준이다.

## 현재 상태

- 기존 본게임은 `Main.gd`, `Apartment.gd`, `SurvivalState.gd` 중심이다.
- `Apartment.gd`는 기존 탑뷰 방의 interaction, collision, wire overlay를 담당한다.
- `Main.gd`는 modal, input routing, Phone / Outlet / Result UI 연결의 중심이다.
- `SurvivalState.gd`는 전력, 시간, connected / active 장치, Phone 배터리, Result 데이터의 source of truth다.
- `QuarterviewRoomPrototype`은 object / interaction contract prototype이다.
- `QuarterviewPerspectiveBlockout`은 쿼터뷰 시점 검증용 blockout이다.
- 실제 Main 교체는 아직 하지 않는다.

## Contract Scope

| Area | Contract Responsibility | Current Source | Future Quarterview Use |
| --- | --- | --- | --- |
| Player input lock | modal / panel 표시 중 플레이어 입력을 잠그거나 푼다 | `Main.gd`, `Player.gd` | sandbox controller가 room에 이동 가능 여부를 전달 |
| Nearest interactable | 가장 가까운 상호작용 object key와 표시명을 알린다 | `Apartment.gd` nearest object 처리 | prompt, HUD hint, object panel 후보 |
| Object interaction request | room object 사용 요청을 signal로 올린다 | `Apartment.interaction_requested` | sandbox / Main-level controller가 Phone, Outlet, Result 여부를 결정 |
| Connected device visual sync | connected device 목록을 room visual에 반영한다 | `SurvivalState`, `Apartment` wire overlay | 쿼터뷰 cable / LED / plugged visual 후보 |
| Active device visual sync | active device 목록을 room visual에 반영한다 | `SurvivalState`, HUD / Result | 켜짐, 충전, 신호, 발열 등의 visual state 후보 |
| Debug overlay | room 전용 debug 표시를 켜고 끈다 | Test Mode, prototype debug overlay | sandbox / prototype diagnostics |
| Room message | 짧은 room feedback text를 표시한다 | HUD warning, prototype event label | object action 결과, 접근 불가, 상태 안내 |
| Player position / debug readout | 플레이어 위치를 읽거나 세팅한다 | `Player.gd`, Test Mode | debug readout, sandbox 테스트 |
| Time-of-day visual hint 후보 | 시간대 label 또는 조명 힌트를 표시한다 | Phone UI, SurvivalState clock | 쿼터뷰 조명 / 창문 색 변화 후보 |
| Room ready lifecycle | room 초기화 완료를 상위 controller에 알린다 | scene ready callbacks | sandbox / Main controller 연결 타이밍 |

## Signal Contract

| Signal | Arguments | Emitted By | Consumed By | Notes |
| --- | --- | --- | --- | --- |
| `interaction_requested` | `object_key: String`, `action_key: String`, `payload: Dictionary` | Room scene | sandbox / Main-level controller | `object_key`는 `bed`, `laptop`, `power`, `phone`, `comm`, `node17` 같은 stable key를 사용한다. |
| `nearest_interactable_changed` | `object_key: String`, `display_name: String` | Room scene | prompt / HUD / controller | 가까운 interactable이 없으면 빈 문자열을 보낼 수 있다. |
| `room_back_requested` | none | prototype / sandbox room | PrototypeHub 또는 sandbox controller | 본게임 Main에서 사용할지는 별도 판단한다. |
| `debug_overlay_toggled` | `enabled: bool` | Room scene | debug HUD / controller | Test Mode와 직접 연결하지 않는다. |
| `player_position_changed` | `position: Vector2` | Room scene | debug readout 후보 | 매 프레임 emit할지, 큰 변화 때만 emit할지는 구현 단계에서 결정한다. |
| `room_ready` | none | Room scene | sandbox / Main-level controller | object definitions, player, UI reference가 준비된 뒤 emit하는 후보. |

## Method Contract

| Method | Called By | Expected Behavior | Notes |
| --- | --- | --- | --- |
| `set_player_input_enabled(enabled)` | controller / modal owner | 플레이어 이동과 room interaction 입력을 허용하거나 막는다 | Phone / Outlet / Result modal과 충돌하지 않게 쓴다. |
| `set_debug_overlay_enabled(enabled)` | controller / debug key handler | room debug overlay 표시 상태를 세팅한다 | prototype debug와 Main Test Mode는 분리한다. |
| `is_debug_overlay_enabled()` | controller / UI | 현재 debug overlay 상태를 반환한다 | 기본 skeleton은 `false`를 반환한다. |
| `set_connected_devices(device_keys)` | controller | connected device visual만 갱신한다 | 전력 계산은 하지 않는다. |
| `set_active_devices(device_keys)` | controller | active device visual만 갱신한다 | drain 계산은 `SurvivalState` 담당이다. |
| `set_device_visual_state(object_key, visual_state)` | controller | 특정 room object의 표시 상태를 바꾼다 | atlas region / overlay 전환 후보. |
| `set_room_object_definitions(definitions)` | controller / setup | room object definition 목록을 주입한다 | `RoomObjectDefinition` Resource 배열 후보. |
| `get_nearest_interactable_key()` | controller / UI | 현재 가까운 interactable key를 반환한다 | 없으면 빈 문자열. |
| `request_nearest_interaction(action_key)` | input handler / UI | 현재 가까운 object에 대한 interaction request를 emit한다 | 기본 action은 `primary`. |
| `get_player_position()` | controller / debug | 플레이어 위치를 반환한다 | Test Mode 후보. |
| `set_player_position(position)` | controller / debug | 플레이어 위치를 이동한다 | 본게임에서는 신중히 제한한다. |
| `set_time_of_day_label(text)` | controller | room 안 시간대 표시 후보를 갱신한다 | Phone UI clock과 별개. |
| `show_room_message(text, duration)` | controller / room | 짧은 feedback message를 표시한다 | duration 처리 방식은 구현 scene이 결정한다. |
| `clear_room_message()` | controller / room | room feedback message를 지운다 | modal 메시지와 구분한다. |

## Object Interaction Flow

1. Player가 object 근처로 이동한다.
2. Room scene이 nearest interactable을 결정한다.
3. Room scene이 `nearest_interactable_changed(object_key, display_name)`을 emit한다.
4. Player가 `E`를 누르거나 UI primary action을 선택한다.
5. Room scene이 `interaction_requested(object_key, action_key, payload)`를 emit한다.
6. Sandbox / Main-level controller가 어떤 UI 또는 상태 호출을 할지 결정한다.
7. Room scene은 sandbox / Main이 명시적으로 연결하기 전까지 Phone / Outlet / Result / End Day / Hacking을 직접 열지 않는다.

Room scene은 object를 감지하고 요청을 발생시키는 쪽에 집중한다. 실제 기능 연결 여부는 상위 controller가 결정한다.

## Device State Sync Flow

1. `SurvivalState`가 connected / active / power drain의 source of truth로 남는다.
2. Controller가 `SurvivalState`에서 connected device와 active device 목록을 읽는다.
3. Controller가 `room.set_connected_devices(...)`를 호출한다.
4. Controller가 `room.set_active_devices(...)`를 호출한다.
5. Room scene은 cable, LED, glow, screen state 같은 visual만 갱신한다.
6. Room scene은 전력 소비량을 계산하지 않는다.

전력 계산은 Room scene이 하지 않는다. 전력 계산은 `SurvivalState`가 한다.

## Sandbox-first Migration Plan

1. `RoomSceneContract` skeleton 추가
2. `QuarterviewGameplaySandbox` 생성
3. Sandbox에서 Quarterview room scene을 contract처럼 다룸
4. `InteractionPanel` 연결
5. Bed End Day 연결
6. Phone UI 연결
7. Power / Outlet UI 연결
8. Active / connected visual sync 연결
9. `02:00` 자동 종료 연결
10. Result 연결
11. Main 교체 여부 판단

각 단계는 `Main`이 아니라 sandbox에서 먼저 검증한다.

## Non-goals

- `Main.tscn` 교체 아님
- `Apartment.gd` 제거 아님
- `SurvivalState.gd` 수정 아님
- Phone / Outlet / Result 직접 연결 아님
- Hacking Action 연결 아님
- 쿼터뷰 최종 아트 적용 아님
- 시점 / 그래픽 품질 판단 아님

## Naming / Key 기준

- `object_key`는 stable key를 사용한다.
- `display_name`은 UI 표시용이며 key와 다를 수 있다.
- `object_key`는 `RoomObjectDefinition.key`와 맞춘다.
- `role`은 `RoomObjectDefinition.role` 기준을 따른다.
- `action_key`는 `primary`, `inspect`, `close`, `debug` 같은 고정 문자열을 사용한다.
- `payload`에는 `zone`, `role`, `future_source`, `visual_state` 같은 선택 정보를 담을 수 있다.

## 현재 작업 범위

- `RoomSceneContract.gd` skeleton을 추가한다.
- signal / method / interaction flow / device sync flow를 문서화한다.
- 기존 `Main`, `Apartment`, `SurvivalState`, prototype scene에는 연결하지 않는다.
