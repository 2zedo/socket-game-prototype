# 쿼터뷰 오브젝트 상호작용 패널 Prototype

## Scene Path

- `res://scenes/prototypes/QuarterviewRoomPrototype.tscn`

## 목적

이 문서는 `QuarterviewRoomPrototype` 안에서 오브젝트를 조사하거나 사용할 때의 UI 흐름을 정리한다.
현재 작업은 실제 Main/DAY1 기능 이식이 아니라, 쿼터뷰 방에서 가까운 오브젝트를 선택했을 때 어떤 정보와 버튼을 보여줄지 확인하는 prototype이다.

## E Interaction Panel 흐름

- 플레이어가 상호작용 가능한 placeholder 근처에 가면 기존처럼 `E: <ObjectName>` prompt가 표시된다.
- `E`를 누르면 prototype 전용 object interaction panel이 열린다.
- panel이 열려 있는 동안 prototype player 이동은 멈춘다.
- panel이 열린 상태에서 `E`를 누르면 Primary button과 같은 no-op action 로그를 출력한다.
- `ESC` 또는 `Close` button으로 panel을 닫는다.
- `B` 또는 `Backspace`는 기존 prototype navigation 규칙대로 `PrototypeHub`로 돌아간다.

## 표시하는 Registry 정보

Panel은 `QuarterviewRoomPrototype.gd`의 object registry에서 아래 정보를 읽어 표시한다.

- `display_name`
- `key`
- `zone`
- `role`
- `future_source`
- `visual_state`

## Role별 Placeholder Action Label

| role | Primary label |
| --- | --- |
| `manual_end_day` | `Rest / End Day` |
| `laptop_job` | `Open Work` |
| `phone_status` | `Check Phone` |
| `phone_charge` | `Charge` |
| `power_management` | `Open Power` |
| `communication` | `Check Signal` |
| `mystery_device` | `Inspect NODE` |
| `audio_hacking_device` | `Enable Audio` |
| `living_appliance` | `Use Appliance` |
| `support_device` | `Use Device` |
| `background_life_hint` | `Inspect` |
| `background_structure` | `Inspect` |

## 실제 기능 연결 금지

이번 prototype panel은 실제 gameplay 기능과 연결하지 않는다.
Primary와 Inspect는 Godot output에 no-op 로그만 출력한다.

연결하지 않는 항목:

- `manual_end_day` -> 기존 Bed 수동 하루 종료 흐름
- `laptop_job` -> HackingActionPrototype 또는 작업 선택 UI
- `phone_status`, `phone_charge` -> 기존 Phone UI 또는 충전 흐름
- `power_management` -> 기존 Outlet UI
- `communication` -> 의뢰 / 신호 확인 UI
- `mystery_device` -> NODE-17 story flag
- `audio_hacking_device` -> 해커모드 오디오 정보 시스템
- `living_appliance` -> Fridge / Microwave / AC 생존 장치

## 향후 연결 후보

나중에 쿼터뷰 Room 본 이식을 검토할 때, 이 panel은 아래 시스템 연결의 검증 지점이 될 수 있다.

- `manual_end_day`: 기존 Bed 수동 종료 확인 흐름
- `laptop_job`: 해킹 미션 선택 또는 `HackingActionPrototype` 계열 진입 흐름
- `power_management`: 기존 Outlet UI
- `phone_status`: 기존 Phone UI
- `phone_charge`: Phone 충전 상태
- `communication`: 의뢰 / 외부 신호 확인 UI
- `mystery_device`: NODE-17 story flag
- `audio_hacking_device`: 해커모드 오디오 로그 / 신호 분석
- `living_appliance`: 냉장고, 전자레인지, 에어컨 생존 장치

## 현재 한계

- UI는 prototype 전용 placeholder이며 최종 스타일이 아니다.
- 버튼 클릭, `E`, `ESC`, `B` / `Backspace` 입력은 GUI 수동 확인이 필요하다.
- 실제 Phone, Outlet, Result, SurvivalState, HackingActionPrototype과 연결하지 않는다.
