# CONCENT GPT Handoff

이 문서는 새 ChatGPT / Codex 세션에서 `CONCENT / 전력 부족의 시대` 작업을 이어받을 때 붙여넣어 쓰기 위한 인계 문서다. repo 구조, 현재 QuarterviewMain 진행 상태, asset 배치 규칙, 디자인 기준, 다음 작업 방향을 추측하지 않도록 실제 현재 구조를 기준으로 요약한다.

새 세션 첫 메시지로 사용할 때는 마지막의 "새 GPT 세션 시작용 문장"을 먼저 붙이고, 그 아래에 이 문서 내용을 함께 붙이면 된다.

## 1. 프로젝트 개요

- 게임명: `CONCENT / 전력 부족의 시대`
- 장르: 작은 방에서 제한된 전력과 장비를 관리하며, 해킹과 정보 탈취를 통해 바깥 세계의 진실에 접근하는 2D 내러티브 생존 어드벤처
- 핵심 컨셉: THE GRID라는 거대 인공 도시의 하층 1인실에서 주인공 유이가 제한된 전력과 장비를 관리하며 살아간다.
- 중요한 정체성:
  - 전기 = 생존
  - 전기 = 노동
  - 전기 = 정보 접근
  - 전기 = 계급 차이
  - 방은 생활 / 작업 / 전력 관리 / 해킹 준비가 모이는 중심 허브
  - 해킹은 단순 코딩 퍼즐이 아니라 상대 시스템에 침투해 데이터를 탈취하는 SF 액션
- 현재 안정 경로: 기존 `godot/scenes/Main.tscn` / DAY1 탑뷰 흐름
- 현재 새 작업 우선순위: 기존 Main을 바로 갈아엎는 것이 아니라, 새 본방 후보 `QuarterviewMain`을 구축하고 검증하는 것
- 기존 Main / Apartment / DAY1은 당장 삭제하지 않는다. legacy / reference / rollback 기준으로 유지한다.
- `godot/project.godot` start scene은 아직 QuarterviewMain으로 바꾸지 않는다.

## 2. 문서 기준 / 작업 기준

작업 시작 시 읽어야 할 우선순위:

1. `AGENTS.md`
2. `docs/CONCENT_PROJECT_IDENTITY.md`
3. 직접 관련 세부 문서
4. `docs/PROJECT_STATUS.md`
5. 필요하면 `docs/DOCUMENT_INVENTORY.md`
6. 최근 흐름은 `docs/PROJECT_WORK_LOG.md`

현재 source of truth:

- `AGENTS.md`
- `docs/CONCENT_PROJECT_IDENTITY.md`

문서 정책:

- `docs/old`는 과거 기록이며 current decision source가 아니다.
- 세부 문서가 `CONCENT_PROJECT_IDENTITY.md`와 충돌하면 identity 문서를 우선한다.
- `PROJECT_STATUS.md`는 짧은 현재 상태판이다.
- `PROJECT_WORK_LOG.md`는 작업 완료 로그다.
- 오래된 문서에는 scope / superseded notice가 붙어 있을 수 있다.
- 실제 구현 여부는 문서만 믿지 말고 repo 파일, Godot scene, Resource, test 결과로 확인한다.

## 3. Repo 작업 규칙

현재 주요 개발 대상은 `godot/`이다. `src/`의 React / Vite / Phaser 웹 프로토타입은 레거시 / 참고용이며, 명시 요청 없으면 수정하지 않는다.

작업 브랜치:

- 기본은 `main`.

작업 전 확인:

```bash
git status --short --branch
git rev-parse --short HEAD
git fetch origin
git log --oneline HEAD..origin/main
```

규칙:

- 현재 브랜치가 `main`이 아니면 작업 중단 후 보고한다.
- `origin/main`에 새 commit이 있으면 pull / merge / rebase / reset 하지 말고 보고한다.
- unrelated local change가 있으면 stage하지 말고 따로 보고한다.
- `git add .` 금지.
- 필요한 파일만 선별 stage한다.
- push 실패 시 force push 금지.
- code / scene 작업은 가능하면 Godot AI MCP로 scene hierarchy를 read-only 확인한다.
- Godot AI MCP가 없으면 그 사실을 보고하고 filesystem + headless 검증으로 보수적으로 진행한다.

현재 계속 남아 있을 수 있는 unrelated 주의 항목:

- `godot/scripts/Apartment.gd` modified 상태가 남아 있을 수 있다. 현재 작업과 무관하면 절대 stage하지 않는다.
- `godot/addons/kenney_*`, `godot/addons/simplelicense/` 같은 raw addon folder가 untracked일 수 있다. stage하지 않는다.
- `godot/LICENSE.txt`, `godot/licenses/`, audio `.wav.import`, 여러 `.gd.uid`, test `.uid`가 untracked일 수 있다. 명시 작업 전까지 stage하지 않는다.

## 4. 실제 폴더 구조

주요 구조:

```text
godot/
  assets/
  data/
  resources/
  scenes/
  scripts/
  test/unit/
  themes/

docs/
src/
```

`godot/`가 현재 활성 Godot 프로젝트다. `src/`는 React / Vite / Phaser 레거시 웹 프로토타입이며, 명시 요청이 없으면 reference only다.

현재 `godot/assets/art/quarterview/` 하위 주요 구조:

```text
godot/assets/art/quarterview/reference/qv_room_concept_reference.png
godot/assets/art/quarterview/room/temp_qv_room_background.png
```

주의:

- 존재하지 않는 `godot/assets/images/` 같은 경로를 만들거나 전제로 삼지 않는다.
- 인물(Yui/person)이 포함된 콘티 이미지는 production background가 아니라 reference overlay로만 사용한다.
- runtime 임시 방 배경은 `godot/assets/art/quarterview/room/temp_qv_room_background.png` 기준이다.

## 5. 기존 Main / DAY1 상태

기존 `Main.tscn` / DAY1 top-view 흐름은 아직 존재한다. AGENTS 기준으로는 golden path 보호 대상이다.

보호 파일:

- `godot/scenes/Main.tscn`
- `godot/scripts/Main.gd`
- `godot/scripts/Apartment.gd`
- `godot/scripts/Player.gd`
- `godot/scripts/SurvivalState.gd`
- `godot/scenes/ui/PhoneUI.tscn`
- `godot/scripts/ui/PhoneUI.gd`
- `godot/scenes/ui/OutletMode.tscn`
- `godot/scripts/ui/OutletMode.gd`
- `godot/scenes/ui/DayResultPanel.tscn`
- `godot/scripts/ui/DayResultPanel.gd`
- `godot/project.godot`

현재 Main / DAY1 구현:

- top-view Main은 전력, 장치 연결, active drain, Phone, Result, `02:00` 종료, Test Mode를 갖고 있다.
- `SurvivalState.gd`가 production day / time / power / device / phone / result source of truth다.
- Phone / Outlet / Result는 현재 Main-only production UI다.
- QuarterviewMain에는 아직 production 연결하지 않는다.

사용자는 이제 새 `QuarterviewMain`이 제대로 만들어지는 것을 중요하게 본다. 그래도 실제 `project.godot` start scene 변경이나 기존 Main 삭제는 별도 승인 전 하지 않는다.

## 6. 현재 본방 후보: QuarterviewMain

현재 가장 중요한 새 방향은 `QuarterviewMain.tscn`을 새 본방 후보로 만드는 것이다.

관련 파일:

```text
godot/scenes/QuarterviewMain.tscn
godot/scripts/QuarterviewMain.gd

godot/scenes/quarterview/QuarterviewRoom.tscn
godot/scripts/quarterview/QuarterviewRoom.gd
godot/scripts/quarterview/QuarterviewPlayer.gd

godot/scripts/resources/RoomObjectDefinition.gd
godot/resources/rooms/quarterview/objects/*.tres
```

현재 room object resources:

```text
aircon.tres
bathroom_door.tres
bed.tres
comm.tres
desk.tres
door.tres
fridge.tres
laptop.tres
microwave.tres
node17.tres
phone.tres
power.tres
shelf.tres
signal_booster.tres
small_table.tres
speaker.tres
ups.tres
```

현재 QuarterviewMain 상태:

- production candidate skeleton
- project.godot start scene은 아직 아님
- 기존 Main / DAY1과 연결하지 않음
- temporary room background를 사용
- normal view는 mouse-click movement 중심
- WASD는 normal mode에서 비활성화
- debug ON 시 arrow key 이동 가능
- `D` debug toggle
- `F3` footprint tuning mode
- `[` / `]` selected object 변경
- `C` selected layout snippet 출력
- `R` restart
- object click -> 유이 이동 -> candidate interaction panel
- candidate panel은 `사용하기 / 설명(살펴보기) / 취소`
- normal panel에는 display name / 짧은 설명 중심
- debug ON에서 key / role / zone / priority / approach / click area 등 개발자 정보 표시
- room movement는 candidate panel / close-up overlay 중 lock

