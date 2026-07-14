# Technical Map

## Role

This is the current reference for important files, protected boundaries, validation commands, and repo navigation.

## Repo Layout

| Path | Purpose |
| --- | --- |
| `godot/` | Active Godot project |
| `godot/scenes/` | Production and candidate scenes |
| `godot/scripts/` | GDScript |
| `godot/resources/` | `.tres` gameplay / candidate data |
| `godot/test/unit/` | GUT unit tests |
| `docs/` | Active docs: game info, status, work log |
| `docs/reference/` | Current reference docs |
| `docs/old/` | Historical archived docs |
| `src/` | Legacy web prototype; do not edit unless explicitly requested |

## Active Docs

Root docs should stay small:

- `docs/GAME_INFO.md`
- `docs/PROJECT_STATUS.md`
- `docs/PROJECT_WORK_LOG.md`

Current reference docs:

- `docs/reference/WORLD.md`
- `docs/reference/STORY.md`
- `docs/reference/CHARACTERS.md`
- `docs/reference/GAME_RULES.md`
- `docs/reference/ROOM_OBJECTS.md`
- `docs/reference/ART_DIRECTION.md`
- `docs/reference/TECHNICAL_MAP.md`

## Protected Production Files

Do not modify by default:

- `godot/scenes/Main.tscn`
- `godot/scripts/Main.gd`
- `godot/scripts/Apartment.gd`
- `godot/scripts/Player.gd`
- `godot/scripts/SurvivalState.gd`
- `godot/scenes/ui/PhoneUI.tscn`
- `godot/scripts/ui/PhoneUI.gd`
- `godot/scenes/ui/OutletMode.tscn`
- `godot/scripts/ui/OutletMode.gd`
- `godot/scenes/ui/DayResultPanel.tscn`
- `godot/scripts/ui/DayResultPanel.gd`
- `godot/project.godot`

## Main Scenes

| Scene | Script | Status |
| --- | --- | --- |
| `godot/scenes/Main.tscn` | `godot/scripts/Main.gd` | protected golden path |
| `godot/scenes/Apartment.tscn` | `godot/scripts/Apartment.gd` | protected top-view room |
| `godot/scenes/QuarterviewMain.tscn` | `godot/scripts/QuarterviewMain.gd` | production candidate |
| `godot/scenes/quarterview/QuarterviewRoom.tscn` | `godot/scripts/quarterview/QuarterviewRoom.gd` | candidate room |
| `godot/scenes/quarterview/QuarterviewApartmentEnvironment.tscn` | `godot/scripts/quarterview/QuarterviewApartmentShellCandidate.gd` | reusable apartment floor/wall/object authority |
| `godot/scenes/quarterview/QuarterviewApartmentShellCandidate.tscn` | inherited Environment script | design/debug wrapper; M/P/N/W/V/F1 |
| `godot/scenes/quarterview/QuarterviewApartmentPlayable.tscn` | Environment + external-provider `QuarterviewRoom` | playable apartment candidate |
| `godot/scenes/quarterview/samples/QuarterviewReusableMapSampleEnvironment.tscn` | `godot/scripts/quarterview/QuarterviewReusableMapSample.gd` | two-room component-reuse validation Environment |
| `godot/scenes/quarterview/samples/QuarterviewReusableMapSampleShell.tscn` | inherited sample Environment script | sample P/M/N/W/V inspection wrapper |
| `godot/scenes/quarterview/samples/QuarterviewReusableMapSamplePlayable.tscn` | sample Environment + external-provider `QuarterviewRoom` | sample movement/door/interaction validation |
| `godot/scenes/Player.tscn` | `godot/scripts/Player.gd` | protected current Main player |

## Apartment Shell Candidate Editing

`QuarterviewApartmentEnvironment` is the single ROTATE_90 Scene-Node authority for floor cells, logical room polygons, wall/opening geometry, navigation, and objects. `QuarterviewApartmentShellCandidate` inherits that PackedScene for design/debug review. `QuarterviewApartmentPlayable` inherits the same PackedScene and adds one `QuarterviewRoom` gameplay instance in opt-in external-environment mode. In that mode the legacy room builder stays empty and hover/click, click-to-move, UsePoint arrival, and interaction signals query the Environment's Scene-Node geometry and walkable-cell graph. Existing `QuarterviewRoom` behavior and non-ROTATE_90 candidate checks retain the legacy calculated fallback. These scenes are candidates, not production wiring.

### Quarterview component reuse sample

`QuarterviewReusableMapSampleEnvironment` is a KEEP_CANDIDATE verification asset, not a story map. It was assembled from fresh instances rather than copied from the apartment: two `ApartmentFloorLayer` TileMaps (25 cells), two `ApartmentRoomArea` polygons, five `ApartmentWallSegment` instances containing 24 `ApartmentWallCell` instances, two door and one window `ApartmentOpeningMarker`, one `ApartmentEditableObject` bed, and one `ApartmentEditableEnvironmentObject` table. The Shell inherits this one Environment without overrides; the Playable inherits the same Environment and adds `QuarterviewRoom` in external-provider mode.

