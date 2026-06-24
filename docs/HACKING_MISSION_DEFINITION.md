# Hacking Mission Definition

## Purpose

`HackingMissionDefinition`은 노트북에서 선택 가능한 해킹 미션의 key, 표시명, 미션 유형, 목표, 요구 장치, 보상 후보, story flag 후보, 결과 문구를 Resource로 관리하기 위한 데이터 구조다.

현재 `HackingActionPrototype`과 직접 연결하지 않는다. 실제 `Laptop -> mission select -> hacking scene` 진입 흐름은 나중 작업이다.

## Resource Path

```text
godot/scripts/resources/HackingMissionDefinition.gd
```

향후 실제 미션 Resource 후보 경로:

```text
godot/resources/hacking/missions/
```

이번 작업에서는 실제 mission `.tres` 파일이나 폴더를 만들지 않는다.

## Field Reference

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `mission_key` | `String` | stable mission key | `deleted_log_001` |
| `display_name` | `String` | UI display name | `Deleted Log Recovery` |
| `description` | `String` | mission description for laptop list | `Recover a damaged log from a lower-grid cache.` |
| `mission_type` | `String` | broad mission category | `data_extract` |
| `difficulty` | `int` | 1-5 difficulty candidate | `2` |
| `map_scene_path` | `String` | future hacking mission scene path | `res://scenes/hacking/missions/deleted_log_001.tscn` |
| `objective_type` | `String` | main player objective | `extract_data` |
| `required_device_keys` | `Array[String]` | devices required to start the mission | `["laptop", "comm"]` |
| `recommended_device_keys` | `Array[String]` | devices that improve mission conditions | `["signal_booster", "ups"]` |
| `unlock_story_flags` | `Array[String]` | story flags required to unlock the mission | `["node17_seen"]` |
| `success_story_flags` | `Array[String]` | story flags granted on success | `["deleted_log_recovered"]` |
| `failure_story_flags` | `Array[String]` | story flags granted on failure | `["trace_warning_001"]` |
| `reward_grid_credit` | `int` | future Grid Credit reward candidate; later intended for `GridCreditState` after mission success | `25` |
| `reward_power_bonus` | `float` | future power or backup reward candidate | `1.0` |
| `reward_info_keys` | `Array[String]` | info fragment / log reward keys | `["log_yui_001"]` |
| `trace_risk` | `int` | mission trace risk candidate | `20` |
| `time_limit_seconds` | `float` | optional mission time limit; `0` means no limit candidate | `90.0` |
| `success_result_text` | `String` | Result text candidate on success | `Recovered one damaged log.` |
| `failure_result_text` | `String` | Result text candidate on failure | `The trace forced Yui to disconnect.` |

## Mission Type Candidates

- `data_extract`: recover or extract a data node.
- `signal_trace`: trace an external or forbidden signal path.
- `firewall_bypass`: bypass a security layer.
- `surveillance_disable`: disable a monitoring node.
- `archive_restore`: restore a damaged archive.
- `false_signal`: plant or route a decoy signal.

## Objective Type Candidates

- `extract_data`: interact with a target data node.
- `reach_exit`: reach an exit after a condition is met.
- `disable_node`: disable a security or surveillance node.
- `survive_timer`: survive until a timer completes.
- `trace_signal`: follow or resolve a signal path.

## Device Requirement Rules

`required_device_keys` are devices needed to start a mission. `recommended_device_keys` are devices that are not mandatory but can improve conditions, reduce risk, or unlock optional information.

- `speaker` is not decoration. It is an `audio_hacking_device` candidate and can affect voice log, signal tone, alarm sound, or audio-analysis missions.
- `node17` is a `mystery_device` candidate and can connect to outside signals, forbidden logs, and major story missions.
- `signal_booster` can affect signal tracing, trace risk, or optional data-node discovery.
- `ups` can affect power stability or trace-risk mitigation.

## Helper Behavior

- `is_valid_definition()` checks stable identity fields and difficulty range.
- `get_debug_summary()` returns mission key, type, objective, difficulty, and map path.
- `get_difficulty_label()` maps difficulty `1-5` to a short UI/debug label.
- `requires_device(device_key)` checks `required_device_keys`.
- `recommends_device(device_key)` checks `recommended_device_keys`.
- `has_any_required_devices()` reports whether the mission has hard device requirements.
- `get_result_text(success)` returns success or failure text, with a default fallback when the field is empty.

## Current Work vs Next Work

Current work:

- Add `HackingMissionDefinition` Resource class.
- Document fields, constants, and helper behavior.
- Do not create mission `.tres` files.
- Do not connect `HackingActionPrototype`.

Next work candidates:

- Create sample `HackingMissionDefinition` `.tres` missions.
- Build a Laptop mission list prototype.
- Connect Laptop to `HackingActionPrototype`.
- Connect mission result to Result, Story, and Grid Credit systems.
- Add GUT tests for `HackingMissionDefinition`.

`reward_grid_credit` is a future value intended to be applied to `GridCreditState` after mission success. It is not wired yet.

## Room Device Visual Mapping

`HackingMissionDefinition.required_device_keys` and `recommended_device_keys` may later correspond to `RoomObjectDefinition` keys and `qv_work_devices_atlas` region keys.
The visual mapping is not wired yet.

Hacking mission visuals may later trigger `qv_fx_atlas.png` effects based on `mission_type`, Trace risk, required / recommended device keys, or mission state. This is not wired yet.

## Relationship To Existing Prototypes

- `HackingActionPrototype` is the current controls, combat, mission state, objective, exit, and feedback prototype.
- `HackingPerspectiveBlockout` is the visual perspective blockout for the long-term `3/4 top-down cyber action view`.
- `HackingMissionDefinition` is mission data structure preparation.

These three pieces have separate roles. This Resource does not replace the current prototype and does not wire laptop interaction into hacking gameplay.

## Non-Goals

- No `Laptop -> HackingActionPrototype` connection.
- No Grid Credit economy implementation.
- No Result or Story flag wiring.
- No hacking mission scene creation.
- No mission `.tres` creation in this pass.
