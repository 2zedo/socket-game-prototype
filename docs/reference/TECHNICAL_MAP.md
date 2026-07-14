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

## Godot Scene Inventory and Map Authoring Audit

This 2026-07-14 read-only audit matched every one of the 62 tracked Scene files against Scene text, Script/Resource references, fixed test paths, and project.godot. Generated godot/.godot editor metadata is excluded from reverse-reference decisions. Separately, the godot-ai MCP session godot@2212 opened Main, Apartment, the Apartment Environment/Shell/Playable, QuarterviewRoom, all three reusable-sample Scenes, ApartmentWallCell, and ApartmentWallSegment and returned that subset's live hierarchy and Inspector properties. No Scene, Script, Resource, Node, or geometry was changed.

| Role | Count | Meaning in this audit |
| --- | ---: | --- |
| Production | 8 | Main, current top-view room/player, and five production UI Scenes |
| Map editing authority | 1 | The current Apartment Environment Scene |
| Debug/Shell | 1 | The inherited Apartment debug wrapper |
| Playable | 2 | QuarterviewMain and the latest Apartment Playable candidate |
| Common Component | 9 | Interactable, QuarterviewRoom runtime, Floor/Room/Wall/Opening/Object components |
| Sample | 3 | The two-room reuse fixture Environment/Shell/Playable |
| Test | 22 | Vendored GUT addon Scenes |
| Legacy | 16 | Prototype/blockout/sandbox Scenes outside the active production and latest apartment paths |
| **Total** | **62** | Matches the complete godot/**/*.tscn file list |

Direct run below means a Scene supplies enough context for a meaningful project/editor run. Component means Godot can technically open it, but it is not a gameplay entry.

### Project Scene inventory (40)

| Scene | Root / Script | Role | Direct run | Child Scene dependencies | Incoming Scene/Script/Test references | Major owned data | Proposal |
| --- | --- | --- | --- | --- | --- | --- | --- |
| scenes/Main.tscn | Node2D / Main.gd | Production | Yes | Apartment; SurvivalHUD; PhoneUI; InteractionPanel; OutletMode; DayResultPanel | project.godot; candidate-dependency test | DAY1 composition, signal wiring, modal/UI orchestration | KEEP |
| scenes/Apartment.tscn | Node2D / Apartment.gd | Production | Partial | Runtime PackedScene exports for Player and Interactable | Main; candidate-dependency test | Top-view room drawing, player/interactable spawning | KEEP |
| scenes/Player.tscn | CharacterBody2D / Player.gd | Production | Component | — | Apartment export | Production keyboard player body | KEEP |
| scenes/Interactable.tscn | Area2D / Interactable.gd | Common Component | Component | — | Apartment export | Production interaction Area contract | KEEP |
| scenes/QuarterviewMain.tscn | Node2D / QuarterviewMain.gd | Playable | Yes | QuarterviewRoom | candidate-flow and dependency tests | Current production-candidate orchestration and mock UI, structurally separate from the newer Apartment Playable experiment | KEEP; later responsibility-based RENAME review |
| scenes/prototypes/PrototypeHub.tscn | Control / PrototypeHub.gd | Legacy | Yes | Script change_scene registry | PrototypeSceneUtils test | Prototype launcher and return flow | KEEP while registered prototypes remain |
| scenes/prototypes/HackingActionPrototype.tscn | Node2D / matching Script | Legacy | Yes | — | PrototypeHub; hacking test; dependency test | Hacking action/state experiment | KEEP |
| scenes/prototypes/HackingPerspectiveBlockout.tscn | Node2D / matching Script | Legacy | Yes | — | PrototypeHub; dependency test | Hacking camera/perspective blockout | REVIEW for ARCHIVE |
| scenes/prototypes/QuarterviewPerspectiveBlockout.tscn | Node2D / matching Script | Legacy | Yes | — | PrototypeHub | Old camera/depth blockout | REVIEW for ARCHIVE |
| scenes/prototypes/QuarterviewRoomPrototype.tscn | Node2D / matching Script | Legacy | Yes | — | PrototypeHub | Old room/object interaction prototype | REVIEW for ARCHIVE |
| scenes/prototypes/QuarterviewRoomShellPrototype.tscn | Control / matching Script | Legacy | Yes | — | PrototypeHub | Same-canvas shell-layer experiment | REVIEW for ARCHIVE |
| scenes/prototypes/QuarterviewGameplaySandbox.tscn | Node2D / matching Script | Legacy | Yes | Runtime loads room stub and six sandbox panels | PrototypeHub | Isolated RoomSceneContract/state/UI sandbox | REVIEW as one sandbox bundle |
| scenes/prototypes/QuarterviewSandboxRoomStub.tscn | Node2D / matching Script | Legacy | Component | — | QuarterviewGameplaySandbox.gd | Sandbox room contract stub | KEEP with sandbox bundle |
| scenes/prototypes/SandboxEndDayPanel.tscn | Control / matching Script | Legacy | Component | — | QuarterviewGameplaySandbox.gd | Sandbox end-day adapter UI | KEEP with sandbox bundle |
| scenes/prototypes/SandboxInteractionPanel.tscn | Control / matching Script | Legacy | Component | — | QuarterviewGameplaySandbox.gd | Sandbox interaction adapter UI | KEEP with sandbox bundle |
| scenes/prototypes/SandboxOutletPanel.tscn | Control / matching Script | Legacy | Component | — | QuarterviewGameplaySandbox.gd | Sandbox outlet adapter UI | KEEP with sandbox bundle |
| scenes/prototypes/SandboxPhonePanel.tscn | Control / matching Script | Legacy | Component | — | QuarterviewGameplaySandbox.gd | Sandbox Phone adapter UI | KEEP with sandbox bundle |
| scenes/prototypes/SandboxResultPanel.tscn | Control / matching Script | Legacy | Component | — | QuarterviewGameplaySandbox.gd | Sandbox result adapter UI | KEEP with sandbox bundle |
| scenes/prototypes/SandboxTestModePanel.tscn | Control / matching Script | Legacy | Component | — | QuarterviewGameplaySandbox.gd | Sandbox test-mode adapter UI | KEEP with sandbox bundle |
| scenes/prototypes/TitleMenuPrototype.tscn | Control / TitleMenuPrototype.gd | Legacy | Yes | Script self-reload | PrototypeHub | Title/pause flow experiment | REVIEW |
| scenes/prototypes/quarterview/WorkDevicesAtlasPreview.tscn | Control / matching Script | Legacy | Yes | — | No active source/test reference | Work-device atlas preview | MOVE to dev previews or ARCHIVE |
| scenes/quarterview/QuarterviewApartmentEnvironment.tscn | Node2D / QuarterviewApartmentShellCandidate.gd | Map editing authority | Yes, inspection | FloorLayer; RoomArea; OpeningMarker; WallCell; both editable-object components | Apartment Shell/Playable; apartment tests | Floor, logical rooms, openings, 58 WallCells, 18 objects, camera, editor guides, provider/debug exports | KEEP Scene; SPLIT Script responsibilities |
| scenes/quarterview/QuarterviewApartmentShellCandidate.tscn | Inherited Environment / inherited Script | Debug/Shell | Yes | Inherits Apartment Environment | apartment layout/guides/playable/dependency tests | No local geometry override; debug review identity only | KEEP; later RENAME to ApartmentDebugShell |
| scenes/quarterview/QuarterviewApartmentPlayable.tscn | Inherited Environment / inherited Script | Playable | Yes | Inherits Apartment Environment; adds QuarterviewRoom | apartment playable/dependency tests | Gameplay instance and external-provider wiring only | KEEP |
| scenes/quarterview/QuarterviewRoom.tscn | Node2D / QuarterviewRoom.gd | Common Component | Yes, legacy standalone; also component | — | QuarterviewMain; Apartment/Sample Playable; room/playable/dependency tests | Player/layers, click movement, hover/use, external-provider consumer plus legacy standalone fallback | KEEP; eventual SPLIT |
| scenes/quarterview/environment/ApartmentFloorLayer.tscn | TileMapLayer / ApartmentFloorLayer.gd | Common Component | Component | — | Apartment and Sample Environments | Editable floor layer defaults and room identity | KEEP; later generic RENAME candidate |
| scenes/quarterview/environment/ApartmentRoomArea.tscn | Node2D / ApartmentRoomArea.gd | Common Component | Component | — | Apartment and Sample Environments | Area2D logical room polygon and editor preview | KEEP; later generic RENAME candidate |
| scenes/quarterview/environment/ApartmentOpeningMarker.tscn | Node2D / ApartmentOpeningMarker.gd | Common Component | Component | — | Apartment and Sample Environments | Door/window semantic mirror and editor preview | KEEP; later generic RENAME candidate |
| scenes/quarterview/environment/ApartmentWallCell.tscn | Node2D / ApartmentWallCell.gd | Common Component | Component | — | Apartment and Sample Environments | One wall edge, height, visual, collision, opening metadata, attachment socket | KEEP; later generic RENAME candidate |
| scenes/quarterview/environment/ApartmentWallSegment.tscn | Node2D / ApartmentWallSegment.gd | Common Component | Component | WallCell container, empty by default | Sample Environment and sample test; Apartment reproduces it locally | WallGroup aggregate/scaffold and cell aggregation contract | REVIEW; normalize Apartment usage |
| scenes/quarterview/objects/ApartmentEditableObject.tscn | Node2D / ApartmentEditableObject.gd | Common Component | Component | — | Apartment and Sample Environments | Interactive visual/body/selection/interaction/use/base/top/socket contract | KEEP; later generic RENAME candidate |
| scenes/quarterview/objects/ApartmentEditableEnvironmentObject.tscn | Node2D / matching Script | Common Component | Component | — | Apartment and Sample Environments | Noninteractive visual/body/selection/base/top/socket contract | KEEP; later generic RENAME candidate |
| scenes/quarterview/samples/QuarterviewReusableMapSampleEnvironment.tscn | Node2D / QuarterviewReusableMapSample.gd | Sample | Yes, inspection | Shared Floor/Room/Opening/WallSegment/WallCell/Object components | Sample Shell/Playable and sample test | Fresh two-room geometry and sample provider/debug contract | KEEP |
| scenes/quarterview/samples/QuarterviewReusableMapSampleShell.tscn | Inherited Sample Environment | Sample | Yes | Inherits Sample Environment | sample test | No local geometry override; sample debug identity | KEEP |
| scenes/quarterview/samples/QuarterviewReusableMapSamplePlayable.tscn | Inherited Sample Environment | Sample | Yes | Inherits Sample Environment; adds QuarterviewRoom | sample test | Sample gameplay instance and external-provider wiring | KEEP |
| scenes/ui/DayResultPanel.tscn | Control / DayResultPanel.gd | Production | Component | — | Main; dependency test | Production day-result UI | KEEP |
| scenes/ui/InteractionPanel.tscn | Control / InteractionPanel.gd | Production | Component | — | Main | Production interaction/dialog UI | KEEP |
| scenes/ui/OutletMode.tscn | Control / OutletMode.gd | Production | Component | — | Main; dependency test | Production outlet UI | KEEP |
| scenes/ui/PhoneUI.tscn | Control / PhoneUI.gd | Production | Component | — | Main; dependency test | Production Phone UI | KEEP |
| scenes/ui/SurvivalHUD.tscn | Control / SurvivalHUD.gd | Production | Component | — | Main | Production survival/time/power HUD | KEEP |

