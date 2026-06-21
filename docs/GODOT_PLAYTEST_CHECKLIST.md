# Godot Playtest Checklist

## Purpose

Use this checklist to verify that the Godot DAY 1 MVP is actually playable in the Godot editor from start through result summary.

## Preconditions

- Open the Godot project at `godot/project.godot`.
- Run the main scene: `res://scenes/Main.tscn`.
- Before testing, confirm local `main` is up to date with `origin/main`.
- Do not commit Godot cache files such as `godot/.godot/`, shader cache, or editor-generated local files.

## Basic Movement Test

- [ ] Yui moves with WASD.
- [ ] Yui moves with arrow keys.
- [ ] Diagonal movement does not pass through wall corners or object blocker corners.
- [ ] Walls and object blockers do not trap or push Yui strangely.
- [ ] Yui cannot enter the black margins beyond the left, right, top, or bottom apartment boundary.
- [ ] Rubbing diagonally against each outer corner does not escape through a gap.
- [ ] Movement stops while the interaction panel is open.
- [ ] Movement resumes after the interaction panel is closed.

## In-Game Clock Test

- [ ] A new day starts at `08:00 / 아침`.
- [ ] Phone UI 시간이 `20:00`, `00:00`, `01:00`을 지나 다음 날 `02:00`까지 진행된다.
- [ ] 시간대가 아침/낮/저녁/밤/새벽으로 표시된다.
- [ ] The normal HUD does not show current time or time period details.
- [ ] `02:00` 도달 시 시간과 지속 전력 소비가 멈추고 `피곤하니 슬슬 자야겠다.` 문구가 표시된다.
- [ ] `02:00` 도달 시 오른쪽 확인 패널 없이 유이 대사와 `[E] 계속` 힌트만 표시된다.
- [ ] 자동 한계 대사 상태에서 `ESC`로 탐색에 복귀할 수 없다.
- [ ] 자동 한계 대사 상태에서 `E`를 누르면 기존 Result 화면으로 이동한다.
- [ ] Time advances during exploration and while only Test Mode is enabled.
- [ ] Time pauses in Phone, Outlet, Interaction, End Day confirmation, and Result screens.
- [ ] Closing a modal resumes the clock.

## Test Mode And Input Routing Test

- [ ] Pressing `P` toggles `TEST MODE: ON` and the debug readout.
- [ ] The readout shows player position, velocity, day, power, load watts, used slots, nearest interactable, and modal state.
- [ ] Player collision is outlined in blue and the interaction range in green.
- [ ] Wall blockers are outlined in red and object blockers in orange-red.
- [ ] Interactable ranges are outlined in green and the nearest interactable is highlighted in yellow.
- [ ] Connected wire/device anchors are visible as debug points when applicable.
- [ ] Moving between nearby objects prints nearest-object changes in the Godot output.
- [ ] Opening the power strip shows outlet slot and adapter hitboxes in the Test Mode overlay.
- [ ] Pressing `ESC` closes Outlet Mode before affecting any lower-priority UI.
- [ ] Pressing `ESC` closes an interaction or End Day confirmation and restores movement.
- [ ] Pressing `ESC` on the result screen does not accidentally return to exploration.
- [ ] Player movement remains locked while any modal UI is active and resumes after it closes.
- [ ] `Tab`으로 Phone UI를 열고 `Tab` 또는 `ESC`로 닫을 수 있다.
- [ ] 테스트 모드에서 `F1`로 한국어 도움말을 열고 닫을 수 있다.
- [ ] 기본 진단 정보에 `[F1] 테스트 키 도움말` 안내가 항상 보인다.
- [ ] `PageUp`/`PageDown`으로 시간을 1시간씩 조정하며 `08:00` 이전으로 내려가지 않는다.
- [ ] `PageUp`으로 `02:00`에 도달하면 기존 자동 종료 대사-only 흐름이 열린다.
- [ ] `F8`로 `01:50`에 이동한 뒤 실제 시간 진행 또는 `PageUp`으로 기존 자동 종료 대사-only 흐름에 진입한다.
- [ ] `-`/`=`로 휴대폰 배터리를 5%씩 조정하고 경고 및 0% 화면을 확인할 수 있다.
- [ ] `1`/`2`/`3`/`4`로 배터리를 `21%`/`11%`/`6%`/`1%`에 놓고 `-`를 눌러 각 경고 임계값을 확인한다.
- [ ] `,`/`.`/`0`으로 오늘 전력을 감소, 증가, 최대 회복할 수 있다.
- [ ] `5`로 오늘 전력을 `0.5`에 놓아 지속 소비에 따른 0 도달 처리를 확인한다.
- [ ] `O`로 모든 작동 장치를 끄되 연결, 전선, 사용 기록이 유지된다.
- [ ] `U`로 모든 장치 연결을 해제하면 작동 장치, 부하, 슬롯, 전선이 함께 초기화되고 사용 기록은 유지된다.
- [ ] `L`로 시간, 전력, 배터리, 부하, 슬롯, 연결/작동 장치, 소비율, 모달, 하루 종료 상태가 출력된다.
- [ ] 테스트 모드가 꺼져 있거나 모달이 열려 있으면 상태 조정 키가 게임 상태를 바꾸지 않는다.
- [ ] With no modal open, `ESC` does not create a pause menu yet.

