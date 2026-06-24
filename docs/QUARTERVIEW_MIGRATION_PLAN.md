# 쿼터뷰 집 화면 마이그레이션 계획

## 목적

이 문서는 현재 탑뷰 집 화면에서 장기적으로 쿼터뷰 / 아이소메트릭 느낌의 집 화면으로 전환할 때의 검토 순서와 구조적 주의사항을 정리한다.

현재 메인 씬을 바로 교체하지 않고, 별도 prototype scene에서 쿼터뷰 구도와 이동감을 먼저 검증한다. 기존 전력 / Phone / Result / Test Mode 흐름은 본 전환 여부를 결정하기 전까지 유지한다.

## 현재 구현

현재 집 화면은 탑뷰 기반이다.

- 전력 관리, 장치 연결, active 장치 소비, Phone UI, Result 화면, 02:00 자동 종료, Test Mode가 이미 구현되어 있다.
- 유이 이동, 근접 상호작용, 멀티탭 UI, 장치 Resource 구조가 이미 존재한다.
- DAY 1 코어 루프는 현재 구현의 유지 대상이다.
- 노트북은 현재 방 안 상호작용 오브젝트이며, 별도 해킹 액션 미션은 아직 구현되어 있지 않다.
- 기존 `res://scenes/prototypes/QuarterviewRoomPrototype.tscn`은 현재 최종 쿼터뷰 시점 검증용이 아니라 object / interaction contract prototype이다.

## 장기 방향

장기적으로 집 화면을 쿼터뷰 / 아이소메트릭 느낌의 방으로 전환할 수 있는지 검토한다.

단, 현재 메인 씬을 바로 갈아엎지 않는다. 별도 prototype scene에서 먼저 검증한 뒤, 조작감과 시인성, 충돌, 상호작용 포인트, 오브젝트 크기 기준이 맞는지 확인하고 본 전환 여부를 판단한다.

현재 코어 루프는 유지 대상이다.

- 방 안 이동
- 근접 상호작용
- 장치 연결과 active 상태
- Phone UI
- 멀티탭 UI
- Result 화면
- 02:00 자동 종료
- Test Mode

## Prototype Scene에서 확인할 것

쿼터뷰 전환은 먼저 별도 prototype 또는 perspective blockout scene에서 검증한다.

현재 `QuarterviewRoomPrototype`은 오브젝트 registry, prompt, panel, zone / role / future source 계약을 확인하는 scene으로 유지한다. 실제 쿼터뷰 시점, cutaway room 감각, 벽 높이, 가구 축, 캐릭터 비율은 `res://scenes/prototypes/QuarterviewPerspectiveBlockout.tscn`에서 먼저 검증한다.

- 쿼터뷰 방에서 유이 이동이 자연스러운지
- 캐릭터와 가구 크기 비율이 맞는지
- 침대, 책상, 노트북, 냉장고, 전자레인지, 에어컨, 멀티탭 위치가 읽히는지
- 벽이나 가구 뒤 가림 처리 또는 Y-sort가 필요한지
- 근접 상호작용 범위를 어떻게 잡을지
- 기존 Phone / Outlet / Result UI와 충돌하지 않는지
- 카메라와 UI가 쿼터뷰 배경을 가리지 않는지
- 테스트 모드 collision / interaction overlay가 쿼터뷰에서도 의미 있게 보이는지

## 구조적으로 고려할 것

쿼터뷰 방은 배경 한 장으로 끝내지 않는 방향을 우선 검토한다. 초기 prototype은 단일 배경으로 시작할 수 있지만, 장기적으로는 바닥, 벽, 가구, 전면 오브젝트를 분리하는 편이 유지보수에 유리하다.

검토할 구조는 아래와 같다.