### Vendored GUT Scene inventory (22)

All rows below are Test role and must remain a single vendored addon bundle. None is a game entry; direct use is addon-only. Individual rename, move, merge, or deletion is not a project maintenance action.

| Scene | Root / Script | Child or incoming addon relation | Major data | Proposal |
| --- | --- | --- | --- | --- |
| addons/gut/GutScene.tscn | Node2D / GutScene.gd | Instances NormalGui and MinGui; used by GutRunner/utils | Test runner scene | KEEP |
| addons/gut/UserFileViewer.tscn | Window / UserFileViewer.gd | No tracked incoming reference; standalone addon UI | User-file viewer | KEEP |
| addons/gut/gui/GutBottomPanel.tscn | Control / GutBottomPanel.gd | Instances RunAtCursor, RunResults, OutputText, ShortcutDialog, ShellOutOptions; plugin entry | Editor bottom panel | KEEP |
| addons/gut/gui/GutControl.tscn | Control / GutControl.gd | Script loads GutRunner; no tracked incoming Scene reference | Runner control UI | KEEP |
| addons/gut/gui/GutEditorWindow.tscn | Window / GutEditorWindow.gd | Loaded by plugin | Detached editor window | KEEP |
| addons/gut/gui/GutLogo.tscn | Node2D / gut_logo.gd | Instanced by About | Addon logo | KEEP |
| addons/gut/gui/GutRunner.tscn | Node2D / GutRunner.gd | Instances GutScene; used by CLI/control/editor runner | Test execution host | KEEP |
| addons/gut/gui/MinGui.tscn | Panel / gut_gui.gd | GutScene; instances ResizeHandle | Compact runner UI | KEEP |
| addons/gut/gui/NormalGui.tscn | Panel / gut_gui.gd | GutScene; instances ResizeHandle | Full runner UI | KEEP |
| addons/gut/gui/OutputText.tscn | VBoxContainer / OutputText.gd | GutBottomPanel | Output view | KEEP |
| addons/gut/gui/ResizeHandle.tscn | ColorRect / ResizeHandle.gd | MinGui and NormalGui | Resize interaction | KEEP |
| addons/gut/gui/ResultsTree.tscn | Tree / ResultsTree.gd | RunResults | Result tree | KEEP |
| addons/gut/gui/RunAtCursor.tscn | Control / RunAtCursor.gd | GutBottomPanel | Cursor test action | KEEP |
| addons/gut/gui/RunExternally.tscn | Control / RunExternally.gd | Loaded by addon utils | External-run UI | KEEP |
| addons/gut/gui/RunResults.tscn | Control / RunResults.gd | GutBottomPanel; instances ResultsTree | Run summary UI | KEEP |
| addons/gut/gui/Settings.tscn | VBoxContainer / no Script | No tracked incoming reference | Empty settings container | KEEP |
| addons/gut/gui/ShellOutOptions.tscn | ConfirmationDialog / matching Script | GutBottomPanel | Shell options | KEEP |
| addons/gut/gui/ShortcutButton.tscn | Control / matching Script | ShortcutDialog | Shortcut row | KEEP |
| addons/gut/gui/ShortcutDialog.tscn | ConfirmationDialog / matching Script | GutBottomPanel; instances ShortcutButton | Shortcut editor | KEEP |
| addons/gut/gui/about.tscn | AcceptDialog / about.gd | Bottom-panel script; instances GutLogo | About dialog | KEEP |
| addons/gut/gui/run_from_editor.tscn | Node2D / matching Script | Addon editor runner | Custom Scene runner | KEEP |
| addons/gut/gut_loader_the_scene.tscn | Node2D / no Script | No tracked incoming reference; addon loader fixture | Empty load target | KEEP |

