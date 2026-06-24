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
- `room_back_requested` signal 수신
- sandbox-only interaction panel
- sandbox-only Bed -> End Day confirmation panel
- sandbox-only Phone panel
- sandbox-only Outlet panel
- sandbox-only Result panel
- sandbox-local clock from `20:00` to `02:00`
- sandbox-only `02:00` auto end state
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
8. Sandbox controller가 sandbox-only interaction panel을 연다.
9. Panel이 열린 동안 `room.set_player_input_enabled(false)`로 room input을 잠근다.
10. Primary / Inspect / Close는 event log와 Godot output에 no-op 기록만 남긴다.
11. Close 또는 `ESC`로 panel을 닫으면 `room.set_player_input_enabled(true)`로 room input을 복구한다.

Room stub에서 `room_back_requested`가 emit되면 sandbox controller는 PrototypeHub 복귀로 처리한다. 이 흐름은 sandbox / prototype navigation 전용이며 본게임 Main back routing과 연결하지 않는다.

Bed의 Primary action은 예외적으로 `SandboxEndDayPanel`을 연다. Confirm 이후에는 sandbox-only Result panel을 연다. 이 흐름도 sandbox-only 확인이며 `SurvivalState.end_current_day()`, `DayResultPanel`, 기존 Main End Day routing은 호출하지 않는다.

Phone의 Primary action은 `SandboxPhonePanel`을 연다. 이 흐름은 sandbox-only mock status 표시이며 기존 Main `PhoneUI`, Main phone routing, 실제 `SurvivalState` battery / charge state는 호출하지 않는다.

Power의 Primary action은 `SandboxOutletPanel`을 연다. 이 흐름은 sandbox-only mock outlet 표시이며 기존 Main `OutletMode`, Main outlet routing, 실제 `SurvivalState` connected / active state, Apartment wire overlay는 호출하지 않는다.

payload에는 가능한 경우 아래 값이 포함된다.

- `zone`
- `role`
- `future_source`
- `visual_state`
- `display_name`

## Sandbox Local Clock

`QuarterviewGameplaySandbox`는 sandbox 내부에서만 쓰는 local clock을 가진다.

- Start: `20:00`
- Auto end target: `02:00`
- Speed: `10` sandbox minutes per real second
- Test shortcut: `T` adds `30` sandbox minutes, `Shift+T` adds `2` sandbox hours

이 시간은 기존 Main / DAY1 clock, `SurvivalState`, Phone UI 시간과 연결하지 않는다.

Sandbox 정책:

- InteractionPanel / EndDayPanel / PhonePanel / OutletPanel이 열려 있어도 sandbox-local clock은 계속 흐른다.
- `02:00`에 도달하면 sandbox-only auto end가 한 번만 발생한다.
- auto end 후 clock은 멈추고 room input은 잠긴다.
- auto end 후 `E`, `Tab`, Bed / Phone / Power interaction은 무시된다.
- auto end 후에는 `R` restart 또는 `B` / `Backspace` PrototypeHub 복귀만 유지한다.
- real Result / `DayResultPanel`, Main day flow, `SurvivalState` day advance는 호출하지 않는다.

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

- Main용 `InteractionPanel`
- 실제 Bed End Day / `SurvivalState.end_current_day()`
- real Main Phone routing
- real `SurvivalState` phone battery / charge integration
- real Main Outlet routing
- real `SurvivalState` connected / active state
- Apartment wire overlay
- real Result / `DayResultPanel`
- `SurvivalState` gameplay flow
- `HackingActionPrototype`
- Test Mode
- real Main `02:00` auto end / Result flow
- reward / Grid Credit / save / story flag

이번 sandbox는 실제 기능을 실행하지 않고 event log만 남긴다.

## Interaction Panel

기존 Main용 `InteractionPanel.tscn`은 대사 / 사용 / 취소 흐름에 맞춰져 있고 Inspect button이 없으므로, 이번 sandbox에서는 `res://scenes/prototypes/SandboxInteractionPanel.tscn` adapter를 사용한다.