## Proximity Interaction Test

- [ ] Light prompt appears only near the Light.
- [ ] Laptop prompt appears only near the Laptop.
- [ ] Fan prompt appears only near the Fan.
- [ ] Charger prompt appears only near the Charger.
- [ ] Communication Device prompt appears only near the Communication Device.
- [ ] Pressing `E` away from interactable objects does not open the interaction panel.

## Outlet Management Test

- [ ] Outlet/power strip prompt appears only near the power strip.
- [ ] Opening the power strip shows `오늘 남은 전력: 10 / 10`.
- [ ] Opening the power strip shows `현재 부하: 0W / 3000W` before any device is connected.
- [ ] Opening the power strip shows `콘센트: 0 / 4` before any device is connected.
- [ ] The center power strip uses the provided `powerstrip_4slot.png`.
- [ ] The bottom adapter row shows Fan, Communication Device, Laptop, Charger, and Lamp adapter PNGs.
- [ ] Dragging a 1-slot adapter highlights valid and invalid socket positions.
- [ ] Dropping a 1-slot adapter on an empty slot connects it.
- [ ] Clicking or dragging an already connected adapter disconnects it.
- [ ] Connecting a device increases current load watts.
- [ ] Connecting a device increases used outlet slots.
- [ ] Fan uses 1 outlet slot.
- [ ] Communication Device uses 1 outlet slot.
- [ ] Charger uses 1 outlet slot.
- [ ] Current implementation: Lamp/Light uses 1 outlet slot. Record this result separately because the final Light model is still a design decision.
- [ ] Laptop uses 2 outlet slots.
- [ ] Laptop can start from slot 1, 2, or 3.
- [ ] Laptop cannot start from slot 4.
- [ ] Laptop + Light + Charger fills `4 / 4` slots.
- [ ] Connecting a device does not decrease today's remaining power.
- [ ] Disconnecting an active device also turns that device off.
- [ ] Disconnecting a device decreases current load watts and used outlet slots.
- [ ] A device that would exceed load or slot limits cannot be connected.
- [ ] The power strip does not feel like a separate resource minigame; it only controls which room objects can be used.

## Dynamic Map Wire Test

- [ ] The apartment map starts from `map_base_no_wires.png` with no device wires visible.
- [ ] Fan-only connection shows only `WireFan`.
- [ ] Communication-only connection shows only `WireCommunication`.
- [ ] Laptop-only connection shows `WireLaptopFloor` and `WireLaptopDesk` together.
- [ ] Charger-only connection shows only `WireCharger`.
- [ ] Lamp-only connection shows only `WireLamp`.
- [ ] Laptop + Charger shows both wires fully, with neither line cut off by the other.
- [ ] Lamp + Laptop shows both wires fully, with the Laptop wire still visible.
- [ ] Laptop + Charger + Lamp shows all three wires fully.
- [ ] Disconnecting a device hides only that device's wire.
- [ ] Refrigerator wiring never appears as a connection target.
- [ ] Laptop desk wire reaches the laptop body and does not stop at the desk edge.