### Scene dependency graph and fragile reverse references

    project.godot
    └─ Main.tscn
       ├─ Apartment.tscn
       │  ├─ Player.tscn               (exported PackedScene; runtime instantiate)
       │  └─ Interactable.tscn         (exported PackedScene; runtime instantiate)
       └─ SurvivalHUD / PhoneUI / InteractionPanel / OutletMode / DayResultPanel

    QuarterviewMain.tscn
    └─ QuarterviewRoom.tscn            (standalone legacy-provider mode)

    QuarterviewApartmentEnvironment.tscn
    ├─ FloorLayer ×4 / RoomArea ×4 / OpeningMarker ×5
    ├─ WallCell ×58
    └─ EditableObject and EditableEnvironmentObject instances ×18

    QuarterviewApartmentEnvironment.tscn
    ├─ inherited by QuarterviewApartmentShellCandidate.tscn
    └─ inherited by QuarterviewApartmentPlayable.tscn
       └─ QuarterviewRoom.tscn         (external-provider mode)

    QuarterviewReusableMapSampleEnvironment.tscn
    ├─ shared Floor/Room/Opening/WallSegment/WallCell/Object components
    ├─ QuarterviewReusableMapSampleShell.tscn inherits Sample Environment
    └─ QuarterviewReusableMapSamplePlayable.tscn inherits Sample Environment
       └─ QuarterviewRoom.tscn         (external-provider mode)

    PrototypeHub.gd
    └─ change_scene_to_file registry for seven prototype entries
       └─ QuarterviewGameplaySandbox.gd runtime-instantiates its room stub and six panels

| Reference kind | Current exact source | Rename/move risk |
| --- | --- | --- |
| Project entry | project.godot run/main_scene → res://scenes/Main.tscn | Main move breaks startup; protected |
| Scene ext_resource / inheritance | Main, QuarterviewMain, Apartment Environment/Shell/Playable, Sample trio | Godot UID may help editor moves, but literal paths and tests still require coordinated updates |
| Exported PackedScene | Apartment.gd player_scene and interactable_scene, assigned in Apartment.tscn | Production runtime spawn fails if either assignment/path breaks |
| Script preload/change_scene | PrototypeHub.gd registry; QuarterviewGameplaySandbox.gd components; TitleMenuPrototype self-reload | Prototype move requires Script registry changes |
| Resource load | QuarterviewRoom.gd loads RoomObjectDefinition resources; Environment/Sample Scenes assign footprint Resources to their root Script exports | Scene move can leave Resource/provider tests stale even when the Scene opens |
| Fixed apartment test paths | test_quarterview_apartment_playable.gd, test_apartment_object_layout_candidate.gd, test_apartment_wall_editor_guides.gd | Environment/Shell/Playable/component renames require same-commit test migration |
| Fixed sample test paths | test_quarterview_reusable_map_sample.gd | Sample and WallSegment paths are contract assertions |
| Fixed candidate/production paths | test_quarterview_candidate_dependencies.gd, test_quarterview_main_candidate_flow.gd, test_quarterview_room_interaction_flow.gd | Main, QuarterviewMain, QuarterviewRoom, and candidate path changes fail intentionally |
| Fixed prototype paths | test_prototype_scene_utils.gd, test_hacking_action_state_machine.gd | PrototypeHub and HackingAction moves require test and registry updates |

Only Apartment.gd exports PackedScene dependencies. No other project Script exports a PackedScene; Quarterview assembly is stored directly through Scene ext_resources and inherited Scenes.

### Apartment editing authority and current WallCell workflow

