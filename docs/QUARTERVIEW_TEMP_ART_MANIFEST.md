# Quarterview Temporary Art Manifest

이 문서는 `QuarterviewMain`에서 쓰는 임시 gameplay art의 파일 규칙을 기록한다.
여기 적힌 이미지는 최종 아트가 아니라 조작감, scale, animation 연결을 확인하기 위한 temporary pass다.

## Yui Quarterview Spritesheet v1

| File | Use | Frame Size | Layout | Direction Order | Notes |
| --- | --- | --- | --- | --- | --- |
| `godot/assets/art/quarterview/character/yui/yui_qv_idle_4dir.png` | Yui idle candidate | `128x128` | `4 rows x 4 columns` | `down_left`, `down_right`, `up_left`, `up_right` | Temporary imagegen pass. Transparent PNG. |
| `godot/assets/art/quarterview/character/yui/yui_qv_walk_4dir.png` | Yui walk candidate | `128x128` | `4 rows x 6 columns` | `down_left`, `down_right`, `up_left`, `up_right` | Temporary imagegen pass. Transparent PNG. |

Verification:

- `yui_qv_idle_4dir.png` is `512x512`, has alpha, and contains no visible green chroma-key pixels.
- `yui_qv_walk_4dir.png` is `768x512`, has alpha, and contains no visible green chroma-key pixels.
- The border alpha is `0` for both files, so the background is transparent.

Runtime tuning:

- `QuarterviewPlayer.gd` uses the Yui sheets as optional temporary visuals.
- Current temporary visual scale: `1.8`.
- Current temporary visual offset: `Vector2(0, -56)`.
- Current temporary idle speed: `0.8 fps`.
- Current temporary idle frame limit: `2` frames from each direction row.
- Current temporary walk speed: `6.0 fps`.

## Current Connection

- `QuarterviewPlayer.gd` can load these sheets at runtime.
- The existing placeholder drawing remains as fallback if either PNG is missing or fails to load.
- The player movement, interaction, overlay, HUD, debug, and tuning flows are not production state wiring.
- This pass does not add object atlas, room shell layers, final Yui animation, save data, or production `SurvivalState` connection.

## Import Notes

- The sheets are regular PNG files under `godot/assets/art/quarterview/character/yui/`.
- Godot creates `.png.import` files directly corresponding to these Yui PNG files.
- The corresponding Yui `.png.import` files are part of this temporary art pass.
- Unrelated addon, `.uid`, audio `.import`, or license files remain outside the staging scope.

## Quarterview Phone UI Atlas v1

| File | Use | Canvas | Background | Notes |
| --- | --- | --- | --- | --- |
| `godot/assets/art/ui/atlases/ui_phone_atlas.png` | Temporary Phone screen candidate UI atlas | `1024x1024` | transparent alpha PNG | Temporary imagegen pass. Not final production UI. |

Included region candidates:

- `phone_frame`
- `phone_screen_dark`
- `phone_battery_icon`
- `phone_signal_icon`
- `phone_message_icon`
- `phone_power_icon`
- `phone_tab_status`
- `phone_tab_message`
- `phone_tab_job`
- `phone_low_battery_overlay`

Current atlas status:

- Generated as a temporary imagegen UI sheet.
- The atlas has transparent alpha and is normalized to `1024x1024`.
- Alpha check found transparent corners and no visible green chroma-key pixels.
- `PhoneScreenCandidate.gd` loads this PNG as optional candidate art inside the QuarterviewMain Phone screen overlay.
- Current helper-local region use: `phone_frame`, `phone_screen_dark`, `phone_battery_icon`, `phone_signal_icon`, `phone_message_icon`, and `phone_power_icon`.
- There is no phone atlas region mapping Resource yet.
- There is no production `PhoneUI`, Theme, Control skin, `SurvivalState`, battery, message, or job wiring.

Region candidate table:

