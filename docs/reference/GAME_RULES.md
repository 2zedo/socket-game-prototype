# Game Rules Reference

## Role

This is the current reference for gameplay rules and state boundaries.

## Current Core Loop

Target loop:

```text
Wake / check current state
-> inspect room objects
-> manage power / food / condition
-> accept or prepare information job
-> enter hacking candidate / future hacking mode
-> review result
-> end day
```

Current QuarterviewMain loop is candidate-only:

- mock HUD
- local mock day/time/power/hunger/condition/info
- object overlays
- job acceptance candidate
- Hacking Entry candidate
- Day Result candidate

Production loop remains old Main / DAY1 until approved replacement.

## Input Rules

Main room direction:

- Mouse-click first.
- Click object -> Yui moves -> candidate panel.
- WASD is not the main design direction.
- Debug / tuning inputs can exist but must not define production UX.

Current QuarterviewMain inputs:

- `P`: portable Phone candidate.
- `D`: debug overlay.
- `F3`: footprint tuning mode.
- `[` / `]`: selected object debug navigation.
- `C`: layout snippet output.
- `Shift+R`: debug-only restart.
- Power board `R`: rotate selected / dragged module.

## State Ownership

Production:

- `SurvivalState.gd` owns day, time, power, connected devices, active devices, phone state, result data.
- Connected and active devices are separate.
- Active drain calculation remains production `SurvivalState`.

Candidate / sandbox:

- QuarterviewMain mock HUD state is local-only.
- Sandbox clock / result / test mode are not production state.
- Candidate overlays do not mutate production state.

## Power Rules

Long-term direction:

- Power equipment becomes modular power-board / power-tetris.
- Manage power, heat, and bonus effects.
- Weird larger shapes may be more efficient.
- Failure should first cause warning, efficiency loss, risk increase, or performance degradation.

Current implementation:

- `PowerBoardCandidate.gd` supports Resource-backed module inventory, drag, snap, overlap invalid, out-of-grid reset, rotation, and return to inventory.
- `PowerModuleDefinition.gd` defines module data.
- No real power calculation.
- No OutletMode wiring.
- No SurvivalState connected / active update.

Current modules:

- `small_core`
- `laptop_adapter`
- `comm_module`
- `odd_efficiency_module` as L-shape candidate

## Food / Hunger Rules

Direction:

- Hunger remains part of the survival axis.
- Low hunger should eventually cause debuffs / poor condition.
- Good food management can eventually give buffs.
- Food tone: processed meat, artificial meat, cultured food, vegetables.
- Seafood is luxury and a symbol of the outside world / sea.

Current implementation:

- Food / Kitchen candidate overlay exists for Fridge / Microwave.
- It changes QuarterviewMain mock HUD only.
- No inventory, real hunger system, SurvivalState connection, or production result link.

## Phone / Job Rules

Phone direction:

- Phone is portable equipment, opened with `P`.
- Phone job tab can present anonymous job candidates.
- Production PhoneUI remains separate and protected.

Current job:

- `maintenance_17_fragment`
- accepts into QuarterviewMain mock active job.
- reflected in HUD, Day Result candidate, Desk / Laptop preparation, Hacking Entry candidate.

No current production:

- message persistence
- battery state integration
- reward payout
- save-load
- story flags

## Hacking Rules

Hacking direction:

- First focus: action infiltration and defense.
- Infiltration target loop: enter -> extract objective -> escape.
- Combat and stealth can be playstyle / equipment branches inside a larger action infiltration mode.
- NAVI proxy is the conceptual bridge between Yui's room and hacking space.

Current implementation:

- `HackingActionPrototype` exists and has GUT state-machine coverage.
- QuarterviewMain Hacking Entry candidate is a no-op pre-entry overlay.
- No Laptop-to-Hacking scene transition.
- No mission reward / result / story flag.

## Day Result Rules

Current:

- QuarterviewMain Day Result candidate summarizes local mock state.
- `DayResultPanel` production UI remains current Main-only.

Future:

- Result should summarize power management, hunger/condition, job progress, risk, and story information.
- Production result wiring must go through an approved Main replacement / state ownership pass.

## Non-Goals Without Explicit Task

- Connect QuarterviewMain mock state to `SurvivalState`.
- Connect Phone candidate to production `PhoneUI`.
- Connect Power board to `OutletMode`.
- Connect Day Result candidate to production `DayResultPanel`.
- Award Grid Credit.
- Save/load job state.
- Set story flags.
- Switch `project.godot` start scene.