| Concern | Scene authority / exact NodePath | Runtime consumer |
| --- | --- | --- |
| Floor cells | QuarterviewApartmentEnvironment/Floor/EntranceFloor, BathroomFloor, LivingFloor, WorkFloor | Environment provider and debug grid |
| TileSet | res://resources/quarterview/dev_apartment_floor_tileset.tres; 128×64 isometric development atlas | Four TileMapLayers |
| Logical rooms | RoomAreas/EntranceArea, BathroomArea, LivingArea, WorkArea → Area2D/CollisionPolygon2D | M and room/path membership |
| Wall groups | Walls/WorkBackWall, WorkLeftWall, WorkRightWall, EntranceWall, EntranceInnerWall, LivingRightWall, LivingFrontCutaway, WorkFrontSharedWall, BathroomWall, BathroomRightWall | Group labels and cell aggregation |
| Wall cells | Each group’s WallCells/CellNN; 8+4+4+6+3+6+11+11+2+3 = 58 | M/N/W/V, wall collision and visuals |
| Openings | Openings/EntranceDoorOpening, EntranceInnerOpening, BathroomDoorOpening, WorkRoomOpening, LivingWindowOpening | Mirrors authoritative opening WallCell metadata |
| Wall sockets | WallConduit is an actual child of WorkBack Cell02/AttachmentSocket, and SeaHorizonPoster is an actual child of LivingRight Cell03/AttachmentSocket. PowerModuleBoard and EntranceDoor remain under EditableObjectNodes and follow WorkBack Cell05 / Entrance Cell04 through `mount_socket_path` plus `mount_offset`. | Physical child tracking for decorations; explicit Socket-path tracking for interactive mounts |
| Floor/root objects | EditableObjectNodes with 11 top-level roots and four nested Socket children | P, N, Playable hover/use/collision |
| Ceiling | CeilingAnchors/FluorescentLightSocket/FluorescentLight | Physical ceiling attachment |
| Navigation | No authored Navigation or NavigationRegion2D Node exists | Derived by QuarterviewApartmentShellCandidate.gd from Floor, RoomArea, WallCell, Opening, and BodyPolygon; QuarterviewRoom delegates in external mode |
| Editor guides | EditorGuides/RoomGuides, WallGuides, ObjectGuides, HeightAndSocketGuides | @tool editor-only guide sync; hidden at runtime |
| Debug | No saved debug layers; QuarterviewApartmentShellCandidate.gd creates P/M/N/W/V/F1 layers in _ready | Environment and inherited Shell/Playable share the same Script |
| Player movement/use | Playable/Gameplay is QuarterviewRoom; PlayerLayer/Player is QuarterviewPlayer | Click path, UsePoint arrival, interaction request |
| Y-sort | Editable object Scripts derive z_index from BasePoint; player derives from global y | Scene-node BasePoint and player position |

WallCell is a Node-instance workflow, not a TileMap paint workflow:

1. Open QuarterviewApartmentEnvironment.tscn and expand Walls/<WallGroup>/WallCells.
2. Duplicate or instance ApartmentWallCell.tscn under WallCells; name it CellNN and give it a unique cell_index.
3. Move the Cell root to the desired edge start. Set end_offset to one 128×64 isometric edge along the authored wall axes: `(64,32)` or `(-64,32)`.
4. Set wall_height, enabled, visual_enabled, collision_enabled, opening_kind/id/passable, and visual mode in Inspector.
5. ApartmentWallCell.gd regenerates StartPoint, EndPoint, BasePoint, TopPoint, Visual, OcclusionVisual, and CollisionPolygon in the editor.
6. Put wall-mounted content under that Cell’s AttachmentSocket.
7. ApartmentWallSegment.gd sorts cells, derives group endpoints/opening mirrors, and disables the retired aggregate Visual/Collision.
8. Reopen inherited Shell and Playable, then validate M/N/W/V and movement.

The current WallCell contract needs per-cell openings, height, collision, state, and child sockets. A TileMap conversion would discard or externalize those instance-specific properties. Do not convert walls to TileMap now. If a second authored map shows repeated placement friction, add a small Cell-stamp tool that instances WallCell Scenes while retaining Node authority.

### Duplicate responsibility and naming confusion

| Finding | Evidence and risk | Direction |
| --- | --- | --- |
| Environment also owns debug/provider behavior | Environment root directly attaches the 6,000-line QuarterviewApartmentShellCandidate.gd | Split data provider/editor-guide sync from Shell input/rendering before renaming |
| Shell is almost only an inherited name | Shell inherits Environment and tests prohibit local geometry overrides | Keep as wrapper; rename to ApartmentDebugShell only in an isolated path-migration commit |
| Playable inherits the debug-capable Environment Script | Playable adds only Gameplay but still carries P/M/N/W/V code | Make Environment assembly/provider-only; attach debug controller only in DebugShell |
| QuarterviewRoom means two things | It is both standalone legacy room builder and external Environment gameplay consumer | Preserve now; later split/rename runtime consumer and legacy fixture |
| Apartment WallGroups duplicate WallSegment scaffold | Sample instances ApartmentWallSegment.tscn; Apartment locally rebuilds its Node structure | Normalize one group at a time after Walls split; never bulk rewrite 58 Cells |
| Aggregate and unit wall geometry coexist | WallGroup Start/End/Visual/Collision are serialized but disabled; WallCells are active authority | Remove retired aggregate children only after tests prove no fallback use |
| Opening has authority plus mirror | WallCell opening metadata overwrites OpeningMarker points/type/passability | Keep WallCell authoritative; label OpeningMarker derived/read-only in editing docs |
| Group sockets and Cell sockets coexist | Physical mounts use Cell sockets; group AttachmentSockets are compatibility containers | Remove only after reverse-reference test proves zero use |
| Resource semantics can drift from physical parenting | Logical parent/wall IDs remain in Resource while transform authority is Scene Socket | Retain semantic metadata, add validation rather than a second transform |
| Sample provider repeats debug/provider code | Sample is a fresh component fixture, not a copied apartment, but owns its own controller | Keep until a second real map proves exactly which provider/debug base is shared |
| Similar Main names imply false equivalence | Main is production; QuarterviewMain is the current production candidate; the newer Apartment Playable experiment is structurally separate | Proposed names must include Production, Candidate, Debug, or Playable responsibility |

There is no current duplicate floor/wall/object geometry in Shell or Playable: both inherit the Environment and their tests reject child transform/geometry overrides. The duplication is inside the Environment’s mixed Script responsibility and WallGroup compatibility scaffolding, not three copies of the apartment map.

### Recommended target Scene structure

The target should separate authoring surfaces only where it removes a real editing or ownership problem:

    godot/scenes/quarterview/maps/apartment/
    ├─ ApartmentEnvironment.tscn       assembly + map-provider contract only
    ├─ ApartmentFloor.tscn             four TileMapLayers
    ├─ ApartmentStructure.tscn         RoomAreas + Walls + Openings + wall children
    ├─ ApartmentObjects.tscn           conditional; free/floor/parent/ceiling objects
    ├─ ApartmentDebugShell.tscn        Environment + debug controller/UI
    └─ ApartmentPlayable.tscn          Environment + gameplay runtime

    godot/scenes/quarterview/components/
    ├─ QuarterviewFloorLayer.tscn
    ├─ QuarterviewRoomArea.tscn
    ├─ QuarterviewOpeningMarker.tscn
    ├─ QuarterviewWallCell.tscn
    ├─ QuarterviewWallGroup.tscn
    ├─ QuarterviewEditableObject.tscn
    └─ QuarterviewEditableEnvironmentObject.tscn