## Power Object Test

For each object below, verify the full flow:

- [ ] Before connecting the device, press `E` near the object and confirm the disconnected message appears.
- [ ] The disconnected message says the device must be connected through the power strip first.
- [ ] Today's remaining power does not decrease when disconnected use is blocked.
- [ ] Connect the matching device through the power strip.
- [ ] Press `E` to open `InteractionPanel` and confirm the connected device shows `꺼짐` with a `켜기` action.
- [ ] Press `ESC` to cancel.
- [ ] Approach again, press `E`, then confirm `켜기`.
- [ ] Current power does not drop as an immediate one-time charge, but decreases while exploration time advances.
- [ ] Laptop alone reports `-3.0 / h`; Fan plus Laptop reports `-4.0 / h`.
- [ ] Remaining power is displayed to one decimal place in Phone UI and decreases according to elapsed game hours.
- [ ] Open Phone, Outlet, Interaction, End Day, and Result modals and confirm active power drain pauses with the clock.
- [ ] Interact with the active device again and confirm `끄기` stops further power drain.
- [ ] Turn the same device on again and confirm the historical used record does not block it.
- [ ] Result use record updates on first activation while Phone shows only the current active-device state.
- [ ] When power reaches zero, active devices switch off safely and a clear warning appears.
- [ ] Phone battery warnings trigger once per downward crossing at `20%`, `10%`, `5%`, and `0%`, without repeating while remaining below a threshold.
- [ ] Charging above a Phone battery threshold rearms it; after charging stops, crossing downward again shows the warning again.
- [ ] Phone battery threshold warnings remain suppressed while the Charger is currently active.

Target objects:

- [ ] Light
- [ ] Laptop
- [ ] Fan
- [ ] Charger
- [ ] Communication Device

## End Day Test

- [ ] Bed/rest prompt appears near the bed/rest position.
- [ ] Press `E` to open the "오늘을 마칠까요?" confirmation panel.
- [ ] Press `ESC` to cancel and return to exploration.
- [ ] Open the panel again and press `E` to confirm.
- [ ] Result summary appears.
- [ ] Summary shows remaining power.
- [ ] Summary shows used objects.
- [ ] Summary shows discovered information.
- [ ] Summary shows simple state changes.
- [ ] Connected device visuals remain synced in the room after continuing to the next day.

## Visual Direction Check

- [ ] The game does not feel like a static point-and-click screen.
- [ ] Top-down movement plus proximity `E` interaction remains clear.
- [ ] The screen does not resemble a prison/facility-management game such as `Break the Animal Prison`.
- [ ] UI does not feel too much like a score board, task sheet, or generic management HUD.
- [ ] Room HUD does not show debug-like `전력 테스트 공간`, points, unclear timer, or unrelated survival status bars.
- [ ] Power strip UI clearly separates daily power budget from current outlet load.
- [ ] The one-room apartment, power shortage, survival log, and power-panel tone remain visible.
- [ ] Exploration state shows only room, compact HUD, nearby prompt, and minimal controls.
- [ ] Exploration does not show the left status HUD; nearby prompt and bottom controls remain visible.
- [ ] Interaction state dims the room and uses the right-side info panel plus Yui comment panel.
- [ ] Multitap state reads as a dark power connection panel, not a separate arcade screen.
- [ ] Result state reads as `DAY 1 기록` / survival log, not a score results screen.

## Bug Report Template

```text
[Bug]
- Scene:
- Steps:
- Expected:
- Actual:
- Screenshot/Video:
- Severity:
- Notes:
```

## Pass Criteria

- [ ] The player can progress from DAY 1 start to End Day result summary.
- [ ] All five power objects support connected-only activation, cancel, on/off control, continuous drain, and zero-power shutdown.
- [ ] Laptop, Fan, Charger, and Communication Device require outlet connection before use.
- [ ] Light follows the currently implemented connection rule; update this criterion after the built-in fluorescent versus plug-in Lamp decision.
- [ ] Movement and interaction UI do not conflict.
- [ ] Test Mode can expose collision and interaction bounds without changing gameplay state.
- [ ] No fatal errors occur during Godot play.
