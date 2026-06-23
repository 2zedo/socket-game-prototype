# Prototype Hub

## Scene Path

- `res://scenes/prototypes/PrototypeHub.tscn`

## Purpose

`PrototypeHub`는 기존 `Main.tscn` 또는 DAY 1 흐름을 대체하지 않는 독립 테스트 허브다.
prototype scene이 늘어날 때 Godot에서 각 prototype을 빠르게 실행하기 위한 편의 화면으로만 사용한다.

## Registered Prototypes

| 키 | Prototype | Scene | 목적 |
| --- | --- | --- | --- |
| `1` / `Q` | Room Object Contract Prototype | `res://scenes/prototypes/QuarterviewRoomPrototype.tscn` | Object registry, interaction prompt, panel contract 검증. 최종 쿼터뷰 아트 아님 |
| `2` / `V` | Quarterview Perspective Blockout | `res://scenes/prototypes/QuarterviewPerspectiveBlockout.tscn` | 미래 쿼터뷰 cutaway room 시점 검증. 사선 바닥, 벽, pseudo 3D 가구, 깊이감 확인 |
| `3` / `H` | Hacking Action Prototype | `res://scenes/prototypes/HackingActionPrototype.tscn` | 탑뷰 해커모드 액션, 이동, 공격, 회피, 목표, 탈출 검증 |
| `4` / `C` | Hacking Perspective Blockout | `res://scenes/prototypes/HackingPerspectiveBlockout.tscn` | 미래 `3/4 top-down` cyber action 시점 검증. arena 깊이, 사선 platform, barrier 확인 |
| `5` / `T` | Title / Pause Menu Prototype | `res://scenes/prototypes/TitleMenuPrototype.tscn` | 시작화면, ESC 메뉴, 설정 placeholder 검증 |

## Controls

- `1` 또는 `Q`: Room Object Contract Prototype 실행.
- `2` 또는 `V`: Quarterview Perspective Blockout 실행.
- `3` 또는 `H`: Hacking Action Prototype 실행.
- `4` 또는 `C`: Hacking Perspective Blockout 실행.
- `5` 또는 `T`: Title / Pause Menu Prototype 실행.
- 포커스된 버튼에서 `E` 또는 `Enter`: 선택한 prototype 실행.
- Room Object Contract 버튼: `QuarterviewRoomPrototype.tscn` 실행.
- Quarterview Perspective 버튼: Quarterview Perspective Blockout 실행.
- Hacking Action 버튼: Hacking Action Prototype 실행.
- Hacking Perspective 버튼: Hacking Perspective Blockout 실행.
- Title / Pause Menu 버튼: Title / Pause Menu Prototype 실행.
- `ESC`: 허브 안에서는 종료 동작을 연결하지 않고 로그만 출력한다.
- 각 prototype 안에서 `B` 또는 `Backspace`: PrototypeHub로 돌아오기.

## Independence From Main

- `PrototypeHub`는 기존 Main game flow에 연결하지 않는다.
- Laptop, Phone, Outlet, Result, Test Mode와 연결하지 않는다.
- prototype 전환은 Hub 내부에서만 `change_scene_to_file()`로 처리한다.
- 기존 `Main.tscn`, `Apartment.gd`, `SurvivalState.gd`는 이 허브의 영향을 받지 않는다.

## Adding A New Prototype

새 prototype을 추가할 때의 기준:

1. Prototype scene은 `res://scenes/prototypes/` 아래에 둔다.
2. Prototype script는 `godot/scripts/prototypes/` 아래에 둔다.
3. 기존 Main/DAY1 흐름에 직접 연결하지 않는다.
4. `PrototypeHub.gd`의 `PROTOTYPES` registry에 `scene_path`, `status`, shortcut, description, button path를 추가한다.
5. `PrototypeHub.tscn`에 버튼과 짧은 설명을 추가한다.
6. 필요한 경우 키 입력을 추가하되, 기존 prototype 조작과 충돌하지 않게 한다.

## Current Limit

현재 최소 목표는 `Hub -> 각 prototype 실행 -> B / Backspace로 Hub 복귀`다.
각 prototype은 기존 `ESC` 의미를 유지하며, 공통 복귀는 `B` 또는 `Backspace`로만 처리한다.
