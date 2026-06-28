# Repository Guidelines

## 1. 프로젝트 방향

* 현재 주요 개발 대상은 `godot/` 아래의 Godot 프로젝트다.
* `src/`의 React / Vite / Phaser 웹 프로토타입은 레거시 / 참고용으로 본다.
* 사용자가 명시적으로 요청하지 않는 한 React / Vite / Phaser 관련 파일은 수정하지 않는다.
* 현재 제품 방향은 `CONCENT / 전력 부족의 시대`다.
* 장르는 작은 방에서 제한된 전력을 관리하며 살아남는 2D 내러티브 생존 어드벤처다.
* 현재 안정된 플레이 경로는 기존 `Main.tscn` / DAY1 탑뷰 흐름이다.
* 쿼터뷰, 해킹 액션, atlas, UI 교체 작업은 production에 바로 연결하지 말고 prototype / sandbox / 문서 / Resource 단계를 거쳐 검증한다.

## 2. 기본 폴더 구조

* `godot/`: 현재 활성 Godot 프로젝트. 우선 작업 대상.
* `godot/scenes/`: Godot scene 파일.
* `godot/scripts/`: GDScript 파일.
* `godot/resources/`: `.tres` Resource 파일.
* `godot/test/unit/`: GUT unit test.
* `docs/`: 설계, 사양, 구현 메모, 마이그레이션 계획, 체크리스트.
* `src/`: 레거시 웹 프로토타입. 명시 요청 없으면 수정하지 않는다.
* `README.md`: 프로젝트 개요와 실행 안내.

## 3. 현재 안정 경로와 Main 교체 게이트

* 현재 `Main.tscn` / DAY1은 golden path다.
* 사용자가 명시적으로 요청하지 않는 한 `Main`을 교체하지 않는다.
* `project.godot`의 main scene을 바꾸지 않는다.
* Quarterview 시스템을 production에 연결하지 않는다.
* Main 교체는 아래 조건 전까지 금지한다.

  * `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md` 리뷰 및 통과
  * `docs/MAIN_REPLACEMENT_WORK_PLAN.md` 리뷰
  * 기존 Main / DAY1 수동 확인 통과
  * `QuarterviewGameplaySandbox` 수동 확인 통과
  * GUT / headless 검증 통과 또는 실패 원인 확인
  * 사용자의 명시적 승인
* 첫 Main 교체 시도는 기존 Main을 직접 갈아엎기보다 새 `QuarterviewMain` 후보 scene을 만드는 전략을 우선 검토한다.
* `project.godot` start scene 변경은 마지막에 별도 commit으로 격리한다.
* 첫 교체 시도에서 기존 `Main.tscn` / `Main.gd`를 삭제하지 않는다.

## 4. 기본 보호 파일

아래 파일은 기본적으로 수정하지 않는다.

* `godot/scenes/Main.tscn`
* `godot/scripts/Main.gd`
* `godot/scripts/Apartment.gd`
* `godot/scripts/Player.gd`
* `godot/scripts/SurvivalState.gd`
* `godot/scenes/ui/PhoneUI.tscn`
* `godot/scripts/ui/PhoneUI.gd`
* `godot/scenes/ui/OutletMode.tscn`
* `godot/scripts/ui/OutletMode.gd`
* `godot/scenes/ui/DayResultPanel.tscn`
* `godot/scripts/ui/DayResultPanel.gd`
* `godot/project.godot`

이 파일들은 production Main / DAY1 흐름 또는 승인된 Main 교체 작업에서만 수정한다.

## 5. Git 작업 규칙

* 현재 레포는 사용자가 별도 브랜치를 요청하지 않는 한 `main`에서 작업한다.
* 작업 시작 전 반드시 확인한다.

```bash
git status --short --branch
git rev-parse --short HEAD
git fetch origin
git log --oneline HEAD..origin/main
```