| Region | Rect `x,y,w,h` | Current Use | Notes |
| --- | --- | --- | --- |
| `phone_frame` | `46,27,381,657` | Phone screen candidate frame preview | Code-local rect only. |
| `phone_screen_dark` | `453,46,336,622` | Phone screen candidate inner panel preview | Code-local rect only. |
| `phone_battery_icon` | `849,103,139,66` | Phone screen candidate status icon | Code-local rect only. |
| `phone_signal_icon` | `858,226,109,136` | Phone screen candidate status icon | Code-local rect only. |
| `phone_message_icon` | `853,375,117,98` | Phone screen candidate message icon | Code-local rect only. |
| `phone_power_icon` | `848,523,124,126` | Phone screen candidate power icon | Code-local rect only. |
| `phone_tab_status` | not mapped | Future tab skin candidate | Not used yet. |
| `phone_tab_message` | not mapped | Future tab skin candidate | Not used yet. |
| `phone_tab_job` | not mapped | Future tab skin candidate | Not used yet. |
| `phone_low_battery_overlay` | not mapped | Future warning overlay candidate | Not used yet. |

## Quarterview Power Board Candidate Status

- `PowerBoardCandidate.gd` owns the QuarterviewMain-only draggable power-board prototype inside the Power equipment close-up.
- Current candidate modules are loaded from `PowerModuleDefinition` Resources under `godot/resources/rooms/quarterview/power_modules/`.
- Current candidate module Resource files: `small_core.tres` (`1x1`), `laptop_adapter.tres` (`2x1`), `comm_module.tres` (`1x2`), and `odd_efficiency_module.tres` (`L-shape 3 cells`).
- Module placement / inventory / rotation state is tracked in runtime `module_states`; UI node positions are not the source of truth.
- Inventory order is tracked separately in `inventory_order`. Placing a module removes it from inventory order, and returning it appends it to the bottom.
- Inventory is displayed through a `ScrollContainer`, so long module lists should stay clipped and scrollable instead of spilling outside the panel.
- Board visuals show only placed modules based on `grid_anchor` and `rotation_index`.
- Drag preview uses valid / invalid colors while the cursor is over the grid.
- Module inventory blocks, debug guides, and drag preview are drawn from `shape_cells`, so non-rectangular modules can be read before production power rules exist.
- `R` and right-click rotate the active module candidate in 90-degree steps; rotation state is kept per runtime module instance and does not rewrite the `.tres` Resource shape.
- Placed module rotation is allowed only when the rotated shape still fits the grid and does not overlap another module; invalid rotation is cancelled.
- Placement and rotation checks go through a single `can_place_module(...)` path. Placed / dragged modules pass their own key as `ignore_module_key`, so rotation is judged against the board bounds and other placed modules only.
- The detail panel has a `보관함으로` button for selected placed modules. `Delete` / `Backspace` also returns the selected placed module to inventory. The prototype resets rotation to the Resource orientation on return.
- Drag start stores a snapshot of placement, grid anchor, rotation, and inventory order. Invalid drops restore that snapshot before rebuilding the inventory, board, and detail panel.
- Occupied cells block overlapping module placement.
- Invalid or out-of-grid drops return the module to the drag start position.
- Successful drops only write no-op status/log text; they do not calculate power.
- If module Resources fail to load, `PowerBoardCandidate.gd` keeps a local fallback list so the prototype remains usable.
- There is no production `OutletMode`, `SurvivalState`, connected / active device, save-load, or result wiring.

## Quarterview Power ModuleDefinition Resources

