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

## Power Object Test

For each object below, verify the full flow:

- [ ] Press `E` to open `InteractionPanel`.
- [ ] Press `ESC` to cancel.
- [ ] Approach again, press `E`, then press `E` again to confirm use.
- [ ] Current power decreases by the expected amount.
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

## Visual Direction Check

- [ ] The game does not feel like a static point-and-click screen.
- [ ] Top-down movement plus proximity `E` interaction remains clear.
- [ ] The screen does not resemble a prison/facility-management game such as `Break the Animal Prison`.
- [ ] UI does not feel too much like a score board, task sheet, or generic management HUD.
- [ ] The one-room apartment, power shortage, survival log, and power-panel tone remain visible.

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
- [ ] Movement and interaction UI do not conflict.
- [ ] No fatal errors occur during Godot play.
