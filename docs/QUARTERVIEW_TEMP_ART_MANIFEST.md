# Quarterview Temporary Art Manifest

이 문서는 `QuarterviewMain`에서 쓰는 임시 gameplay art의 파일 규칙을 기록한다.
여기 적힌 이미지는 최종 아트가 아니라 조작감, scale, animation 연결을 확인하기 위한 temporary pass다.

## Yui Quarterview Spritesheet v1

| File | Use | Frame Size | Layout | Direction Order | Notes |
| --- | --- | --- | --- | --- | --- |
| `godot/assets/art/quarterview/character/yui/yui_qv_idle_4dir.png` | Yui idle candidate | `128x128` | `4 rows x 4 columns` | `down_left`, `down_right`, `up_left`, `up_right` | Temporary imagegen pass. Transparent PNG. |
| `godot/assets/art/quarterview/character/yui/yui_qv_walk_4dir.png` | Yui walk candidate | `128x128` | `4 rows x 6 columns` | `down_left`, `down_right`, `up_left`, `up_right` | Temporary imagegen pass. Transparent PNG. |

## Current Connection

- `QuarterviewPlayer.gd` can load these sheets at runtime.
- The existing placeholder drawing remains as fallback if either PNG is missing or fails to load.
- The player movement, interaction, overlay, HUD, debug, and tuning flows are not production state wiring.
- This pass does not add object atlas, room shell layers, final Yui animation, save data, or production `SurvivalState` connection.

## Import Notes

- The sheets are regular PNG files under `godot/assets/art/quarterview/character/yui/`.
- Godot may create related `.import` files after project parse.
- Only import files directly corresponding to these Yui PNG files are candidates for staging with this temporary art pass.
- Unrelated addon, `.uid`, audio `.import`, or license files remain outside the staging scope.