Reusable without apartment geometry changes: `ApartmentFloorLayer`, `ApartmentRoomArea`, `ApartmentWallSegment`, `ApartmentWallCell`, `ApartmentOpeningMarker`, both editable-object scenes, `ApartmentEnvironmentEditorGuides`, and `QuarterviewRoom`'s external-provider contract. External mode now optionally reads `playable_direct_object_ids()` so the sample loads only its bed interaction while the apartment still loads its canonical seven. Provider IDs are currently limited to that existing seven-ID legacy mapping; providers without the optional list keep the former seven-object behavior. The sample provider implements Scene-node object lookup, walk target/path queries, and P/M/N/W/V locally; apartment-specific 18-object inventory, four-room measurements, wall labels, ROTATE_90 constants, and candidate panels remain in `QuarterviewApartmentShellCandidate.gd`.

The sample owns a sample-only walk/debug controller but reuses the complete WallSegment scaffold as a PackedScene. A second real map should first instantiate Floor layers, then RoomArea polygons, WallSegment/WallCell groups and Opening markers, editable objects, a provider Environment, the inherited Shell, and finally the inherited Playable with `QuarterviewRoom`. Extract a common map-debug base only when another real map repeats that controller contract; a generic map EditorPlugin is intentionally out of scope.

### 아파트 환경 편집 방법

- 실제 구조 수정은 `QuarterviewApartmentEnvironment.tscn`, 판정 확인은 `QuarterviewApartmentShellCandidate.tscn`, 플레이어 조작 확인은 `QuarterviewApartmentPlayable.tscn`에서 한다.
- 오브젝트는 `EditableObjectNodes/<Object>` 아래의 Root 위치, `Visual/Sprite2D` 또는 `VisualPreview`, `Body/BodyPolygon`, `SelectionArea/SelectionPolygon`, `InteractionArea/InteractionPolygon`, `UsePoint` 순으로 수정한다. 환경 오브젝트에는 Interaction/UsePoint가 없다.
- 바닥은 `Floor/<Room>Floor` TileMapLayer에서 칠하고, 벽은 `Walls/<WallGroup>/WallCells/CellNN`, 벽부착 장비는 해당 Cell의 `AttachmentSocket`에서 수정한다.
- Environment 루트 `/QuarterviewApartmentEnvironment`의 `Environment Editor Guides > editor_guide_mode`는 `CLEAN`(실물+옅은 Visual 외곽), `STRUCTURE`(Room/Wall/Opening/WallCell/Socket), `OBJECT`(오브젝트 판정과 Base/Top/Socket), `ALL`(전체)을 전환한다. `OBJECT`에서 `editor_focus_object_id`를 지정하면 그 오브젝트만 사용자 정의 가이드를 표시하며, 비워 두면 Scene Tree에서 선택한 오브젝트를 따른다. 판정 Polygon을 직접 선택했을 때의 Godot 기본 꼭짓점 편집은 모드와 무관하게 유지된다.
- 생성 가이드는 `EditorGuides/RoomGuides`, `WallGuides`, `ObjectGuides`, `HeightAndSocketGuides`로 나뉘며 눈 아이콘으로도 임시 제어할 수 있다. 게임 실행 시 `EditorGuides` 전체가 자동으로 숨는다.
- Shell 키는 `P` 선택/hover 오브젝트 판정, `Shift+P` 전체 오브젝트 검사, `M` 방 측량, `N` 이동·충돌, `W` 벽 wireframe/그룹 라벨, `V` 벽 Visual의 기본→반투명→숨김 순환이다. W는 직선 Cell 이음은 합치고 방향이 다른 벽이 만나는 Junction만 강조하며, 기본에는 WallGroup당 라벨 하나를 표시하고 WallCell 클릭 후에만 enabled/Opening/AttachmentSocket 상세를 표시한다.
- 권장 순서는 Environment에서 Visual/Polygon/Socket 수정 → Shell에서 P/M/N/W/V 확인 → Playable에서 실제 이동·가림·상호작용 확인이다.

