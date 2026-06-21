# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Branch: `main`
- Current commit at task start: `4b503cd`
- Phase: QuarterviewRoomPrototype 레이어 구조 정리와 이식 준비
- Main target: Godot project under `godot/`
- Web prototype: reference only

## Current State

- DAY 1 separates outlet connection from device active state; connected devices can be switched on/off and only active time drains the daily budget.
- Yui uses a processed four-direction walk sheet based on `docs/reference/yui-1.png`.
- The apartment uses `map_base_no_wires.png` as its visible base map.
- The multitap screen uses draggable adapter PNGs rather than card-based device selection.
- `SurvivalState.gd` is the source of truth for slot occupancy, connected devices, outlet load, and daily power state.
- DAY 1 장치의 이름, 부하, 슬롯, 시간당 소비량, Result 플래그는 `godot/resources/devices/*.tres`가 소유한다.
- Connected devices reveal their matching map wire overlays; disconnected devices keep those overlays hidden.
- Laptop occupies two adjacent slots and cannot start from slot 4.
- Communication Device currently occupies one slot.
- Pressing `P` toggles a developer Test Mode with gameplay-state text and collision/interaction overlays.
- 테스트 모드에서 `F1` 도움말과 시간·휴대폰 배터리·오늘 전력 조정 키를 사용할 수 있으며, 상태 조정은 탐색 중에만 허용된다.
- Test Mode 2차 조작은 작동 장치 전체 끄기, 모든 연결 해제, `01:50` 이동, 배터리 경고 직전값, 전력 `0.5`, 현재 상태 출력을 제공한다.
- Modal input is routed through `Main.gd`; movement is locked while interaction, outlet, end-day, phone, or result UI is active.
- `Tab` opens the existing Phone UI during exploration; it closes with `Tab` or `ESC` and locks Yui movement while visible.
- Phone UI 시간은 기존 DAY 길이를 유지하면서 `08:00`부터 다음 날 `02:00`까지 표시되며, 일반 HUD에는 시간 정보를 표시하지 않는다.
- `02:00` 도달 시 시간과 전력 소비가 멈추고 오른쪽 확인 패널 없이 유이 대사와 `[E] 계속` 힌트만 표시된다.
- Apartment outer-wall collision now follows the walkable floor inside the map art, with overlapping corners to prevent diagonal escape gaps.
- Exploration hides the left status HUD; Phone UI is the primary status view while prompts, controls, and Test Mode remain visible.
- The in-game clock advances only during free exploration and pauses for Phone, Outlet, Interaction, End Day, and Result modals.
- Room objects can be activated by left-clicking their existing interaction rectangle while Yui is within the same proximity range used by `E`; room clicks are ignored while a modal is open.
- Interaction panels expose clickable use and cancel/close buttons that reuse the existing `E` and `ESC` action paths.
- Interaction buttons brighten their border on hover/press; informational panels without a primary action close with either `E`, `ESC`, or the close button.
- Informational interaction panels label their shared close action as `[E / ESC] 닫기`.
- Outlet dragging highlights only the targeted existing slot hitbox: green for a valid drop and red for an invalid drop, with two-slot adapters spanning both affected slots.
- Normal outlet presentation hides slot borders and exposes the PNG's built-in green LED only for occupied slots; empty-slot LEDs are darkened while drag-time feedback remains separate.
- Connected adapters no longer retain a selection-like border after placement; borders remain limited to active drag feedback and Test Mode diagnostics.
- Outlet preview and drop now resolve the same target slot, preventing valid two-slot Laptop feedback from disagreeing with placement.
- Connected adapter placement exposes per-device offset and scale tuning while retaining the previous zero-offset/unit-scale defaults.
- Phone battery warnings appear whenever battery crosses `20%`, `10%`, `5%`, or `0%` downward; charging above a threshold naturally rearms it, while active charging suppresses warnings.
- At `0%`, Phone UI remains accessible but hides status details until charging restores the battery.
- Active drain uses per-game-hour tuning: Light `0.5`, Laptop `3.0`, Fan `1.0`, Charger `1.0`, and Communication Device `2.0` units per game hour.
- 현재 `60`초 DAY는 `08:00`부터 다음 날 `02:00`까지 18시간으로 변환되며, 최초 작동 기록은 이후 켜기/끄기를 막지 않는다.
- Disconnecting a device clears its active state, while map wire overlays continue to follow connection state.
- Phone UI is a current-status view only: time, period, battery, remaining power, hourly drain, and active devices. Historical use remains exclusive to Result.
- 결과 화면은 기존 계산 데이터를 유지하면서 `DAY n 생존 기록`, 한국어 하루 요약, 장치·정보·상태 자연문을 표시한다.
- 쿼터뷰 방 전환은 기존 Main을 대체하지 않고 `res://scenes/prototypes/QuarterviewRoomPrototype.tscn` 독립 prototype에서 먼저 검증한다.
- 쿼터뷰 prototype placeholder는 `key`, `zone`, `role`, `blocks`, `interactable` 중심으로 정리하고, 기존 Apartment 기능 대응은 `docs/QUARTERVIEW_APARTMENT_MAPPING.md`에서 추적한다.
- 쿼터뷰 prototype은 `World/FloorLayer`, `WallBackLayer`, `FurnitureBackLayer`, `ObjectLayer`, `PlayerLayer`, `FurnitureFrontLayer`, `InteractionDebugLayer`, `LabelLayer` 구조로 Main 이식 전 레이어 책임을 확인한다.
- 쿼터뷰 아트는 `docs/QUARTERVIEW_ART_ASSET_PLAN.md`에서 room layer, atlas, Yui spritesheet, visual mapping Resource 후보 기준으로 계획한다.
- 채택된 쿼터뷰 방 콘티는 최종 아트가 아니라 `docs/QUARTERVIEW_ROOM_DIRECTION.md`의 layout mood reference로 고정한다.

