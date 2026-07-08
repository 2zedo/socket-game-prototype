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

## Apartment Shell Footprint Placeholders

These are coordinate-based debug placeholders in `QuarterviewApartmentShellCandidate`, not final room objects, sprites, or production interactions.

Resource script:

- `godot/scripts/quarterview/ApartmentObjectFootprintConfig.gd`
- `godot/scripts/quarterview/ApartmentObjectFootprintSetConfig.gd`

Default Resource:

- `godot/resources/quarterview/apartment_shell_object_footprints.tres`

Fallback list location:

- `_default_object_footprint_configs()` in `godot/scripts/quarterview/QuarterviewApartmentShellCandidate.gd`

Loading order:

1. `object_footprint_set.objects` from the Resource assigned on `QuarterviewApartmentShellCandidate`
2. fallback `_default_object_footprint_configs()` when the Resource is empty or unassigned
3. additive `custom_object_footprints` entries from the Inspector

Current shell-only placeholder defaults:

| Placeholder ID | Room Area | Anchor | Size | Interaction Cells | Movement |
| --- | --- | --- | --- | --- | --- |
| `bed_placeholder` | `living_area` | `(8,6)` | `(2,2)` | `(7,7)` | blocks |
| `fridge_placeholder` | `living_area` | `(10,4)` | `(1,1)` | `(10,5)` | blocks |
| `sink_counter_placeholder` | `living_area` | `(8,4)` | `(1,1)` | `(8,5)` | blocks |
| `microwave_placeholder` | `living_area` | `(9,4)` | `(1,1)` | `(9,5)` | non-blocking |
| `small_table_placeholder` | `living_area` | `(4,6)` | `(2,1)` | `(4,7)`, `(5,7)` | blocks |
| `desk_placeholder` | `work_power_area` | `(2,0)` | `(2,1)` | `(2,1)` | blocks |
| `navi_chair_placeholder` | `work_power_area` | `(4,1)` | `(2,2)` | `(4,3)`, `(5,3)` | blocks |
| `power_panel_placeholder` | `work_power_area` | `(8,1)` | `(1,2)` | `(7,2)` | blocks |
| `connector_board_placeholder` | `work_power_area` | `(7,1)` | `(1,1)` | `(7,2)` | blocks |
| `comm_device_placeholder` | `work_power_area` | `(1,2)` | `(1,1)` | `(2,2)` | non-blocking |
| `bathroom_fixture_placeholder` | `bathroom` | `(0,7)` | `(1,1)` | `(1,7)` | blocks |
| `entrance_shoe_area_placeholder` | `entrance_area` | `(1,9)` | `(1,1)` | `(1,8)` | non-blocking |

First-pass coordinate intent:

- Doorway-adjacent placeholders avoid the current entrance and shared-room passable edges.
- Blocking living-space placeholders leave the entrance, table approach, kitchen approach, and shared doorway test paths walkable.
- Work-space placeholders stay inside `work_power_area` and keep the center / entry approach open for shell navigation checks.
- `entrance_shoe_area_placeholder` is non-blocking and sits near the entrance without occupying the exterior door cell.

Shell editing controls:

- `P`: show object footprint placeholders.
- `N`: show navigation / collision debug; blocking footprints are removed from walkable cells.
- `I`: print wall inventory followed by object footprint summary.
- `debug_focus_object_id`: emphasize one footprint id, for example `bed_placeholder`.
- Object overlay detail options: `show_object_labels`, `show_object_interaction_cells`, `show_blocking_object_cells`, and `show_nonblocking_object_cells`.

Coordinate rule:

- Object footprints use floor cell coordinates: `anchor_cell`, `size_cells`, `occupied_cells`, and `interaction_cells`.
- Wall segments use wall edge coordinates: `from_cell -> to_cell`.
- Do not treat object floor cells and wall edge coordinates as the same coordinate layer.

Production boundary:

- These placeholders do not create `RoomObjectDefinition` Resources.
- They do not add furniture, final sprites, atlas wiring, pathfinding, save-load, Grid Credit, story flags, or QuarterviewMain production wiring.
- They exist only to test footprint, interaction-cell, and movement-blocking assumptions before final art / object placement.

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