| Need | Where |
| --- | --- |
| Paint or erase floor cells | `Floor/EntranceFloor`, `BathroomFloor`, `LivingFloor`, or `WorkFloor` (`TileMapLayer`, 128×64 isometric) |
| Edit a logical room boundary | `RoomAreas/<Room>/Area2D/CollisionPolygon2D`; M reads this Polygon |
| Move one wall unit | `Walls/<WallGroup>/WallCells/CellNN`; each Cell is one 128×64 isometric edge and owns its Visual/Collision/Socket |
| Review a long wall meaning | Select `Walls/<WallGroup>`; its Start/End summary and M/N unit edges are derived from its authored WallCells |
| Change wall display/opening metadata | Select an `ApartmentWallCell`; Inspector shows wall id, Korean room/wall name, axis, sequence, and opening metadata |
| Move a door/window opening | Move its Opening WallCell: Entrance `Cell04`, EntranceInner `Cell01`, BathroomRight `Cell02`, WorkFront `Cell06`, or LivingRight window `Cell05` |
| Inspect opening semantics | `Openings/<Opening>` mirrors the owning Cell's start/end/type/passable values for tools and previews; do not edit its derived Marker positions |
| Move Power Board with its wall | `Walls/WorkBackWall/WallCells/Cell05/AttachmentSocket`; the board follows by `mount_socket_path` |
| Move Entrance Door with its wall | `Walls/EntranceWall/WallCells/Cell04/AttachmentSocket`; the door follows by `mount_socket_path` |
| Move a migrated floor interaction object | Move `EditableObjectNodes/Bed`, `Fridge`, `NaviLink`, or `Node17` |
| Move a migrated floor environment object | Move `EditableObjectNodes/SinkCounter`, `DiningTable`, `UpsUnit`, `BathroomFixture`, or `ShoesSlippers` |
| Move the entrance door itself without changing the wall opening | Edit `EditableObjectNodes/EntranceDoor/mount_offset` |
| Edit installation / height references | Move each migrated object's sibling `BasePoint` and `TopPoint`; these do not move Selection, Interaction, or UsePoint |
| Edit migrated movement collision | Edit Bed/Fridge/NAVI/NODE-17 `Body/BodyPolygon` vertices; the door BodyPolygon is closed-state wall blocking, not floor occupancy |
| Move Power Board / Microwave with their attachment | Move the WorkBackWall Socket or `EditableObjectNodes/SinkCounter/AttachmentSockets/MicrowaveSocket` respectively |
| Edit migrated P hover/click selection | Edit `SelectionArea/SelectionPolygon`; it is independent from game-use geometry |
| Edit a migrated interaction range/access point | Edit `InteractionArea/InteractionPolygon` and sibling `UsePoint` independently |
| Edit a migrated temporary visual bound | Edit `Visual/VisualPreview`; once `Visual/Sprite2D` has a texture, its texture rect takes priority |
| Edit the attachment point | Move `AttachmentSocket`; parent/wall relationships remain Resource metadata |
| Show wall wireframe / IDs | Press `W` in the shell scene; shows authored WallCell bottom/top/end edges, door/window boundaries, and Korean-first group labels even while V is HIDDEN |
| Print wall inventory | Press `I` in the shell scene |
| Show floor cell coordinates | Press `G` in the shell scene; floor labels use `칸 (x,y)` |
| Show wall edge / vertex coordinates | Press `E` in the shell scene; wall labels use `벽선 from -> to` / `축=A/B` |
| Show navigation / collision debug | Press `N`; shows only movement cells, object-blocked cells, wall/door edges, the marker, current room, and a compact legend |
| Show object placement debug | Press `P` for hover Selection or selected-object details; `Shift+P` shows all objects at low alpha while keeping the selection emphasized |
| Show room measurements / placement reference | Press `M`; shows simplified room bounds, placement zones, doorway clearance, required paths, and wall-mount availability |
| Open complete shell shortcut help | Press `F1`; press `F1` or `ESC` to close the Korean help panel |
| Inspect walls without changing collision | Press `V` to cycle `NORMAL -> TRANSPARENT (18%) -> HIDDEN -> NORMAL`; openings, collision, navigation, sockets, and attached objects remain active |
| Open shell interaction debug menu | Press `J`; choose a mock object to test use / inspect / cancel panel flow |
| Open shell Phone debug overlay | Press `H`; switch mock Messages / Power / Jobs / Settings tabs |
| Close top shell debug UI | Press `ESC`; closes Phone, interaction detail/menu, full help, then the active M/P/N mode in priority order |
| Highlight occlusion / revealable walls | Press `O` in the shell scene; labels use `숨김벽` and Korean display-state text |
| Identify a floor cell under the mouse | Enable `G`, then hover a floor tile; click to print the cell and its four wall edges |
| Identify an exact wall edge under the mouse | Enable `E`, then hover near a floor edge; click to print the nearest wall edge `from_cell -> to_cell` |
| Identify navigation state for a floor cell | Enable `N`, then click a floor tile to print room area, walkable state, neighbors, and edge blockers |
| Move the shell-only navigation marker | Enable `N`, then use arrow keys to test movement through blocked / passable edges |
| Test room-area reveal walls | Set `debug_auto_reveal_walls=true`, enable `N`, and move the shell marker between room areas |
| Emphasize one wall | Set `debug_focus_wall_id`, e.g. `bathroom_left_wall`, in the Inspector |
| Preview revealable walls as full walls | Set `preview_revealed_walls=true` in the Inspector |

The four Floor layers contain the user's 99 authored cells: Entrance 6 (brown), Bathroom 7 (gray), Living 54 (beige), and Work 32 (blue-gray). Each TileMapLayer has a Korean `editor_description`, and `EditorGuides` shows editor-only room labels plus this color legend while hiding itself at runtime. They share `dev_apartment_floor_tiles_128x64.svg`, a color-only development TileSet that must be replaced by final floor art later. RoomArea preview polygons and Opening preview lines are editor-only; saved CollisionPolygon/Marker positions are the runtime authority.

Ten local WallGroup nodes contain 58 individually selectable `ApartmentWallCell` instances: WorkBack 8, WorkLeft 4, WorkRight 4, Entrance 6, EntranceInner 3, LivingRight 6, LivingFront 11, WorkFront 11, Bathroom 2, and BathroomRight 3. Door/window Cells own opening position and passability metadata; their `OpeningMarker` nodes are synchronized mirrors. M/N use each enabled Cell's authored endpoints, so `enabled=false` removes both physical and navigation blocking. V changes Cell visuals only. Environment startup no longer calls the legacy floor-diamond, aggregate wall-visual, aggregate wall-collision, or door/window placeholder builders. The old rectangle/config builders remain only as regression fallback for standalone/non-ROTATE_90 paths, where the authored ROTATE_90 visuals and collisions are disabled. All 18 Environment objects are Scene-node authorities; Resource/fallback geometry no longer supplies an active Environment position, visual, selection, collision, or attachment transform.

