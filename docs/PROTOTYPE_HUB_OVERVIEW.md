# Prototype Hub Overview

## 목적

`PrototypeHub`는 기존 `Main.tscn` 또는 DAY 1 흐름과 분리된 독립 prototype 실행 화면이다.
현재 목적은 기능 prototype과 시점 blockout을 한 화면에서 구분해 실행하고, 각 scene의 수동 GUI 확인을 빠르게 시작하는 것이다.

## Scene Path

- Hub: `res://scenes/prototypes/PrototypeHub.tscn`

## 등록된 Prototype

| 키 | Prototype | Scene | 구분 |
| --- | --- | --- | --- |
| `1` / `Q` | Room Object Contract Prototype | `res://scenes/prototypes/QuarterviewRoomPrototype.tscn` | Object registry, interaction prompt, interaction panel, UI contract 검증 |
| `2` / `V` | Quarterview Perspective Blockout | `res://scenes/prototypes/QuarterviewPerspectiveBlockout.tscn` | 미래 쿼터뷰 cutaway room 시점 검증: 사선 바닥, 벽, pseudo 3D 가구, 깊이감 |
| `3` / `H` | Hacking Action Prototype | `res://scenes/prototypes/HackingActionPrototype.tscn` | 해킹 액션 조작, shot, roll, hop, objective, exit, state 검증 |
| `4` / `C` | Hacking Perspective Blockout | `res://scenes/prototypes/HackingPerspectiveBlockout.tscn` | 미래 `3/4 top-down` cyber action 시점 검증: arena 깊이, 사선 platform, barrier |
| `5` / `T` | Title / Pause Menu Prototype | `res://scenes/prototypes/TitleMenuPrototype.tscn` | 타이틀, ESC menu, settings placeholder 검증 |

## 조작

- 숫자 또는 문자 shortcut으로 각 prototype을 바로 실행한다.
- 버튼 포커스 상태에서 `E` 또는 `Enter`로 선택한 prototype을 실행한다.
- 각 prototype 안에서는 `B` 또는 `Backspace`로 Hub에 복귀한다.
- `ESC`는 Hub 내부에서 실제 종료와 연결하지 않고 로그만 출력한다.
- Prototype 공통 입력 규칙과 helper 기준은 `docs/PROTOTYPE_COMMON_RULES.md`에서 관리한다.

## Main과의 관계

- PrototypeHub는 기존 Main/DAY1 흐름에 연결하지 않는다.
- Laptop에서 Hacking prototype으로 들어가지 않는다.
- Quarterview blockout은 Main room 교체가 아니다.
- Perspective blockout scene은 실제 아트 적용이나 gameplay 이식이 아니라 시점 검증 전용이다.
- Hub 설명은 contract prototype과 perspective blockout을 구분해서 표시한다.
