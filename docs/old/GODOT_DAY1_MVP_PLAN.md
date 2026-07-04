# Godot DAY 1 MVP Plan

> [!NOTE]
> Scope: 이 문서는 현재 top-view Main / DAY1 범위에 대한 문서다.
> 현재 게임 정체성과 최신 디자인 방향은 `docs/CONCENT_PROJECT_IDENTITY.md`를 우선한다.
> 이 문서의 내용이 identity 문서와 충돌하면 identity 문서를 우선한다.

## Purpose

Define the smallest Godot implementation that proves the core `CONCENT / 전력 부족의 시대` loop: limited power, object interaction, feedback, and day completion.

## MVP Success Criteria

- The player can enter the main room scene.
- Current power is visible.
- The player can interact with a small set of room objects.
- Room objects require a matching outlet connection before use.
- Connected devices can be switched on and off.
- Active devices spend power continuously while game time advances.
- Choices are blocked when power is insufficient.
- Each choice gives clear dialogue or event feedback.
- The day can end.
- A simple result summary appears after the day ends.

## Required Systems

- Power state
- Outlet connection/load state
- Power display
- Interactable objects
- Spend/cancel choice
- Disconnected-device message
- Insufficient power message
- Dialogue feedback
- Day end
- Result summary

## DAY 1 Object List

The initial object list should stay small and match `docs/DAY1_CONTENT_BRIEF.md`:

- Light
- Laptop
- Fan
- Charger
- Communication device

## Suggested Temporary Power Costs

These placeholder MVP values are stored in Godot Resources under `godot/resources/devices/`.

- Starting power: `10 units`
- Light: `0.5 unit / game hour`
- Laptop: `3.0 units / game hour`
- Fan: `1.0 unit / game hour`
- Charger: `1.0 unit / game hour`
- Communication device: `2.0 units / game hour`

## Outlet Load Model

`오늘 남은 전력` and `현재 부하` are one connected system, but they mean different things:

- `오늘 남은 전력: 10 / 10` is the DAY 1 action budget. It decreases over elapsed exploration time while connected devices are active.
- `현재 부하: 0W / 3000W` is the sum of devices currently connected to the outlet/power strip. It is not a second power meter.
- `콘센트: 0 / 4` is the number of outlet slots occupied by connected devices.
- Connecting or disconnecting a device does not spend today's power.
- `drain_per_game_hour`가 소비량 기준이다. 현재 `60`초 DAY는 `08:00`부터 다음 날 `02:00`까지 18시간으로 변환된다.
- Connected devices can be switched on and off; only active devices drain the daily budget, and modal-paused time does not drain it.
- First activation records the device in the daily history, but the record does not block later on/off control.

Current DAY 1 device Resource values:

- Light: `60W`, `1` outlet slot, `0.5 / game hour`; built-in fluorescent versus plug-in Lamp is still a design decision
- Laptop: `1300W`, `2` outlet slots, `3.0 / game hour`
- Fan: `900W`, `1` outlet slot, `1.0 / game hour`
- Charger: `20W`, `1` outlet slot, `1.0 / game hour`
- Communication device: `300W`, `1` outlet slot, `2.0 / game hour`

## Minimum Flags / State To Track

- `max_power`
- `current_power`
- `max_load_watts`
- `current_load_watts`
- `max_outlet_slots`
- `used_outlet_slots`
- connected device keys
- active device keys
- `used_light`
- `checked_laptop`
- `used_fan`
- `charged_device`
- `sent_or_received_signal`
- `day_ended`

## Current Implementation Status

- `SurvivalState.gd` owns connected state, active state, continuous DAY 1 power drain, first-use flags, and result-summary data.
- `DeviceDefinition.gd`와 `godot/resources/devices/*.tres`가 장치별 표시명, 부하, 슬롯, 시간당 소비량, Result 플래그를 정의한다.
- `SurvivalState.gd` now treats outlet connection state as the prerequisite for DAY 1 object use.
- `SurvivalState.gd` is the source of truth for outlet slot sizes; Laptop currently occupies `2` slots, while Light/Lamp, Fan, Charger, and Communication device occupy `1` slot each.
- Light/Lamp's current one-slot behavior is implemented but not yet accepted as the final design; resolve built-in fluorescent versus plug-in Lamp before further balancing.
- `OutletMode.gd` is the draggable adapter PNG connection/load panel: it changes current load watts and outlet slots, but it does not spend today's power.
- Connected-device wires are separate overlays whose visibility follows the same connection state in `SurvivalState.gd`.
- `Apartment.gd` now exposes the five DAY 1 interactables: Light, Laptop, Fan, Charger, and Communication device.
- `Player.gd` and `project.godot` already support keyboard top-down movement through WASD and arrow input actions.
- `Apartment.gd` tracks the nearest interactable by player proximity, so `E` only opens interaction UI near an object.
- `Main.gd` routes nearby powered objects through `E: 켜기` / `E: 끄기` confirmation and pauses both time and power drain while a modal is open.
- `InteractionPanel.gd` supports context-specific footer text for use/cancel prompts.
- `SurvivalHUD.tscn` has enough status label space to show current DAY 1 power and use records.
- `Apartment.gd` now includes a bed/rest interactable that opens an explicit `End Day` confirmation through the same proximity `E` model.
- `SurvivalState.gd` exposes `end_current_day()` so the explicit rest interaction can enter the existing result summary flow.
- `02:00` 도달 시 확인/취소 패널 대신 유이 대사와 `[E] 계속` 힌트만 표시되며, `E` 입력으로 동일한 `end_current_day()` 결과 흐름을 사용한다.
- HUD wording now prioritizes `DAY 1`, `오늘 남은 전력`, and used devices instead of debug-like points/time/status bars.
- `SurvivalState.gd`와 `OutletMode.gd`는 동일한 장치 Resource를 조회하며 adapter 이미지 경로와 연결 위치 튜닝은 별도 시각 데이터로 유지한다.

## Suggested Godot Files To Inspect First

- `godot/scenes/Main.tscn`
- `godot/scripts/Main.gd`
- `godot/scripts/SurvivalState.gd`
- `godot/scripts/ui/OutletMode.gd`

Start implementation from these existing files. Before adding new systems, identify what they already handle for room flow, state, and outlet/power behavior.

## Implementation Order

1. Inspect the current Godot scene and script structure.
2. Identify the existing owner of power/state data.
3. Compare current behavior against `docs/DAY1_CONTENT_BRIEF.md`.
4. Define where temporary power costs and object data should live.
5. Wire a readable power display to the existing state.
6. Add outlet connection checks before spend/cancel choices.
7. Add disconnected-device and insufficient-power feedback.
8. Add simple dialogue feedback for successful choices.
9. Add day-end trigger and result summary.
10. Validate the loop in the Godot main scene.

## Out Of Scope For Now

- DAY 2+ content
- Save/load
- Multiple endings
- Complex relationship or NPC systems
- Full Phaser feature parity
- Web prototype changes