* 현재 브랜치가 `main`이 아니면 작업하지 말고 보고한다.
* `origin/main`에 새 commit이 있으면 pull / merge / rebase / reset 하지 말고 보고한다.
* unrelated local change가 있으면 stage하지 말고 따로 보고한다.
* `git add .`는 사용하지 않는다.
* 현재 작업에 필요한 파일만 선별 stage한다.
* commit 전 확인한다.

```bash
git status --short
git diff --cached --name-only
```

* commit은 작고 되돌리기 쉽게 유지한다.
* push 실패 시 force push하지 말고 보고한다.
* 충돌이 발생하면 임의 해결하지 말고 충돌 파일과 원인을 보고한다.

## 6. Godot 작업 규칙

* Godot 4.5.x 기준으로 작업한다.
* `godot/`이 현재 개발의 source of truth다.
* scene / UI 작업은 가능하면 Godot AI MCP로 scene hierarchy를 먼저 read-only 확인한다.
* `.tscn`을 텍스트로 추측 수정하지 않는다.
* Godot AI MCP를 사용할 수 없으면 그 사실을 보고하고, filesystem / headless 검증을 보수적으로 사용한다.
* scene script는 scene 동작에 집중한다.
* 반복되는 상태 / 수치 / 정의는 가능한 경우 `Resource` 또는 data 파일로 분리한다.
* 새 코드에는 의도, 엔진 특성, 비자명한 판단을 설명하는 주석을 추가한다.
* 기존 주석은 함부로 삭제하지 않는다.
* 큰 구조 변경 전에는 영향 파일과 이유를 먼저 정리한다.
* 넓은 리팩터링보다 작고 검토 가능한 변경을 우선한다.

## 7. Production 상태 소유권

* production의 day / time / power / device / phone / result 상태는 `SurvivalState.gd`가 source of truth다.
* connected device와 active device는 반드시 구분한다.
* active drain 계산은 production에서는 `SurvivalState` 기준으로 유지한다.
* sandbox-local clock, sandbox result, sandbox Test Mode 값은 production 상태가 아니다.
* room scene은 interaction request와 visual sync를 담당하고, power 계산이나 Result 진행을 직접 소유하지 않는다.
* production 연결 전까지 sandbox mock state를 production에 복사하지 않는다.

## 8. Prototype / Sandbox 경계

* `godot/scenes/prototypes/` 아래 scene은 production entry가 아니다.
* `QuarterviewRoomPrototype`은 object / interaction contract prototype이다. 최종 쿼터뷰 아트 검증용이 아니다.
* `QuarterviewPerspectiveBlockout`은 시점 / 깊이감 / 비율 확인용 blockout이다.
* `QuarterviewRoomShellPrototype`은 room shell layer 경로, missing status, 크기 확인용 visual prototype이다.
* `QuarterviewGameplaySandbox`는 sandbox-only다.
* `QuarterviewGameplaySandbox`의 local clock, Result panel, Test Mode, Phone mock, Outlet mock, Interaction panel은 production wiring이 아니다.
* `HackingActionPrototype`은 조작 / 상태 / 피드백 prototype이다.
* `HackingPerspectiveBlockout`은 해킹 시점 검증용 blockout이다.
* `PrototypeSceneUtils`, `PrototypeSfx`, `PrototypeInputPrompts`는 prototype 전용 helper다.
* 명시 작업 전까지 sandbox panel은 아래를 호출하거나 수정하지 않는다.

  * `Main.gd`
  * `SurvivalState.gd`
  * `PhoneUI.gd`
  * `OutletMode.gd`
  * `DayResultPanel.gd`
  * save/load
  * Grid Credit reward
  * Story flag

## 9. Asset / Atlas 정책