## Current DAY 1 Decisions

- Laptop: keep at `2` outlet slots to create meaningful space pressure.
- Communication Device: keep at `1` outlet slot so DAY 1 does not become overly restrictive.
- Light: decision required. Current code treats it as a connected `1`-slot Lamp/Light, while the narrative art still reads as a built-in fluorescent ceiling light.
- Until the Light decision is resolved, current documents must distinguish implemented behavior from intended design.

## Changed Files

- `godot/project.godot`: added Test Mode, reserved phone, and shared cancel input actions.
- `godot/scripts/Main.gd`: centralized Test Mode and modal input routing.
- `godot/scripts/Apartment.gd`: added collision, interaction, nearest-object, and wire-anchor overlays.
- `godot/scripts/ui/OutletMode.gd`: added slot/adapter debug overlays and delegated ESC handling to `Main.gd`.
- `godot/scripts/ui/SurvivalHUD.gd`, `godot/scenes/ui/SurvivalHUD.tscn`: added the Test Mode status/readout.
- `godot/scenes/ui/PhoneUI.tscn`: updated the reserved phone key hint to `Tab`.
- `godot/scripts/Main.gd`: routes `open_phone` plus a raw `KEY_TAB` edge through the existing Phone UI toggle and logs each received toggle.
- `godot/scripts/SurvivalState.gd`: provides the Phone UI clock text and daytime period while the HUD omits those details.
- `godot/scripts/Apartment.gd`: aligns only the four outer wall blockers to the interior floor boundary.
- `godot/scenes/ui/SurvivalHUD.tscn`, `godot/scripts/ui/SurvivalHUD.gd`: hide exploration status panels and their power icon.
- `godot/scripts/Main.gd`, `godot/scripts/SurvivalState.gd`: pause only the display clock while modal UI is active.
- `godot/scripts/Main.gd`: routes eligible left-clicks through the existing nearest-interactable request used by `E`.
- `godot/scenes/ui/InteractionPanel.tscn`, `godot/scripts/ui/InteractionPanel.gd`, `godot/scripts/Main.gd`: connect real panel buttons to the existing confirm and cancel handlers.
- `godot/scripts/ui/InteractionPanel.gd`: adds distinct hover/pressed feedback while preserving existing button actions.
- `godot/scripts/ui/InteractionPanel.gd`: aligns the no-primary-action hint with its existing `E` and `ESC` close behavior.
- `godot/scripts/ui/OutletMode.gd`: draws valid/invalid drag feedback above the power-strip art without changing slot coordinates or connection rules.
- `godot/scripts/ui/OutletMode.gd`: maps occupancy onto the existing LED artwork in `powerstrip_4slot.png` without adding new LED shapes.
- `godot/scripts/ui/OutletMode.gd`: removes the normal connected-adapter outline while preserving drag feedback.
- `godot/scripts/ui/OutletMode.gd`: shares one target-slot resolver between drag preview and actual drop.
- `godot/scripts/ui/OutletMode.gd`: centralizes connected visual offset/scale tuning for Fan, Charger, Communication Device, Lamp, and Laptop.
- `godot/scripts/SurvivalState.gd`, `godot/scripts/Main.gd`: detect repeatable downward battery-threshold crossings and route warning messages to the HUD.
- `godot/scripts/ui/SurvivalHUD.gd`, `godot/scenes/ui/SurvivalHUD.tscn`: show short battery warnings above the screen center.
- `godot/scripts/SurvivalState.gd`: defines hourly device drain, converts elapsed real time to game hours, and exposes decimal remaining power plus current active drain.
- `godot/scripts/Main.gd`: shows hourly drain and decimal remaining power in interaction and Test Mode readouts.
- `godot/scripts/SurvivalState.gd`: removes first-use history and unrelated daily summary fields from Phone text while preserving Result data.
- `godot/scripts/SurvivalState.gd`, `godot/scripts/Main.gd`: `08:00 → 02:00` 시간 매핑과 자동 하루 마침 확인 흐름을 연결한다.
- `godot/scripts/Main.gd`, `godot/scripts/ui/InteractionPanel.gd`, `godot/scenes/ui/InteractionPanel.tscn`: 자동 한계 종료를 대사-only 모달과 `E` 진행으로 분리한다.
- `godot/scripts/Main.gd`, `godot/scripts/SurvivalState.gd`, `godot/scripts/ui/SurvivalHUD.gd`, `godot/scenes/ui/SurvivalHUD.tscn`: 테스트 모드 전용 조작과 한국어 도움말을 추가한다.
- `godot/scripts/Main.gd`, `godot/scripts/SurvivalState.gd`, `godot/scripts/ui/SurvivalHUD.gd`, `godot/scenes/ui/SurvivalHUD.tscn`: Test Mode 2차 키 라우팅, 상태 세팅 함수, 상태 출력, 기본 `F1` 안내와 도움말 전환을 추가한다.
- `docs/GODOT_PLAYTEST_CHECKLIST.md`, `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`: Test Mode 2차 수동 확인 항목과 표시 정책을 기록한다.
- `docs/GODOT_PLAYTEST_CHECKLIST.md`, `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`: documented the diagnostic workflow.
- `godot/scripts/resources/DeviceDefinition.gd`, `godot/resources/devices/*.tres`: 다섯 DAY 1 장치의 공통 데이터 구조와 기존 MVP 값을 정의한다.
- `godot/scripts/SurvivalState.gd`, `godot/scripts/ui/OutletMode.gd`: Resource 기반 장치 조회를 슬롯, 부하, 소비율, 표시명, Result 플래그에 연결한다.
- `docs/GODOT_DAY1_MVP_PLAN.md`, `docs/DAY1_CONTENT_BRIEF.md`, `docs/ASSET_PIPELINE.md`: 장치 데이터의 현재 Resource 경로와 유지된 값을 기록한다.
- `godot/scripts/ui/DayResultPanel.gd`, `godot/scenes/ui/DayResultPanel.tscn`: 기존 결과 데이터를 생존 기록 문장과 `[E] 계속` 안내로 재구성한다.
- `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`, `docs/GODOT_PLAYTEST_CHECKLIST.md`: Result 표현 정책과 수동 확인 항목을 기록한다.
- `godot/scenes/prototypes/QuarterviewRoomPrototype.tscn`, `godot/scripts/prototypes/QuarterviewRoomPrototype.gd`, `godot/scripts/prototypes/QuarterviewPrototypePlayer.gd`: 쿼터뷰 구도와 이동 / 충돌 / 가림 / 상호작용 포인트 확인용 독립 prototype을 추가한다.
- `docs/QUARTERVIEW_MIGRATION_PLAN.md`: prototype scene 경로와 본 전환 전 유지할 범위를 기록한다.
- `godot/scripts/prototypes/QuarterviewRoomPrototype.gd`: prototype placeholder를 `key`, `zone`, `role`, `blocks`, `interactable` 중심의 `PLACEHOLDERS` 구조로 정리한다.
- `docs/QUARTERVIEW_APARTMENT_MAPPING.md`: 기존 탑뷰 Apartment 기능과 쿼터뷰 placeholder의 대응표를 기록한다.
- `docs/QUARTERVIEW_MIGRATION_PLAN.md`: 쿼터뷰 대응표 문서 위치를 구조 검토 항목에 연결한다.
- `docs/QUARTERVIEW_ART_ASSET_PLAN.md`: 쿼터뷰 전환용 P0-P3 아트 우선순위와 atlas / spritesheet 원칙을 기록한다.
- `docs/ASSET_PIPELINE.md`: 쿼터뷰 아트 계획 문서를 에셋 교체 기준에 짧게 연결한다.
- `docs/QUARTERVIEW_ROOM_DIRECTION.md`: 채택 콘티 기준, 공간 배치, 피해야 할 디자인, 스피커 / 현관 / 욕실 기준을 기록한다.
- `godot/scenes/prototypes/QuarterviewRoomPrototype.tscn`, `godot/scripts/prototypes/QuarterviewRoomPrototype.gd`: 독립 쿼터뷰 prototype의 레이어 노드 구조와 placeholder `layer/zone/role` 정의를 정리한다.
- `docs/QUARTERVIEW_MIGRATION_PLAN.md`: 쿼터뷰 prototype의 레이어 검증 기준을 본 전환 전 확인 항목에 추가한다.