| Decision | Recommendation | Reason |
| --- | --- | --- |
| Split Floor | Yes, first structural split | Four TileMapLayers have no physical child sockets and can be edited without wall occlusion |
| Split Walls | Yes, as ApartmentStructure with RoomAreas/Openings | Openings are WallCell-derived mirrors and room/wall editing is one structural concern |
| Split Objects | Conditional, after mount contract audit | Wall/parent/ceiling objects physically live under sockets outside one flat object root |
| Environment assembly-only | Yes | It should expose map queries and assemble authored children, not own debug input/UI |
| Debug vs Playable | Yes | Debug input/rendering belongs only to DebugShell; Playable should add gameplay only |
| Keep a Room Scene | Yes, but clarify its role | QuarterviewRoom is the reusable player/movement/interaction runtime; legacy standalone layout should later be separated |
| Keep Sample | Yes | It proves fresh component assembly and fixed provider behavior; move to test fixtures only after a second real map replaces its evidence |
| Generic component rename | Later, not first | Apartment-prefixed components are already reused, but rename cost touches tests and Scene ext_resources |

### Future Scene candidates

#### A. High-probability new Scenes

| Candidate | Purpose / included Nodes | Instances | Source | When / completion |
| --- | --- | --- | --- | --- |
| ApartmentFloor.tscn | Floor root and four TileMapLayers | Shared FloorLayer component | Environment/Floor | Stage 2; this child Scene becomes the sole Floor edit authority, with zero instance transform and no Environment-local child overrides |
| ApartmentStructure.tscn | RoomAreas, Walls/WallCells, Openings, wall-attached children | RoomArea, WallCell, later WallGroup | Environment structural roots | Stages 3–4; this child Scene becomes the sole Structure edit authority, with zero instance transform, no Editable Children/local overrides, and unchanged M/N/W/V, sockets, and collision |
| ApartmentDebugController.tscn | Runtime debug layers, labels, panels, help | No map geometry | Environment root Script responsibilities | Stage 6; only DebugShell processes P/M/N/W/V |
| ApartmentObjects.tscn | Free/floor objects plus parent/ceiling anchors where cross-Scene mounts are explicit | Editable object components | Environment object roots | Stage 4 conditional; all 18 world transforms and socket tracking unchanged |

#### B. Rename or split results

| Target name | From | Purpose | Creation point / completion |
| --- | --- | --- | --- |
| ApartmentDebugShell.tscn | QuarterviewApartmentShellCandidate.tscn | Name the actual debug wrapper role | Stage 6 isolated rename; all reverse refs/tests updated together |
| QuarterviewGameplayRuntime.tscn | External-provider half of QuarterviewRoom.tscn | Player, movement, hover/use consumer only | Stage 7 after external-provider tests pass without legacy builder |
| QuarterviewLegacyRoomFixture.tscn | Standalone fallback half of QuarterviewRoom.tscn | Preserve regression-only generated room | Stage 7; standalone tests remain green |
| QuarterviewWallGroup.tscn | ApartmentWallSegment.tscn after two-map proof | Generic Cell aggregation contract | Conditional Stage 11 only after an actual second-map requirement proves identical use |
| Quarterview-prefixed Floor/Room/Opening/Object components | Current Apartment-prefixed components | Remove false apartment-only naming | Conditional Stage 11 in one path-only migration, only after two-map evidence |

#### C. Create only for an actual second-map request

| Candidate set | Purpose | Required content | Create only when / completion |
| --- | --- | --- | --- |
| MapBEnvironment / MapBDebugShell / MapBPlayable | Author a real requested non-apartment map while proving post-split assembly | Requirements of that map; never a synthetic duplicate made only for validation | Conditional Stage 10, only after an explicit map request and stable Apartment migration |
| Optional WallCellStamp test fixture | Verify a future Cell-instancing helper | Empty WallGroup and reversible stamp/remove cases | Conditional Stage 12 only if two actively authored maps demonstrate manual duplication pain |

The existing reusable sample already serves as the first fresh assembly fixture. Do not create a second sample merely to rename it.

### Visual/editing backlog status

| Reported issue | Audit result | Planned checkpoint |
| --- | --- | --- |
| Walls obscure floor/object editing | Structurally valid: full wall visuals share one Environment authoring canvas | Floor and Structure split; keep CLEAN/STRUCTURE/OBJECT/ALL as local visibility aids |
| Project guides mix with Godot white gizmos | Godot gizmo colors are engine-owned; project guides are separately toggled | Preserve direct Polygon editing and hide project guides by mode rather than restyling engine gizmos |
| Normal game and debug grid separation | Already implemented: runtime debug layers are hidden unless P/M/N/W is active | Protect with startup/debug-state tests through every split |
| W Junction appears unimplemented | Code now clusters endpoints with tolerance, ignores collinear joins, classifies inner/outer Junctions, and draws 3-way markers | Stage 9 is visual acceptance/regression, not a from-zero implementation |
| W labels appear under wall lines | Code now uses `DebugOverlayLayer` CanvasLayer with a dedicated `WallScreenLabels` Control, outward offset, viewport flip, overlap/line rejection | Stage 9 visually verify after camera/Scene splits and tune only with evidence |
| TileMap-style wall stamping | Not present; current workflow is Node instance/duplicate + Inspector metadata | Review a small stamp helper only after an actual second authored map shows repeated need |
| Large EditorPlugin | Not justified by one apartment plus one sample | Conditional Stage 12 decision; never before common Scene contracts stabilize |

### Staged migration plan