Wall inventory columns: `id`, `name_ko`, `enabled`, `source`, `axis`, `edge_from_cell`, `edge_to_cell`, `length`, `wall_type`, `render_mode`, `current_state`, `state_ko`, `doorway`, `doorway_ko`, `reveal`, `logical`, `height_mode`, and `edit_hint`.

Object layout summary columns, printed after `I`: `id`, Korean name, category, source, room, anchor type, anchor cell, pixel offset, visual/collision/interaction pixel sizes and offsets, parent, wall ratio, occupied cells, movement blocking, interaction cells, and edit hint.

Room measurement summary is printed after the existing `I` inventories. It reports room floor bounds, cell dimensions, assigned floor cells, current walkable cells, advisory placement cells, screen-space pixel bounds, center coordinates, doorways, windows, walls, wall-mount availability, and current footprint warnings. `doorway_clearance_cells` and `main_path_clearance_cells` are Inspector-tunable review margins; they do not change collision or snap object art to tiles.

Current room-area boundaries follow the existing wall shell without moving geometry:

- `entrance_area`: floor cells inside `(0,7) -> (2,10)`, the left external-door entry compartment
- `bathroom`: floor cells inside `(0,4) -> (2,7)`, the small enclosed room beyond the internal doorway
- `living_area`: the remaining assigned cells inside the large `(0,4) -> (11,10)` living bounds
- `work_power_area`: floor cells inside `(1,0) -> (9,4)`

Measurement coordinate roles:

- floor cell: approximate floor position, room membership, movement, and placement-reference unit
- wall edge: grid-line boundary used by walls, doors, windows, and wall-mount spans
- screen pixel: final sprite dimensions, collision dimensions, and per-object position offsets
- placement area: advisory free space after doorway clearance, required movement paths, current footprints, and the no-large-object zone are excluded; it is not a tile-snap rule

Debug overlay language policy:

- Screen labels are Korean-first where practical.
- Internal ids remain visible as secondary edit references.
- No custom font asset is added; the shell relies on the current Godot/default project font stack for Korean rendering.

`edge_from_cell -> edge_to_cell` is the preferred way to read wall placement. The older `start_cell + axis + length` values still drive the data model, but the `E` wall-edge overlay is the quickest way to pick an exact wall segment. `G` is for floor cell centers and room footprint checks.

Floor cell coordinates and wall grid-line coordinates are related but not identical. A floor cell `(x,y)` spans to the next grid line, so its right outside wall is on `x+1`, and its front / lower outside wall is on `y+1`. For example, the outer right edge of floor cell `(10,9)` is wall grid line `x=11`, and its outer front edge is wall grid line `y=10`. Wall segments should be specified with grid-line `from_cell -> to_cell` coordinates, not the interior floor cell coordinate.

When `G` is enabled, clicking a floor cell prints all four edge coordinates:

- top edge: `(x,y) -> (x+1,y)`
- right edge: `(x+1,y) -> (x+1,y+1)`
- bottom edge: `(x,y+1) -> (x+1,y+1)`
- left edge: `(x,y) -> (x,y+1)`

When `E` is enabled, the shell displays wall grid-line vertices and the hover panel reports the nearest edge with `cell`, `edge`, `edge from`, `edge to`, and `axis`. Clicking prints the same nearest-edge information to the console.

`M`, `P`, and `N` are primary debug modes backed by `DebugMode.NONE`, `ROOM_MEASUREMENT`, `OBJECT_PLACEMENT`, and `NAVIGATION`. A normal key press replaces the previous primary mode; pressing the active key again returns to `NONE`. `Shift+M/P/N`, or `allow_combined_debug_overlays=true`, explicitly permits combined inspection while the default remains exclusive. Legacy `show_room_measurements`, `show_object_placeholders`, and `show_navigation_debug` exports remain load-compatible and are normalized into the active mode at startup.

Their render responsibilities are separated into `RoomMeasurementDebugLayer`, `ObjectPlacementDebugLayer`, `NavigationDebugLayer`, `DebugSelectionLayer`, `FloorGridDebugLayer`, and `WallWireframeLayer`. `DebugDetailPanel` shows only the current mode's room/object/navigation summary, `ObjectPlacementLegend` appears only with P, and `DebugHelpPanel` owns the complete Korean shortcut list. The compact top help shows the fixed review view (`ROTATE_90`), current mode, P scope, M/N/W, V wall-inspection state, and F1. Floor debug grid geometry is enabled only by M/N/P; the Playable default shows only the authored floor tile art.

When `N` is enabled, the shell displays walkable floor cells, room areas, object-blocked cells, logical blocked wall edges, passable doorway edges, and a shell-only debug marker. Bed, fridge, NAVI, NODE-17, sink counter, dining table, UPS, and bathroom fixture blocked cells are derived from their Scene `Body/BodyPolygon`; the environment objects use Body overlap on the BasePoint installation row so polygon edits change occupancy without leaving a hidden Resource blocker. Shoes/slippers and the six attached environment/decoration objects have no BodyPolygon and do not block. An optional future PlacementFootprint may override occupancy, but none of these objects has one. The entrance door instead toggles its exact doorway edge between blocked while closed and passable while open, without floor occupancy. N does not display object names, ids, sizes, interaction data, parent data, or `ObjectPlacementDebugLayer`.

