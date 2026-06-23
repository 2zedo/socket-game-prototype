# Godot Testing

## Purpose

This document records the current automated test setup for the Godot project.

The first test target is `SurvivalState.gd` because it owns DAY 1 power state, outlet connection state, active device state, clock pause behavior, and Phone battery warnings.

## Test Addon

- Test framework: GUT
- Installed version: `v9.5.0`
- Compatibility target: Godot `4.5.x`
- Addon path: `godot/addons/gut/`

GUT `v9.5.0` is used because the project currently runs on Godot `4.5.1`. Do not upgrade to a Godot `4.6`-only GUT release without first upgrading the project and confirming compatibility.

## Current Test Files

- `godot/test/unit/test_survival_state.gd`

Covered behavior:

- DAY 1 `DeviceDefinition` Resource values for Laptop and Communication Device.
- Connected and active state separation.
- Active device drain-rate summing.
- Modal pause stopping active power drain.
- Phone battery warning rearm after threshold recovery.

## Command Line

Run the current unit tests from the repository root:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_survival_state.gd
```

CI-style runs should include `-gexit` so the command exits after printing results:

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
