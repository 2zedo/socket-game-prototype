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
- [ ] Walls and object blockers do not trap or push Yui strangely.
- [ ] Movement stops while the interaction panel is open.
- [ ] Movement resumes after the interaction panel is closed.

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
- [ ] Press `E` to open `InteractionPanel`.
- [ ] Press `ESC` to cancel.
- [ ] Approach again, press `E`, then press `E` again to confirm use.
- [ ] Current power decreases by the expected amount.
- [ ] Power strip `오늘 남은 전력` and room HUD `오늘 남은 전력` show the same value after use.
- [ ] HUD use record updates.
- [ ] Trying the same object again is blocked as already used.
- [ ] When power is insufficient, use is blocked and a clear message appears.

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
- [ ] All five power objects support use, cancel, insufficient-power, and duplicate-use flows.
- [ ] Laptop, Fan, Charger, and Communication Device require outlet connection before use.
- [ ] Light follows the currently implemented connection rule; update this criterion after the built-in fluorescent versus plug-in Lamp decision.
- [ ] Movement and interaction UI do not conflict.
- [ ] No fatal errors occur during Godot play.
