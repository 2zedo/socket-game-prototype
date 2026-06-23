# 구현 로드맵 개정안

## 목적

이 문서는 `CONCENT / 전력 부족의 시대`의 앞으로 구현 순서를 정리한다.

큰 방향과 가까운 작업을 구분해, 바로 구현할 수 없는 장기 아이디어가 현재 작업처럼 섞이지 않도록 한다.

## 중요한 원칙

- 현재 DAY 1 탑뷰 MVP를 먼저 안정화한다.
- 기존 전력 / Phone / Result / Test Mode 흐름을 깨지 않는다.
- 기존 탑뷰 방은 당장 유지한다.
- 새 기능은 작은 prototype으로 시작한다.
- 쿼터뷰와 해킹 액션은 바로 본 구현으로 들어가지 않는다.
- 먼저 별도 prototype 또는 perspective blockout scene으로 검증한 뒤, 조작감과 비용을 보고 본 전환 여부를 결정한다.
- 문서와 코드에서 "현재 구현"과 "장기 방향"을 섞지 않는다.
- 이미지 참고 자료는 분위기 참고용이며, 실제 에셋이나 UI로 복제하지 않는다.

## 추천 구현 순서

1. 현재 DAY 1 탑뷰 MVP 안정화
2. 장치 / 생활 오브젝트 방향 정리
3. 해킹 액션 prototype scene 1개 제작
4. 노트북에서 해킹 미션 진입 / 복귀 연결
5. 해킹 결과를 Result / 정보 플래그에 연결
6. 쿼터뷰 방 object / interaction prototype 유지
7. 별도 쿼터뷰 perspective blockout으로 실제 시점 / 이동 / 가림 / Y-sort 검증
8. 본격 쿼터뷰 전환 여부 결정
9. 장기 경제 / 전력 토큰 / Grid Credit 설계
10. DAY 2+ 콘텐츠 확장

## 가까운 작업

아래 작업은 장기 기능을 바로 구현하기 전에 먼저 정리하거나 검증할 수 있는 가까운 후보들이다.

### 현재 DAY 1 전체 수동 플레이테스트

- 목적: 현재 구현된 전력, 멀티탭, Phone, Result, `02:00` 종료, Test Mode 흐름이 실제로 끊기지 않는지 확인한다.
- 먼저 볼 파일 / 시스템: `godot/scenes/Main.tscn`, `godot/scripts/Main.gd`, `godot/scripts/SurvivalState.gd`, `docs/GODOT_PLAYTEST_CHECKLIST.md`
- 완료 기준: 수동 종료와 `02:00` 자동 종료 모두 Result로 이어지고, 전력 / Phone / 멀티탭 상태가 크게 어긋나지 않는다.

### 생활 전자기기 설계 정리

- 목적: 냉장고, 전자레인지, 에어컨 같은 생활 전자기기를 DAY 1 이후에 어떤 역할로 쓸지 정리한다.
- 먼저 볼 파일 / 문서: `docs/DAY1_CONTENT_BRIEF.md`, `docs/DAILY_LOOP_REVISED.md`, `docs/ASSET_PIPELINE.md`
- 완료 기준: 새 장치를 바로 구현하지 않고, 전력 소비, 생활감, 의뢰 조건, Result 기록 중 어떤 축에 연결할지 문서로 구분한다.

### 선풍기 유지 여부와 에어컨 교체 여부 결정

- 목적: 현재 Fan 구현을 유지할지, 장기적으로 에어컨으로 교체할지 결정한다.
- 먼저 볼 파일 / 문서: `docs/QUARTERVIEW_ROOM_DIRECTION.md`, `godot/resources/devices/fan.tres`
- 완료 기준: 현재 구현 유지, 이름 변경, 장기 교체 중 하나를 문서에 명확히 남긴다.

### 해킹 액션 prototype 최소 조작 정의

- 목적: 해킹 액션 prototype에서 필요한 최소 조작을 정한다.
- 먼저 볼 문서: `docs/HACKING_ACTION_DIRECTION.md`, `docs/HACKING_ACTION_MISSION_LOOP.md`
- 완료 기준: 이동, 공격 / 도구, 회피, 짧은 기동성 행동, 노드 상호작용 중 첫 prototype에 넣을 항목을 확정한다.

