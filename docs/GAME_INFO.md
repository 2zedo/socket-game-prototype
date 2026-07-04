# CONCENT Game Info

## 1. Purpose

이 문서는 `CONCENT / 전력 부족의 시대`의 현재 게임 정보 입구다.

새 세션, 새 작업자, Codex는 `AGENTS.md` 다음으로 이 문서를 읽는다. 세부 기준은 `docs/reference/`의 current reference 문서를 따른다. reference 문서가 바뀌면 이 문서의 요약도 같이 갱신한다.

## 2. One-Line Definition

`CONCENT / 전력 부족의 시대`는 작은 하층 주거 공간에서 제한된 전력과 장비를 관리하며, 해킹과 정보 탈취를 통해 바깥 세계의 진실에 접근하는 2D 내러티브 생존 어드벤처다.

## 3. Current Product Direction

- Main interaction is mouse-click first: object click -> Yui moves -> candidate panel / overlay.
- Existing `Main.tscn` / DAY1 top-view flow remains the protected golden path.
- `QuarterviewMain.tscn` is the current production candidate scene, but it is not the project start scene.
- Quarterview systems remain candidate / prototype until explicit Main replacement approval.
- Phone is portable equipment opened with `P`, not a fixed room object.
- Desk / Laptop is the job and hacking-entry hub.
- Power equipment is moving toward a modular power-board / power-tetris system.
- Hacking direction is action infiltration + defense, not a puzzle-only mode.
- Current room image direction is fixed `1920x1080` quarterview, slightly pulled-back camera, readable Yui scale, indoor wall finishes, varied warm/cool palette, logical two-room door connection, and Act 1 play-loop cues: power rationing, portable Phone / DM life, PIP-03 support spots, anonymous job traces, and NAVI LINK-centered work / power function.
- Current mock HUD / overlays in QuarterviewMain are local candidate state, not production `SurvivalState`.

## 4. Current Implementation Snapshot

| Area | Status | Notes |
| --- | --- | --- |
| Current Main / DAY1 | implemented / protected | `Main.tscn`, `Main.gd`, `Apartment.gd`, `SurvivalState.gd`, production Phone / Outlet / Result flow. |
| QuarterviewMain | production candidate | Temporary room background, click movement, hover affordance, candidate panel, portable Phone, Desk, Power, Bed, Food / Kitchen, Door, Day Result, Hacking Entry candidate overlays. |
| QuarterviewRoom | candidate room scene | `RoomObjectDefinition` data, invisible click / approach / collision data, hover prompt, debug / tuning helpers. |
| Phone candidate | sandbox/candidate | `P` opens `PhoneScreenCandidate`; job tab can accept `maintenance_17_fragment`; no production PhoneUI / battery wiring. |
| Power board candidate | sandbox/candidate | Resource-backed modules, drag / snap / rotate / return UX; no OutletMode / SurvivalState power calculation. |
| Hacking Entry candidate | sandbox/candidate | NAVI proxy prep overlay from active job; no Hacking scene transition, Grid Credit, save-load, story flag. |
| HackingActionPrototype | prototype-only | Action/state feedback prototype; not connected to Laptop / Job / Result. |
| Grid Credit | skeleton | `GridCreditState` exists, but reward/economy is not production-wired. |
| Art / asset direction | reference-driven | Current room image spec lives in `docs/reference/ART_DIRECTION.md`; temporary generated PNGs exist, but most atlas mapping plans are historical/reference only. |

## 5. Source Documents

Read only the relevant reference docs after this file:

| Need | Current Reference |
| --- | --- |
| World / setting | `docs/reference/WORLD.md` |
| Story / acts / first job | `docs/reference/STORY.md` |
| Yui / NAVI / characters | `docs/reference/CHARACTERS.md` |
| Gameplay rules | `docs/reference/GAME_RULES.md` |
| Room objects / keys / file paths | `docs/reference/ROOM_OBJECTS.md` |
| Art / image / atlas direction | `docs/reference/ART_DIRECTION.md` |
| Scene / script / resource / test map | `docs/reference/TECHNICAL_MAP.md` |

`docs/old/` is historical archive. Do not use it as current source of truth unless a task explicitly asks to recover old details.

## 6. Protected Production Boundary

Do not modify these by default:

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

Production state ownership:

- `SurvivalState.gd` owns production day / time / power / connected / active / phone / result state.
- Room scenes request interactions and display visuals. They do not own production power drain or result flow.
- Candidate overlays may update local mock state only.

## 7. Main Replacement Gate

Main replacement is forbidden until:

- Current Main / DAY1 manual check passes.
- QuarterviewMain manual check passes.
- `docs/reference/TECHNICAL_MAP.md` validation commands pass or failures are documented.
- Main replacement risk/work plan is explicitly approved by the user.
- `project.godot` start scene change is handled as a final isolated step.

## 8. Documentation Rules

Root `docs/` is intentionally small:

- `GAME_INFO.md`
- `PROJECT_STATUS.md`
- `PROJECT_WORK_LOG.md`

Reference docs live in `docs/reference/`.

When changing game direction:

1. Update the relevant `docs/reference/*.md`.
2. Update this `GAME_INFO.md` summary if the top-level truth changed.
3. Update `PROJECT_STATUS.md` and `PROJECT_WORK_LOG.md` only for current progress / completion notes.

When `PROJECT_STATUS.md` or `PROJECT_WORK_LOG.md` grows past about 200 lines, rotate it to `docs/old/<NAME>_<YYYYMMDD>_<NN>.md` and recreate a short active file.

## 9. Current Next Work Candidates

- GUI playtest QuarterviewMain after latest overlays and power-board drag fixes.
- Use `docs/reference/ART_DIRECTION.md` as the stable room image prompt and review baseline.
- Continue QuarterviewMain MVP candidate work without production-wiring PhoneUI, OutletMode, DayResultPanel, SurvivalState, Hacking, Grid Credit, save-load, or story flags.
