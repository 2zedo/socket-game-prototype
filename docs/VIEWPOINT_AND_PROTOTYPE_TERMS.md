# 시점 / Prototype 용어 정리

## 목적

이 문서는 `CONCENT / 전력 부족의 시대`에서 사용하는 시점 용어와 현재 prototype의 역할을 구분하기 위한 기준이다.

현재 prototype 이름만 보고 최종 시점 검증이 끝난 것으로 오해하지 않도록, "현재 검증 중인 것"과 "장기 목표 시점"을 분리한다.

## 시점 용어

### Top-down / 정수리뷰

- 완전히 위에서 내려다보는 시점이다.
- 캐릭터와 오브젝트의 윗면이 중심이 되고, 앞면이나 옆면의 입체감은 거의 보이지 않는다.
- 현재 `HackingActionPrototype`의 placeholder arena는 이 시점에 가깝다.
- 최종 해킹 액션 목표 시점은 아니다.

### 3/4 Top-down / 내려다보는 액션 시점

- 위에서 내려다보되, 캐릭터와 오브젝트의 앞면 / 옆면 / 높이감이 조금 보이는 시점이다.
- 완전 정수리뷰보다 카메라가 살짝 내려온 느낌이다.
- `Enter the Gungeon`류처럼 액션 가독성과 입체감을 함께 확보하는 방향에 가깝다.
- 장기 해킹 액션 목표 시점이다.

### Quarterview / 쿼터뷰 실내

- 실내 방을 사선 / 입체감 있게 보여주는 시점이다.
- 바닥, 뒤쪽 벽, 측면 벽, 가구의 앞면과 옆면이 읽혀야 한다.
- 방, 가구, 캐릭터가 같은 축과 크기 기준을 공유해야 한다.
- 최종 방 화면은 단순 정수리뷰나 평면 UI가 아니라, 좁은 실내를 입체적으로 읽을 수 있는 방향을 목표로 한다.

### Cutaway room / 실내 단면

- 앞쪽 벽을 제거하거나 낮게 처리해 내부를 보여주는 방식이다.
- 쿼터뷰 방에 적합하다.
- 현관, 침대, 작업 책상, 창문, 주방 / 전력 장비가 한 화면에서 읽히도록 돕는다.
- 앞쪽 벽이 시야를 막지 않도록 조절하는 것이 중요하다.

## 현재 Prototype 역할 재정의

### QuarterviewRoomPrototype

현재 역할:

- 최종 쿼터뷰 시점 prototype이 아니다.
- 현재는 room object registry / interaction panel / UI contract prototype이다.
- 오브젝트의 `key`, `zone`, `role`, `future_source`, `visual_state`와 interaction panel 흐름을 검증한다.

가치:

- 기존 `Apartment` 기능을 나중에 쿼터뷰 Room으로 옮길 때 필요한 object contract를 정리한다.
- 오브젝트별 role과 향후 연결 후보를 실험한다.
- 가까운 오브젝트 prompt, panel, no-op action, debug overlay 같은 상호작용 UI 흐름을 검증한다.

한계:

- 아직 입체감 있는 쿼터뷰 방 시점 검증으로는 부족하다.
- 방 / 가구 / 캐릭터의 실제 축, 벽 높이, 가림, cutaway 구성, 최종 이동감은 따로 검증해야 한다.
- 이름에 `Quarterview`가 들어가 있지만, 현재 scene은 최종 perspective blockout으로 간주하지 않는다.

### HackingActionPrototype

현재 역할:

- 해커모드 조작 / 상태 / 목표 / 피드백 검증용 독립 arena다.
- `move`, `shot`, `roll`, `hop`, `objective`, `exit`, mission state, HP / Trace 흐름을 검증한다.

가치:

- 해킹 액션의 기본 조작과 실패 / 성공 흐름을 빠르게 확인한다.
- SFX, event feedback, debug overlay, input prompt icon이 액션 prototype에서 읽히는지 확인한다.
- Laptop, Result, 보상, Story flag와 연결하기 전 독립적으로 흐름을 실험한다.

한계:

- 현재는 거의 정수리뷰 placeholder arena에 가깝다.
- 최종 목표인 `3/4 top-down cyber action view`와는 시점이 다르다.
- 캐릭터, 보안 프로그램, 장애물의 입체감과 디지털 공간의 깊이감은 별도 blockout에서 검증해야 한다.

## 장기 목표

### Room

- 좁지만 정돈된 `THE GRID` 하층민 1인실을 목표로 한다.
- 생활 공간보다 해커 작업 공간이 우선된 쿼터뷰 실내다.
- 따뜻한 실내 작업등과 차가운 Grid 외부 도시빛의 대비를 유지한다.
- 현재 object / interaction prototype과 별도로, 실제 시점 blockout이 필요하다.

### Hacking

- 완전 정수리뷰가 아니라 `3/4 top-down cyber action view`를 목표로 한다.
- 디지털 보안 공간이지만 캐릭터, 적, 장애물의 입체감이 어느 정도 보여야 한다.
- 보안 프로그램, 스캔 라인, 경보 노드, 탈출 지점이 액션 시점에서 잘 읽혀야 한다.
- 현재 `HackingActionPrototype`은 조작과 상태 흐름 검증용으로 유지하고, 최종 시점 검증은 별도 blockout에서 진행한다.

## 다음 작업 기준

- 기존 `QuarterviewRoomPrototype`은 버리지 않고 object / interaction contract prototype으로 유지한다.
- 실제 쿼터뷰 시점 검증은 `res://scenes/prototypes/QuarterviewPerspectiveBlockout.tscn`에서 진행한다.
- 현재 `HackingActionPrototype`은 조작 / 상태 prototype으로 유지한다.
- 해킹모드 시점 검증은 `res://scenes/prototypes/HackingPerspectiveBlockout.tscn`에서 진행한다.
- 두 perspective blockout은 `PrototypeHub`에 contract / gameplay prototype과 구분되는 시점 검증용 항목으로 등록한다.
- 기존 prototype rename은 하지 않는다.
- Main / DAY1 흐름과 prototype scene은 계속 분리한다.

## 구현 금지 기준

아래 항목은 별도 작업 전까지 이 문서만으로 구현하지 않는다.

- `QuarterviewRoomPrototype`을 Main으로 교체
- `QuarterviewRoomPrototype` rename
- `HackingActionPrototype` rename
- Laptop에서 `HackingActionPrototype` 연결
- `QuarterviewPerspectiveBlockout`을 Main으로 연결하거나 기존 contract prototype을 대체
- `HackingPerspectiveBlockout`을 Laptop, Result, Reward, Story flag와 연결
- 실제 아트 에셋 적용
- DAY1 gameplay / SurvivalState / Phone / Outlet / Result 연결 변경