## Validation Results

- Local `main` was aligned with `origin/main` at task start.
- Godot 4.5.1 headless import and Main scene run completed without script or runtime errors.
- Automated scene checks passed for Test Mode toggle, modal labels, movement locking, outlet/end-day ESC cancellation, and result-screen ESC consumption.
- A rendered Test Mode capture confirmed that debug text and colored overlays are visible at `1280x720`.
- `git diff --check` passed. Web files were not modified.
- Godot 4.5.1 headless editor initialization completed after adding mouse interaction routing.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after converting interaction controls to clickable buttons.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after adding interaction-button hover feedback.
- Godot 4.5.1 headless Main scene startup completed after updating the interaction close hint.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after the outlet drag-feedback change.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after replacing normal slot borders with LEDs.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after mapping occupancy to the PNG's built-in LEDs.
- Godot 4.5.1 headless Main scene startup completed after removing connected-adapter borders.
- Godot 4.5.1 headless Main scene startup completed after unifying outlet preview/drop target selection.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after exposing connected-adapter tuning values.
- Godot 4.5.1 headless Main scene startup completed after adding Phone battery warnings and the empty-battery view.
- Godot 4.5.1 headless Main scene startup completed after separating connected and active power states.
- Godot 4.5.1 headless Main scene startup completed after converting active drain to per-game-hour units.
- Godot 4.5.1 headless Main scene startup completed after changing Phone battery warnings to repeatable downward crossings.
- DAY 시간 확장과 자동 하루 마침 확인 연결 후 Godot 4.5.1 headless Main scene 시작을 확인했다.
- 자동 하루 종료 대사-only 흐름 분리 후 Godot 4.5.1 headless Main scene 시작을 확인했다.
- 테스트 모드 조작과 한국어 도움말 추가 후 Godot 4.5.1 headless Main scene 시작을 확인했다.
- Test Mode 2차 확장 후 `git diff --check`, Godot 4.5.1 headless 편집기 초기화, Main scene 시작이 완료됐다.
- 쿼터뷰 방 prototype scene 추가 후 `git diff --check`와 Godot 4.5.1 headless scene startup이 완료됐다.
- 쿼터뷰 prototype 구조 정리 후 `git diff --check`와 Godot 4.5.1 headless scene startup이 완료됐다.
- 장치 Resource화 후 Godot 4.5.1 headless import와 Main scene 시작이 완료됐다.
- 결과 화면 1차 개선 후 `git diff --check`, Godot 4.5.1 headless import와 Main scene 시작이 완료됐다.
- 쿼터뷰 아트 에셋 계획 문서화 후 `git diff --check`가 완료됐다. Godot 실행은 문서 작업이라 생략했다.
- 채택된 쿼터뷰 방 콘티 기준 문서화 후 `git diff --check`가 완료됐다. Godot 실행은 문서 작업이라 생략했다.
- 쿼터뷰 prototype 레이어 정리 후 `git diff --check`와 Godot 4.5.1 headless scene startup이 완료됐다.
- Pre-existing untracked source-side `.png.import` files remain unrelated and unstaged.
- Phone input requires user manual verification because GUI key simulation was intentionally not run.