- 바닥과 벽은 별도 레이어로 관리한다.
- 침대, 책상, 냉장고, 전자레인지, 에어컨 같은 큰 가구는 충돌과 가림 처리를 고려해 분리한다.
- 노트북, Phone, 멀티탭, 통신 장치 같은 상호작용 오브젝트는 위치, 상호작용 범위, 충돌 범위를 scene 또는 data 구조로 관리한다.
- 쿼터뷰 Room 오브젝트 정의는 `RoomObjectDefinition` Resource 기반으로 관리하며, 현재 contract prototype의 object 정의는 `godot/resources/rooms/quarterview/objects/*.tres`가 소유한다.
- 쿼터뷰 Main 교체 전, `RoomSceneContract`와 sandbox를 통해 입력, 상호작용 요청, 장치 시각 동기화, UI 연결을 분리 검증한다.
- 기존 탑뷰 Apartment 기능과 쿼터뷰 placeholder의 대응 관계는 `docs/QUARTERVIEW_APARTMENT_MAPPING.md`에서 추적한다.
- 쿼터뷰 prototype의 object key, role, future source, visual state 계약은 `docs/QUARTERVIEW_OBJECT_CONTRACT.md`에서 추적한다.
- 쿼터뷰 prototype은 `FloorLayer`, `WallBackLayer`, `FurnitureBackLayer`, `ObjectLayer`, `PlayerLayer`, `FurnitureFrontLayer`, `InteractionDebugLayer`, `LabelLayer`를 분리해 본 전환 전 레이어 책임과 가림 방식을 확인한다.
- 비주얼 에셋은 나중에 교체 가능하도록 gameplay 영역과 분리한다.
- 시점과 캐릭터 크기 기준을 먼저 고정하고, 세부 그래픽 스타일은 이후 교체 가능하게 유지한다.

## 마이그레이션 순서 초안

1. 현재 DAY 1 탑뷰 구현 안정화
2. 기존 `QuarterviewRoomPrototype`을 object / interaction contract 기준으로 유지
3. `QuarterviewPerspectiveBlockout.tscn`에서 쿼터뷰 perspective blockout 검증
4. 쿼터뷰용 임시 바닥 / 벽 / 가구 배치
5. 유이 이동과 Y-sort / 가림 처리 테스트
6. 주요 오브젝트 상호작용 포인트 배치
7. 기존 전력 / Phone / Result 흐름과 연결 가능성 검토
8. 본 전환 여부 결정
9. 전환하기로 결정한 경우 기존 탑뷰 방을 단계적으로 대체

## 유지해야 할 구조

쿼터뷰 전환을 검토하더라도 아래 구조는 유지 대상으로 본다.

- `SurvivalState` 중심의 전력 / 장치 상태 관리
- 장치 Resource 기반 데이터 정의
- connected 상태와 active 상태의 분리
- 멀티탭 연결 상태와 wire 표시 기준
- Phone UI를 통한 현재 상태 확인
- Result 화면을 통한 하루 생존 기록
- 02:00 자동 하루 종료 흐름
- Test Mode의 좌표 / 충돌 / 상호작용 확인 기능

## 아직 결정하지 않은 것

- 실제 쿼터뷰 방을 단일 배경으로 시작할지, 레이어 분리형으로 시작할지
- 캐릭터 이동을 현재 2D 탑뷰 이동 그대로 유지할지, 쿼터뷰에 맞춰 속도감과 축 보정을 조정할지
- 가구 뒤 가림 처리를 Y-sort로 해결할지, 전면 오브젝트 레이어로 해결할지
- 현재 선풍기를 장기적으로 에어컨으로 교체할지
- 기존 Main scene을 언제, 어떤 단위로 대체할지

## 이번 작업의 범위

- 현재 구현 = 탑뷰 방
- 현재 `QuarterviewRoomPrototype` = 독립 scene에서 object registry, interaction prompt, object panel, zone / role / future source contract를 확인
- `QuarterviewPerspectiveBlockout` = 실제 쿼터뷰 구도, 이동, 충돌, 가림, pseudo 3D 가구 비율을 확인
- 장기 방향 = 쿼터뷰 방 본 전환 여부 검토
- 본 전환 전까지 구현하지 않음 = 기존 Main scene 교체, 전력 / Phone / Result / Test Mode 흐름 변경, 최종 쿼터뷰 에셋 적용