* 실제 PNG 생성, import, 적용은 명시적인 asset 작업에서만 한다.
* `/mnt/data`나 임시 외부 경로의 이미지를 임의로 복사하지 않는다.
* 사용자가 특정 이미지를 직접 적용하라고 명시한 경우에만 Godot 프로젝트로 복사한다.
* raw Asset Library addon 폴더는 stage하지 않는다.
* third-party asset은 필요한 파일만 `godot/assets/.../third_party/...`로 선별 복사하고 license 파일을 함께 둔다.
* `.import`와 `.uid`는 필요한 경우만 stage한다.
* unrelated `.png.import`, `.wav.import`, `.uid`, addon 생성 파일은 stage하지 않는다.
* `godot/.godot/`와 캐시 / generated output은 절대 commit하지 않는다.
* Git LFS는 아직 활성화하지 않았다.
* 큰 art, atlas, spritesheet, source-art, audio 추가는 별도 LFS / 용량 정책 결정 후 진행한다.

## 10. Room Shell 이미지 규칙

쿼터뷰 room shell 이미지는 atlas가 아니다. 같은 canvas 기준의 투명 PNG 레이어다.

핵심 파일:

* `qv_room_floor_base.png`
* `qv_room_walls_back.png`
* `qv_room_walls_side.png`
* `qv_room_foreground_occluders.png`
* `qv_room_window_city_view.png`
* `qv_room_static_lighting_overlay.png`

규칙:

* 모든 room shell layer는 같은 canvas 크기와 같은 원점을 공유한다.
* 같은 카메라 각도를 유지한다.
* 투명 배경 PNG로 관리한다.
* 요청한 layer에 해당하는 요소만 남긴다.
* item sheet / asset sheet / atlas처럼 만들지 않는다.
* 캐릭터, UI, 텍스트, 라벨을 넣지 않는다.
* 요청하지 않은 가구, 소품, 장치, 케이블을 넣지 않는다.
* `qv_room_foreground_occluders.png`는 전경 가림 레이어이며 소품 atlas가 아니다.
* 창밖 도시는 `qv_room_window_city_view.png` 전용이다.
* 조명, glow, shadow는 lighting / FX overlay로 분리한다.

## 11. Atlas Mapping 문서의 의미

대부분의 atlas 관련 작업은 현재 documented-only다.

문서화된 atlas 후보:

* qv furniture / appliances / work devices / FX / props / cable
* hacking arena tiles / avatar / enemies / objects / FX
* UI common / HUD / phone / outlet / result-log / dialogue / device-icons

명시적인 구현 작업 전까지 아래를 만들지 않는다.

* 실제 PNG atlas
* mapping JSON / CSV / `.tres`
* Theme Resource
* StyleBoxTexture
* AtlasTexture
* SpriteFrames
* Control node
* scene wiring
* gameplay wiring

## 12. 문서 규칙

* 작업 시작 시 `AGENTS.md` 다음으로 `docs/CONCENT_PROJECT_IDENTITY.md`를 읽는다.
* 디자인 / 기능 방향 판단은 아래 우선순위를 따른다.

  1. `AGENTS.md`
  2. `docs/CONCENT_PROJECT_IDENTITY.md`
  3. 직접 관련 세부 문서
  4. `docs/PROJECT_STATUS.md`
