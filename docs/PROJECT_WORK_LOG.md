# Project Work Log

## 목적

이 문서는 `CONCENT / 전력 부족의 시대`의 작업 완료 로그를 짧게 누적하는 파일이다.

자세한 설계 기준은 `docs/CONCENT_PROJECT_IDENTITY.md`를 우선한다. `PROJECT_STATUS.md`는 현재 상태판이고, 이 파일은 최근 작업 흐름을 빠르게 확인하기 위한 짧은 로그다.

## 최신 로그

### 32fb9c0 - AGENTS.md 최신화

- Commit: `32fb9c0`
- Result: 현재 Main / DAY1 golden path, sandbox-only 경계, protected files, asset / atlas 정책, 검증 명령을 agent guideline에 반영했다.
- Changed: `AGENTS.md`
- Validation: docs-only 범위에서 `git diff --check`를 사용했다.
- Next: 이후 작업은 AGENTS 기준으로 Main / DAY1 보호와 selective staging을 유지한다.

### cca6de2 - QuarterviewMain 1차 본방 후보 생성

- Commit: `cca6de2`
- Result: 기존 Main을 대체하지 않고 `QuarterviewMain` production candidate skeleton과 `QuarterviewRoom` / `QuarterviewPlayer` 구조를 만들었다.
- Changed: QuarterviewMain scene / script, quarterview room scene / script, player placeholder, status update.
- Validation: Godot project parse, `QuarterviewMain` startup, full GUT suite를 실행했다.
- Next: 실제 Phone / Outlet / Result / `SurvivalState` 연결은 별도 승인 작업으로 남겼다.

### 46a463b - QuarterviewMain visual blockout 개선

- Commit: `46a463b`
- Result: QuarterviewMain의 방 구도와 pseudo blockout을 콘티 방향에 가깝게 재구성했다.
- Changed: Quarterview room visual blockout, layer / object density, status notes.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain startup을 실행했다.
- Next: polygon blockout만으로 final visual을 잡는 방향은 중단하고 concept / background 기반 구조를 검토한다.

### a885d97 - CONCENT GPT handoff 문서 추가

- Commit: `a885d97`
- Result: 새 GPT / Codex 세션이 repo 구조와 QuarterviewMain 상태를 추측하지 않도록 handoff 문서를 추가했다.
- Changed: `docs/CONCENT_GPT_HANDOFF.md`
- Validation: docs-only 범위에서 `git diff --check`를 사용했다.
- Next: 새 세션은 handoff와 AGENTS를 읽고 실제 repo 구조 기준으로 작업한다.

### a6833bf - Quarterview room visual reference 적용

- Commit: `a6833bf`
- Result: QuarterviewRoom에 임시 room background / concept reference layer를 적용하고 polygon blockout visual은 기본 화면에서 숨겼다.
- Changed: QuarterviewRoom scene / script, temporary room background / concept reference asset, status notes.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain startup, full GUT suite를 실행했다.
- Next: GUI에서 background, invisible interaction / collision, prompt, debug overlay를 수동 확인한다.

### 920128a - Room / power / hacking design direction 문서화

- Commit: `920128a`
- Result: 메인방, 책상 클로즈업, 모듈형 전력 장비, 유이 방 모티프, 허기, 해킹 침투 / 방어 방향을 하나의 디자인 기준으로 정리했다.
- Changed: `docs/CONCENT_ROOM_POWER_HACKING_DESIGN_DIRECTION.md`, `docs/PROJECT_STATUS.md`
- Validation: `git diff --check`, `git diff --cached --check`를 실행했다.
- Next: identity 문서에서 이 방향을 current decision source로 승격한다.

### 2d0db19 - 문서 체계 정리 및 identity 문서 생성

- Commit: `2d0db19`
- Result: `CONCENT_PROJECT_IDENTITY.md`를 현재 게임 정체성의 단일 기준 문서로 추가하고, 작업 로그와 문서 우선순위 / 로테이션 정책을 정리한다.
- Changed: `docs/CONCENT_PROJECT_IDENTITY.md`, `docs/PROJECT_WORK_LOG.md`, `AGENTS.md`, `docs/PROJECT_STATUS.md`
- Validation: `git diff --check`, `git diff --cached --check`
- Next: `PROJECT_STATUS.md`가 200줄을 넘는 상태이므로 별도 작업에서 로테이션 여부를 검토한다.

### cc47319 - PROJECT_STATUS 로테이션 및 문서 인벤토리 생성

