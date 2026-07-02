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
- `QuarterviewMain` can load this PNG as an optional candidate preview inside the Phone screen overlay.
- There is no phone atlas region mapping Resource yet.
- There is no production `PhoneUI`, Theme, Control skin, `SurvivalState`, battery, message, or job wiring.

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
