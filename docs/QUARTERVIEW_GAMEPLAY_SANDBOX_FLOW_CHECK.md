# Quarterview Gameplay Sandbox Flow Check

## 목적

이 문서는 `QuarterviewGameplaySandbox`의 sandbox-only 흐름이 한 scene 안에서 끊기지 않는지 확인한 결과를 기록한다.

이번 점검은 새 기능 추가나 본게임 연결 작업이 아니다. `Main.tscn`, `Main.gd`, `Apartment.gd`, `SurvivalState.gd`, 기존 `PhoneUI`, `OutletMode`, `DayResultPanel` 흐름은 변경하지 않는다.

## 점검 대상 흐름

- `PrototypeHub`에서 `QuarterviewGameplaySandbox` 진입
- scene startup과 기본 UI node 준비
- room stub attach와 `RoomSceneContract` 계열 signal 수신
- player 이동과 nearest interactable 감지
- `E` interaction 요청
- sandbox-only `SandboxInteractionPanel` 표시
- Bed Primary -> sandbox-only End Day confirmation
- `Tab` 또는 Phone Primary -> sandbox-only Phone panel
- Power Primary -> sandbox-only Outlet panel
- sandbox-local clock from `20:00` to `02:00`
- sandbox-only Test Mode panel
- `02:00` sandbox-only auto end
- sandbox-only Result panel
- modal open 중 player input lock
- modal close 후 player input restore
- `R` restart
- `D` debug toggle
- `B` / `Backspace` PrototypeHub 복귀
- `ESC` current modal close
- `F2` Test Mode open / close

## 현재 연결된 Sandbox-Only 기능

`QuarterviewGameplaySandbox`는 `QuarterviewSandboxRoomStub`을 `RoomHost`에 붙이고 room stub이 emit하는 signal을 sandbox controller에서 수신한다.

현재 수신하는 signal:

- `room_ready`
- `nearest_interactable_changed`
- `interaction_requested`
- `room_back_requested`
- `debug_overlay_toggled`
- `player_position_changed`

`interaction_requested`는 실제 기능을 실행하지 않고 sandbox panel routing으로만 이어진다.

- Bed / `manual_end_day`: `SandboxEndDayPanel`
- Phone / `phone_status` / `phone_charge`: `SandboxPhonePanel`
- Power / `power_management`: `SandboxOutletPanel`
- 그 외 object: `SandboxInteractionPanel` no-op Primary / Inspect log

Sandbox-local clock은 `20:00`에 시작해 `02:00`에 도달하면 auto end 상태를 표시한다. 이 clock은 Main / DAY1 clock, `SurvivalState`, Phone UI와 연결하지 않는다.

Manual Bed End confirm과 `02:00` auto end는 모두 `SandboxResultPanel`을 연다. 이 panel은 기존 `DayResultPanel`을 열지 않고 sandbox-local summary만 표시한다.

`F2`는 `SandboxTestModePanel`을 열고 닫는다. Test Mode는 sandbox-local time, end state, Result state만 조작하며 Main / DAY1 Test Mode, `SurvivalState`, `PhoneUI`, `OutletMode`, `DayResultPanel`을 호출하지 않는다.

## Modal Priority

현재 `_unhandled_input` 기준 우선순위는 아래와 같다.

1. `B` / `Backspace`: PrototypeHub 복귀
2. `R`: current sandbox restart
3. Result UI terminal state handling
4. `F2`: sandbox-only Test Mode open / close
5. 열린 Test Mode panel 처리
6. `T` / `Shift+T`: sandbox time test advance, if clock is running
7. auto end triggered state: block normal interactions
8. 열린 Outlet panel 처리
9. 열린 Phone panel 처리
10. 열린 End Day panel 처리
11. 열린 Interaction panel 처리
12. `Tab`: Phone panel toggle
13. `D`: debug overlay toggle
14. `E`: nearest interaction request

이 구조는 열린 modal 위에 다른 modal이 겹쳐 열리는 것을 피하고, `B` / `Backspace`와 `R`은 modal 상태와 관계없이 우선 처리한다.

## Input Lock 기준

Room stub player input은 sandbox modal이 열릴 때 잠기고, 모든 modal이 닫힌 뒤 복구된다.

잠금 대상:

- `SandboxInteractionPanel`
- `SandboxEndDayPanel`
- `SandboxPhonePanel`
- `SandboxOutletPanel`
- `SandboxTestModePanel`

`_has_open_modal()`과 `_restore_room_input_if_no_modal()`이 modal overlap과 premature input restore를 막는 기준으로 사용된다.

## 확인 결과

### Hub 진입