현재 candidate overlay:

- Desk / Laptop 사용 시 `Desk close-up candidate`
- Power 사용 시 `Power equipment close-up candidate`
- Phone 사용 시 `Phone candidate overlay`
- Bed 사용 시 `Bed rest/sleep candidate overlay`
- Fridge / Microwave 사용 시 `Food / Kitchen candidate overlay`
- Door 사용 시 `Door candidate overlay`

각 overlay는 현재 no-op / status log만 남긴다. 실제 Hacking, PhoneUI, OutletMode, DayResultPanel, SurvivalState, Grid Credit, save/load와 연결하지 않는다.

## 7. QuarterviewMain overlay별 현재 기능

Desk close-up hotspot:

- Laptop
- Communication Device
- NODE-17
- Signal Booster
- Speaker / Audio Analyzer
- Small Notes / Job Memo

Power close-up:

- mock power-board grid
- placeholder power modules
- 실제 drag/drop, 전력 계산, OutletMode, SurvivalState 연결 없음

Phone overlay:

- Battery
- Signal
- Messages
- Charge Port
- 실제 PhoneUI, 실제 배터리 상태, SurvivalState 연결 없음

Bed overlay:

- 잠깐 쉰다
- 오늘을 마무리한다
- 몸 상태를 확인한다
- 실제 하루 종료, 시간 진행, DayResultPanel, SurvivalState 연결 없음

Food / Kitchen overlay:

- Fridge source:
  - 보관 식량 확인
  - 간단히 먹을 것 찾기
  - 냉장고 상태 확인
- Microwave source:
  - 합성 식품 데우기
  - 조리 상태 확인
  - 오늘 먹을 것 생각하기
- 실제 허기 수치, food inventory, SurvivalState, DayResultPanel 연결 없음

Door overlay:

- 문 밖 상황 확인
- 복도 소리 듣기
- 외출 준비 생각하기
- 실제 외부 맵, scene transition, story flag, save-load 연결 없음

공통 close-up 규칙:

- overlay 중 room click movement 잠김
- ESC 닫기
- 닫기 버튼 닫기
- 빈 영역 클릭 닫기
- 닫은 뒤 room movement / object click 복구
- GUI에서 반복 클릭 안정성은 계속 수동 확인 필요

## 8. 메인방 최종 디자인 방향

메인방은 넓은 해커 연구실이 아니다. 작고 어두운 THE GRID 하층 1인실이어야 한다.

한 줄:

작고 어두운 THE GRID 하층 1인실. 왼쪽에는 출입문과 전력 차단기, 중앙은 빈 이동 공간, 왼쪽~중앙에는 침대와 바다 동경 소품, 오른쪽 창가에는 간결한 해킹 책상, 오른쪽에는 냉장고 / 전자레인지 중심의 생활 가전, 오른쪽 아래 구석에는 관물대처럼 숨겨진 전력 장비가 있는 방.

중요한 구조:

- 중앙은 빈 이동 공간
- 중앙 테이블, 작은 테이블, 큰 매트, 바닥 쿠션, 메모 공간 제거
- 왼쪽은 출입문 + 전력 차단기 / 방 불 스위치 정도
- 신발, 외투, 발매트, 계단 제거
- 욕실은 눈에 띄지 않게. 사용 가능한 공간처럼 보이면 안 됨
- 침대 주변은 기계 장비가 아니라 유이 성격을 보여주는 공간
- 침대 주변에는 바다 / 수평선 / 해변 포스터 / 파란 소품 등으로 자유 동경 표현
- 방 전체가 해변방처럼 보이면 안 됨
- 오른쪽 창가 / 벽면에는 간결한 책상
- 책상 위에는 노트북, 최소 통신 장비, 짧은 메모 정도만
- NODE-17, 신호 증폭기, 의미 모를 검은 박스, 과도한 오디오 장비 제거
- 생활 가전 구역은 냉장고 / 전자레인지 / 싱크대 / 간단한 조리대 중심
- 생활 가전 구역에 해킹 장비를 섞지 않음
- 오른쪽 아래 구석에는 전력 장비
- 전력 장비는 대형 공개 서버랙이 아니라 관물대 / 금속 캐비닛처럼 숨겨진 느낌
- 문이 살짝 열려 모듈 보드와 케이블이 보이는 정도
- UPS / 배터리팩 따로 늘어놓지 않음
- 전력 장비는 나중에 power board close-up으로 진입할 하나의 명확한 오브젝트

