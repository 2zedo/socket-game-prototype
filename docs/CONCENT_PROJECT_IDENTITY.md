# CONCENT Project Identity

## 1. 이 문서의 역할

이 문서는 `CONCENT / 전력 부족의 시대`의 현재 게임 정체성과 작업 판단 기준을 고정하는 단일 기준 문서다.

작업 전에는 `AGENTS.md` 다음으로 이 문서를 우선 읽는다. 과거 문서나 세부 문서가 이 문서와 충돌하면 이 문서를 우선한다. 단, 실제 구현 상태는 항상 repo 파일, Godot scene, Resource, test 결과를 함께 확인한다.

`docs/old`는 과거 기록이다. 현재 결정의 source of truth로 삼지 않는다. 아직 유효한 내용이 있더라도 최신 문서와 충돌하지 않는 범위에서만 참고한다.

## 2. 현재 게임 한 줄 정의

`CONCENT / 전력 부족의 시대`는 작은 방에서 제한된 전력과 장비를 관리하며, 해킹과 정보 탈취를 통해 바깥 세계의 진실에 접근하는 2D 내러티브 생존 어드벤처다.

## 3. 현재 핵심 방향

- 메인 방은 마우스 클릭 중심이다.
- 기본 흐름은 `오브젝트 클릭 -> 유이 이동 -> 사용하기 / 설명(살펴보기) / 취소 패널 표시`다.
- WASD는 메인 조작이 아니라 보조 / 디버그 / PC 편의 조작이다.
- 책상은 해킹 / 작업 허브다.
- 책상 사용 시 바로 추상 UI로 점프하지 않고, 책상 클로즈업으로 전환하는 방향이다.
- 전력 장비는 기존 멀티탭을 장기적으로 대체하는 모듈형 전력 테트리스 시스템이다.
- 해킹은 우선 `액션 침투`와 `방어` 중심이다.
- 액션 침투는 하나의 모드 안에서 장비 세팅과 플레이 방식에 따라 전투형 / 스텔스형으로 갈린다.
- 방어는 플레이어가 직접 움직이며 피하고 사냥하는 이벤트형 생존 모드다.
- 음식 / 욕구 축에서는 허기 시스템을 유지한다.
- 유이의 방은 THE GRID 바깥 세계와 바다에 대한 동경을 보여줘야 한다.

## 4. 메인 방 디자인 기준

메인 방은 작은 하층민 1인실과 해커 작업실이 섞인 공간이다. 넓은 연구실처럼 보이면 안 된다.

공간 기준:

- 생활 공간과 작업 공간이 자연스럽게 섞인다.
- 중앙의 작은 탁상은 제거 후보이다.
- 오른쪽 구석에 전력 장비 구역을 둔다.
- 책상은 방 안에서 가장 중요한 작업 허브다.
- 책상 위에는 노트북, 통신 장비, 스피커 / 오디오 분석 장비, NODE-17, 신호 증폭기를 둔다.
- 방 visual이 먼저 좋아 보여도 interaction / collision / prompt는 별도 invisible data로 분리한다.

유이의 자유 동경은 새 / 날개 직접 장식이 아니라 바다, 피서, 수평선, 해변 같은 오브젝트로 표현한다. 예시는 낡은 바다 포스터, 바다 화면보호기, 해변 광고 전단, 파란 조명, 물결 이미지, 인공 조개 장식이다.

## 5. 전력 장비 기준

전력 장비는 compact 데이터센터 랙 / Molex / 모듈형 전력 보드 느낌으로 설계한다. 너무 큰 서버랙은 금지한다.

보드 형태:

- 바둑판 / 벌집 / 메이플 유니온 같은 모양 맞추기 구조를 참고한다.
- 징그러운 벌집 느낌은 피하고 기계적인 슬롯 / 모듈 보드 느낌을 우선한다.
- 다양한 모양의 모듈이 있어야 퍼즐 의미가 있다.

모듈 방향:

- 작고 단순한 모듈은 전력 소모가 크다.
- 크고 이상한 모양은 전력 효율이 좋다.
- 기본 관리 축은 `전력 + 발열 + 보너스 효과`다.
- 습도와 안정도는 초반 범위에서 제외한다.
- 실패는 즉시 게임오버보다 경고 / 효율저하 / 위험증가 / 성능저하다.
- 전력 보드 세팅은 해킹 무기, 보조 드론, 스텔스 보정과 연결된다.

## 6. 해킹 모드 기준

해킹 모드는 우선 `액션 침투`와 `방어`만 둔다.

액션 침투:

- 목표는 `침투 -> 데이터 탈취 -> 탈출`이다.
- 시점은 대각선 아이소메트릭이 아니라 정면성이 있는 45도 상단 시점이다.
- 던전앤파이터처럼 횡 이동 감각이 있지만 X / Y / Z 축을 모두 쓰는 2.5D 액션이다.
- 카메라는 기존 reference board보다 가까워야 한다.
- 마우스 포인터 방향으로 카메라가 살짝 따라 움직인다.
- 오브젝트 뒤의 적 / 플레이어는 가려져야 한다.

전투형:

- 드론, 광선검 / SF 액션 무기, 보조 드론, 구르기, 대시, 시원한 돌파가 중심이다.
- 모든 문을 부수는 게임이 아니라 경로 선택과 우회가 필요하다.

스텔스형:

- 은신, 숨기, 시야 회피, 막힌 문 / 적 보안 장치 해킹이 중심이다.
- 신호 조정 퍼즐, 노드 연결 퍼즐을 사용할 수 있다.
- 가까이 접근하면 빔 형태 교살용 와이어 / 데이터 와이어로 조용히 제거한다.

방어:

- 플레이어가 백신 / 코어 같은 존재로 직접 움직이며 일정 시간 버티는 생존 이벤트다.
- 중앙 코어를 가만히 지키는 방식은 우선하지 않는다.
- 기본 공격은 자동 단발 발사체다.
- 방어는 매일 발생하지 않는 이벤트형이다.

## 7. 음식 / 허기 기준

- 허기 시스템은 유지한다.
- 허기가 낮으면 상태이상 / 디버프를 준다.
- 허기가 높거나 잘 관리되면 버프를 줄 수 있다.
- 음식은 가공육, 인공육, 배양육, 채소 중심이다.
- 해산물은 사치이자 바깥 세계 / 바다의 상징이다.

## 8. 현재 구현 상태 구분

| Area | Status | Notes |
| --- | --- | --- |
| Current Main / DAY1 | implemented | 기존 top-view golden path. `Main.gd`, `Apartment.gd`, `SurvivalState.gd`, Phone, Outlet, Result 흐름은 보호 대상이다. |
| QuarterviewMain | production candidate skeleton | 독립 실행 가능한 본방 후보. 아직 `project.godot`, Phone, Outlet, Result, `SurvivalState`, Hacking, Grid Credit, save/load와 연결하지 않았다. |
| QuarterviewRoom | production candidate room shell | 임시 배경, invisible interaction / collision 후보, `RoomObjectDefinition` 기반 object data를 사용한다. |
| QuarterviewGameplaySandbox | sandbox-only | sandbox-local panel / clock / result / test mode 검증용이다. production wiring이 아니다. |
| RoomObjectDefinition | resource contract | 쿼터뷰 room object key, role, future_source, visual_state, position, size를 정의한다. |
| SurvivalState | production source of truth | DAY / time / power / connected / active / phone / result 상태의 기준이다. room scene이 power를 계산하지 않는다. |
| Phone / Outlet / Result | current Main only | 아직 QuarterviewMain에 production 연결하지 않았다. |
| qv / hack / ui atlas | documented-only | 실제 PNG atlas, Theme, mapping Resource, scene wiring은 없다. |
| HackingActionPrototype | prototype-only | 조작 / state / feedback 검증용이며 Laptop과 연결하지 않았다. |
| HackingMissionDefinition | resource skeleton | mission `.tres`, Laptop wiring, reward, Result, story flag 연결은 없다. |
| GridCreditState | skeleton | economy / reward 후보이며 Main, Result, save data와 연결하지 않았다. |
| LivingDeviceDefinition | resource skeleton | living appliance 후보 구조이며 `.tres`와 gameplay wiring은 없다. |

