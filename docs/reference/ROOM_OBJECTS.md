# Room And Objects Reference

## Role

This is the current reference for room structure, object keys, roles, and relevant file locations.

## Current Room Architecture

Production golden path:

- `godot/scenes/Main.tscn`
- `godot/scripts/Main.gd`
- `godot/scenes/Apartment.tscn`
- `godot/scripts/Apartment.gd`
- `godot/scripts/SurvivalState.gd`

Quarterview candidate:

- `godot/scenes/QuarterviewMain.tscn`
- `godot/scripts/QuarterviewMain.gd`
- `godot/scenes/quarterview/QuarterviewRoom.tscn`
- `godot/scripts/quarterview/QuarterviewRoom.gd`
- `godot/scripts/quarterview/QuarterviewPlayer.gd`

Room contract:

- `godot/scripts/contracts/RoomSceneContract.gd`

## Current QuarterviewMain Flow

- Background image / room shell candidate is shown.
- Player moves by mouse click.
- Room object click moves Yui to approach point.
- Candidate panel opens after approach.
- Overlays are QuarterviewMain-only.
- Room input is locked while overlay / candidate panel is open.
- ESC / close button / backdrop click closes overlays.

Current overlays:

- Desk close-up candidate
- Power board candidate
- Phone screen candidate through `P`
- Bed rest candidate
- Food / Kitchen candidate
- Door candidate
- Day Result candidate
- Hacking Entry candidate

## Room Object Resources

Resource script:

- `godot/scripts/resources/RoomObjectDefinition.gd`

Resource directory:

- `godot/resources/rooms/quarterview/objects/`

Current object resources:

| Key | File | Role / Purpose |
| --- | --- | --- |
| `bed` | `bed.tres` | rest / manual end-day candidate |
| `desk` | `desk.tres` | desk close-up / work area |
| `laptop` | `laptop.tres` | job / Hacking Entry candidate |
| `power` | `power.tres` | power board candidate |
| `phone` | `phone.tres` | portable equipment; room interaction disabled |
| `comm` | `comm.tres` | communication device |
| `node17` | `node17.tres` | mystery device |
| `speaker` | `speaker.tres` | audio / hacking device |
| `signal_booster` | `signal_booster.tres` | support / communication |
| `ups` | `ups.tres` | support power device candidate |
| `fridge` | `fridge.tres` | living appliance |
| `microwave` | `microwave.tres` | living appliance |
| `aircon` | `aircon.tres` | living appliance / fixture candidate |
| `door` | `door.tres` | entrance / outing candidate |
| `bathroom_door` | `bathroom_door.tres` | background structure |
| `shelf` | `shelf.tres` | background life hint |
| `small_table` | `small_table.tres` | background life hint |

## Portable Phone Policy

Phone is no longer treated as a fixed room click target in QuarterviewMain.

Current behavior:

- Open with `P`.
- `phone.tres` is marked portable-only / room interaction disabled.
- Room click / hover / nearest targeting excludes Phone.

Production boundary:

- Current production `PhoneUI` remains Main-only.

Visual planning rule:

- Living-space art may include a Phone charging/resting spot near bed or dining.
- That spot is environmental storytelling only unless a future task creates a separate object/resource.
- Phone itself remains portable and opened with `P`.

## Act 1 Visual Cue Candidates

These are current art / story planning cues, not implemented `RoomObjectDefinition` Resources unless listed elsewhere.

| Candidate | Preferred Space | Purpose | Implementation Status |
| --- | --- | --- | --- |
| `power_ration_panel` | living wall | small power ration / outlet-limit cue | visual planning only |
| `phone_charge_spot` | living bed/dining side | portable Phone life cue, Mika DM implication | visual planning only |
| `pip03_charge_spot` | living entrance / utility corner | PIP-03 home support cue | visual planning only |
| `job_notice_trace` | living small surface | anonymous job notification hint, not full work board | visual planning only |
| `navi_link_station` | work + power room | primary hacking-entry visual | visual planning; Hacking Entry candidate is UI-only |
| `navi_power_line` | work + power room | clean connection between NAVI LINK and power panel | visual planning only |
| `pip03_service_port` | work + power room | PIP-03 diagnostic / power-check port | visual planning only |
| `node17_slot` | work + power room | future NODE-17 / signal slot, inactive | visual planning only |

Do not add these as production gameplay objects without a dedicated Resource / interaction task.

## Job Resources

Resource script:

- `godot/scripts/resources/QuarterviewJobDefinition.gd`

Resource directory:

- `godot/resources/rooms/quarterview/jobs/`

Current job:

- `maintenance_17_fragment.tres`

Current flow:

- Phone job tab displays it.
- Accepting it sets QuarterviewMain mock active job.
- Desk / Laptop and Hacking Entry candidate read the local active job.

## Power Module Resources

Resource script:

- `godot/scripts/resources/PowerModuleDefinition.gd`

Resource directory:

- `godot/resources/rooms/quarterview/power_modules/`

Current modules:

- `small_core.tres`
- `laptop_adapter.tres`
- `comm_module.tres`
- `odd_efficiency_module.tres`

Current PowerBoardCandidate behavior:

- load module Resources
- show inventory
- drag module ghost
- snap to grid
- block overlap
- block out-of-grid placement
- rotate selected / dragged module
- return to inventory

No production power calculation is wired.

## Legacy Device Resources

Current Main / DAY1 device resources:

- `godot/scripts/resources/DeviceDefinition.gd`
- `godot/resources/devices/charger.tres`
- `godot/resources/devices/communication_device.tres`
- `godot/resources/devices/fan.tres`
- `godot/resources/devices/laptop.tres`
- `godot/resources/devices/light.tres`

These remain production Main / DAY1 references. Do not casually merge them with Quarterview power module data.

## Object Implementation Boundaries

Room object data can define:

- stable key
- display name
- role
- future source
- visual state
- position / size
- approach / click / footprint candidates
- portable / room interaction flags

Room object data should not own:

- production power drain
- production day advance
- production result calculation
- save-load
- story flag state

## Current Manual Check Focus

- Click movement to object approach.
- Candidate panel placement and close.
- Overlay input lock and restore.
- Phone `P` access.
- Power board drag / rotate / return UX.
- Desk / Laptop active-job Hacking Entry candidate.
- No production PhoneUI / OutletMode / DayResultPanel / SurvivalState calls.