- `PrototypeHub.gd` registry에 `quarterview_gameplay_sandbox` 항목이 있다.
- scene path는 `res://scenes/prototypes/QuarterviewGameplaySandbox.tscn`이다.
- `PrototypeHub.tscn` startup이 headless에서 성공했다.

### Scene Startup

- `QuarterviewGameplaySandbox.tscn` startup이 headless에서 성공했다.
- project parse도 headless에서 성공했다.
- room stub, status / help / log label, panel preload 경로가 script error 없이 준비된다.

### RoomSceneContract Signal Flow

- `room_ready`, `nearest_interactable_changed`, `interaction_requested`, `debug_overlay_toggled`, `player_position_changed` 수신 경로를 확인했다.
- `room_back_requested`는 room stub에서 emit 가능한 signal이지만 sandbox controller 연결이 빠져 있어, sandbox-only bugfix로 연결과 handler를 추가했다.
- 추가된 handler는 no-op log 후 PrototypeHub로 돌아가며 Main / DAY1과 연결하지 않는다.

### Sandbox Clock / 02:00 Auto End

- Sandbox-local clock은 `20:00`에서 시작한다.
- `SANDBOX_AUTO_END_AFTER_MINUTES = 360` 기준으로 `02:00` 도달을 판정한다.
- 표시 시간은 elapsed minutes 기반으로 계산해 `23:59 -> 00:00 -> 02:00` midnight wrap을 처리한다.
- 기본 속도는 real `1`초당 sandbox `10`분이다.
- `T`는 `30`분, `Shift+T`는 `2`시간을 sandbox-only로 전진시킨다.
- `02:00` 도달 시 `sandbox_auto_end_triggered = true`, `sandbox_clock_running = false`, `sandbox_end_reason = "auto_02_00"`가 된다.
- auto end는 한 번만 발생한다.

### InteractionPanel Flow

- `E` 입력은 room stub의 nearest interaction request로 이어진다.
- `interaction_requested` payload는 `zone`, `role`, `future_source`, `visual_state`, `display_name`을 포함할 수 있다.
- `SandboxInteractionPanel`은 key / role / zone / future / state를 표시한다.
- Inspect는 no-op log만 남긴다.
- Bed / Phone / Power가 아닌 object Primary는 no-op log만 남긴다.
- Close / `ESC`는 panel을 닫고 room input을 복구한다.

### Bed End Day Flow

- Bed Primary는 sandbox-only `SandboxEndDayPanel`을 연다.
- Confirm은 `day_end_confirmed = true`를 sandbox status에 표시한다.
- Confirm은 `sandbox_end_reason = "manual_bed"`로 표시된다.
- Confirm 후 sandbox-local clock은 멈춘다.
- Confirm 후 `SandboxResultPanel`이 열린다.
- Confirm은 `DayResultPanel`, `Main`, `SurvivalState`를 호출하지 않는다.
- Cancel / Close / `ESC`는 confirmation을 닫고 room input을 복구한다.
- Confirmed 상태에서도 `R` restart와 `B` / `Backspace` Hub 복귀가 우선 유지된다.

### Auto End Flow

- `02:00` auto end는 confirmation 없이 종료 메시지를 표시한다.
- auto end 발생 시 현재 열린 sandbox modal은 숨겨진다.
- auto end 이후 `SandboxResultPanel`이 열린다.
- auto end 후 room input은 잠긴다.
- auto end 후 `E`, `Tab`, Bed / Phone / Power interaction은 무시된다.
- `ESC`는 auto end message를 닫지 않고 `R` restart 또는 `B` / `Backspace` Hub 안내만 남긴다.
- 실제 Result, Main day flow, `SurvivalState` day advance는 호출하지 않는다.

### Sandbox Result UI Flow

- `SandboxResultPanel`은 end reason, start time, end time, elapsed minutes, sandbox-only warning을 표시한다.
- Manual Bed End는 `manual_bed` / `Manual Rest`로 표시된다.
- Auto End는 `auto_02_00` / `02:00 Auto End`로 표시된다.
- Result open 후 room input은 잠긴다.
- Result open 후 `E`, `Tab`, Bed / Phone / Power interaction은 실행되지 않는다.
- Result `Restart` button과 `R`은 current sandbox scene reload로 초기화한다.
- Result `Hub` button과 `B` / `Backspace`는 PrototypeHub로 복귀한다.
- Result `Hide Details`는 panel만 숨기며 gameplay는 종료 상태로 유지한다.
- 기존 `DayResultPanel`, `Main`, `SurvivalState`, reward, save / load, story flag는 호출하지 않는다.

### Sandbox Test Mode Flow