## 9. 문서 신뢰도 규칙

- 이 문서가 현재 방향의 최상위 기준이다.
- `docs/old`는 과거 기록이다.
- `docs/PROJECT_STATUS.md`는 현재 상태판이지만, 너무 길어지면 로테이션 대상이다.
- 세부 문서는 필요할 때 참조하되, 이 문서와 충돌하면 이 문서를 우선한다.
- 오래된 문서의 룰이 최신 방향과 충돌하면 최신 방향만 반영한다.
- 확실하지 않은 내용은 `미확정` 또는 `확인 필요`로 남긴다.
- 실제 구현 여부는 문서만 보지 말고 repo, Godot startup, GUT 결과로 확인한다.

문서 확인 우선순위:

1. `AGENTS.md`
2. `docs/CONCENT_PROJECT_IDENTITY.md`
3. 직접 관련 세부 문서
4. `docs/PROJECT_STATUS.md`

## 10. 더 이상 우선하지 않는 방향

| 이전 방향 | 현재 방향 |
| --- | --- |
| 메인 방 WASD 자유 이동 중심 | 마우스 클릭 중심, WASD는 보조 / 디버그 / PC 편의 |
| 기존 멀티탭 중심 전력 UI | 모듈형 전력 보드 / 전력 테트리스로 확장 |
| 중앙 탁상 중심 레이아웃 | 중앙 탁상은 제거 후보 |
| 해킹을 여러 퍼즐 모드로 넓게 분산 | 우선 액션 침투 / 방어 중심 |
| 전투형과 스텔스형을 별도 모드로 분리 | 같은 액션 침투 모드 안의 장비 / 플레이스타일 분기 |
| 습도 / 안정도까지 초반 관리 | 초반은 전력 + 발열 + 보너스 효과 |
| 회의용 reference board를 그대로 구현 | 텍스트 결정사항 우선, reference board는 방향 참고 |

## 11. 문서 로테이션 정책

대상은 `docs/PROJECT_STATUS.md`, `docs/PROJECT_WORK_LOG.md`, 앞으로 생길 active progress 문서다.

- active progress 문서가 200줄을 넘으면 로테이션 후보로 본다.
- 단, 자동 이동하지 않는다. 해당 문서를 갱신해야 하는 작업에서만 판단한다.
- 로테이션 시 기존 파일은 `docs/old/<ORIGINAL_NAME>_<YYYYMMDD>_<NN>.md`로 이동한다.
- `<YYYYMMDD>`는 `date +%Y%m%d`로 얻는다.
- `<NN>`은 같은 날짜 파일이 있으면 `01`, `02`, `03`처럼 증가한다.
- active 문서는 최신 요약, 현재 상태, 다음 작업만 남긴다.
- `AGENTS.md`와 이 문서는 로테이션하지 않는다.
- 설계 기준 문서는 함부로 `old`로 보내지 않는다. deprecated 판단이 명확할 때 별도 보고 후 진행한다.
- 대량 old 이동은 별도 승인 작업으로 분리한다.

## 12. 다음 작업 판단 기준

- 새 기능보다 먼저 메인 방 visual, click flow, desk close-up, power board를 우선한다.
- 이미지 asset 적용 시 room shell / background / collision / interaction을 분리한다.
- Codex는 이미지 생성보다 Godot 적용 구조, scene hierarchy, collision, interaction 정리에 집중한다.
- 좌표 / 미세 배치는 사용자가 GUI 화면을 보고 판단한다.
- 해킹 액션 구현 전에는 시점, 카메라, occlusion, 전투형 / 스텔스형 분기 원칙을 이 문서 기준으로 확인한다.
- Main 교체는 `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md`와 `docs/MAIN_REPLACEMENT_WORK_PLAN.md`를 통과하고 사용자가 명시 승인하기 전까지 하지 않는다.