| Stage | Changed files / implementation | Existing behavior to protect | Automated validation | godot-ai MCP and user check | Rollback / next gate |
| --- | --- | --- | --- | --- | --- |
| 1. Confirm roles and names | Documentation and path-impact list only | All current paths and entry points | Complete Scene inventory and reverse-reference check | Open current Environment/Shell/Playable; user approves target names | Revert docs only; approval required before file moves |
| 2. Split Floor | New ApartmentFloor as sole Floor edit authority; Environment instances it at zero transform with Editable Children off and no local child overrides | 99 cells, TileSet, room colors, no overrides in Environment/Shell/Playable | Cell/TileSet equality, Environment-source override rejection, instance-transform-zero check, and three-scene startup | Edit the child Scene only, change one cell and undo; user compares Environment/Shell/Playable | Revert Floor commit; proceed when byte/behavior parity and single-authority tests pass |
| 3. Split Structure | New ApartmentStructure as sole RoomArea/Wall/Opening authority; Environment uses a zero-transform instance without Editable Children/local overrides | 58 Cells, five openings, M/N/W/V, door collision | hierarchy/count/path-query/navigation tests plus Environment-source override and instance-transform checks | Edit the child Scene only, move one Cell/room point/opening then undo; user checks editor clarity | Revert Structure commit; proceed only with unchanged world geometry and single authority |
| 4. Normalize wall groups and object boundary | Instance common WallGroup one group at a time; decide conditional Objects Scene | Socket parenting, all 18 transforms, no retired geometry regression | per-group edge/socket/world-transform tests | Inspect Cell/socket tracking and P selection; user approves mount workflow | Revert latest group only; Objects split waits for explicit mount solution |
| 5. Make Environment assembly/provider-only | Extract map query/provider Script from Shell Script | Floor/room/wall/object authority and Playable queries | provider contract, zero fallback, startup tests | Inspector shows assembly children; Shell/Playable map equality | Restore old Script attachment; proceed when provider API is stable |
| 6. Separate DebugShell | Add debug controller only to Shell; optionally isolated rename | P/M/N/W/V/F1, guide modes, no Playable default guides | debug mode tests and fixed-path migration | Run all debug modes; user checks labels/overlays | Restore old Shell path/controller; proceed after visual approval |
| 7. Clarify Playable/Room runtime | Split external gameplay runtime from legacy standalone fallback if evidence supports it | Click movement, UsePoint, interaction, legacy QuarterviewMain regression | Room external/standalone tests and Playable startup | Play Apartment and sample; user checks controls | Revert runtime split; production connection remains blocked |
| 8. Lock Sample and Legacy boundaries | Keep the sample as a fixture and record prototype/legacy ownership; do not move or archive PrototypeHub/Hacking content in the apartment migration | Sample evidence and all prototype paths/registries remain unchanged | fixed-path, dependency, sample startup, and prototype registry checks | Open the sample trio; user confirms it remains a fixture rather than an Apartment copy | Revert boundary/test commit; any archive cleanup requires a separate explicit task |
| 9. W/Junction visual acceptance | Tune only current Junction/label implementation with visual evidence | Wall geometry, V states, W visibility | Junction merge/label bounds tests | W with V NORMAL/TRANSPARENT/HIDDEN; user approves readability | Revert tuning commit; no structural rollback required |
| 10. Conditional real second map | Only when explicitly requested, assemble that map's Environment/DebugShell/Playable from common components; do not create MapB merely for validation | Apartment and reusable sample remain unchanged | both-map provider/startup/movement tests | Edit the requested map's Floor/Cell/Opening and play; user confirms workflow | Revert only the new map commit; Stage 9 may be the migration endpoint |
| 11. Conditional common extraction | Only with two actively authored maps, rename/move components proven identical in both | Both map paths, Resource links, all fixed tests | dependency and two-map full regression | Open both hierarchies and compare Inspector contracts | Revert one path-migration commit; skip when evidence is insufficient |
| 12. Conditional small editor helper | Design decision only after two maps prove repetitive manual WallCell work; implement at most a narrow stamp helper | Manual Node workflow and undo safety | stamp/undo/id/index/opening tests | User trials create/move/undo in both maps | Keep manual workflow if benefit is unclear; plugin is never a prerequisite |

Stages 1–9 are the complete Apartment migration and may stop after Stage 9. Stages 10–12 are optional gates triggered only by an explicit real-map request and repeated-work evidence. Every structural stage is its own commit and must pass `scripts/validate_concent.sh --full`, global `git diff --check`, its targeted tests, and the listed MCP check before the next stage. Main.tscn, DAY1, production Apartment, SurvivalState, production UI, and project.godot remain outside this map-authoring migration.

## Quarterview Apartment Production Readiness

The current decision is `KEEP_CANDIDATE`. `QuarterviewApartmentEnvironment` and `QuarterviewApartmentPlayable` are not connected to production `Main`, DAY1 state, or production UI. In particular, `QuarterviewMain.tscn` still instances the standalone `QuarterviewRoom`; it is not a wrapper for the latest Apartment Environment/Playable pair.

### Responsibility comparison

| Component | Current production owner | Current Quarterview owner | Duplicate or gap | Required Adapter / contract | Keep / absorb / retire candidate | Main risk |
| --- | --- | --- | --- | --- | --- | --- |
| Scene entry / exit | `project.godot` → `Main.tscn`; `Main.gd` owns the DAY1 composition | Environment, Shell, Playable, and `QuarterviewMain` are direct-run candidates | No production entry to the latest Playable; no Quarterview exit contract | Separate production-candidate composition and explicit enter/back contract | Keep Main until the final gate; absorb Playable only through a new composition | Replacing Main early removes the rollback path |
| Player creation / movement | `Apartment.gd` runtime-spawns `Player.tscn`; keyboard physics | `QuarterviewApartmentPlayable.tscn` adds `QuarterviewRoom`, click path, UsePoint arrival, and uses the Environment Camera2D | Two players and two movement models | Room adapter with one input-lock API and one active camera/player | Keep Quarterview click movement; retire old Player only after parity | Simple nesting creates two player/input models, while the QV Environment camera takes viewport framing ownership |
| Object select / move / use | `Apartment.gd` emits one `ApartmentInteractable` argument | `QuarterviewRoom.gd` emits `(object_key, action_key, payload)` | Signal shapes and seven-object inventories differ | Stable public object ID plus production action/device mapping | Absorb Quarterview geometry/movement; keep production action semantics | Direct signal connection is invalid |
| Phone open / close | `Main.gd`, production `PhoneUI`, scene-local `SurvivalState` | `QuarterviewMain` uses candidate Phone; Apartment Environment uses P for debug | Production P=test, Environment P=object debug, candidate P=Phone. `open_phone` is currently Backspace while Main also checks raw Tab | One orchestrator must own modal > Phone > interaction > debug priority and remove raw-key duplication | Keep production Phone first; candidate Phone adoption is conditional | One key can open/toggle multiple owners; ESC propagation can close the wrong layer |
| Time progress | Scene-local `SurvivalState.gd` and `Main.gd` modal pause | Quarterview Playable has no time state | Missing integration; candidate mock time lives only in `QuarterviewMain.gd` | Read-only clock/state adapter plus modal pause contract | Keep `SurvivalState`; delete mock time only after real wiring | State is lost on scene replacement because it is not an Autoload |
| Power / battery | `SurvivalState.gd`, `OutletMode`, device Resources, production Phone/HUD | `PowerBoardCandidate` and candidate HUD are local/mock | Two UIs, no shared calculation | Object/action mapping and a state-to-room visual adapter | Keep production calculations; candidate visuals are conditional | Split-brain load/device state; QV object IDs do not match DAY1 device IDs |
| Day start / end | `Main.gd`, `SurvivalState.end_current_day()`, `DayResultPanel`, continue-next-day | Bed/DayResult candidate flows are mock | No real result or next-day connection | Bed action → orchestrator → state/result contract | Keep production flow until end-to-end parity | Candidate could end only its local mock day |
| Save / restore | No SaveManager, persistence Autoload, or `user://` state write exists | Explicitly absent and forbidden by the candidate boundary | Entire feature is missing in both paths | Add a versioned save contract only if persistence is separately approved or made release-required; otherwise record the no-persistence/state-lifetime policy explicitly | Nothing to absorb yet | Scene change currently discards scene-local day state |
| UI / input priority | `Main.gd` owns result, outlet, interaction, Phone, exploration order | `QuarterviewMain`, Environment debug, and `QuarterviewRoom` each handle input | Multiple `_unhandled_input` owners | Single production-candidate orchestrator; runtime-debug disable flag | Keep M/N/P/W/V in Shell, not in production runtime | Event order changes behavior and can leave movement unlocked/locked |
| Signals / Autoload / Resources | Main connects local Apartment/State/UI; only `_mcp_game_helper` is Autoload | Environment provider + RoomObjectDefinition and Scene-node object data | No common implemented Room contract; `RoomSceneContract.gd` is a no-op skeleton | Implement the skeleton or introduce one typed adapter, not both | Keep local state for candidate composition; decide persistence separately | Duplicate connections after ad-hoc re-entry; legacy roles can be mistaken for production actions |

