# Title And Pause Menu Prototype

## Scene Path

- `res://scenes/prototypes/TitleMenuPrototype.tscn`

## Purpose

`TitleMenuPrototype`은 `CONCENT`의 시작화면과 ESC / Pause 메뉴 방향을 확인하기 위한 독립 UI prototype이다.
현재 `Main.tscn` 또는 DAY 1 게임 흐름에 연결하지 않는다.

## Title 화면 구성

표시 요소:

- `CONCENT`
- `전력 부족의 시대`
- `[새 게임]`
- `[이어하기]`
- `[프로토타입 허브]`
- `[설정]`
- `[종료]`

동작:

- `[새 게임]`: 실제 Main으로 이동하지 않고 로그만 출력한다.
- `[이어하기]`: save/load가 없으므로 비활성화한다.
- `[프로토타입 허브]`: `res://scenes/prototypes/PrototypeHub.tscn`으로 이동한다.
- `[설정]`: placeholder settings panel을 표시하거나 숨긴다.
- `[종료]`: prototype 내부 로그만 출력한다.

## ESC / Pause Overlay 구성

`ESC`를 누르면 Title prototype 내부에서만 pause overlay를 표시하거나 숨긴다.

표시 요소:

- `PAUSED / SYSTEM MENU`
- `[계속]`
- `[설정]`
- `[프로토타입 허브로]`
- `[타이틀로]`
- `[종료]`

동작:

- `[계속]`: overlay를 닫는다.
- `[설정]`: placeholder settings panel을 표시하거나 숨긴다.
- `[프로토타입 허브로]`: PrototypeHub로 이동한다.
- `[타이틀로]`: Title prototype scene을 다시 연다.
- `[종료]`: prototype 내부 로그만 출력한다.

## Settings Placeholder

실제 오디오, 화면, 저장 설정은 구현하지 않는다.

표시 항목:

- `BGM Volume: placeholder`
- `SE Volume: placeholder`
- `Text Speed: placeholder`
- `Fullscreen: placeholder`
- `[닫기]`

## PrototypeHub 등록

`PrototypeHub`에서 아래 입력과 버튼으로 실행할 수 있다.

- `3` 또는 `T`: Title / Pause Menu Prototype 실행.
- `Title / Pause Menu Prototype 실행` 버튼.

## Not Connected Yet

- 실제 title scene으로 승격하지 않았다.
- `[새 게임]`은 `Main.tscn`으로 이동하지 않는다.
- `[이어하기]`는 save/load와 연결하지 않는다.
- ESC 메뉴는 기존 `Main.gd` modal/input routing과 통합하지 않았다.
- Settings는 실제 audio/config 저장과 연결하지 않았다.

## Future Connection Candidates

- 실제 title scene으로 승격.
- `[새 게임]` -> `Main.tscn` 연결.
- `[이어하기]` -> save/load 연결.
- ESC 메뉴 -> Main modal/input routing과 통합.
- Settings -> 실제 audio/config 저장과 연결.
