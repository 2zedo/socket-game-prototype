# Godot Testing

## Purpose

This document records the current automated test setup for the Godot project.

The first test target was `SurvivalState.gd` because it owns DAY 1 power state, outlet connection state, active device state, clock pause behavior, and Phone battery warnings. The unit suite now also protects key Resource contracts and prototype helper contracts that future sandbox work depends on.

## Test Addon

- Test framework: GUT
- Installed version: `v9.5.0`
- Compatibility target: Godot `4.5.x`
- Addon path: `godot/addons/gut/`

GUT `v9.5.0` is used because the project currently runs on Godot `4.5.1`. Do not upgrade to a Godot `4.6`-only GUT release without first upgrading the project and confirming compatibility.

## Current Test Files

- `godot/test/unit/test_survival_state.gd`
- `godot/test/unit/test_device_definition_resources.gd`
- `godot/test/unit/test_room_object_definition.gd`
- `godot/test/unit/test_room_scene_contract.gd`
- `godot/test/unit/test_prototype_scene_utils.gd`

Covered behavior:

- DAY 1 `DeviceDefinition` Resource values for Laptop and Communication Device.
- Connected and active state separation.
- Active device drain-rate summing.
- Modal pause stopping active power drain.
- Phone battery warning rearm after threshold recovery.
- `DeviceDefinition` Resource validity, stable keys, slot counts, drain values, and duplicate-key guard.
- `RoomObjectDefinition` helper behavior, primary action label mapping, Resource validity, and key room object roles.
- `RoomSceneContract` signal names, action constants, no-op skeleton method safety, and interaction payload shape.
- `PrototypeSceneUtils` shared B / Backspace, R, D, E / Enter, and ESC input-event checks.

## Command Line

Run the full unit suite from the repository root:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
```

Individual test files can still be run with `-gtest` when isolating a failure:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_survival_state.gd -gexit
```

For all future GUT tests, prefer adding test files under:

```text
godot/test/unit/
```

## Scope Rules

- Tests should protect current behavior before changing gameplay code.
- Do not modify `SurvivalState.gd` just to make a test pass unless the user explicitly asks for a behavior fix.
- UI, scene layout, mouse drag, and visual feedback still require Godot Editor manual checks.
- Prototype tests should stay separate from Main / DAY 1 tests unless a task explicitly connects those systems.
