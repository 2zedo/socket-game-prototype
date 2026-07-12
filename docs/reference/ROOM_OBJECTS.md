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

Use the exclusive `M`, `P`, and `N` views first, then hold Shift while adding another M/P/N mode only when a combined comparison is needed. Automatic checks do not move walls or force art sizes to floor-cell dimensions. User visual confirmation is still required before placement is treated as final.

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

Node migration stage 2 overrides that loading order for exact ROTATE_90 geometry on all seven direct-interaction objects. `entrance_door`, `bed`, `fridge`, `microwave`, `navi_link`, `power_module_board`, and `node_17` use `EditableObjectNodes` in the candidate Scene for ObjectRoot, `Visual/Sprite2D/VisualPreview`, BasePoint, TopPoint, BodyPolygon when blocking, SelectionPolygon, InteractionPolygon, UsePoint, and AttachmentSocket. BasePoint is the installation/ground reference and TopPoint is the independent height reference. SelectionPolygon owns P hover/click only; InteractionPolygon remains the game-use range. Their Resource entries retain logical identity, category, room, interaction status, wall/parent relationship, UI specification, and future asset strings, but no duplicate position/size/offset/access-cell values. The other eleven environment objects continue to use the Resource/fallback footprint path.

Current rotated-floorplan placement candidate:

| Object ID | Room | Anchor | Offset px | Visual px | Collision px | Interaction | Anchor type / role |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `entrance_door` | entrance | Scene `EntranceWallParentAnchor/EntranceDoor` | Inspector | `Visual/VisualPreview` | closed-only `Body/BodyPolygon`; no floor occupancy | `InteractionArea/InteractionPolygon` + independent `UsePoint` | `WALL_EDGE`: `entrance_wall` doorway / interaction |
| `bed` | living | Scene `EditableObjectNodes/Bed` | Inspector | `Visual/VisualPreview` | `Body/BodyPolygon` | `InteractionArea/InteractionPolygon` + independent `UsePoint` | `FLOOR` / interaction |
| `fridge` | living | Scene `ObjectRoot` | Inspector | `Visual/VisualPreview` until Sprite texture exists | `Body/BodyPolygon` | `InteractionArea/InteractionPolygon` + independent `UsePoint` | `FLOOR` / interaction |
| `microwave` | living | `SinkCounterParentAnchor` child | Inspector | `Visual/VisualPreview` until Sprite texture exists | none | `InteractionArea/InteractionPolygon` + independent `UsePoint` | `PARENT_OBJECT`: `sink_counter` / interaction |
| `navi_link` | work/power | Scene `ObjectRoot` | Inspector | `Visual/VisualPreview` until Sprite texture exists | `Body/BodyPolygon` | `InteractionArea/InteractionPolygon` + independent `UsePoint` | `FLOOR` / interaction |
| `power_module_board` | work/power | `WorkBackWallParentAnchor` child | Inspector | `Visual/VisualPreview` until Sprite texture exists | none | `InteractionArea/InteractionPolygon` + independent `UsePoint` | `WALL_EDGE`: `work_back_wall` / interaction |
| `node_17` | work/power | Scene `EditableObjectNodes/Node17` | Inspector | `Visual/VisualPreview` | `Body/BodyPolygon` | `InteractionArea/InteractionPolygon` + independent `UsePoint` | `FLOOR` / interaction |
| `sink_counter` | living | `(3,4)` | `(0,0)` | `220x150` | `160x70` | none | floor environment |
| `dining_table` | living | `(4,7)` | `(0,0)` | `170x120` | `130x70` | none | `FLOOR` / environment |
| `signal_booster` | work/power | `(1,2)` | `(-68,-58)` | `112x96` | none | none | parent: `node_17` |
| `ups_unit` | work/power | `(8,2)` | `(0,0)` | `140x110` | `100x60` | none | `FLOOR` / environment |
| `bathroom_fixture` | bathroom | `(0,4)` | `(0,0)` | `200x140` | `150x80` | none | floor environment |
| `sea_horizon_poster` | living | `(11,7)` | `(0,-20)` | `160x80` | none | none | wall edge: `living_right_wall` |
| `fluorescent_light` | living | `(6,6)` | `(0,0)` | `240x40` | none | none | ceiling |
| `shoes_slippers` | entrance | `(1,9)` | `(0,0)` | `100x60` | none | none | `FLOOR` / non-blocking decoration |
| `cable_bundle` | work/power | `(2,2)` | `(36,42)` | `80x40` | none | none | parent: `node_17` |
| `wall_conduit` | work/power | `(3,0)` | `(0,0)` | `128x64` | none | none | wall edge: `work_back_wall` |
| `power_housing` | work/power | `(6,0)` | `(0,0)` | `240x210` | none | none | parent: board / `work_back_wall` |

