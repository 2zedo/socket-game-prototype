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

### this commit - QuarterviewMain pathfinding 에러 수정

- Commit: `this commit`
- Result: 빠른 클릭 중 empty path가 나와도 crash하지 않도록 guard를 추가하고, `skew` local variable shadow warning을 정리했다.
- Changed: QuarterviewRoom path failure handling / same-position arrival handling / debug failure reason, status docs.
- Validation: `git diff --check`, Godot project parse, QuarterviewMain headless startup, full GUT 54 tests passed.
- Next: GUI에서 빠른 연속 클릭, blocker 위 / 근처 클릭, object click 반복, `D` debug failure reason 표시를 수동 확인한다.
