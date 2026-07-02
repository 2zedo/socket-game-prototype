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
- There is no atlas region mapping Resource yet.
- There is no `AtlasTexture`, `SpriteFrames`, Theme, or scene wiring yet.
- Existing QuarterviewRoom objects still use invisible interaction / collision data and current placeholder/background visuals.
