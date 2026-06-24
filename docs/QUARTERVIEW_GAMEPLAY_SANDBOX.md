# Quarterview Gameplay Sandbox

## 목적

`QuarterviewGameplaySandbox`는 기존 Main / DAY1 기능을 쿼터뷰로 바로 옮기기 전에, `RoomSceneContract` 기반 signal flow를 검증하는 독립 sandbox다.

이 scene은 실제 Main 교체가 아니다. 기존 `Main.tscn`, `Apartment.gd`, `SurvivalState.gd`, Phone / Outlet / Result 흐름과 분리되어 있다.

## Scene Path

- Sandbox: `res://scenes/prototypes/QuarterviewGameplaySandbox.tscn`
- Room stub: `res://scenes/prototypes/QuarterviewSandboxRoomStub.tscn`

## 현재 포함된 것

- `RoomHost`
- `RoomSceneContract`와 같은 signal / method를 제공하는 room stub
- `interaction_requested` signal 수신
- `nearest_interactable_changed` signal 수신
- `D` debug overlay
- `B` / `Backspace` PrototypeHub 복귀
- `R` sandbox restart
- PrototypeHub 등록
- no-op event log

## Room Stub

`QuarterviewSandboxRoomStub`은 `RoomSceneContract`와 같은 signal / method 이름을 제공하는 signal-compatible `Node2D` stub이다. `RoomSceneContract` skeleton은 `Node` 기반 interface 문서 역할을 유지하고, 이 stub은 drawing과 debug overlay가 필요해 `Node2D`로 구현한다.

현재 stub은 `godot/resources/rooms/quarterview/objects/*.tres`의 `RoomObjectDefinition` Resource 중 sandbox 검증에 필요한 object를 읽어 단순 도형으로 표시한다.

포함 object 후보:

- `bed`
- `laptop`
- `power`
- `phone`
- `comm`
- `node17`
- `fridge`
- `microwave`
- `aircon`
- `speaker`
- `ups`
- `signal_booster`

이 stub은 최종 쿼터뷰 아트나 시점 검증용이 아니다. 기능 이식 전 contract signal 흐름을 확인하는 최소 room이다.

## Interaction Signal Flow

1. Player가 room stub 안에서 `WASD` / 방향키로 이동한다.
2. Room stub이 가까운 interactable object를 계산한다.
3. Room stub이 `nearest_interactable_changed(object_key, display_name)`을 emit한다.
4. Sandbox controller가 prompt와 status를 갱신한다.
5. Player가 `E`를 누른다.
6. Sandbox controller가 `room.request_nearest_interaction("primary")`를 호출한다.
7. Room stub이 `interaction_requested(object_key, action_key, payload)`를 emit한다.
8. Sandbox controller가 event log와 Godot output에 no-op 기록을 남긴다.

payload에는 가능한 경우 아래 값이 포함된다.

- `zone`
- `role`
- `future_source`
- `visual_state`
- `display_name`

## Debug Overlay

`D` 키로 debug overlay를 켜고 끈다.

Debug OFF:

- 기본 room stub
- status / help
- nearest prompt

Debug ON:

- object labels
- interaction radius
- blocker / bounds 후보 표시
- player position
- signal log
- room contract state

## 아직 연결하지 않은 것

- `InteractionPanel`
- Bed End Day
- Phone UI
- Outlet UI
- Result
- `SurvivalState` gameplay flow
- `HackingActionPrototype`
- Test Mode
- `02:00` auto end

이번 sandbox는 실제 기능을 실행하지 않고 event log만 남긴다.

## PrototypeHub 등록

`PrototypeHub`에는 아래 항목으로 등록되어 있다.

| Key | Title | Scene | Notes |
| --- | --- | --- | --- |
| `6` / `G` | Quarterview Gameplay Sandbox | `res://scenes/prototypes/QuarterviewGameplaySandbox.tscn` | `RoomSceneContract` signal flow only. No Phone / Outlet / Result wiring yet. |

## 다음 작업 후보

13. Sandbox `InteractionPanel` 연결
14. Sandbox Bed -> End Day 연결
15. Sandbox Phone UI 연결
16. Sandbox Power / Outlet UI 연결

각 작업은 기존 Main / DAY1을 직접 수정하지 않고 sandbox에서 먼저 검증한다.

## Non-goals

- `Main.tscn` 교체 아님
- Quarterview final art 아님
- 실제 gameplay loop 아님
- 기존 `Apartment` 제거 아님
- Phone / Outlet / Result 연결 아님
- Laptop -> Hacking 연결 아님
- `SurvivalState` power drain 계산 연결 아님