* 세부 문서가 `docs/CONCENT_PROJECT_IDENTITY.md`와 충돌하면 identity 문서를 우선한다.
* 단, 실제 구현 상태는 repo 파일, Godot scene, Resource, test 결과를 함께 확인한다.
* 관련 문서를 어디서 찾아야 할지 불명확하면 `docs/DOCUMENT_INVENTORY.md`를 먼저 확인한다.
* `docs/old`는 과거 기록이며 current decision source가 아니다.
* `docs/PROJECT_STATUS.md`는 현재 상태판이지 긴 작업 일지가 아니다.
* `docs/PROJECT_WORK_LOG.md`는 작업 완료 로그를 짧게 누적하는 파일이다.
* `AGENTS.md`에는 1~52 작업 이력을 전부 넣지 않는다.
* 없는 tracking 문서를 임의로 만들지 않는다.
* `NEXT_TASKS.md`, `WORK_LOG.md` 같은 파일은 사용자가 요청하지 않으면 만들지 않는다.
* 의미 있는 작업 단위가 끝나면 `docs/PROJECT_STATUS.md`를 갱신한다.
* 의미 있는 작업 단위가 끝나면 `docs/PROJECT_WORK_LOG.md`에도 commit / 작업명 / 결과 / 다음 작업을 짧게 추가한다.
* task 성격에 맞는 세부 문서만 갱신한다.
* `docs/ROADMAP.md`는 큰 방향 / 단계 변경 때만 갱신한다.
* `docs/GODOT_DAY1_MVP_PLAN.md`는 MVP 성공 기준이나 구현 계획이 바뀔 때만 갱신한다.
* `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`는 map, UI, dialogue window, outlet screen, layout, camera, lighting, visual presentation이 바뀔 때 갱신한다.
* `docs/ASSET_APPLICATION_NOTES.md`는 실제 이미지 / pixel asset / SpriteFrames / texture / atlas / font를 적용할 때만 갱신한다.
* `docs/YUI_ANIMATION_NOTES.md`는 유이의 실제 in-game sprite / animation을 바꿀 때만 갱신한다.
* `README.md`는 개요와 실행 안내 중심으로 유지하고, 작은 변경마다 갱신하지 않는다.
* 문서에 과한 날짜 / 시간을 넣지 않는다. 날짜와 작성자는 Git commit을 기준으로 본다.
* active progress 문서가 200줄을 넘으면 로테이션 후보로 본다.
* 로테이션은 자동으로 하지 않는다. 해당 문서를 갱신해야 하는 작업에서만 판단하고, 필요하면 별도 작업으로 진행한다.
* 로테이션 시 기존 파일은 `docs/old/<ORIGINAL_NAME>_<YYYYMMDD>_<NN>.md`로 이동하고, active 문서는 최신 요약 / 현재 상태 / 다음 작업만 남긴다.
* `AGENTS.md`와 `docs/CONCENT_PROJECT_IDENTITY.md`는 로테이션하지 않는다.
* 설계 기준 문서는 deprecated 판단이 명확할 때만 별도 보고 후 `docs/old` 이동을 검토한다.

## 13. 테스트 / 검증 명령

변경 범위에 맞는 검증만 실행한다.

Godot project parse:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --quit-after 2
```

전체 GUT:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
```

주요 targeted GUT 예시:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_survival_state.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_hacking_action_state_machine.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_asset_smoke.gd -gexit
```

web prototype 변경 시에만:

```bash
npm run lint
npm run build
```

검증을 실행하지 못했으면 반드시 이유를 보고한다.

## 14. 작업 종료 절차

의미 있는 작업 단위가 끝나면:

1. 실제 변경 파일을 확인한다.
2. 가능한 검증을 실행한다.
3. task 성격에 맞는 세부 문서를 갱신한다.
4. `docs/PROJECT_STATUS.md`를 갱신한다.
5. 현재 repo 상태 기준으로 다음 추천 작업을 재평가한다.
6. `git diff`를 확인한다.
7. 필요한 파일만 stage한다.
8. 명확한 commit message로 commit한다.
9. `origin main`에 push한다.

작업 종료 전 확인:

* 코드와 scene이 저장되어 있는가
* 검증을 실행했는가
* docs가 실제 결과와 일치하는가
* 변경 파일이 docs에 반영되었는가
* commit / push가 성공했는가
* 미완료 작업을 완료로 기록하지 않았는가

## 15. 보고 형식

작업 완료 보고는 짧고 구체적으로 한다.

권장 형식:

* Completed
* Changed Files
* Documentation Updated
* Validation
* Manual Checks Still Needed
* Risks / TODO
* Git

“구조 개선”, “아키텍처 개선” 같은 모호한 표현은 실제 변경 내용을 함께 적을 때만 사용한다.
