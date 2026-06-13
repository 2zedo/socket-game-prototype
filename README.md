# CONCENT / 전력 부족의 시대

`CONCENT / 전력 부족의 시대`는 제한된 전력과 생활 욕구를 관리하는 생존형 게임 프로토타입입니다.

현재 메인 개발 대상은 `godot/` 아래의 Godot 프로젝트입니다. 루트의 React/Vite/Phaser 웹 프로젝트는 참고용 레거시 프로토타입으로 유지하며, 명시적인 요청이 없는 한 웹 쪽 파일은 수정하지 않습니다.

## Repo Structure

- `godot/`: 앞으로의 메인 개발 대상인 Godot 프로젝트
- `godot/project.godot`: Godot 프로젝트 설정 파일
- `godot/scenes/`: Godot 씬 파일
- `godot/scripts/`: Godot 게임 로직과 UI 스크립트
- `src/`: React/Vite/Phaser 기반 웹 프로토타입 소스
- `public/`: 웹 프로토타입 정적 파일
- `package.json`: 웹 프로토타입 실행, 빌드, 린트 스크립트

## Running the Godot Project

1. Godot 4.5 이상을 설치합니다.
2. Godot Project Manager에서 `godot/project.godot`를 엽니다.
3. 메인 씬은 `res://scenes/Main.tscn`입니다.
4. Godot 에디터에서 Run을 눌러 실행합니다.

## Web Prototype

React/Vite/Phaser 웹 프로토타입은 기존 아이디어와 상호작용을 참고하기 위한 레거시 자료입니다.

필요할 때만 다음 명령으로 확인합니다.

```sh
npm install
npm run lint
npm run build
```

## Current Development Goal

현재 목표는 Godot 기반 DAY 1 MVP 구현입니다. 우선 Godot 프로젝트 안에서 핵심 하루 플레이 루프, 전력 선택, 상태 변화, 기본 피드백을 안정적으로 만드는 데 집중합니다.
