# Grid Credit System

## Purpose

Grid Credit은 THE GRID 하층 생활에서 해킹 의뢰, 정보 노동, 전력 구매, 장비 / 부품, 식량, 수리 비용 등에 쓰일 수 있는 미래 경제 시스템 후보이다.

현재는 실제 Main / DAY1에 연결하지 않고, 독립 skeleton으로만 추가한다.

## World Meaning

- 유이는 하층민이지만 뒷세계 해커 / 정보 노동으로 어느 정도 벌이가 있다.
- Grid Credit은 단순 돈이 아니라 THE GRID 내부의 배급, 거래, 비공식 작업 보상을 표현하는 후보다.
- 정식 Credit인지, 암시장성 token인지, power credit과 통합할지는 아직 결정하지 않는다.
- 현재는 이름을 Grid Credit으로 두고 skeleton만 만든다.

## Current Implementation Scope

- `godot/scripts/systems/GridCreditState.gd`
- `current_credit`
- `earn()`, `spend()`, `adjust()`
- transaction log
- GUT test coverage in `godot/test/unit/test_grid_credit_state.gd`

`GridCreditState` is a `RefCounted` class. It is not an Autoload and is not used by `Main`, `SurvivalState`, `Result`, Laptop UI, or Hacking prototypes yet.

## Not Implemented Yet

- UI display
- Save / load
- `SurvivalState` connection
- `HackingMissionDefinition.reward_grid_credit` payout
- Result reflection
- Shop / purchase system
- Power purchase
- Story flag connection
- Main / DAY1 connection

## Future Connection Candidate

```text
HackingMissionDefinition.reward_grid_credit
-> Hacking mission success
-> GridCreditState.earn()
-> Result / Phone / Laptop UI에 표시
-> Power purchase / device upgrade / food cost 등에 사용
```

This flow is a future candidate only. This pass does not wire it.

Grid Credit gains, spending rows, and reward summaries may later be displayed with `ui_result_log_atlas.png` result / log visuals. This is not wired yet.

## API

| Method | Purpose | Notes |
| --- | --- | --- |
| `reset(starting_credit)` | Reset balance, lifetime counters, and transaction log | Negative starting credit clamps to `0` |
| `earn(amount, reason, source)` | Add credit and record earned lifetime amount | Rejects `0` or negative amounts |
| `can_spend(amount)` | Check whether credit can cover a spend | Requires positive amount |
| `spend(amount, reason, target)` | Subtract credit and record spent lifetime amount | Rejects insufficient credit |
| `adjust(delta, reason, source)` | Debug / admin balance adjustment | Clamps balance at `0`; does not change lifetime earned / spent |
| `get_summary()` | Return current balance and lifetime counters | Includes transaction count |
| `get_transaction_log()` | Return transaction log copy | Uses deep duplicate to avoid external mutation |
| `get_last_transaction()` | Return the most recent transaction copy | Empty dictionary if no log exists |
| `clear_log()` | Clear transaction history only | Keeps current balance and lifetime counters |

## Transaction Log

| Field | Purpose | Example |
| --- | --- | --- |
| `type` | Transaction kind | `earn`, `spend`, `adjust` |
| `amount` | Applied amount | `25`, `-10` |
| `balance_after` | Balance after transaction | `125` |
| `reason` | Why the change happened | `hacking_reward` |
| `source` | Origin of an earn or adjustment | `deleted_log_001` |
| `target` | Target of a spend | `extra_power` |

The log does not use `SurvivalState` time, Main day number, or save data yet.

## Reason Constants

- `hacking_reward`
- `power_purchase`
- `device_repair`
- `food`
- `debug`
- `unknown`

## Current Boundary

Grid Credit is a future economy and reward skeleton. It should stay separate from DAY1 gameplay until a dedicated wiring task connects it to mission success, UI, save data, and Result history.
