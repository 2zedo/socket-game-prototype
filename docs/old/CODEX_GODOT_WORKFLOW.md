# Codex / Godot 작업 워크플로우

## 목적

이 문서는 Codex가 `CONCENT / 전력 부족의 시대` Godot 프로젝트를 작업할 때 따를 기본 규칙을 정리한다.

최근 Godot AI MCP 연결이 성공했으므로, scene / UI 작업에서는 `.tscn`을 텍스트로 추측 수정하기보다 가능한 한 Godot AI MCP로 scene hierarchy, node path, property를 먼저 확인한다.

## 역할 구분

| 역할 | 책임 |
| --- | --- |
| User | GUI 수동 확인, 감성 / 조작감 / 시각 판단, 최종 방향 결정 |
| ChatGPT | 기획 정리, Codex 프롬프트 작성, Codex 결과 검토, 다음 작업 분할 |
| Codex | repo 파일 수정, 문서 / 코드 / scene 작업, 검증 명령 실행, 관련 파일만 commit / push |
| Godot AI MCP | scene hierarchy 확인, node path / property 확인, scene / UI 작업 전 구조 파악, `.tscn` 추측 수정 감소 |
| Godot Editor | GUI 수동 확인, 실제 조작감 / 시각 확인 |

## Godot AI MCP 사용 원칙

기준 원칙:

```text
가능하면 Godot AI MCP로 scene hierarchy를 먼저 읽고 작업한다.
.tscn을 텍스트로 추측 수정하지 말고, node 경로와 property를 확인한 뒤 수정한다.
```

특히 아래 작업에서는 MCP 확인을 우선한다.

- UI panel 위치 / anchor 수정
- scene node 구조 정리
- `CollisionShape2D` / `Area2D` 작업
- `PrototypeHub` 구조 정리
- `QuarterviewRoomPrototype` 수정
- `HackingActionPrototype` scene 구조 확인

문서 작업이나 순수 GDScript 리팩터링에서는 MCP가 필수는 아니다. 다만 scene node path에 의존하는 코드라면, 가능한 범위에서 MCP 또는 Godot editor 기준으로 실제 node 구조를 확인한다.

## 작업 시작 전 체크

작업 시작 전에는 아래를 확인한다.

```bash
git status --short --branch
git fetch origin
git log --oneline HEAD..origin/main
```

원격에 새 커밋이 있으면 임의로 pull / rebase / merge하지 않고 중단 보고한다.

충돌 가능성이 있거나 rebase / merge가 막히면 Codex가 임의로 해결하지 않는다. 충돌 파일, 원인 추정, 필요한 다음 행동을 보고하고 멈춘다.

기존 unrelated local change는 작업 범위가 아니면 건드리지 않는다.

## 작업 종류별 검증 기준

### 문서 작업

- `git diff --check`
- `git status --short`
- Godot headless 실행 불필요

### GDScript 코드 작업

- `git diff --check`
- 관련 scene headless startup
- 필요하면 Main scene startup
- GUI 입력 / 감성 / 소리 / 조작감은 사용자가 수동 확인

### Godot Scene / UI 작업

- 가능하면 Godot AI MCP로 scene hierarchy 확인
- node path / property 확인 후 수정
- `git diff --check`
- 수정한 scene headless startup
- 시각 배치, hover, drag, 클릭, 키 입력은 사용자가 Godot Editor에서 수동 확인

### 에셋 / 오디오 / 이미지 작업

- `docs/THIRD_PARTY_ASSET_INVENTORY.md` 확인
- 라이선스 근거 확인
- 전체 asset pack stage 금지
- 실제 사용하는 파일만 선별 stage
- 필요한 license file 함께 stage
- `git diff --check`
- 관련 prototype scene startup
- 오디오 청감, 이미지 톤, particle timing은 사용자가 수동 확인

### Prototype 작업

- 기존 Main / DAY 1 영향 여부 확인
- `PrototypeHub` 또는 해당 prototype scene startup
- Main scene 교체나 Laptop / Phone / Outlet / Result 연결은 별도 명시가 있을 때만 진행
- GUI 조작 확인은 사용자에게 맡긴다

## Git / Staging 규칙

- `git add .` 금지
- 관련 파일만 명시적으로 stage
- 기존 unrelated 변경은 건드리지 않음
- 기존 `godot/scripts/Apartment.gd` local change는 작업 범위가 아니면 stage하지 않음
- 기존 `.png.import` / `.gd.uid` / asset import 파일은 작업과 직접 관련 없으면 stage하지 않음
- 원본 외부 asset addon 폴더 전체 stage 금지
- commit 전 `git diff --cached --stat` 또는 `git diff --cached --name-only`로 범위 확인
- push 전 `git fetch origin`과 `git log --oneline HEAD..origin/main`으로 remote ahead 여부 확인
- push 실패 시 force push하지 않고 중단 보고

## 작업 종료 보고 형식

Codex는 작업 후 아래 형식으로 짧게 보고한다.

```text
수정/생성한 파일:
작업 요약:
Godot AI MCP 사용 여부:
기존 Main 영향 여부:
이미지/Resource 추가 여부:
확인 결과:
stage 제외한 unrelated 파일:
commit/push:
수동 확인 필요 항목:
```

## 현재 프로젝트에서 특히 조심할 것

- 기존 Main / DAY 1 흐름은 안정화 대상이므로 prototype 작업과 섞지 않는다.
- Quarterview Room은 아직 Main 대체가 아닌 독립 prototype이다.
- Hacking Action은 아직 Laptop과 연결하지 않은 독립 prototype이다.
- Phone / Outlet / Result / `SurvivalState` 연결은 별도 작업으로 분리한다.
- 실제 쿼터뷰 아트 적용은 P1 에셋 계획 이후 별도 작업으로 진행한다.
- 외부 에셋은 설치 여부와 실제 사용 여부를 구분한다.
- Godot AI MCP는 scene 구조 확인과 안전한 node 작업을 돕는 도구이며, GUI 감성 판단을 대체하지 않는다.

## 관련 기준 문서

- `docs/PROJECT_DIRECTION_REVISED.md`
- `docs/IMPLEMENTATION_ROADMAP_REVISED.md`
- `docs/THIRD_PARTY_ASSET_INVENTORY.md`
- `docs/QUARTERVIEW_MIGRATION_PLAN.md`
- `docs/HACKING_ACTION_PROTOTYPE_IMPLEMENTATION.md`
- `docs/PROJECT_STATUS.md`