- `F2`는 `SandboxTestModePanel`을 열고 닫는다.
- Test Mode open 중 sandbox-local clock은 pause된다.
- Test Mode close 시 terminal state가 아니면 open 전 clock running 상태를 복구한다.
- Test Mode open 중 room stub movement, `E` interaction, `Tab` Phone toggle, Bed / Phone / Power panel open은 잠긴다.
- `B` / `Backspace` Hub 복귀와 `R` restart는 Test Mode보다 우선 처리된다.
- `+30 min`과 `+2 hours`는 sandbox-local elapsed minutes만 진행한다.
- time advance가 `02:00`에 도달하면 기존 sandbox auto end helper를 호출한다.
- `Jump 01:50`은 sandbox-local time을 `01:50`으로 맞추며 auto end는 아직 발생시키지 않는다.
- `Trigger Auto End`는 기존 sandbox auto end / Result helper 흐름을 사용한다.
- `Trigger Manual Result`는 sandbox-only manual Bed result helper 흐름을 사용한다.
- `Reset Sandbox`는 time `20:00`, elapsed `0`, end / result / modal 상태를 초기화하고 room input을 복구한다.
- Test Mode는 Main Test Mode, `SurvivalState`, `DeviceDefinition`, `PhoneUI`, `OutletMode`, `DayResultPanel`, reward, save / load, story flag를 조작하지 않는다.

### Phone Panel Flow

- `Tab`으로 sandbox Phone panel을 열고 닫는 경로가 있다.
- Phone object Primary도 sandbox Phone panel을 연다.
- Phone panel은 mock status와 Main / DAY1 Phone flow 미연결 안내를 표시한다.
- `Tab` / `ESC` / Close는 panel을 닫고 room input을 복구한다.
- 기존 `PhoneUI.gd`, Main phone routing, `SurvivalState` battery state는 호출하지 않는다.

### Outlet Panel Flow

- Power object Primary는 sandbox Outlet panel을 연다.
- Outlet panel은 mock slot / candidate list와 Main / DAY1 Outlet flow 미연결 안내를 표시한다.
- Mock buttons는 text / log feedback만 남기고 실제 connected / active state를 변경하지 않는다.
- `ESC` / Close는 panel을 닫고 room input을 복구한다.
- 기존 `OutletMode.gd`, `SurvivalState`, `Apartment` wire overlay는 호출하지 않는다.

### Debug / Restart / Help

- `D`는 sandbox debug overlay와 room stub debug overlay를 함께 갱신하는 경로가 있다.
- `R`은 current scene reload로 sandbox 상태를 초기화한다.
- `T` / `Shift+T`는 sandbox-local clock 수동 확인용 shortcut이다.
- `B` / `Backspace`는 modal 상태보다 우선해 PrototypeHub로 복귀한다.
- Result open 후 `ESC`는 gameplay로 돌아가지 않고 안내 로그만 남긴다.
- Help label에는 `E`, `Tab`, `ESC`, `T`, `D`, `R`, `B` / `Backspace` 안내가 포함되어 있다.

## 아직 연결하지 않은 실제 기능

- Main용 `InteractionPanel`
- 실제 Bed End Day / `SurvivalState` day advance
- `DayResultPanel`
- real Main `PhoneUI`
- real Main `OutletMode`
- real `SurvivalState` phone battery / charge state
- real `SurvivalState` connected / active state
- Apartment wire overlay
- real Main `02:00` auto end / Result flow
- real Main Test Mode
- Laptop -> `HackingActionPrototype`
- reward / Result / story flag
- save / load
- Grid Credit reward

## 검증

- `git diff --check`
- `/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --quit-after 2`
- `/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/prototypes/QuarterviewGameplaySandbox.tscn --quit-after 2`
- `/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/prototypes/PrototypeHub.tscn --quit-after 2`
- `/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_survival_state.gd -gexit`

Godot AI MCP read-only 확인은 local MCP HTTP 연결 실패로 수행하지 못했다. 대신 로컬 파일과 Godot headless startup으로 확인했다.

## 남은 이슈 / 다음 작업 후보

- GUI에서 실제 키 입력으로 `E`, `Tab`, `ESC`, `R`, `D`, `B` / `Backspace` 우선순위를 수동 확인해야 한다.
- GUI에서 sandbox-local clock 표시와 `T` / `Shift+T` time advance, `02:00` auto end trigger를 수동 확인해야 한다.
- GUI에서 Sandbox Result UI의 Restart / Hub / Hide Details buttons와 terminal input lock을 수동 확인해야 한다.
- GUI에서 modal open 중 player movement lock과 close 후 restore를 수동 확인해야 한다.
- Sandbox panel layout, text fit, focus, button hover / click 상태는 headless로 검증되지 않는다.
- 다음 단계에서 실제 기능 연결을 시작하더라도 Main / DAY1 직접 수정이 아니라 sandbox에서 먼저 검증한다.