Current object inventories are intentionally different:

- Production Apartment: `bed`, `charger`, `communication_device`, `fan`, `laptop`, `light`, `power_strip`.
- Quarterview direct interaction: `bed`, `entrance_door`, `fridge`, `microwave`, `navi_link`, `node_17`, `power_module_board`.
- Plausible mappings such as `navi_link ↔ communication_device` and `power_module_board ↔ power_strip` are not yet approved contracts. Light/laptop/fan/charger have no direct equivalent in the current seven, while door/fridge/microwave/NODE-17 have no production DAY1 action mapping.

### Exact connection-file classification

Must change before production integration:

- New `godot/scripts/quarterview/QuarterviewApartmentRoomAdapter.gd` plus contract tests: expose only normalized generic nearest/request payloads, input lock, and player/room seams. Stage B has no production state/UI knowledge and must not push production meanings into `QuarterviewRoom` definitions.
- New `godot/scenes/quarterview/QuarterviewApartmentProductionCandidate.tscn` and `godot/scripts/quarterview/QuarterviewApartmentProductionCandidate.gd`: instance the existing Playable, local `SurvivalState`, and unchanged production UI; own modal/input/signal orchestration without modifying Main.
- A typed object/action mapping Resource, QV visual/state adapter, and integration tests before Stage D; the proposed data path is `godot/resources/quarterview/apartment_production_action_map.tres`. Production action/device mapping and state-to-room visuals belong here and in the Stage-C/D composition controller, not in the generic room adapter.

Conditionally change only after a product decision:

- `godot/scenes/quarterview/QuarterviewApartmentPlayable.tscn`: reuse unchanged first; edit only if the external adapter needs an exported hook that cannot be supplied by composition.
- `godot/scripts/quarterview/QuarterviewRoom.gd`: its current public Environment IDs and generic three-argument interaction payload are already suitable adapter input. Change only if Stage B proves a stable player-position/back signal or another missing public room seam is required.
- `godot/scripts/quarterview/QuarterviewApartmentShellCandidate.gd`: the composition can initially disable Environment `_unhandled_input`; add an explicit runtime-debug mode only if that composition-level control is insufficient while preserving Shell M/P/N/W/V/J/H/F1.
- `godot/scripts/contracts/RoomSceneContract.gd`: implement only if selected instead of the new typed adapter. Its current methods are safe no-ops, not an implementation.
- `godot/scenes/QuarterviewMain.tscn` and `godot/scripts/QuarterviewMain.gd`: only if its candidate overlay UX is retained. Never promote its mock time/power/day state.
- `godot/scenes/quarterview/QuarterviewApartmentEnvironment.tscn`, `godot/resources/quarterview/apartment_shell_object_footprints.tres`, `godot/resources/rooms/quarterview/objects/*.tres`, and `godot/scripts/resources/RoomObjectDefinition.gd`: only after deciding how production light/laptop/fan/charger appear in the 18-object world.
- `godot/scripts/SurvivalState.gd`: reuse unchanged first; modify only for an approved persistence contract, new action model, or corrected phase model.
- Candidate Phone/Power Board scripts or production Phone/Outlet/Result Scenes and scripts: change one UI at a time only if that UI is selected for production.
- Recommended final-entry path: change only `godot/project.godot` to the fully validated new composition at the explicit Main replacement gate, leaving `godot/scenes/Main.tscn` and `godot/scripts/Main.gd` intact for direct-run rollback. Any alternative that edits Main requires a separate approved preservation/rollback plan.

Do not change during readiness and adapter work:

- Production `Main.tscn`, `Main.gd`, `Apartment.tscn`, `Apartment.gd`, `Player.tscn`, `Player.gd`, `Interactable.tscn`, `Interactable.gd`, production SurvivalHUD/Phone/InteractionPanel/Outlet/Result Scenes and scripts, and `project.godot`. The new composition may instance these UI Scenes unchanged; that does not authorize editing them.
- Existing Environment floor, wall, opening, object, Polygon, and camera authoring data.

Removable only after promotion and a regression period:

- Runtime-generated production `Apartment`/`Player`/`Interactable` path.
- `QuarterviewRoom` standalone blockout/layout builders once no tested standalone path needs them.
- `QuarterviewMain` mock state and mock Bed/Kitchen/Door/DayResult/Hacking handlers.
- Environment non-ROTATE_90/legacy Resource geometry fallback after its tested compatibility paths are retired.
- The no-op `RoomSceneContract` only if a different typed adapter becomes the accepted contract.

Keep in production: `SurvivalState` day/power/battery calculation, production modal/result flow, device Resources, and the existing Main golden path until final approval. Absorb later: Environment Scene-node geometry, click path/UsePoint movement, door passability, and seven-object interaction payloads through an adapter. Temporarily adapt: signal shape, input lock, object/action IDs, and state-to-visual updates. Decision still unavailable: final Phone/Power Board UI, persistence lifetime, and how the missing DAY1 devices appear in the new room.

### Staged connection plan