| Resource | Shape Cells | Mock Labels | Atlas Region | Notes |
| --- | --- | --- | --- | --- |
| `godot/resources/rooms/quarterview/power_modules/small_core.tres` | `(0,0)` | `전력 안정`, `효율 낮음`, `기본 코어 후보` | `small_core` | 1x1 prototype module. |
| `godot/resources/rooms/quarterview/power_modules/laptop_adapter.tres` | `(0,0)`, `(1,0)` | `노트북 우선 공급`, `발열 약간 증가`, `작업 장비 우선 후보` | `laptop_adapter` | 2x1 prototype module. |
| `godot/resources/rooms/quarterview/power_modules/comm_module.tres` | `(0,0)`, `(0,1)` | `통신 유지`, `과부하 낮음`, `신호 보정 후보` | `comm_module` | 1x2 prototype module. |
| `godot/resources/rooms/quarterview/power_modules/odd_efficiency_module.tres` | `(0,0)`, `(1,0)`, `(0,1)` | `효율 보정`, `발열 관리 필요`, `비정형 배치 보너스 후보` | `odd_efficiency_module` | 3-cell L-shape prototype module. |

Resource script:

- `godot/scripts/resources/PowerModuleDefinition.gd`
- Fields include `key`, `display_name`, `role`, `description`, `shape_cells`, mock labels, `candidate_action`, `atlas_region_name`, `inventory_position`, `color`, and `is_prototype`.
- Helpers derive size from `shape_cells`, normalize / rotate shape cells for the prototype UI, build no-op candidate action names, and format effect/debug labels.
- These Resources are data for the QuarterviewMain candidate Power board only. They do not implement power simulation.

## Quarterview Power Board UI Atlas v1

| File | Use | Canvas | Background | Notes |
| --- | --- | --- | --- | --- |
| `godot/assets/art/ui/atlases/ui_power_board_atlas.png` | Temporary Power equipment close-up visual atlas | `2048x2048` | transparent alpha PNG | Temporary imagegen pass. Not final production UI. |

Included region candidates:

- `board_frame`
- `grid_cell_normal`
- `grid_cell_valid`
- `grid_cell_invalid`
- `small_core`
- `laptop_adapter`
- `comm_module`
- `odd_efficiency_module`
- connector / LED / warning icon candidates

Current atlas status:

- Generated as a temporary imagegen UI sheet.
- The generated source was normalized to a transparent `2048x2048` PNG for Godot use.
- `PowerBoardCandidate.gd` loads this PNG optionally and uses code-local `AtlasTexture` regions for module button icons.
- The current Power board screen uses a simple readable ColorRect grid as the primary play surface, so the board / cell atlas regions are kept as future candidates rather than the default normal view.
- The original visual fallback remains: if the PNG fails to load, the existing ColorRect / Button based drag prototype remains usable.
- Region coordinates below are code-local candidates based on the generated `1254x1254` source layout; the helper scales them to the runtime atlas size.
- There is no power-board mapping Resource yet.
- There is no production `OutletMode`, `SurvivalState`, connected / active device, save-load, or result wiring.

Region candidate table:

| Region | Source Rect `x,y,w,h` | Current Use | Notes |
| --- | --- | --- | --- |
| `board_frame` | `38,40,648,626` | Power board background frame | Code-local rect, scaled to runtime atlas size. |
| `grid_cell_normal` | `714,42,210,210` | Future grid cell visual candidate | Not used in the default readable board view. |
| `grid_cell_valid` | `980,44,220,210` | Future valid drop preview visual | Not used in the default readable board view. |
| `grid_cell_invalid` | `980,290,220,214` | Future invalid drop preview visual | Not used in the default readable board view. |
| `small_core` | `715,318,106,120` | `small_core` module icon | Code-local rect, scaled to runtime atlas size. |
| `laptop_adapter` | `718,548,294,198` | `laptop_adapter` module icon | Code-local rect, scaled to runtime atlas size. |
| `comm_module` | `1080,585,122,290` | `comm_module` module icon | Code-local rect, scaled to runtime atlas size. |
| `odd_efficiency_module` | `882,876,342,330` | `odd_efficiency_module` module icon | Code-local rect, scaled to runtime atlas size. |

## Quarterview Work Devices Atlas v1

| File | Use | Canvas | Background | Notes |
| --- | --- | --- | --- | --- |
| `godot/assets/art/quarterview/atlases/qv_work_devices_atlas.png` | Temporary quarterview work device atlas candidate | `2048x2048` | transparent alpha PNG | Temporary imagegen pass. Not final production art. |

