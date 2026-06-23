# Prototype GUI Playtest Checklist

## 목적

이 체크리스트는 본게임 DAY1 플레이테스트가 아니라, 현재 독립 prototype scene들의 GUI / 조작 / SFX / Input Prompt 확인용이다.

본게임 확인과 prototype 확인은 섞지 않는다. `Main.tscn`, DAY1 전력 루프, Phone / Outlet / Result 흐름은 이 문서의 확인 범위가 아니다.

## 사전 조건

- Godot project: `godot/project.godot`
- 최신 `main` 기준으로 확인한다.
- 테스트 전 Godot editor를 재시작해도 좋다.
- GUI 확인은 사용자 수동 확인으로 진행한다.
- Headless startup 통과는 조작감, 시각 가독성, SFX 볼륨을 보장하지 않는다.

확인할 scene 경로:

- `res://scenes/prototypes/PrototypeHub.tscn`
- `res://scenes/prototypes/QuarterviewRoomPrototype.tscn`
- `res://scenes/prototypes/QuarterviewPerspectiveBlockout.tscn`
- `res://scenes/prototypes/HackingActionPrototype.tscn`
- `res://scenes/prototypes/HackingPerspectiveBlockout.tscn`
- `res://scenes/prototypes/TitleMenuPrototype.tscn`

## PrototypeHub

- [ ] `PrototypeHub` scene이 정상 실행된다.
- [ ] `Room Object Contract`, `Quarterview Perspective`, `Hacking Action`, `Hacking Perspective`, `Title Menu` 항목이 보인다.
- [ ] `W` / `S` 또는 `Up` / `Down`으로 선택 이동이 된다.
- [ ] `E` 또는 `Enter`로 선택한 prototype에 진입된다.
- [ ] `1` / `Q`로 Room Object Contract Prototype에 진입된다.
- [ ] `2` / `V`로 Quarterview Perspective Blockout에 진입된다.
- [ ] `3` / `H`로 Hacking Action Prototype에 진입된다.
- [ ] `4` / `C`로 Hacking Perspective Blockout에 진입된다.
- [ ] `5` / `T`로 Title / Pause Menu Prototype에 진입된다.
- [ ] 선택 이동 시 SFX가 너무 크거나 거슬리지 않는다.
- [ ] 실행 confirm SFX가 들린다.
- [ ] Input Prompt icon이 텍스트와 겹치지 않는다.
- [ ] 아이콘이 너무 크거나 작지 않다.
- [ ] `B` / `Backspace` 복귀 안내가 이해된다.

## QuarterviewRoomPrototype

- [ ] Scene이 정상 실행된다.
- [ ] 기본 화면에서 전체 label / range / collision이 숨겨져 있다.
- [ ] 가까운 오브젝트에만 `[E]` prompt가 표시된다.
- [ ] `[E]` prompt의 input icon과 텍스트가 겹치지 않는다.
- [ ] `D` 키로 debug overlay ON / OFF가 된다.
- [ ] Debug overlay ON일 때 label / range / collision이 보인다.
- [ ] `BATH DOOR`, `DOOR` 같은 구조 라벨은 기본 화면에 보이지 않는다.
- [ ] `E`로 `ObjectInteractionPanel`이 열린다.
- [ ] Panel은 오른쪽 고정 위치에 표시된다.
- [ ] Panel이 열리면 player 이동이 멈춘다.
- [ ] `Primary`, `Inspect`, `Close` 버튼이 보인다.
- [ ] `Primary` / `Inspect`는 실제 기능 연결 없이 no-op 로그만 남긴다.
- [ ] `Close` 또는 `ESC`로 panel이 닫힌다.
- [ ] `B` / `Backspace`로 `PrototypeHub` 복귀가 우선된다.
- [ ] Panel open / close / button SFX가 너무 과하지 않다.

주의:

- `QuarterviewRoomPrototype`은 아직 `Main` / DAY1을 대체하지 않는다.
- `Bed`, `Laptop`, `Power`, `Phone`, `Outlet`, `Result`, `Hacking`은 실제 기능과 연결하지 않은 상태다.

## QuarterviewPerspectiveBlockout

- [ ] Scene이 정상 실행된다.
- [ ] 사선 바닥과 뒤/측면 벽이 쿼터뷰 실내 시점처럼 읽힌다.
- [ ] Bed / Desk / Fridge 등 pseudo 3D block의 축이 서로 맞아 보인다.
- [ ] Player placeholder 이동과 큰 가구 collision이 동작한다.
- [ ] Desk / Bed 앞뒤를 지나가며 가림 테스트가 가능하다.
- [ ] `D` 키로 debug overlay ON / OFF가 된다.
- [ ] `B` / `Backspace`로 `PrototypeHub`에 복귀된다.

## HackingActionPrototype