재질:

- 과도한 나무 가구 금지
- 전체는 금속, 콘크리트, 합성 소재, 낡은 패널 중심
- 침대 / 책상 일부는 어두운 합판 / 재활용 목재 정도 가능
- 감옥 / 연구소처럼 너무 차갑게 만들지 말 것

## 9. 메인방 조작 / 판정 구조

메인방 조작:

- 마우스 클릭 중심
- 오브젝트 클릭
- 유이가 이동
- `사용하기 / 설명 / 취소`
- 필요 시 close-up 전환

WASD:

- normal mode에서는 사용하지 않음
- debug / 보조 이동 정도

판정 분리:

- `visual_body_rect`: 화면상 보이는 참고 영역
- `click_area`: 마우스로 클릭 가능한 영역
- `blocker_footprint`: 실제 이동을 막는 바닥 footprint
- `approach_point`: 유이가 서야 하는 위치

쿼터뷰 / 3/4에서는 visual body 전체 사각형을 blocker로 쓰면 안 된다. 실제 캐릭터의 발이 닿는 바닥 점유 영역인 polygon footprint를 우선해야 한다.

현재 QuarterviewRoom에는 floor-contact footprint polygon 후보가 들어가 있다. 좌표는 1차 후보이며 GUI 확인 후 조정 필요하다. Codex가 화면 없이 좌표를 맞추는 방식은 비효율적이므로, tuning mode / debug overlay를 통해 사용자가 직접 확인하고 조정할 수 있게 해야 한다.

## 10. 전력 장비 방향

기존 멀티탭을 장기적으로 대체하는 핵심 시스템이다. 사용자는 "전력 테트리스"를 원한다.

전력 장비:

- 오른쪽 아래 / 구석
- 관물대 / 금속 캐비닛처럼 숨겨진 느낌
- 방에 대놓고 커다란 서버랙을 두지 않음
- 닫힌 캐비닛 안쪽에 모듈 보드 / 케이블 / 슬롯이 보임
- 나중에 사용하기로 power board close-up 진입

전력 보드 시스템:

- 바둑판 / 벌집 / 메이플 유니온 배치 같은 그리드
- 징그러운 벌집 느낌 금지
- 기계적인 슬롯 / 모듈 보드 느낌
- 다양한 모양의 모듈 필요
- 작은 단순 모듈은 전력 소모 큼
- 크고 이상한 모양은 전력 효율 좋음
- 기본 축은 전력 + 발열 + 보너스 효과
- 습도 / 안정도는 초반 제외
- 실패는 즉시 게임오버가 아니라 경고 / 효율 저하 / 위험 증가 / 성능 저하
- 모듈은 해킹 무기, 보조 드론, 스텔스 보정과 연결 가능
- 기본 공격은 자동 단발 발사체

## 11. 생활 / 허기 / 음식

허기 시스템은 유지한다.

- 허기 낮으면 상태이상 / 디버프
- 허기 높거나 잘 관리하면 버프
- 음식 후보: 가공육, 인공육, 배양육, 채소, 합성 식품
- 해산물은 사치품이자 바다 / 바깥 세계 상징
- 생활 가전 구역은 냉장고, 전자레인지, 싱크대 / 조리대, 식량 보관 중심
- 생활 가전 구역에는 이상한 해킹 장비를 섞지 않는다.

## 12. 해킹 모드 방향

해킹 모드는 우선 두 축이다.

1. 액션 침투
2. 방어

액션 침투:

- 하나의 모드 안에서 장비 세팅과 플레이 방식에 따라 전투형 / 스텔스형으로 갈림
- 목표: 침투 -> 데이터 탈취 -> 탈출
- 해킹은 코딩 퍼즐이 아니라 상대 시스템 내부에 침투하는 SF 액션 게임

시점:

- 대각선 아이소메트릭 아님
- 정면성이 있는 45도 상단 시점
- 던전앤파이터처럼 횡 이동 감각이 있지만 X / Y / Z 축을 모두 쓰는 2.5D 액션
- 카메라가 더 가까움
- 마우스 포인터 방향으로 카메라가 살짝 따라 움직임
- 오브젝트 뒤의 적 / 플레이어는 가려져야 함