Navigation area ids are `living_area`, `work_power_area`, `bathroom`, and `entrance_area`. The shell-only marker starts at `player_debug_cell=(1,8)` by default. Arrow keys move the marker only when `N` is enabled; blocked wall edges and non-walkable target cells stop movement, while doorway edges allow passage.

When `P` is enabled, hover without a click draws only that object's SelectionPolygon as cyan dashes. A clicked object draws its BodyPolygon-derived occupancy as one low blue face plus red collision outline, SelectionPolygon as cyan dashes, InteractionPolygon as orange dashes, UsePoint as a green marker, physical parent/AttachmentSocket in magenta, BasePoint in light green, TopPoint/height guide in yellow, and Sprite2D/VisualPreview bounds as white dashes. Non-selected objects remain hidden. `Shift+P` enables the all-object layer at reduced alpha and keeps the selected object thick and fully emphasized; it does not duplicate selected geometry. A future distinct PlacementFootprint may draw separately, but the current Body occupancy/collision is composited once. Wall, ceiling, and non-floor parent attachments do not block `N` unless they receive a BodyPolygon in a later migration.

P hit testing is separate from the gameplay interaction inventory. All 18 objects are selectable through explicit SelectionPolygon geometry. The eleven environment objects expose no orange InteractionPolygon or UsePoint; the six attached objects also expose no BodyPolygon. Interaction and physical shapes rank above parent/wall attachments, while ceiling and non-blocking environment visuals remain last. Repeated clicks with the same candidate group cycle in ranked order. For the active Environment, `DebugDetailPanel` is intentionally compact: `source=SCENE_NODE`, exact ObjectRoot and physical parent Socket NodePaths, Body/Selection/Interaction presence, UsePoint/BasePoint/TopPoint, visual source, and AttachmentSockets. It does not print deprecated Resource anchor/offset/size/cell geometry. Only the isolated compatibility path prints a separate `LEGACY_RESOURCE` section.

`ApartmentEditableObject.tscn` and `ApartmentEditableObject.gd` define the interactive object structure. `ApartmentEditableEnvironmentObject.tscn` and `.gd` define `EnvironmentObjectRoot → Visual(Sprite2D, VisualPreview) / BasePoint / TopPoint / Body(optional BodyPolygon) / SelectionArea(SelectionPolygon) / AttachmentSockets` and intentionally omit InteractionArea and UsePoint. Both scripts are `@tool`, derive world geometry from the authored nodes, keep polygon scale at `(1,1)`, and warn when required paths, polygon points, collision policy, physical mount Socket, or deprecated Resource geometry are invalid. At ROTATE_90, all 18 objects resolve exact geometry from Scene nodes; a missing/invalid Scene object produces a warning and no visual, hit, interaction, occupancy, or blocker ghost. Resources keep logical metadata only. Other map rotations retain inventory compatibility but do not claim Node-geometry visual support in this stage.

`QuarterviewApartmentShellCandidate._object_footprints()` is a hard authority boundary. The Environment branch calls `_scene_node_object_footprints()` and reads only logical Resource metadata; its Resource-geometry read counter must remain zero. The explicit `_legacy_resource_object_footprints()` branch owns deprecated cell/offset/size projection, Resource hover/hit tests, and custom/non-ROTATE compatibility. Standalone `QuarterviewRoom` is a separate regression path backed by its own `RoomObjectDefinition`/layout contract and is not rewritten through the apartment footprint Resource.

Physical attachment hierarchy is authoritative: NODE-17 owns independent `SignalBoosterSocket` and `CableBundleSocket`; Power Module Board owns `PowerHousingSocket`; WorkBack Cell02 owns Wall Conduit; LivingRight Cell03 owns Sea Horizon Poster; and `CeilingAnchors/FluorescentLightSocket` owns the fluorescent light. A WallCell's `enabled` and V visual state affect wall physics/visuals without deleting or hiding socket children. Only explicitly hiding the WallCell root hides its entire subtree.

Fridge now uses `res://assets/art/objects/fridge/fridge_dl_closed.png` through `EditableObjectNodes/Fridge/Visual/Sprite2D`. The user's Environment root position `(1128,186)` and edited Selection/Interaction geometry are preserved; the Sprite keeps its `90x146` visual bound with its bottom centered on BasePoint `(1136,263)`. Because the supplied RGB PNG has a baked neutral checkerboard rather than alpha, a Fridge-only CanvasItem shader removes that bright neutral background at runtime. `ApartmentEditableObject` derives absolute Y-sort from BasePoint, so future Inspector position changes do not leave a second stale `z_index` authority.

Object placement display options:

- `show_object_names=true` permits the hover/selected Korean short name; it does not restore persistent world detail labels.
- `show_object_floor_footprints=true`, `show_object_collision_shapes=true`, and `show_object_interaction_areas=true` retain their existing controls. SelectionPolygon and BasePoint/TopPoint references form independent P channels for all 18 Scene-node objects; orange interaction geometry remains limited to the seven direct interactions.
- `show_object_parent_links=true` shows the exact physical Socket/parent guide in P's base layer; selection does not redraw that geometry.
- Legacy object display exports remain available for scene compatibility, but they do not make P details appear in M or N.
- `I` prints each object's authority source plus an edit hint. The current Environment must report `scene_node`; resource/fallback/custom labels belong only to the isolated legacy inventory path.