### 노트북에서 미션 선택으로 들어가는 UX 초안

- 목적: 기존 방 루프에서 노트북을 켠 뒤 해킹 미션으로 진입하는 흐름을 설계한다.
- 먼저 볼 파일 / 문서: `godot/scripts/Main.gd`, `godot/scripts/ui/InteractionPanel.gd`, `docs/DAILY_LOOP_REVISED.md`
- 완료 기준: 실제 구현 전, 방 상호작용 패널과 별도 미션 선택 UI의 경계를 문서로 정리한다.

## 중기 작업

### 해킹 액션 prototype scene 1개

- 목표: 작은 미션 1개로 해킹 액션이 현실 방 루프와 연결될 수 있는지 검증한다.
- 범위: 작은 맵, 목표 노드 하나, 위험 요소 1~2종, 성공 / 실패 결과.
- 주의: Grid Credit 경제, 복수 미션, 스킬트리는 넣지 않는다.

### 노트북 진입 / 복귀 연결

- 목표: 방에서 노트북을 통해 prototype 미션에 들어가고, 완료 후 방으로 돌아온다.
- 범위: 미션 시작, 결과 반환, Result 기록 연결.
- 주의: 기존 노트북 active 전력 소비와 DAY 시간 흐름을 깨지 않는다.

### 해킹 결과의 Result / 정보 플래그 연결

- 목표: 해킹 성공 / 실패가 하루 생존 기록에 자연스럽게 남도록 한다.
- 범위: 정보 조각, 실패 손실, 짧은 결과 문장.
- 주의: 복잡한 분기 엔딩이나 DAY 2+ 스토리로 확장하지 않는다.

## 장기 작업

- 쿼터뷰 메인 전환
- Grid Credit 경제
- 전력 구매 / 추가 배급 시스템
- 복수 해킹 미션
- DAY 2+ 스토리
- 외부 세계 진실 해금 구조
- 전용 쿼터뷰 아트 에셋 제작
- 장기 의뢰 목록과 난이도 체계
- 생활 전자기기 확장과 장치 밸런싱

## Prototype 우선 원칙

쿼터뷰와 해킹 액션은 바로 본 구현으로 들어가지 않는다.

먼저 별도 prototype scene 또는 perspective blockout scene으로 검증한 뒤, 조작감과 비용을 보고 본 전환 여부를 결정한다. 기존 `QuarterviewRoomPrototype`은 object / interaction contract 검증용이며, 실제 쿼터뷰 시점 검증은 별도 blockout에서 진행한다. `HackingActionPrototype`은 조작 / 상태 흐름 검증용이며, 장기 목표 시점은 완전 정수리뷰가 아닌 `3/4 top-down cyber action view`다. 자세한 용어는 `docs/VIEWPOINT_AND_PROTOTYPE_TERMS.md`를 따른다.

prototype에서 검증할 것은 완성도 높은 아트가 아니라, 아래 요소다.

- 조작감
- 카메라와 시인성
- 캐릭터와 오브젝트 비율
- 충돌과 가림 처리
- 상호작용 범위
- 기존 전력 / Phone / Result 흐름과의 연결 가능성

## 구현 시 주의사항

- 기존 DAY 1 전력 / Phone / Result / Test Mode 흐름을 깨지 않는다.
- 기존 탑뷰 방은 당장 유지한다.
- 새 기능은 작은 prototype으로 시작한다.
- 문서와 코드에서 현재 구현과 장기 방향을 섞지 않는다.
- 이미지 참고 자료는 분위기 참고용이며, 실제 에셋이나 UI로 복제하지 않는다.
- 장기 아이디어를 현재 완료된 기능처럼 문서에 쓰지 않는다.
- 본 구현 전에는 수동 테스트 기준과 실패 기준을 먼저 정한다.

## 지금 구현하면 안 되는 것

- 쿼터뷰 Main scene 대체
- 해킹 액션 본편 구현
- Grid Credit 경제 전체 구현
- DAY 2+ 콘텐츠
- 저장 / 로드
- 스킬트리
- 복잡한 분기 엔딩
- 대규모 장치 밸런스 변경
- 전용 쿼터뷰 아트 일괄 교체