- Commit: `cc47319`
- Result: `PROJECT_STATUS.md`를 `docs/old`로 보존하고, 새 짧은 상태판과 `DOCUMENT_INVENTORY.md`를 만들었다.
- Changed: `docs/PROJECT_STATUS.md`, `docs/old/PROJECT_STATUS_20260628_01.md`, `docs/DOCUMENT_INVENTORY.md`, `docs/PROJECT_WORK_LOG.md`, `AGENTS.md`
- Validation: `git diff --check`, `git diff --cached --check`
- Next: deprecated notice 정리나 세부 문서 정리는 별도 작업에서 검토한다.

### 0f53ccc - deprecated notice 정리

- Commit: `0f53ccc`
- Result: legacy / conflict candidate docs에 superseded 또는 scope notice를 붙였고, archive 이동은 하지 않았다.
- Changed: candidate docs notice, `docs/DOCUMENT_INVENTORY.md`, `docs/PROJECT_STATUS.md`, `docs/PROJECT_WORK_LOG.md`
- Validation: `git diff --check`, `git diff --cached --check`, `find docs -type f | sort`, targeted `wc -l`
- Next: 필요하면 superseded 문서를 current identity 기준으로 통합하거나 archive stub 처리한다.

### 22b3356 - QuarterviewMain 1차 정리

- Commit: `22b3356`
- Result: QuarterviewMain normal view를 mouse-click 이동 중심으로 정리하고, object click 접근 / candidate panel / debug-only blockout 흐름을 추가했다.
- Changed: QuarterviewMain script / scene, QuarterviewRoom script, QuarterviewPlayer script, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 normal view, click movement, object approach, `D` debug, `R` restart를 수동 확인한다.

### 02bc38c - QuarterviewMain 이동감 개선

- Commit: `02bc38c`
- Result: QuarterviewMain player marker를 키우고, click / object approach 이동에 blocker-aware candidate grid pathfinding을 추가했다.
- Changed: QuarterviewPlayer path follow / marker size, QuarterviewRoom path grid / debug overlay, QuarterviewMain path failure status, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 침대 / 책상 / power rack 근처 우회 이동과 debug path overlay를 수동 확인한다.

### c5589b5 - QuarterviewMain pathfinding 에러 수정

- Commit: `c5589b5`
- Result: 빠른 클릭 중 empty path가 나와도 crash하지 않도록 guard를 추가하고, `skew` local variable shadow warning을 정리했다.
- Changed: QuarterviewRoom path failure handling / same-position arrival handling / debug failure reason, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 빠른 연속 클릭, blocker 위 / 근처 클릭, object click 반복, `D` debug failure reason 표시를 수동 확인한다.

### c4d7d00 - QuarterviewMain 이동감 튜닝 및 debug 안정화

- Commit: `c4d7d00`
- Result: click/path tuning constants를 정리하고, `D` debug toggle이 room / camera / player transform을 바꾸지 않도록 guard를 추가했다.
- Changed: QuarterviewRoom tuning constants / debug overlay visibility, QuarterviewPlayer debug keyboard toggle behavior, QuarterviewMain debug status transform guard, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 debug ON/OFF 화면 밀림, obstacle-aware movement, object approach, fast click stability를 수동 확인한다.

### de33465 - QuarterviewMain debug toggle / UI 분리

- Commit: `de33465`
- Result: `D` debug toggle과 player movement input을 분리하고, debug keyboard movement를 arrow key 전용으로 제한했다. Normal candidate panel은 display name / 짧은 설명 / 버튼 중심으로 정리하고, key / role / zone / action 같은 개발자 정보는 debug ON에서만 보이게 했다.
- Changed: QuarterviewPlayer debug input, QuarterviewMain candidate panel / status text, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 `D` 반복 입력 시 player 위치 유지, debug ON arrow-key 이동, normal/debug panel 표시 차이를 수동 확인한다.

### e7f8ee7 - QuarterviewMain interaction 튜닝

- Commit: `e7f8ee7`
- Result: object click priority를 추가해 책상 / 노트북 / 전력 장비가 장식 오브젝트보다 우선 잡히도록 하고, 주요 object approach point와 candidate panel 위치 clamp를 정리했다. Debug overlay는 전체 상세 텍스트 대신 selected / nearest focus 중심으로 priority, role, approach, click area를 읽게 했다.
- Changed: QuarterviewRoom click priority / approach / debug focus, QuarterviewMain panel placement / debug detail, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 desk / laptop / power / door / fridge / microwave 클릭 우선순위와 접근 위치, panel 위치, debug 가독성을 수동 확인한다.

### ab6371c - QuarterviewMain Desk close-up candidate

- Commit: `ab6371c`
- Result: desk / laptop `사용하기`에서 no-op Desk close-up candidate overlay를 열고, candidate UI가 열린 동안 room click movement와 pending focus를 잠그도록 정리했다.
- Changed: QuarterviewMain desk close-up overlay / hotspot no-op log, QuarterviewRoom modal input lock, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 desk / laptop 사용하기, close-up Close / ESC, room movement lock, hotspot no-op status, `D` debug, `R` restart를 수동 확인한다.