`ApartmentObjectFootprintConfig.AnchorType` still separates logical spatial role from category. For wall/parent/ceiling objects, the physical Scene parent Socket is the exact transform source while Resource `anchor_type`, `wall_segment_id`, and `parent_object_id` retain semantic ownership only. The legacy projection path remains compatibility code outside the active Environment authority. The current pass is visually authored against the existing `ROTATE_90` reference view.

`W` uses authored WallCell and Opening data directly: bright gray bottom edges, pale-yellow top edges, dashed gray ends, green door boundaries, blue window boundaries, and an optional white focused Cell. `V` cycles the authored WallCell visuals through `NORMAL`, `TRANSPARENT (18%)`, and `HIDDEN`; W or M keeps this wireframe visible while floor/edge/debug data, blocked/passable navigation edges, openings, collision, sockets, and wall-attached objects remain active in all three states.

Shell-only interaction UI:

- `J` opens a mock menu for the seven direct world-interaction ids plus portable `phone`; the other eleven footprints remain P-debug-selectable but are excluded from use/inspect interaction inventory.
- Selecting an item opens a candidate-only interaction panel with `사용하기`, `살펴보기`, and `취소`.
- The panel only writes mock text; it does not move Yui, mutate hunger / power / time, call production object logic, or save state.
- `H` opens a separate shell-only Phone overlay with mock tabs: `메시지`, `전력`, `의뢰`, and `설정`.
- The shell Phone overlay does not use production `PhoneUI` and intentionally avoids `SurvivalState`, save-load, job state, and production wiring.
- Phone and interaction panels are kept mutually exclusive; `ESC` closes the topmost shell debug UI.

`debug_auto_reveal_walls=false` keeps the existing shell view: `REVEALABLE` walls stay as low stubs. When `debug_auto_reveal_walls=true`, the shell marker's active room area can reveal a `REVEALABLE` wall if that wall has `reveal_when_area_active=true` and matching `reveal_area_id`. `preview_revealed_walls=true` still has priority and forces all `REVEALABLE` walls to full-wall preview regardless of active room. Example reveal areas: `reveal_area_id="living_area"` reveals while the marker is in the living space; `reveal_area_id="work_power_area"` would reveal while the marker is in the work / power room.

`render_mode` separates logical wall existence from the current shell display. `FULL` draws a full-height wall. `CUTAWAY_STUB`, `HIDDEN_STUB`, and `REVEALABLE` keep the wall enabled in inventory while showing only a low cutaway / stub in this camera view. `REVEALABLE` walls draw a visible low body, top cap line, and base shadow by default; `preview_revealed_walls=true` temporarily draws them as full walls for inspection. `LOGICAL_ONLY` keeps the wall as data without drawing it.

Current bathroom shell wall IDs:

- `bathroom_wall`: shared bathroom / entrance boundary, `axis=A`, `from_cell=(0,7)`, `to_cell=(2,7)`
- `bathroom_right_wall`: bathroom doorway wall, `axis=B`, `from_cell=(2,4)`, `to_cell=(2,7)`, doorway `from_cell=(2,6)`, `to_cell=(2,7)`
- `entrance_inner_wall`: entrance inner wall, `axis=B`, `from_cell=(2,7)`, `to_cell=(2,10)`, doorway `from_cell=(2,8)`, `to_cell=(2,9)`
- `entrance_wall`: outer entrance wall, doorway `from_cell=(0,8)`, `to_cell=(0,9)`
- `bathroom_left_wall`: legacy disabled bathroom-left segment, `enabled=false`
- `living_right_wall`: logical right-side outer wall, `from_cell=(11,4)`, `to_cell=(11,10)`, `render_mode=REVEALABLE`
- `living_front_cutaway`: logical front outer wall / cutaway, `from_cell=(0,10)`, `to_cell=(11,10)`, `render_mode=CUTAWAY_STUB`
- `living_occlusion_right_wall`: legacy disabled wrong-cell-coordinate segment, `from_cell=(10,4)`, `to_cell=(10,9)`, `enabled=false`
- `living_occlusion_front_wall`: legacy disabled wrong-cell-coordinate segment, `from_cell=(0,9)`, `to_cell=(10,9)`, `enabled=false`

Legacy service segments remain in the inventory as disabled entries:

- `service_wall`: `enabled=false`
- `service_right_wall`: `enabled=false`

Current shell object layout candidate IDs:

- Interaction: `entrance_door`, `bed`, `fridge`, `microwave`, `navi_link`, `power_module_board`, `node_17`
- Environment/decoration: `sink_counter`, `dining_table`, `signal_booster`, `ups_unit`, `bathroom_fixture`, `sea_horizon_poster`, `fluorescent_light`, `shoes_slippers`, `cable_bundle`, `wall_conduit`, `power_housing`
- Excluded from world footprints: portable `phone`, optional `air_conditioner`, and the retired desk/panel/connector placeholders

