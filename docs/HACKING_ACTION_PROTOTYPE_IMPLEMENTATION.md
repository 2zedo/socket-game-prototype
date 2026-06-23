# 해킹 액션 Prototype 구현 메모

## Prototype Scene 경로

- `res://scenes/prototypes/HackingActionPrototype.tscn`
- `res://scenes/prototypes/HackingPerspectiveBlockout.tscn`: 별도 시점 blockout. 기존 조작 prototype을 대체하지 않는다.

## Prototype 역할 구분

- `HackingActionPrototype`: move / shot / roll / hop / objective / exit / mission state를 검증하는 조작 / 상태 prototype이다.
- `HackingPerspectiveBlockout`: 완전 정수리뷰가 아닌 `3/4 top-down cyber action view`를 검증하는 시각 blockout이다.
- 두 scene 모두 `Main`, Laptop, Result, Reward, Story flag와 연결하지 않는다.

## 구현한 조작

- `WASD` / 방향키: 해킹 아바타 이동.
- `J` / 마우스 왼쪽 클릭: 해킹 샷 발사.
- `Shift` / `K`: 짧은 구르기 회피.
- `Space`: scan line과 hazard 접촉을 피하기 위한 짧은 hop.
- `E`: data node 근처에서 데이터 추출.
- `R`: prototype 재시작.
- `D`: prototype 전용 debug overlay 표시 / 숨김.
- `B` / `Backspace`: `PrototypeHub`로 복귀.
- `ESC`: prototype 안에서는 종료 흐름에 연결하지 않고 로그만 출력한다.

## 구현한 흐름

1. 작은 탑뷰 사이버 arena에서 scene이 시작된다.
2. 플레이어는 시작 지점에서 corrupted data node 쪽으로 이동한다.
3. security program placeholder가 플레이어를 추적한다.
4. hacking shot은 적을 공격하거나 제거한다.
5. scan line과 unstable hazard zone에 닿으면 Trace가 증가한다. 단, hop 중에는 무시한다.
6. data node 근처에서 `E`를 누르면 objective가 extracted 상태가 된다.
7. 데이터 추출 후 exit gate가 활성화된다.
8. 활성화된 exit gate에 들어가면 success 상태가 표시된다.
9. HP가 `0`이 되거나 Trace가 `100%`에 도달하면 failure 상태가 표시된다.
10. `R`로 prototype을 초기화한다.

## Mission State

`HackingActionPrototype.gd`는 prototype 전용 상태를 `MissionState` enum으로 관리한다.

```text
READY
-> RUNNING
-> OBJECTIVE_EXTRACTED
-> SUCCESS

RUNNING / OBJECTIVE_EXTRACTED
-> FAILED
```

- `RUNNING`: objective 추출 전 기본 진행 상태.
- `OBJECTIVE_EXTRACTED`: data node 추출 후 exit gate가 활성화된 상태.
- `SUCCESS`: objective 추출 후 exit에 도달한 상태.
- `FAILED`: HP `0` 또는 Trace `100%` 도달 상태.

상태 전환은 `_set_mission_state()`를 통해 처리하며, objective / exit 색상과 UI objective 문구도 이 상태를 기준으로 갱신한다.

## Tuning Constants

prototype 조정값은 각 책임 script 상단에 상수로 모았다.

- `HackingActionPrototype.gd`: arena, objective, exit, wall, trace, hazard cooldown.
- `HackingPrototypePlayer.gd`: 이동 속도, roll 속도 / 시간 / cooldown, hop 시간, HP, invulnerability, projectile origin.
- `HackingPrototypeEnemy.gd`: enemy 속도, HP, contact range, contact damage, contact cooldown.
- `HackingPrototypeProjectile.gd`: projectile 속도, lifetime, damage, collision radius.

이번 정리는 밸런스 변경이 아니라, 다음 prototype 조정 때 숫자를 찾기 쉽게 만드는 구조 정리다.

## Prototype 구성 요소

- Player: 청록색 해킹 아바타 placeholder.
- Enemy: security drone과 firewall sentry placeholder.
- Objective: `DATA NODE` placeholder.
- Exit: 추출 전에는 비활성 회색, 추출 후에는 파란색으로 바뀌는 gate.
- Hazard: scan line과 unstable tile placeholder.
- UI: 조작 안내, HP, Trace, objective, state, 최신 event message 표시.

## Perspective Blockout 구성 요소

`HackingPerspectiveBlockout`은 기존 조작 prototype과 분리된 시점 검증용 scene이다.

- Floor / wall / platform: 완전 정수리뷰가 아닌 사선 cyber arena 축을 확인한다.
- Enemy / objective blocks: Security Program, Sentry, Data Node, Signal Relay, Exit Gate를 pseudo 3D block으로 배치한다.
- ForegroundLayer: 전면 firewall block으로 player 앞 / 뒤 깊이감과 일부 가림 가능성을 확인한다.
- Debug: `D`로 object label, collision guide, depth guide를 토글한다.

## Feedback / Debug 표시

- 기본 UI는 HP, Trace, Objective, State, Event를 항상 표시한다.
- `D`를 누르면 prototype 내부 debug overlay가 켜지고, player position, mission state, objective extracted 여부, exit active 여부, enemy count, projectile count, roll / hop 상태를 추가 표시한다.
- enemy가 projectile에 맞으면 잠깐 흰색으로 flash되고 `Hit security program` event가 표시된다.
- player가 enemy contact damage를 받으면 기존 invulnerability 색상과 함께 `Damage -1` event가 표시된다.
- hazard가 Trace를 올리면 해당 hazard가 잠깐 강조되고 `Trace +...` event가 표시된다.
- data node 추출과 exit 활성화, success / failed 상태도 event message로 표시한다.

## 책임 분리

- `HackingPrototypePlayer.gd`: 이동, 바라보는 방향, roll, hop, invulnerability, HP, shot 요청 신호를 담당한다.
- `HackingPrototypeEnemy.gd`: 추적, projectile 피격, HP 제거, player 접촉 시 damage 요청 신호를 담당한다.
- `HackingPrototypeProjectile.gd`: 직선 이동, lifetime, 충돌 시 damage 전달과 제거를 담당한다.
- `HackingActionPrototype.gd`: mission state, Trace 증가, player damage 적용, objective 추출, exit 성공, UI 표시를 담당한다.

## 아직 연결하지 않은 것

이번 prototype은 독립 scene이다.

- `Main.tscn`을 대체하지 않는다.
- Laptop 상호작용에서 진입하지 않는다.
- `SurvivalState.gd`를 사용하지 않는다.
- apartment 전력을 소비하지 않는다.
- 보상, Grid Credit, story flag, Result 기록을 지급하지 않는다.
- Phone, Outlet, Result, Test Mode, Quarterview Room 흐름을 수정하지 않는다.
- `HackingPerspectiveBlockout`은 시점 검증용이며, 기존 `HackingActionPrototype`의 조작 / 전투 시스템을 대체하지 않는다.

## 향후 연결 후보

장기 연결 방향은 아래 흐름으로 검토한다.

```text
Laptop 상호작용
-> 미션 선택
-> HackingActionPrototype 또는 향후 미션 scene
-> 성공 / 실패
-> 보상 / 정보 flag / Result 기록
-> apartment로 복귀
```

이 연결은 첫 prototype 범위에서 의도적으로 제외했다.
