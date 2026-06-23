# Prototype Common Rules

## 목적

이 문서는 `PrototypeHub`와 독립 prototype scene들의 공통 입력 / 복귀 / 재시작 / debug 규칙을 정리한다.
본게임 `Main.tscn` / DAY 1 규칙이 아니라 prototype 전용 규칙이다.

## 공통 키 규칙

| Action | Key | Scope | Notes |
| --- | --- | --- | --- |
| Hub Back | `B` / `Backspace` | all prototype scenes | `PrototypeHub`로 돌아간다. Panel이나 mission 상태보다 우선한다. |
| Restart | `R` | action / blockout scenes | 현재 prototype을 재시작한다. Scene reload 또는 prototype 내부 reset으로 처리할 수 있다. |
| Debug Toggle | `D` | debug-capable prototypes | debug overlay를 표시 / 숨김 한다. |
| Confirm / Interact | `E` / `Enter` | hub, room, objective scenes | Hub 항목 실행, 오브젝트 상호작용, objective 추출 등에 사용한다. |
| Cancel / Close | `ESC` | panels / menus | Panel close, menu toggle, 또는 prototype별 no-op 로그로 처리한다. |

## Prototype별 적용 범위

| Prototype | Hub Back | Restart | Debug | Confirm | Cancel | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `PrototypeHub` | no | no | no | `E` / `Enter` open selected prototype | `ESC` no-op log | Registry menu. Number / letter shortcuts remain scene-specific. |
| `QuarterviewRoomPrototype` | yes | no | yes | `E` interact / primary action | `ESC` panel close | Object / interaction contract prototype. |
| `HackingActionPrototype` | yes | yes | yes | `E` objective extract | `ESC` no-op log | Gameplay state prototype. Existing mission state and tuning remain local. |
| `QuarterviewPerspectiveBlockout` | yes | optional | yes | none | optional | Visual perspective test. No gameplay wiring. |
| `HackingPerspectiveBlockout` | yes | optional | yes | none | optional | Visual perspective test. No gameplay wiring. |
| `TitleMenuPrototype` | yes | no | optional | menu buttons | `ESC` pause overlay toggle | Title / menu flow test. |

## Helper 기준

`PrototypeSceneUtils.gd`는 prototype 전용 helper다.

- Autoload가 아니다.
- `Main.tscn` / DAY 1에는 사용하지 않는다.
- Prototype scene script에서 필요할 때 `preload()`해서 사용한다.
- Prototype마다 필요한 입력만 골라 사용한다.
- 기존 scene의 우선순위를 깨지 않는다.
- Panel이 열린 상태의 `ESC` 닫기, `B` / `Backspace` Hub 복귀 우선순위, Hacking Action의 mission state 처리는 기존 prototype script가 계속 결정한다.

## 기존 Helper와의 관계

기존 prototype helper는 유지한다.

| Helper | 역할 |
| --- | --- |
| `PrototypeSfx.gd` | Prototype 전용 SFX 재생 |
| `PrototypeInputPrompts.gd` | Prototype input prompt icon 로딩 / 표시 |
| `PrototypeSceneUtils.gd` | Input event 판정, Hub 복귀, current scene restart helper |

`PrototypeSceneUtils.gd`는 SFX나 prompt icon을 직접 다루지 않는다.

## 금지 기준

- Helper 정리 작업 중 Main / DAY 1 연결 금지
- Prototype을 실제 게임 흐름과 연결 금지
- `QuarterviewRoomPrototype`을 Main으로 교체 금지
- `HackingActionPrototype`을 Laptop과 연결 금지
- Scene rename / delete 금지
- Gameplay tuning 금지
- SFX / Input Prompt / asset policy 변경 금지

## 수동 확인 필요

Headless startup은 script load와 scene 초기화만 확인한다.
아래는 사용자가 Godot GUI에서 확인한다.

- `B` / `Backspace` Hub 복귀
- `R` restart
- `D` debug overlay
- `E` / `Enter` confirm / interact
- `ESC` panel close, menu toggle, no-op 로그