Panel 표시 정보:

- `display_name`
- `key`
- `zone`
- `role`
- `future_source`
- `visual_state`
- sandbox note

Button 동작:

- Primary: role별 label을 표시하지만 실제 기능은 실행하지 않는다.
- Inspect: payload / debug 정보를 no-op 로그로 남긴다.
- Close: panel을 닫고 room input을 복구한다.
- `ESC`: panel이 열려 있으면 Close와 같은 경로로 닫는다.
- `B` / `Backspace`: panel open 여부와 무관하게 PrototypeHub 복귀 우선 규칙을 유지한다.

## Sandbox End Day Panel

`bed` / `manual_end_day` Primary action은 `res://scenes/prototypes/SandboxEndDayPanel.tscn`을 연다.

Panel 동작:

- Confirm: sandbox-only `day_end_confirmed = true` 상태를 표시한다.
- Cancel / Close / `ESC`: confirmation을 닫고 room input을 복구한다.
- Confirm 이후에는 sandbox-only Result panel을 표시한다.
- `R`: sandbox를 재시작해 상태를 초기화한다.
- `B` / `Backspace`: panel 상태와 무관하게 PrototypeHub 복귀를 유지한다.

이 panel은 기존 Main의 `InteractionPanel`, `DayResultPanel`, `SurvivalState` day-end flow와 연결되어 있지 않다.

## Sandbox 02:00 Auto End

Sandbox-local clock이 `02:00`에 도달하면 confirmation 없이 auto end 상태를 표시한다.

Auto end 동작:

- 현재 열린 sandbox modal을 숨긴다.
- `SandboxResultPanel`을 표시한다.
- `sandbox_end_reason = "auto_02_00"`로 기록한다.
- room input을 잠근다.
- `R` restart와 `B` / `Backspace` PrototypeHub 복귀는 유지한다.

Manual Bed End와의 차이:

- Manual Bed End: Bed Primary -> confirmation -> Confirm -> `sandbox_end_reason = "manual_bed"`
- Auto End: `02:00` 도달 -> confirmation 없이 auto-end message -> `sandbox_end_reason = "auto_02_00"`

둘 다 기존 Main / DAY1 Result, `SurvivalState`, save / load, reward 계산과 연결되어 있지 않다.

## Sandbox Result Panel

Manual Bed End confirm 또는 `02:00` auto end 이후 `res://scenes/prototypes/SandboxResultPanel.tscn`을 연다.

Panel 표시 정보:

- end reason
- start time
- end time
- elapsed minutes
- sandbox-only result note
- Phone / power / outlet / reward / Grid Credit 미연결 안내
- real `DayResultPanel`, Main / DAY1, `SurvivalState`, save / load, story flag 미연결 안내

Panel 동작:

- Restart: sandbox scene을 reload한다.
- Hub: `PrototypeHub`로 복귀한다.
- Hide Details: panel만 숨긴다. Gameplay는 종료 상태로 남고 room input은 계속 잠긴다.
- `ESC`: Result UI에서 gameplay로 돌아가지 않고 안내 로그만 남긴다.
- `R`: sandbox를 재시작한다.
- `B` / `Backspace`: `PrototypeHub`로 복귀한다.

이 panel은 기존 `res://scenes/ui/DayResultPanel.tscn`을 열지 않는다. 기존 `DayResultPanel`은 `SurvivalState`와 DAY result data 전제를 가지므로 sandbox mock result에는 직접 재사용하지 않는다.

## Sandbox Phone Panel

`Tab` 또는 `phone` / `phone_status` / `phone_charge` Primary action은 `res://scenes/prototypes/SandboxPhonePanel.tscn`을 연다.

Panel 표시 정보:

- sandbox-local time
- sandbox mock battery
- sandbox-only power / active device text
- local mock signal
- Main / DAY1 Phone flow 미연결 안내

Panel 동작:

- `Tab`: 닫혀 있으면 열고, 열려 있으면 닫는다.
- Phone object Primary: sandbox Phone panel을 연다.
- `ESC` / Close: panel을 닫고 room input을 복구한다.
- Panel이 열린 동안 room stub player movement는 잠긴다.
- `B` / `Backspace`: panel 상태와 무관하게 PrototypeHub 복귀를 유지한다.

기존 `res://scenes/ui/PhoneUI.tscn`은 `SurvivalState` 인스턴스를 요구하므로 이번 sandbox 단계에서는 직접 재사용하지 않는다.

## Sandbox Outlet Panel

`power` / `power_management` Primary action은 `res://scenes/prototypes/SandboxOutletPanel.tscn`을 연다.

Panel 표시 정보:

- sandbox-only power management note
- 4-slot mock list
- device candidate list
- Main / DAY1 Outlet flow 미연결 안내
- real `SurvivalState` connected / active state 미연결 안내
- Apartment wire overlay 미연결 안내

Panel 동작:

- Power object Primary: sandbox Outlet panel을 연다.
- `ESC` / Close: panel을 닫고 room input을 복구한다.
- Panel이 열린 동안 room stub player movement는 잠긴다.
- Mock buttons: log / text feedback만 남기며 실제 connected / active state는 바꾸지 않는다.
- `B` / `Backspace`: panel 상태와 무관하게 PrototypeHub 복귀를 유지한다.

기존 `res://scenes/ui/OutletMode.tscn`은 실제 `SurvivalState` 슬롯 / 연결 상태와 본게임 adapter UI 전제를 가지고 있으므로 이번 sandbox 단계에서는 직접 재사용하지 않는다.

## Flow Check

`docs/QUARTERVIEW_GAMEPLAY_SANDBOX_FLOW_CHECK.md`는 현재 sandbox-only 흐름 점검 결과를 기록한다. 확인 범위는 Hub 진입, scene startup, room contract signal 수신, InteractionPanel, Bed confirmation, Phone panel, Outlet panel, `02:00` auto end, Sandbox Result UI, modal priority, input lock, `R` restart, `D` debug, `B` / `Backspace` Hub 복귀다.

이번 점검에서 sandbox controller가 room stub의 `room_back_requested` signal도 수신하도록 연결했다. 이 변경은 sandbox 내부 복귀 signal 처리만 보강하며 Main / DAY1에는 연결하지 않는다.

## PrototypeHub 등록

`PrototypeHub`에는 아래 항목으로 등록되어 있다.

| Key | Title | Scene | Notes |
| --- | --- | --- | --- |
| `6` / `G` | Quarterview Gameplay Sandbox | `res://scenes/prototypes/QuarterviewGameplaySandbox.tscn` | `RoomSceneContract` signal flow only. No Phone / Outlet / Result wiring yet. |

## 다음 작업 후보

13. Sandbox `InteractionPanel` 연결
14. Sandbox Bed -> End Day 연결: sandbox-only confirmation까지 완료. 실제 `SurvivalState` / Result 연결은 아직 하지 않는다.
15. Sandbox Phone UI 연결: sandbox-only mock panel까지 완료. 실제 Main Phone routing / `SurvivalState` battery 연결은 아직 하지 않는다.
16. Sandbox Power / Outlet UI 연결: sandbox-only mock panel까지 완료. 실제 Main Outlet routing / `SurvivalState` connected state / Apartment wire overlay 연결은 아직 하지 않는다.
17. Sandbox Result UI 연결: sandbox-only Result panel까지 완료. 실제 `DayResultPanel` / `SurvivalState` / reward / save 연결은 아직 하지 않는다.

각 작업은 기존 Main / DAY1을 직접 수정하지 않고 sandbox에서 먼저 검증한다.

## Non-goals

- `Main.tscn` 교체 아님
- Quarterview final art 아님
- 실제 gameplay loop 아님
- 기존 `Apartment` 제거 아님
- real Main Phone / Outlet / Result 연결 아님
- Apartment wire overlay 연결 아님
- Laptop -> Hacking 연결 아님
- `SurvivalState` power drain 계산 연결 아님