- [ ] Scene이 정상 실행된다.
- [ ] `WASD` / 방향키 이동이 된다.
- [ ] `J` 또는 Mouse Left로 hacking shot이 발사된다.
- [ ] `Shift` 또는 `K`로 roll이 된다.
- [ ] `Space`로 hop이 된다.
- [ ] `D` 키로 debug overlay ON / OFF가 된다.
- [ ] Enemy에 projectile이 맞으면 hit feedback과 SFX가 나온다.
- [ ] Player가 damage를 받으면 HP가 줄고 event message가 나온다.
- [ ] Hazard / scan에 닿으면 Trace가 오른다.
- [ ] `E`로 data node를 추출할 수 있다.
- [ ] Objective 추출 후 exit가 활성화된다.
- [ ] Exit에 도달하면 `SUCCESS` 상태가 된다.
- [ ] HP `0` 또는 Trace `100`이면 `FAILED` 상태가 된다.
- [ ] `R`로 restart된다.
- [ ] `B` / `Backspace`로 `PrototypeHub`에 복귀된다.
- [ ] UI에서 HP / Trace / Objective / State / Event가 읽힌다.
- [ ] Input Prompt icon이 너무 많아 화면을 가리지 않는다.
- [ ] Shot / hit / damage / success / fail SFX가 구분된다.

조작감 판단:

- [ ] 이동 속도가 너무 빠르거나 느리지 않은가.
- [ ] Roll이 의미 있는가.
- [ ] Hop이 함정 회피처럼 느껴지는가.
- [ ] Shot이 맞는 느낌이 있는가.
- [ ] Trace / HP 실패가 이해되는가.

## HackingPerspectiveBlockout

- [ ] Scene이 정상 실행된다.
- [ ] 완전 정수리뷰보다 `3/4 top-down` cyber action 시점에 가깝게 보인다.
- [ ] 사선 floor / raised barrier / data node / exit gate가 구분된다.
- [ ] Player placeholder 이동이 가능하다.
- [ ] `D` 키로 debug overlay ON / OFF가 된다.
- [ ] `B` / `Backspace`로 `PrototypeHub`에 복귀된다.

## TitleMenuPrototype

- [ ] Scene이 정상 실행된다.
- [ ] 메뉴 항목이 보인다.
- [ ] `PrototypeHub`로 진입할 수 있다.
- [ ] 선택 / 확정 / 취소 흐름이 어색하지 않다.
- [ ] 아직 실제 `Main` 게임 시작과 연결되지 않은 상태가 명확하다.

`TitleMenuPrototype`은 아직 낮은 우선순위의 UI 방향 prototype이다. 실제 title scene 승격, save / load, Main 시작 연결, Main ESC menu 통합은 별도 작업이다.

## SFX 확인 항목

- [ ] UI select 소리가 너무 자주 나와 거슬리지 않는다.
- [ ] Confirm / cancel 소리가 구분된다.
- [ ] Quarterview panel open / close 소리가 어색하지 않다.
- [ ] Hacking shot / hit / damage / success / fail 소리가 구분된다.
- [ ] 전체 볼륨이 너무 크지 않다.
- [ ] 소리가 겹쳐서 지저분하게 들리지 않는다.

SFX는 현재 prototype 전용이다. Main / DAY1 사운드 시스템으로 확정된 것이 아니다.

## Input Prompt Icon 확인 항목

- [ ] 키 아이콘이 텍스트보다 가독성을 해치지 않는다.
- [ ] 아이콘 크기가 적절하다.
- [ ] `PrototypeHub`에서 아이콘이 버튼 / 설명과 겹치지 않는다.
- [ ] Quarterview의 `[E]` prompt가 너무 튀지 않는다.
- [ ] Hacking의 조작 안내가 아이콘 때문에 너무 복잡하지 않다.
- [ ] 필요하다면 아이콘 수를 줄여도 된다.

## 판정 기준

### Pass 기준

- 각 prototype scene이 실행된다.
- Hub에서 각 prototype에 진입 / 복귀할 수 있다.
- Quarterview 기본 화면이 지나치게 지저분하지 않다.
- Quarterview Perspective Blockout이 실제 쿼터뷰 시점 검증용으로 구분된다.
- Hacking prototype의 기본 미션 흐름이 이해된다.
- Hacking Perspective Blockout이 Hacking Action 조작 prototype과 구분된다.
- SFX와 input prompt가 prototype 확인을 방해하지 않는다.

### Needs Fix 기준

- 아이콘이나 라벨이 화면을 과하게 가린다.
- SFX가 너무 크거나 반복이 거슬린다.
- Quarterview panel이 조작을 방해한다.
- Hacking 조작 안내가 너무 복잡하다.
- Hub에서 진입 / 복귀가 헷갈린다.

## Bug Report Template

```text
[Prototype Bug]
- Scene:
- Steps:
- Expected:
- Actual:
- Screenshot/Video:
- Severity:
- Notes:
```