## Candidate UI Scripts

| Feature | File |
| --- | --- |
| Portable Phone candidate | `godot/scripts/ui/quarterview/PhoneScreenCandidate.gd` |
| Power board candidate | `godot/scripts/ui/quarterview/PowerBoardCandidate.gd` |
| Quarterview orchestration | `godot/scripts/QuarterviewMain.gd` |

## Resource Scripts

| Resource | File |
| --- | --- |
| DeviceDefinition | `godot/scripts/resources/DeviceDefinition.gd` |
| RoomObjectDefinition | `godot/scripts/resources/RoomObjectDefinition.gd` |
| QuarterviewJobDefinition | `godot/scripts/resources/QuarterviewJobDefinition.gd` |
| PowerModuleDefinition | `godot/scripts/resources/PowerModuleDefinition.gd` |
| HackingMissionDefinition | `godot/scripts/resources/HackingMissionDefinition.gd` |
| LivingDeviceDefinition | `godot/scripts/resources/LivingDeviceDefinition.gd` |
| GridCreditState | `godot/scripts/systems/GridCreditState.gd` |
| ApartmentObjectFootprintConfig | `godot/scripts/quarterview/ApartmentObjectFootprintConfig.gd` |
| ApartmentObjectFootprintSetConfig | `godot/scripts/quarterview/ApartmentObjectFootprintSetConfig.gd` |

## Prototype Scenes

| Scene | Purpose |
| --- | --- |
| `godot/scenes/prototypes/PrototypeHub.tscn` | Prototype menu |
| `godot/scenes/prototypes/QuarterviewGameplaySandbox.tscn` | Sandbox-only room/UI/state flow |
| `godot/scenes/prototypes/QuarterviewRoomPrototype.tscn` | Object / interaction contract prototype |
| `godot/scenes/prototypes/QuarterviewPerspectiveBlockout.tscn` | Quarterview perspective blockout |
| `godot/scenes/prototypes/QuarterviewRoomShellPrototype.tscn` | Room shell layer path / missing check |
| `godot/scenes/prototypes/HackingActionPrototype.tscn` | Hacking action state / control prototype |
| `godot/scenes/prototypes/HackingPerspectiveBlockout.tscn` | Hacking perspective blockout |
| `godot/scenes/prototypes/quarterview/WorkDevicesAtlasPreview.tscn` | Work device atlas preview |

## Tests

Unit tests live in `godot/test/unit/`.

Current important tests:

- `test_survival_state.gd`
- `test_room_scene_contract.gd`
- `test_quarterview_room_interaction_flow.gd`
- `test_quarterview_main_candidate_flow.gd`
- `test_quarterview_candidate_dependencies.gd`
- `test_room_object_definition.gd`
- `test_quarterview_job_definition.gd`
- `test_power_module_definition.gd`
- `test_power_board_candidate_state.gd`
- `test_hacking_action_state_machine.gd`
- `test_grid_credit_state.gd`
- `test_living_device_definition.gd`
- `test_asset_smoke.gd`
- `test_apartment_object_layout_candidate.gd`
- `test_apartment_wall_editor_guides.gd`

The Quarterview candidate regression tests keep movement completion deterministic: they test object selection, pending focus, cancellation/replacement, and the arrival gate without waiting on long physics movement. Main candidate tests instantiate the real scene and cover panel/modal routing, room input lock restoration, close/ESC/backdrop paths, and portable Phone gating. The dependency boundary test recursively inspects candidate Resource dependencies and executable reference patterns while leaving production-wide autoload policy outside candidate ownership.

## Third-Party Asset Inventory

The current asset smoke test reads this section instead of the archived `docs/old/THIRD_PARTY_ASSET_INVENTORY.md`. Root `docs/` stays limited to `GAME_INFO.md`, `PROJECT_STATUS.md`, and `PROJECT_WORK_LOG.md`.

This inventory tracks selected copies that are actually present under `godot/assets/.../third_party/...`. Broad Asset Library addon folders, generated `.uid` files, and unrelated local addon installs remain outside the current commit scope unless a dedicated vendor-assets task says otherwise.

| Asset Group | Selected Copies | License Evidence | Current Use | Notes |
| --- | --- | --- | --- | --- |
| Kenney UI Audio | selected copies under `godot/assets/audio/third_party/kenney/ui/`: `ui_select.wav`, `ui_confirm.wav` | `godot/assets/audio/third_party/kenney/LICENSES/kenney_ui_audio_LICENSE.txt` | Prototype UI select / confirm SFX smoke-tested as `AudioStreamWAV` | Source addon folder is not a required committed source for the smoke test. |
| Kenney Interface Sounds | selected copies under `godot/assets/audio/third_party/kenney/interface/`: `prototype_open.wav`, `prototype_cancel.wav`, `hacking_hit.wav`, `hacking_damage.wav`, `hacking_success.wav`, `hacking_fail.wav` | `godot/assets/audio/third_party/kenney/LICENSES/kenney_interface_sounds_LICENSE.txt` | Prototype overlay / hacking feedback SFX smoke-tested as `AudioStreamWAV` | Only the selected copied asset paths are required for current tests. |
| Kenney Input Prompts | selected copies under `godot/assets/ui/third_party/kenney/input_prompts/`: `key_a.png`, `key_arrows.png`, `key_b.png`, `key_backspace.png`, `key_d.png`, `key_e.png`, `key_enter.png`, `key_escape.png`, `key_j.png`, `key_r.png`, `key_s.png`, `key_shift.png`, `key_space.png`, `key_w.png`, `mouse_left.png` | `godot/assets/ui/third_party/kenney/LICENSES/kenney_input_prompts_LICENSE.txt` | Prototype prompt icons smoke-tested as `Texture2D` | Keep these as selected copies; do not point tests at raw addon source folders. |

