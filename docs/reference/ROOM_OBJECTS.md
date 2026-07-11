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

## Apartment Shell Object Layout Candidate

These are the first measured placement candidates in `QuarterviewApartmentShellCandidate`, not final sprites or production interactions. The list is synchronized with the approved apartment world-object inventory. Phone remains portable UI equipment and is not a world footprint; the spreadsheet's optional air-conditioner candidate is not part of this first pass.

Press `M + P + N` in the shell candidate to compare pixel visual/collision/interaction rectangles against room areas, doorway clearance, required circulation, wall attachment spans, and navigation. Automatic checks do not move walls or force art sizes to floor-cell dimensions. User visual confirmation is still required before placement is treated as final.

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

Current first-placement candidate:

| Object ID | Room | Anchor | Offset px | Visual px | Collision px | Interaction | Placement |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `entrance_door` | entrance | `(0,8)` | `(0,-6)` | `150x220` | none | `(0,8)`, `96x56` | wall: `entrance_wall` doorway |
| `bed` | living | `(8,6)` | `(10,-6)` | `260x180` | `180x90` | `(7,7)`, `120x64` | floor |
| `fridge` | living | `(10,4)` | `(-8,-12)` | `120x190` | `70x70` | `(10,5)`, `80x56` | floor |
| `microwave` | living | `(8,4)` | `(0,-60)` | `96x72` | none | `(8,5)`, `96x56` | parent: `sink_counter` |
| `navi_link` | work/power | `(4,1)` | `(12,-16)` | `300x240` | `210x120` | `(4,3)`, `(5,3)`, `128x80` | floor |
| `power_module_board` | work/power | `(8,1)` | `(0,-30)` | `200x180` | none | `(7,2)`, `120x72` | wall: `work_right_wall` |
| `node_17` | work/power | `(1,2)` | `(0,-8)` | `150x140` | `90x60` candidate | `(2,2)`, `96x64` | floor |
| `sink_counter` | living | `(8,4)` | `(0,0)` | `220x150` | `160x70` | none | floor environment |
| `dining_table` | living | `(4,6)` | `(0,0)` | `170x120` | `130x70` | none | floor environment |
| `signal_booster` | work/power | `(1,2)` | `(-68,-58)` | `112x96` | none | none | parent: `node_17` |
| `ups_unit` | work/power | `(8,2)` | `(0,0)` | `140x110` | `100x60` | none | parent: board; floor blocker |
| `bathroom_fixture` | bathroom | `(0,4)` | `(0,0)` | `200x140` | `150x80` | none | floor environment |
| `sea_horizon_poster` | living | `(10,7)` | `(0,-20)` | `160x80` | none | none | wall: `living_right_wall` |
| `fluorescent_light` | living | `(6,6)` | `(0,0)` | `240x40` | none | none | ceiling |
| `shoes_slippers` | entrance | `(1,9)` | `(0,0)` | `100x60` | none | none | non-blocking environment |
| `cable_bundle` | work/power | `(2,2)` | `(36,42)` | `80x40` | none | none | parent: `node_17` |
| `wall_conduit` | work/power | `(7,0)` | `(0,0)` | `128x64` | none | none | wall: `work_back_wall` |
| `power_housing` | work/power | `(8,1)` | `(0,0)` | `240x210` | none | none | parent: board / same wall |

Attachment policy:

- Wall, ceiling, and non-floor parent attachments do not remove navigation cells or participate in floor overlap checks.
- `ups_unit` retains floor occupancy and collision despite its relationship to `power_module_board`.
- `entrance_door` is represented in object inventory but aligns to the existing wall doorway unit; it does not create a duplicate floor blocker.
- Expected image/scene/audio values are future logical specification strings only. Missing assets are not loaded or validated in this candidate.

Shell editing controls:

- `P`: show object footprint placeholders.
- `N`: show navigation / collision debug; blocking footprints are removed from walkable cells.
- `I`: print wall inventory followed by object footprint summary.
- `J`: open shell-only interaction debug menu for mock object use / inspect / cancel flow.
- `H`: open shell-only Phone debug overlay; this does not call production `PhoneUI`.
- `ESC`: close the topmost shell debug overlay.
- `debug_focus_object_id`: emphasize one object id, for example `bed`.
- Object overlay detail options: `show_object_labels`, `show_object_interaction_cells`, `show_blocking_object_cells`, and `show_nonblocking_object_cells`.

Coordinate rule:

- Floor objects use `anchor_cell`, `size_cells`, occupied cells, and interaction cells for room membership and navigation. Pixel offsets and visual/collision/interaction sizes remain independent.
- Wall/ceiling/parent objects use `placement_type`, `parent_object_id`, `wall_segment_id`, and `wall_position_ratio` without automatically occupying a floor cell.
- Wall segments use wall edge coordinates: `from_cell -> to_cell`.
- Do not treat object floor cells and wall edge coordinates as the same coordinate layer.

Production boundary:

- These placeholders do not create `RoomObjectDefinition` Resources.
- The shell interaction menu and Phone overlay are debug-only UI and do not call production object interaction, production `PhoneUI`, save-load, Grid Credit, story flags, or QuarterviewMain production wiring.
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
