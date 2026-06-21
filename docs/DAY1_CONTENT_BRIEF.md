# DAY 1 Content Brief

## DAY 1 Purpose

DAY 1 is the tutorial and core loop proof. It should teach the player that power is limited, connected devices can be switched on or off, active time consumes power, and the day ends with a simple summary.

Do not overload DAY 1 with many events. The goal is a playable power-choice loop, not full story delivery.

## Player Situation

Yui is alone in a small apartment during a power shortage. The room is dark, old electronics still work inconsistently, and the player must decide which devices deserve limited power.

The first day should feel quiet and practical: learn the room, test devices, notice the power limit, and understand that comfort, information, and survival compete with each other.

## Starting Power Assumption

- Temporary starting power: `10 units`
- 임시 장치 소비량은 게임 시간 1시간 기준이다. 현재 `60`초 DAY는 `08:00`부터 다음 날 `02:00`까지 18시간을 나타내며, 실제 DAY 길이는 기존 설정값을 사용한다.
- The exact values are placeholders for MVP testing and balance.

## Power And Outlet Meaning

DAY 1 uses two linked values:

- `오늘 남은 전력` is the action budget for the day. It starts at `10 / 10` and decreases over time only while one or more devices are active.
- `현재 부하` is the watt total of devices currently connected to the power strip. It starts at `0W / 3000W` and changes when devices are plugged in or unplugged.
- `콘센트` tracks occupied outlet slots. The current MVP uses `0 / 4`.
- Connecting a device enables later activation, but it does not spend today's power.
- A connected device can be switched on and off repeatedly while power remains. Disconnecting it forces its active state off.
- `used` flags are historical records set on first activation; they do not block later on/off control.
- Wire overlays continue to follow connection state, not active state.

## Current Outlet Decisions

- Laptop uses `2` adjacent outlet slots. This is intentional so DAY 1 includes meaningful space pressure.
- Communication Device uses `1` outlet slot. Laptop already supplies the main two-slot constraint, so a second two-slot information device would make the tutorial unnecessarily restrictive.
- Light requires a design decision. Current code implements a connected `1`-slot Lamp/Light, but the current room art and narrative description read as a built-in fluorescent ceiling light.
- The active multitap UI uses draggable adapter PNGs, not device-selection cards.
- `SurvivalState.gd` is the source of truth for slot occupancy, connected devices, outlet load, and daily power state.
- 장치별 부하, 슬롯, 시간당 소비량, Result 플래그는 `godot/resources/devices/*.tres`에서 관리한다.
- Only connected devices show their matching map wire overlays.
- Laptop cannot start from slot 4 because it needs two adjacent slots.

## Initial Interactable Objects

### Light

- Gameplay purpose: teaches that power can improve room safety/readability.
- Active drain: `0.5 unit / game hour`
- Current implementation: `60W`, `1` outlet slot, connection required.
- Decision required:
  - Built-in fluorescent/ceiling light: use `0` outlet slots, do not require multitap connection, and spend only DAY power.
  - Plug-in Lamp: rename to `스탠드 조명` or `작업등`, retain `1` outlet slot and connection requirement.
- Sample feedback/dialogue direction: "The room softens under the weak light. It will not last forever."
- Possible result flag: `used_light`

### Laptop

- Gameplay purpose: introduces information gathering and the Grid mystery.
- Active drain: `3.0 units / game hour`
- Current load data: `1300W`, `2` adjacent outlet slots
- Slot rationale: the large adapter creates the primary space constraint in the DAY 1 multitap puzzle.
- Sample feedback/dialogue direction: "Old logs flicker on the screen. Some entries mention Grid."
- Possible result flag: `checked_laptop`

### Fan

- Gameplay purpose: introduces comfort/survival tradeoff.
- Active drain: `1.0 unit / game hour`
- Suggested load data: `900W`, `1` outlet slot
- Sample feedback/dialogue direction: "The fan turns slowly. The air moves, but the meter drops."
- Possible result flag: `used_fan`

### Charger

- Gameplay purpose: introduces practical survival maintenance.
- Active drain: `1.0 unit / game hour`
- Suggested load data: `20W`, `1` outlet slot
- Sample feedback/dialogue direction: "The phone battery crawls upward. It feels like buying time."
- Possible result flag: `charged_device`

### Communication Device

- Gameplay purpose: introduces outside contact and the management office / delivery robot thread.
- Active drain: `2.0 units / game hour`
- Current load data: `300W`, `1` outlet slot
- Slot rationale: keeping this device at one slot avoids excessive early restriction while Laptop already occupies two slots.
- Sample feedback/dialogue direction: "A broken signal cuts through. Someone is still broadcasting notices."
- Possible result flag: `sent_or_received_signal`

## Day End Condition

- MVP option: the day ends when the player chooses `End Day`.
- Current implementation direction: use a bed/rest point in the room as the explicit `End Day` interactable.
- The bed/rest point should use the same top-down proximity + `E` confirmation model as power objects.
- Optional later condition: the day can also end when power reaches `0` or all core interactions are resolved.
- The first implementation should prefer an explicit `End Day` action for clarity.
- `02:00`에 도달하면 시간이 멈추고 오른쪽 확인 패널 없이 유이의 `피곤하니 슬슬 자야겠다.` 대사와 `[E] 계속` 힌트만 표시된다. `E` 입력 후 기존 Result 흐름으로 이동한다.
- 수면 버프, 커피, 피로도 확장은 현재 구현 범위가 아니다.

## Result Summary Direction

The summary should be short and readable:

- Remaining power
- Objects used
- Current outlet load and slot use
- Any important flags
- One line of narrative consequence
- Prompt to continue or return to the room

## Out Of Scope

- DAY 2+ content
- Delivery robot gameplay beyond a hint or signal reference
- Management office quest chain
- Grid revelation
- Save/load
- Multiple endings
- Complex relationship system
- Full visual polish
- Web prototype changes