## Validation Commands

Godot project parse:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --quit-after 2
```

QuarterviewMain startup:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/QuarterviewMain.tscn --quit-after 2
```

Apartment shell candidate startup:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/quarterview/QuarterviewApartmentShellCandidate.tscn --quit-after 2
```

Existing room and composed playable startup:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/quarterview/QuarterviewRoom.tscn --quit-after 2
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/quarterview/QuarterviewApartmentPlayable.tscn --quit-after 2
```

Full GUT:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
```

### Unified Validation Script

Run `scripts/validate_concent.sh` from any directory to execute the current Git checks, Godot project parse, QuarterviewMain and apartment-shell startup checks, strict unit-test script parsing, and the Full GUT runner without issuing Git mutation commands.

Codex should use the repository Skill at `.agents/skills/concent-godot-validation/SKILL.md` to choose `--full` or `--quick`; invoke it explicitly as `$concent-godot-validation` when needed.

### Candidate Workflow

`.agents/skills/concent-candidate-workflow/SKILL.md` defines the CONCENT-only
candidate decision, protected-production boundary, automated/manual completion
criteria, and `GRADUATE` / `KEEP_CANDIDATE` / `ABANDON` decision. It delegates
validation to `$concent-godot-validation` and selective Git completion to
`$concent-safe-git`; it does not wire a candidate into production.

### Documentation Sync

`.agents/skills/concent-docs-sync/SKILL.md` selects the minimal current
documentation update after a CONCENT implementation, design, or structure
change. It maps changes to one reference source of truth, keeps GAME_INFO,
current status, and work history distinct, and checks `docs/old/` convention
before any rotation. Candidate status remains owned by
`$concent-candidate-workflow`; validation and Git remain owned by
`$concent-godot-validation` and `$concent-safe-git`.

```bash
scripts/validate_concent.sh --full
scripts/validate_concent.sh --quick
GODOT_BIN=/Applications/Godot.app/Contents/MacOS/Godot scripts/validate_concent.sh --full
scripts/validate_concent.sh --godot-bin /Applications/Godot.app/Contents/MacOS/Godot --keep-logs
```

- `--full` is the default and strictly parses every `godot/test/unit/*.gd` before Full GUT. `--quick` skips both test-script parsing and Full GUT.
- Godot lookup order is `--godot-bin`, `GODOT_BIN`, `godot`/`godot4` on `PATH`, then the macOS app path above.
- Logs are created outside the repository and are removed after a successful run unless `--keep-logs` is supplied. Failed runs preserve their logs.
- The script only reports Git status; it never stages, commits, pushes, cleans, restores, or deletes repository files. Godot may still generate its normal `.import`, `.uid`, or `.godot` metadata, which the final Git-status comparison reports.
- Every Godot validation step fails when its log contains `Parse Error` or `Failed to load script`, even if Godot exits with status 0. This closes the engine case where a script reload failure is logged without a failing process exit.
- The separate unit-test parse step is required because GUT 9.5 intentionally disables GDScript warnings while loading test scripts. A warning configured as an error can therefore be skipped by discovery and still let Full GUT pass; `--script <test> --check-only` keeps the project warning policy active and exposes that failure.
- The known Phone PNG direct-load export warning may appear during QuarterviewMain startup and remains warning-only; it does not match the fatal script-load markers.

Targeted GUT examples:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_survival_state.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_power_board_candidate_state.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_room_object_definition.gd -gexit
```

## Git / Staging Rules

Codex should use the repository Skill at `.agents/skills/concent-safe-git/SKILL.md` for explicit-path staging, reviewed commit creation, normal upstream push, and final hash/status reporting. Invoke it explicitly as `$concent-safe-git`; it delegates Godot checks to `$concent-godot-validation` rather than duplicating validation commands.

- Work on `main` unless user asks otherwise.
- Before work:

```bash
git status --short --branch
git rev-parse --short HEAD
git fetch origin
git log --oneline HEAD..origin/main
```

- If `origin/main` has commits, stop and report.
- Never use `git add .`.
- Stage only files changed for the current task.
- Do not stage unrelated `godot/addons/*`, `.uid`, `.import`, license files, generated caches, or `godot/.godot/`.
- Force push is forbidden.

Known current caveat:

- Full `git diff --check` may fail on unrelated `godot/addons/godot_ai/handlers/texture_handler.gd` EOF whitespace if that unrelated local change remains. Do not fix it unless explicitly tasked.

## Documentation Rotation

- `PROJECT_STATUS.md` and `PROJECT_WORK_LOG.md` are active progress docs.
- When either grows beyond about 200 lines, move it to `docs/old/<NAME>_<YYYYMMDD>_<NN>.md` and recreate a short active file.
- Do not rotate `GAME_INFO.md` or reference docs by default.