| Stage | Files | Start condition | Implementation | Automated tests | MCP / user check | Completion and rollback | Next gate |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A. Independent contract freeze | Existing readiness/dependency and Apartment Playable tests; docs only | Current Environment/Playable starts independently | Characterize Main composition, signals, input keys, state seams, QV signal/ID mismatch; keep `KEEP_CANDIDATE` | Main/Apartment/Environment/Shell/Playable/Sample startup; readiness GUT; full validation | MCP starts current scenes; user only confirms the audit scope | Done when no production files change. Rollback: remove only characterization tests/docs | All current contracts remain green |
| B. Room adapter candidate | New `QuarterviewApartmentRoomAdapter.gd` and test; optionally implement `RoomSceneContract.gd` instead | Stage A green; one contract approach selected | Normalize nearest/request payload, input lock, player position, and public object ID; no state/UI | Adapter unit tests plus existing QV movement/door tests | MCP click→path→UsePoint→adapter signal; user checks control feel | Done when adapter has no production dependency. Rollback: delete new adapter | Stable payload and one movement owner |
| C. Production-candidate composition and input | New `QuarterviewApartmentProductionCandidate.tscn/.gd`; production UI is instanced, not edited | Stage B stable; input policy and production state/UI reuse explicitly approved | Compose Playable + local SurvivalState + existing HUD/Phone/Interaction/Outlet/Result; disable runtime debug ownership; resolve P/Tab/Backspace and ESC priority | Modal order, Phone open/close, no duplicate signals, input-lock tests | MCP rapid Phone/interaction/ESC; user confirms UI/input priority | Done with Main untouched. Rollback: remove new composition | Candidate starts repeatedly with one camera/player/state |
| D. Time and power mapping | Proposed `godot/resources/quarterview/apartment_production_action_map.tres`, its typed Resource script/test, QV visual adapter, and `godot/scripts/SurvivalState.gd` only if an approved gap requires it | Stage C composition stable; object/action matrix approved | Connect clock/modal pause, power/battery, device active/connected, Power Board/Outlet, and object visuals | Drain, battery, connection-vs-active, modal pause, each mapping | MCP clock/power changes reflected in HUD/Phone/room; user confirms semantics | Done when no mock state drives production UI. Rollback: detach the mapping adapter; any approved SurvivalState change must be an isolated commit and is reverted independently to restore the unchanged production state path | All seven QV interactions have an explicit production outcome |
| E. Conditional save / restore track | New versioned persistence service/Resource and tests; exact path is intentionally TBD because no current save owner exists | Separate user approval of state lifetime/storage schema; this is not required for parity with the current no-save Main | Save only canonical state and player/scene entry data; define missing/corrupt-data defaults | New/no/corrupt/old save tests; scene reload restore | MCP restart/reload; user confirms continue/new-game behavior | Done when no-data startup and rollback migration pass. Rollback: disable/revert the isolated persistence service and keep current defaults | Runs in parallel only when approved; does not block F/H unless explicitly promoted to a release requirement |
| F. DAY1 flow inside the candidate | New production-candidate composition Scene/Script from Stage C; protected Main remains untouched | Stages C-D green; Stage E only if separately approved as a release requirement | Complete direct-run candidate Bed end-day, Result, continue-next-day, and candidate-local exit/back behavior; do not add a Main route | Candidate launch→Result→next day tests; repeat-launch duplicate-signal test | MCP direct-run full DAY1 loop; user directly verifies every transition screen | Done with Main and start scene unchanged. Rollback: revert only candidate composition commits | Full functional parity checklist passes |
| G. Legacy parity and removal decision | Comparison tests/docs; no deletion in the first pass | Stage F used successfully and golden-path comparison recorded | Decide retain/absorb/delete for old Apartment/Player/Interactable and candidate mocks | Old/new parity matrix and full validation | User approves any behavior difference | Done with a per-file removal list. Rollback: keep legacy path | Explicit deletion approval |
| H. Final promotion | One dedicated `godot/project.godot` start-scene commit | Required Stages A-D, F, and G PASS; conditional E only when separately approved; old Main, `QuarterviewMain`, and the selected production-candidate composition manual checks PASS; explicit user approval | Point the start scene to the validated production-candidate composition; do not edit or delete existing `Main.tscn`/`Main.gd` | Full validation plus old Main, QuarterviewMain, and new composition direct startup | MCP fresh project launch; user final play-through | Done after normal push. Rollback: revert this single start-scene commit or direct-run the unchanged old Main | Cleanup only after a regression period |

### Promotion checklist

| Gate | Status | Evidence / blocker |
| --- | --- | --- |
| Independent Scene stability | PASS | Environment/Shell/Playable and reusable sample have startup and interaction tests; Stage A fresh MCP/full validation is recorded in the current work log |
| Validated production entry composition | NOT IMPLEMENTED | No production-candidate composition exists. The recommended path does not add a temporary route inside old Main; final entry becomes active only through the isolated Stage H start-scene commit |
| Phone / input ownership has no conflict | BLOCKED | P has three meanings across production/candidates; `open_phone` is Backspace while Main also polls raw Tab; ESC has multiple owners |
| Time / power connected to Quarterview | NOT IMPLEMENTED | `SurvivalState` exists only under production Main; Playable has no state adapter |
| Save / restore | NOT IMPLEMENTED | No persistence service or schema exists in either current Main or Quarterview. It is a conditional track, not a parity blocker unless separately approved as a release requirement |
| DAY start / end on Quarterview | NOT IMPLEMENTED | Candidate Bed/Result are not wired to production state/result flow |
| Existing Apartment functional parity | BLOCKED | Production and QV seven-object inventories/action IDs differ; keyboard vs click movement also requires an approved parity definition |
| MCP runtime verification of current scenes | PASS | Current Main/DAY1, old Apartment, QV Playable, and sample startup are checked without a production transition |
| User production-screen / control approval | BLOCKED | Required at Stages C, F, and H; this audit makes no screen or entry change |
| Rollback remains available | PASS | Main/start scene and all protected production files remain unchanged |
| Full repository validation | PASS | Current readiness GUT, all startups, metadata inspection, and `validate_concent.sh --full` pass before commit |

Additional known risks are characterization findings, not changes made by this audit: `SurvivalState` currently has a microwave needs branch without a microwave DAY1 device definition; time-period text can report night/dawn while the internal `phase` update remains `day`; and `preview_power_use()` temporarily writes load outside the Outlet topology. Resolve each only in its own approved production task.

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
- Source-side `godot/**/*.uid` and `godot/**/*.import` files are stable project metadata and must be tracked beside their tracked Script/image/audio source. The validator checks before and after import, rejecting untracked or unstaged sidecars, invalid UID syntax, mismatched import source paths, and sidecars whose source is missing or untracked; only generated `godot/.godot/` import outputs remain ignored cache.
- Before parse/startup checks, the validator runs a headless Godot import so a clean clone or CI workspace rebuilds the ignored `.godot` cache without changing tracked sidecar identity.
- Every Godot validation step fails when its log contains `Parse Error` or `Failed to load script`, even if Godot exits with status 0. This closes the engine case where a script reload failure is logged without a failing process exit.
- The separate unit-test parse step is required because GUT 9.5 intentionally disables GDScript warnings while loading test scripts. A warning configured as an error can therefore be skipped by discovery and still let Full GUT pass; `--script <test> --check-only` keeps the project warning policy active and exposes that failure.
- `PhoneScreenCandidate` preloads the imported Phone atlas as one typed `Texture2D`; every `AtlasTexture` region shares that resource, so candidate startup never decodes the source PNG through `Image.load()`.

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