Attachment policy:

- Candidate Resources expose `anchor_type` as `FLOOR`, `WALL_EDGE`, `CEILING`, or `PARENT_OBJECT`; object category remains independently `interaction`, `environment`, or `decoration`.
- Wall, ceiling, and non-floor parent attachments do not remove navigation cells or participate in floor overlap checks.
- `ups_unit` is floor-anchored and retains floor occupancy/collision; it has no spatial parent anchor.
- `entrance_door` is parented to `EntranceWallParentAnchor`. Its BodyPolygon blocks the exact doorway edge while closed and is disabled while open; it never creates floor occupancy.
- Direct world interaction is limited to exactly seven objects: `entrance_door`, `bed`, `fridge`, `microwave`, `navi_link`, `power_module_board`, and `node_17`. Each has valid interaction geometry and at least one walkable access point/cell.
- `sink_counter`, `dining_table`, `signal_booster`, `ups_unit`, `bathroom_fixture`, `sea_horizon_poster`, `fluorescent_light`, `shoes_slippers`, `cable_bundle`, `wall_conduit`, and `power_housing` have no gameplay interaction geometry. They remain selectable only for P placement inspection.
- P debug selection and direct game/mock interaction are separate contracts. A zero size, empty access-cell set, or non-interaction category never creates an orange interaction marker.
- Expected image/scene/audio values are future logical specification strings only. Missing assets are not loaded or validated in this candidate.

Shell editing controls:

- `M`: show room measurement only; the default view does not include object detail.
- `P`: show BodyPolygon-derived floor occupancy in blue, BodyPolygon collision in red, SelectionPolygon in cyan dashes, InteractionPolygon in orange dashes, UsePoint as an orange marker, AttachmentSocket in pink, BasePoint in green, and TopPoint/height guide in yellow. White Sprite2D/VisualPreview bounds appear only on the selected object. Equivalent floor/collision surfaces use one blue fill with a red collision outline.
- `N`: show navigation / collision debug; blocking footprints are removed from walkable cells.
- `V`: make all candidate wall, stub, door, and window visuals translucent for wall-attached and behind-wall inspection; floor edges, logical walls, navigation edges, collision, and reveal state do not change.
- `I`: print wall inventory followed by object footprint summary.
- `J`: open shell-only interaction debug menu for mock object use / inspect / cancel flow.
- `H`: open shell-only Phone debug overlay; this does not call production `PhoneUI`.
- `ESC`: close the topmost shell debug overlay.
- `debug_focus_object_id`: emphasize one object id, for example `bed`.
- For the seven migrated objects, SelectionPolygon is the only P hover/click authority and hover labels identify its owner; InteractionPolygon is not reused for selection. The other eleven retain floor/collision, wall/parent anchor, then visual fallback priority. Repeated clicks at one location still cycle candidates and show `선택 n/m`.

Coordinate rule:

- Migrated floor objects derive movement-blocked cells and P floor occupancy from `Body/BodyPolygon`; no current object has a separate PlacementFootprint. The wall-mounted entrance door uses its BodyPolygon only for closed-state edge blocking and never derives floor occupancy. The common script supports an optional future `PlacementFootprint`, which overrides occupancy only when a real reservation area must differ from collision.
- ObjectRoot position plus BasePoint and authored polygons are the exact Scene geometry authority. BasePoint supplies the installation reference and auxiliary floor-cell calculation; TopPoint supplies only the 2.5D height guide. Neither marker replaces Body, Selection, Interaction, UsePoint, or AttachmentSocket.
- `SelectionArea/SelectionPolygon` controls candidate P hover/click. `InteractionArea/InteractionPolygon` controls game-use range, while sibling `UsePoint` controls the character access cell. Moving any one of those three channels never moves the others; only moving ObjectRoot or a parent anchor moves all of them.
- Migrated wall/parent objects follow their Scene ParentAnchor, and `AttachmentSocket` is the exact child/wall attachment marker. Their logical `anchor_type`, `parent_object_id`, and `wall_segment_id` remain Resource metadata.
- Sprite2D texture bounds are the visual authority when a texture exists; otherwise one editor-only VisualPreview polygon supplies the temporary visual bound. Neither visual source participates in movement collision or interaction.
- Unmigrated floor objects continue to use `anchor_cell`, `size_cells`, occupied cells, and interaction cells. Unmigrated wall/ceiling/parent objects continue to use the existing Resource anchor fields.
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