Included region candidates:

- `laptop_off`
- `laptop_on`
- `laptop_active`
- `phone_idle`
- `phone_charging`
- `charger`
- `power_strip_empty`
- `power_strip_active`
- `comm_off`
- `comm_on`
- `node17_off`
- `node17_on`
- `signal_booster_off`
- `signal_booster_on`
- `speaker_off`
- `speaker_on`
- `ups_idle`

Current atlas status:

- Generated as a temporary imagegen atlas / item sheet.
- The atlas has transparent alpha and is normalized to `2048x2048`.
- Alpha component scan found 18 slice candidates. The rects below are candidate bounds, not final production mapping data.
- Visible green check found only 10 `#00ff00` pixels with alpha `1`, treated as negligible matte fringe for now.
- Region preview helper: `docs/reference/qv_work_devices_atlas_regions_preview.png`.
- Godot preview scene: `res://scenes/prototypes/quarterview/WorkDevicesAtlasPreview.tscn`.
- There is no atlas region mapping Resource yet.
- There is no `AtlasTexture`, `SpriteFrames`, Theme, or scene wiring yet.
- Existing QuarterviewRoom objects still use invisible interaction / collision data and current placeholder/background visuals.

Preview scene status:

- `WorkDevicesAtlasPreview.tscn` creates runtime `AtlasTexture` previews from the rects below.
- It is a prototype/debug verification scene only.
- It is not registered in `PrototypeHub` yet.
- It does not change `QuarterviewMain`, room object visuals, collision, pathfinding, interaction, or production UI.

Region candidate table:

| Region | Rect `x,y,w,h` | Use | Notes |
| --- | --- | --- | --- |
| `laptop_off` | `165,40,415,385` | Desk / Laptop off visual candidate | Auto bbox from alpha component. |
| `laptop_on` | `703,40,415,385` | Desk / Laptop on visual candidate | Auto bbox from alpha component. |
| `laptop_active` | `1241,40,415,385` | Desk / Laptop active visual candidate | Auto bbox from alpha component. |
| `phone_idle` | `168,511,267,190` | Phone idle visual candidate | Auto bbox from alpha component. |
| `phone_charging` | `617,511,267,190` | Phone charging visual candidate | Auto bbox from alpha component. |
| `charger` | `1128,514,204,174` | Charger / adapter visual candidate | Auto bbox from alpha component. |
| `cable` | `1557,511,263,205` | Loose cable visual candidate | Auto bbox from alpha component. |
| `power_strip_empty` | `400,770,373,215` | Power strip empty visual candidate | Auto bbox from alpha component. |
| `power_strip_active` | `1077,770,374,215` | Power strip active visual candidate | Auto bbox from alpha component. |
| `comm_off` | `460,1015,313,222` | Communication device off visual candidate | Auto bbox from alpha component. |
| `comm_on` | `1146,1015,314,222` | Communication device on visual candidate | Auto bbox from alpha component. |
| `node17_off` | `442,1270,264,199` | NODE-17 off visual candidate | Auto bbox from alpha component. |
| `node17_on` | `1125,1270,264,199` | NODE-17 on visual candidate | Auto bbox from alpha component. |
| `signal_booster_off` | `432,1472,243,219` | Signal booster off visual candidate | Auto bbox from alpha component. |
| `signal_booster_on` | `1140,1472,244,219` | Signal booster on visual candidate | Auto bbox from alpha component. |
| `speaker_off` | `294,1708,182,280` | Speaker / audio analyzer off visual candidate | Auto bbox from alpha component. |
| `speaker_on` | `770,1708,181,280` | Speaker / audio analyzer on visual candidate | Auto bbox from alpha component. |
| `ups_idle` | `1259,1709,283,292` | UPS / backup power visual candidate | Auto bbox from alpha component. |