### 8a0b4b3 - QuarterviewMain debug / close-up input 안정화

- Commit: `8a0b4b3`
- Result: debug detail의 mixed payload 값을 안전하게 문자열화하고, shadow warning을 정리했으며, Desk close-up 빈 backdrop 클릭으로 overlay를 닫을 수 있게 했다.
- Changed: QuarterviewMain debug detail / close-up backdrop input, QuarterviewRoom debug visibility parameter, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 debug ON object click, close-up 빈 영역 닫기, hotspot click overlay 유지, room movement lock 복구를 수동 확인한다.

### 511c606 - QuarterviewMain footprint interaction tuning

- Commit: `511c606`
- Result: Desk close-up 빈 영역 클릭 닫기를 fallback으로 보강하고, QuarterviewRoom 이동 blocker를 visual rect / click area / floor footprint polygon 후보로 분리했다.
- Changed: QuarterviewMain close-up outside-click handling, QuarterviewRoom polygon footprint collision / path blocking / debug guides, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 close-up 빈 영역 닫기, hotspot overlay 유지, footprint polygon debug 색상, bed / desk / power / fridge 주변 이동감을 수동 확인한다.

### c2defec - QuarterviewMain footprint tuning mode

- Commit: `c2defec`
- Result: object candidate panel 빈 영역 클릭 닫기를 추가하고, footprint 좌표를 final blocker가 아닌 debug / tuning candidate로 분리했다. `D` debug ON 뒤 `F3`으로 selected object footprint tuning mode를 켜고, `[ / ]`로 대상 전환, `C`로 layout snippet을 출력할 수 있게 했다.
- Changed: QuarterviewMain candidate panel outside-click handling, QuarterviewRoom footprint tuning mode / debug visibility / path blocker separation, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 panel 빈 영역 닫기, close-up 빈 영역 닫기, `D` / `F3` tuning mode, `[ / ]` object selection, `C` snippet output / clipboard, selected footprint / click area / approach marker 가독성을 수동 확인한다.

### 69ba1c4 - QuarterviewMain Power equipment close-up candidate

- Commit: `69ba1c4`
- Result: Power object의 `사용하기`에서 no-op Power equipment close-up candidate overlay를 열고, mock power-board grid와 placeholder modules를 선택할 수 있게 했다. Room movement는 close-up 동안 잠기며, ESC / 닫기 / 빈 영역 클릭으로 닫는다.
- Changed: QuarterviewMain power close-up overlay / module no-op log, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, and full GUT passed (54 tests).
- Next: GUI에서 Power object 접근, `사용하기`로 close-up 열기, module 선택 / 모듈 확인 / 설명 no-op status, ESC / 닫기 / 빈 영역 클릭 close, 닫은 뒤 room movement 복구, 기존 Desk close-up 유지 여부를 수동 확인한다.

### f5e9fac - QuarterviewMain Phone candidate overlay

- Commit: `f5e9fac`
- Result: Phone object의 `사용하기`에서 no-op Phone candidate overlay를 열고, Battery / Signal / Messages / Charge Port 후보 상태를 확인할 수 있게 했다. Room movement는 overlay 동안 잠기며, ESC / 닫기 / 빈 영역 클릭으로 닫는다.
- Changed: QuarterviewMain phone candidate overlay / item no-op log, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, and full GUT passed (54 tests).
- Next: GUI에서 Phone object 접근, `사용하기`로 overlay 열기, item 선택 / 확인 / 설명 no-op status, ESC / 닫기 / 빈 영역 클릭 close, 닫은 뒤 room movement 복구, 기존 Desk / Power close-up 유지 여부를 수동 확인한다.

### this commit - QuarterviewMain Bed rest candidate overlay

- Commit: `this commit`
- Result: Bed object의 `사용하기`에서 no-op Bed rest candidate overlay를 열고, 잠깐 쉼 / 오늘 마무리 / 몸 상태 확인 후보 행동을 선택할 수 있게 했다. Room movement는 overlay 동안 잠기며, ESC / 닫기 / 빈 영역 클릭으로 닫는다.
- Changed: QuarterviewMain bed rest candidate overlay / rest option no-op log, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, and full GUT passed (54 tests).
- Next: GUI에서 Bed object 접근, `사용하기`로 overlay 열기, 잠깐 쉼 / 오늘 마무리 / 몸 상태 확인 선택 / no-op status, ESC / 닫기 / 빈 영역 클릭 close, 닫은 뒤 room movement 복구, 기존 Desk / Power / Phone close-up 유지 여부를 수동 확인한다.