전투형:

- 정찰형 바퀴 달린 드론
- 광선검 / SF 액션 무기
- 업그레이드 시 원거리 보조 공격 드론
- 구르기, 대시
- 시원한 돌파
- 적을 섬멸하고 데이터 탈취 후 탈출
- 막힌 문 / 지름길은 무조건 부수지 않고 우회해야 함

스텔스형:

- 은신
- 숨기
- 시야 회피
- 막힌 문 / 적 보안 장치 해킹
- 신호 조정 퍼즐
- 노드 연결 퍼즐
- 가까이 접근하면 빔 형태 교살용 와이어 / 데이터 와이어로 조용히 제거
- 데이터 탈취 후 흔적 최소화하고 탈출

방어:

- 뱀파이어 서바이벌식 생존 이벤트
- 중앙 코어를 가만히 지키는 방식은 재미없음
- 플레이어가 백신 / 코어 같은 존재로 직접 움직이며 일정 시간 버팀
- 적이 랜덤하게 달려들거나 지나감
- 기본 공격은 자동 단발 발사체
- 전력 장비 모듈 세팅으로 무기 수 / 공격 방식 / 보조 드론 / 발사체 효과 증가
- 매일 발생하지 않는 이벤트형

## 13. 현재 하면 안 되는 작업

- `godot/project.godot` start scene 변경 금지
- 기존 `Main.tscn`, `Main.gd`, `Apartment.gd`, `Player.gd`, `SurvivalState.gd` 삭제 또는 무리한 수정 금지
- 기존 PhoneUI / OutletMode / DayResultPanel production flow에 바로 연결 금지
- Hacking mission 연결 금지
- Grid Credit / story flag / save-load 연결 금지
- qv atlas 전체 적용 금지
- 실제 atlas PNG / mapping Resource 대량 생성 금지
- 이미지 레이어를 한 번에 많이 생성하거나 적용하지 말 것
- polygon blockout을 계속 "예쁜 방 아트"로 다듬는 데 시간을 쓰지 말 것

## 14. 다음 구현 작업 후보

가장 가까운 후보:

1. QuarterviewMain GUI 확인
   - Door overlay
   - Fridge / Microwave Food-Kitchen overlay
   - Bed / Phone / Power overlay
   - Desk close-up
   - close-up 빈 영역 클릭 닫힘
   - hotspot / option 클릭 시 overlay 유지
   - debug ON에서 visual rect / click area / footprint 구분
   - bed / desk / power / fridge / kitchen 주변 이동감
   - 빠른 클릭 / object click 반복 / D / F3 / R 유지
2. 최소 하루 루프 후보
   - QuarterviewMain 전용 HUD / status
   - Bed rest/sleep candidate를 day result candidate overlay로 확장
   - 기존 DayResultPanel / SurvivalState production 연결은 별도 승인 전 금지
3. Main replacement gate review
   - `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md`
   - `docs/MAIN_REPLACEMENT_WORK_PLAN.md`
   - start scene 변경 전 반드시 검토

## 15. 검증 명령

Godot project parse:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --quit-after 2
```

QuarterviewMain startup:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/QuarterviewMain.tscn --quit-after 2
```

Full GUT:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
```

## 16. Codex 작업 보고 형식

```text
## Completed:

## Changed Files:

## Not Changed:

- Main / DAY1 / Phone / Outlet / Result / SurvivalState / project.godot 수정 여부
- Hacking / GridCredit / story flag 연결 여부
- 새 asset 추가 여부
- unrelated 파일 stage 여부

## Validation:

## Manual Checks Still Needed:

## Next Recommended Step:

## Risks / TODO:

## Git:

- commit hash
- push 결과
```

## 17. 새 GPT 세션 시작용 문장

아래 문장을 새 ChatGPT 세션의 첫 메시지에 붙여넣고, 그 아래에 이 문서 내용을 함께 붙여넣으면 된다.

```text
이 대화는 Godot 게임 프로젝트 CONCENT / 전력 부족의 시대 작업 이어받기용입니다. 아래 CONCENT_GPT_HANDOFF 내용을 기준으로 답변해 주세요. repo 경로는 추측하지 말고, 이 문서에 적힌 실제 구조를 기준으로만 말해 주세요. 한국어로 답변해 주세요.
```