## Current Risks Or Known Issues

- The Light model is unresolved: built-in fluorescent circuit versus plug-in Lamp.
- Reported wall/object pass-through and diagonal collision behavior is now observable but has not been redesigned or fixed in this pass.
- Dynamic adapter drag/drop, outlet hitboxes, and wire visibility still require hands-on mouse testing in Godot.
- Laptop desk-wire and several device endpoints may need small visual anchor adjustments.
- Interaction and blocker overlays require manual alignment review against the map image before collision changes are made.
- Mouse interaction requires manual checks for all six room targets and out-of-range clicks; no GUI input simulation was run.
- Interaction-panel button clicks require manual confirmation; GUI input simulation was intentionally not run.
- Interaction-button hover colors require manual visual confirmation; no GUI or screenshot validation was run.
- Outlet valid/invalid colors and two-slot span feedback require manual drag confirmation; connection logic was not changed.
- Outlet LED off/on states, including two-slot Laptop occupancy, require manual visual confirmation.
- Built-in LED mask alignment and two-slot LED exposure require manual visual confirmation at the target resolution.
- Two-slot Laptop drops require manual checks at valid starts 1-3 and invalid start 4.
- 장치 Resource 값과 Outlet 연결 결과가 같은지 GUI 수동 확인이 필요하며, adapter 시각 튜닝은 계속 `OutletMode.gd`에 남는다.
- `02:00` 대사-only 표시, `[E] 계속`, `ESC` 무시, Result 전환은 수동 GUI 확인이 필요하다.
- 테스트 모드 도움말 토글과 시간·배터리·전력 조정 키는 수동 GUI 확인이 필요하다.
- Test Mode 2차의 `O`/`U`/`F8`/숫자 세팅/`L` 출력과 모달 차단은 수동 입력 확인이 필요하다.
- Continuous drain rate, modal pause, repeated on/off control, disconnect shutdown, and zero-power shutdown require manual gameplay confirmation.
- Hourly drain totals and one-decimal Phone display require manual timing confirmation, especially Laptop-only and Laptop-plus-Fan cases.
- Phone current-status-only content and unchanged Result history require manual GUI confirmation.
- 결과 화면의 한국어 줄바꿈, 빈 사용 기록, 수동 종료와 `02:00` 자동 종료 진입은 GUI 수동 확인이 필요하다.
- 전용 정전 일지/생존 기록 이미지 스킨은 아직 적용하지 않았다.

## Next Recommended Task

1. 채택 콘티 기준을 `QuarterviewRoomPrototype.tscn`의 placeholder 구역과 비교해 현관 / 침대 / 작업 책상 / 주방 / 전력 구역의 방향이 맞는지 확인한다.
2. `docs/QUARTERVIEW_ART_ASSET_PLAN.md`와 `docs/QUARTERVIEW_ROOM_DIRECTION.md`를 기준으로 P1 room shell과 furniture / devices atlas 제작 순서를 확정한다.
3. Yui 쿼터뷰 spritesheet의 기준 크기, 발밑 pivot, 4방향 idle / walk 요구사항을 별도 문서나 아트 브리프로 정리한다.

## Archive

- Previous accumulated status history: `docs/old/PROJECT_STATUS_20260619.md`
