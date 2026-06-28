# Document Inventory

## 1. 목적

이 문서는 `docs/`와 `docs/old/`의 문서를 찾기 쉽게 분류한 인벤토리다.

현재 게임 정체성과 디자인 판단은 `docs/CONCENT_PROJECT_IDENTITY.md`를 우선한다. 이 문서는 source of truth가 아니라 navigation / index다. 실제 구현 상태는 repo 파일, Godot scene, Resource, test 결과로 확인한다.

## 2. 현재 최우선 문서

| Path | 역할 | 언제 읽을지 | 비고 |
| --- | --- | --- | --- |
| `AGENTS.md` | repo 작업 규칙, 보호 파일, staging / validation 기준 | 모든 작업 시작 전 | 최상위 작업 규칙 |
| `docs/CONCENT_PROJECT_IDENTITY.md` | 현재 게임 정체성, 디자인 방향, 구현 상태 경계 | `AGENTS.md` 다음 | 방향 충돌 시 우선 |
| `docs/PROJECT_STATUS.md` | 짧은 현재 상태판 | 현재 phase / next task 확인 | 상세 과거 기록은 `docs/old` archive 참조 |
| `docs/PROJECT_WORK_LOG.md` | 최근 작업 완료 로그 | 최근 commit 흐름 확인 | 상세 설계 기준 아님 |
| `docs/DOCUMENT_INVENTORY.md` | 문서 위치 index | 관련 문서를 모를 때 | source of truth 아님 |

## 3. 핵심 디자인 / 방향 문서

| Path | 현재성 | 짧은 설명 | 비고 |
| --- | --- | --- | --- |
| `docs/CONCENT_ROOM_POWER_HACKING_DESIGN_DIRECTION.md` | Current | 메인방, 책상 클로즈업, 전력 장비, 허기, 해킹 침투 / 방어 방향 | identity의 근거 문서 |
| `docs/QUARTERVIEW_ROOM_DIRECTION.md` | Current | 쿼터뷰 방 콘티, 분위기, 공간 배치 기준 | identity와 충돌하면 identity 우선 |
| `docs/VIEWPOINT_AND_PROTOTYPE_TERMS.md` | Current | top-down, 3/4 top-down, quarterview, cutaway 용어 정리 | prototype 역할 구분 기준 |
| `docs/PROJECT_DIRECTION_REVISED.md` | Planning | 구현 상태와 장기 방향 구분 | 일부 내용은 identity로 요약됨 |
| `docs/IMPLEMENTATION_ROADMAP_REVISED.md` | Planning | 추천 구현 순서와 prototype 우선 원칙 | 오래된 항목은 확인 필요 |
| `docs/ROADMAP.md` | Planning | 간단한 큰 단계 roadmap | 최신 세부 방향은 identity 우선 |
| `docs/DAILY_LOOP_REVISED.md` | Planning | 하루 루프, 현실 / 해킹 / 보상 방향 | Main / DAY1 실제 구현과 함께 확인 |
| `docs/WORLD_BIBLE.md` | Planning | 세계관 요약 | 상위 분위기 참고 |
| `docs/YUI_CHARACTER_BRIEF.md` | Planning | 유이 캐릭터 방향 | 방 모티프는 identity 우선 |
| `docs/VISUAL_DIRECTION.md` | Planning | 전반 visual 방향 | 최신 room / power / hacking 방향과 함께 확인 |

## 4. 구현 / 시스템 문서

### Room / Quarterview

| Path | 현재성 | 짧은 설명 | 비고 |
| --- | --- | --- | --- |
| `docs/QUARTERVIEW_MIGRATION_PLAN.md` | Planning | top-view에서 quarterview로 넘어갈 때의 검토 순서 | Main 교체 직접 지시 아님 |
| `docs/QUARTERVIEW_APARTMENT_MAPPING.md` | Planning | 기존 Apartment / Main 기능과 quarterview object 대응표 | 실제 연결 전 sandbox first |
| `docs/ROOM_SCENE_CONTRACT.md` | Planning | 미래 room scene signal / method contract | skeleton만 존재 |
| `docs/ROOM_OBJECT_DEFINITION.md` | Current | `RoomObjectDefinition` Resource field / helper 기준 | `.tres` object resources와 연결 |
| `docs/ROOM_DEVICE_DIRECTION.md` | Planning | 방 장치 방향 | 최신 power board 방향과 함께 확인 |
| `docs/QUARTERVIEW_OBJECT_CONTRACT.md` | Current | object key, zone, role, future_source, visual_state 계약 | contract 기준 |
| `docs/QUARTERVIEW_OBJECT_INTERACTION_PROTOTYPE.md` | Prototype-only | QuarterviewRoomPrototype object panel 흐름 | production UI 아님 |
| `docs/QUARTERVIEW_ROOM_SHELL_LAYER_PLAN.md` | Planning | room shell PNG layer 정책 | actual PNG 적용 아님 |
| `docs/QUARTERVIEW_ROOM_SHELL_PROTOTYPE.md` | Prototype-only | room shell layer missing / size check prototype | production scene 아님 |
| `docs/QUARTERVIEW_WINDOW_CITY_VIEW_GUIDE.md` | Documented-only | future `qv_room_window_city_view.png` 기준 | asset 없음 |
| `docs/QUARTERVIEW_FOREGROUND_OCCLUDER_GUIDE.md` | Documented-only | future foreground occluder 기준 | asset 없음 |
| `docs/QUARTERVIEW_STATIC_LIGHTING_OVERLAY_GUIDE.md` | Documented-only | future static lighting overlay 기준 | asset 없음 |
| `docs/YUI_QV_SPRITESHEET_IMPORT_GUIDE.md` | Documented-only | future Yui quarterview spritesheet import 기준 | actual qv sprite 없음 |

### Hacking

| Path | 현재성 | 짧은 설명 | 비고 |
| --- | --- | --- | --- |
| `docs/HACKING_ACTION_DIRECTION.md` | Planning | 해킹 액션 모드 방향 | 최신 모드 구분은 identity 우선 |
| `docs/HACKING_ACTION_MISSION_LOOP.md` | Planning | 침투, 목표, 위험, 보상 루프 | 실제 mission wiring 없음 |
| `docs/HACKING_ACTION_CONTROL_PROTOTYPE.md` | Prototype-only | 해킹 action control prototype 기준 | production 아님 |
| `docs/HACKING_ACTION_PROTOTYPE_IMPLEMENTATION.md` | Prototype-only | HackingActionPrototype 구현 메모 | Laptop과 미연결 |
| `docs/HACKING_MISSION_DEFINITION.md` | Planning | `HackingMissionDefinition` Resource contract | sample mission `.tres` 없음 |
| `docs/GRID_CREDIT_SYSTEM.md` | Planning | Grid Credit skeleton / reward 후보 | production economy 미연결 |

### Power / Device

| Path | 현재성 | 짧은 설명 | 비고 |
| --- | --- | --- | --- |
| `docs/DAY1_CONTENT_BRIEF.md` | Current / Main-only | DAY1 device / power / result 내용 | top-view Main 기준 |
| `docs/GODOT_DAY1_MVP_PLAN.md` | Current / Main-only | Godot DAY1 MVP 기준 | protected golden path 참고 |
| `docs/LIVING_DEVICE_DEFINITION.md` | Planning | future living device Resource contract | `.tres` / gameplay wiring 없음 |
| `docs/THIRD_PARTY_ASSET_INVENTORY.md` | Current | 설치 / 선별 third-party asset inventory | asset 적용 전 확인 |
| `docs/GIT_LFS_ASSET_POLICY.md` | Current | large asset / LFS 도입 정책 | LFS 아직 비활성 |

### UI

| Path | 현재성 | 짧은 설명 | 비고 |
| --- | --- | --- | --- |
| `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md` | Current / Main-only | current top-view UI visual notes | Quarterview final UI 기준 아님 |
| `docs/GODOT_PLAYTEST_CHECKLIST.md` | Current / Main-only | DAY1 manual playtest checklist | current Main 확인용 |
| `docs/TITLE_AND_PAUSE_MENU_PROTOTYPE.md` | Prototype-only | Title / Pause menu prototype 기준 | production start / ESC 미연결 |

### Testing

| Path | 현재성 | 짧은 설명 | 비고 |
| --- | --- | --- | --- |
| `docs/GODOT_TESTING.md` | Current | GUT / Godot test command 기준 | test 작업 전 확인 |
| `docs/CODEX_GODOT_WORKFLOW.md` | Current | Codex / Godot 작업 방식 | AGENTS와 함께 확인 |
| `docs/CONCENT_GPT_HANDOFF.md` | Current | 새 GPT / Codex 세션용 handoff | repo 구조 추측 방지용 |

## 5. Atlas / Asset 계획 문서

대부분 `Documented-only`다. 실제 PNG atlas, mapping JSON / CSV / `.tres`, Theme, StyleBoxTexture, AtlasTexture, SpriteFrames, Control node, scene wiring, gameplay wiring은 명시 작업 전까지 만들지 않는다.

| Path | 현재성 | 짧은 설명 | 비고 |
| --- | --- | --- | --- |
| `docs/ASSET_PIPELINE.md` | Current | asset folder / replacement target / warning 기준 | 실제 적용 전 확인 |
| `docs/ASSET_APPLICATION_NOTES.md` | Current / Main-only | applied asset notes | Quarterview final art 기준 아님 |
| `docs/QUARTERVIEW_ART_ASSET_PLAN.md` | Planning | qv art priority and atlas principles | actual art 적용 아님 |
| `docs/QV_FURNITURE_ATLAS_REGION_MAPPING.md` | Documented-only | qv furniture atlas region plan | PNG / mapping 없음 |
| `docs/QV_APPLIANCES_ATLAS_REGION_MAPPING.md` | Documented-only | qv appliances atlas region plan | PNG / mapping 없음 |
| `docs/QV_WORK_DEVICES_ATLAS_REGION_MAPPING.md` | Documented-only | qv work devices atlas region plan | PNG / mapping 없음 |
| `docs/QV_FX_ATLAS_REGION_MAPPING.md` | Documented-only | qv FX atlas region plan | PNG / mapping 없음 |
| `docs/QV_PROPS_AND_CABLE_ATLAS_BACKLOG.md` | Documented-only | qv props / cable deferred backlog | 후순위 |
| `docs/HACK_ARENA_TILES_ATLAS_REGION_MAPPING.md` | Documented-only | hacking arena tile atlas plan | TileSet / wiring 없음 |
| `docs/HACK_AVATAR_SPRITESHEET_IMPORT_GUIDE.md` | Documented-only | hacking avatar spritesheet guide | asset 없음 |
| `docs/HACK_ENEMIES_ATLAS_REGION_MAPPING.md` | Documented-only | hacking enemies atlas plan | AI / spawn wiring 없음 |
| `docs/HACK_OBJECTS_ATLAS_REGION_MAPPING.md` | Documented-only | hacking objects atlas plan | objective wiring 없음 |
| `docs/HACK_FX_ATLAS_REGION_MAPPING.md` | Documented-only | hacking FX atlas plan | FX trigger 없음 |
| `docs/UI_COMMON_ATLAS_MAPPING.md` | Documented-only | common UI atlas plan | Theme 없음 |
| `docs/UI_HUD_ATLAS_MAPPING.md` | Documented-only | HUD atlas plan | HUD scene wiring 없음 |
| `docs/UI_PHONE_ATLAS_MAPPING.md` | Documented-only | Phone UI atlas plan | current PhoneUI unchanged |
| `docs/UI_OUTLET_ATLAS_MAPPING.md` | Documented-only | Outlet UI atlas plan | current OutletMode unchanged |
| `docs/UI_RESULT_LOG_ATLAS_MAPPING.md` | Documented-only | Result / log UI atlas plan | current DayResultPanel unchanged |
| `docs/UI_DIALOGUE_ATLAS_MAPPING.md` | Documented-only | Dialogue UI atlas plan | dialogue system 없음 |
| `docs/UI_DEVICE_ICONS_ATLAS_MAPPING.md` | Documented-only | device icon atlas plan | icon wiring 없음 |
| `docs/YUI_ANIMATION_NOTES.md` | Current / Main-only | current Yui top-view animation notes | qv spritesheet와 구분 |

## 6. Prototype / Sandbox 문서

| Path | 현재성 | 짧은 설명 | 비고 |
| --- | --- | --- | --- |
| `docs/PROTOTYPE_HUB.md` | Prototype-only | PrototypeHub scene path / controls | production entry 아님 |
| `docs/PROTOTYPE_HUB_OVERVIEW.md` | Prototype-only | Hub entries overview | production entry 아님 |
| `docs/PROTOTYPE_COMMON_RULES.md` | Prototype-only | prototype input / back / debug rules | Main rules 아님 |
| `docs/PROTOTYPE_GUI_PLAYTEST_CHECKLIST.md` | Prototype-only | prototype GUI manual checklist | headless 검증 대체 아님 |
| `docs/QUARTERVIEW_GAMEPLAY_SANDBOX.md` | Sandbox-only | QuarterviewGameplaySandbox scope | production wiring 아님 |
| `docs/QUARTERVIEW_GAMEPLAY_SANDBOX_FLOW_CHECK.md` | Sandbox-only | sandbox flow check notes | Main flow 아님 |
| `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md` | Current gate | Main replacement Go / No-Go checklist | 승인 전 교체 금지 |
| `docs/MAIN_REPLACEMENT_WORK_PLAN.md` | Current gate | Main replacement strategy / phase plan | start scene 변경 전 확인 |

## 7. docs/old

`docs/old`는 과거 기록이다. 현재 source of truth가 아니다.

| Path | 현재성 | 설명 | 비고 |
| --- | --- | --- | --- |
| `docs/old/ASSET_APPLICATION_NOTES_20260619.md` | Archived | 이전 asset application notes | 현재 asset 정책은 최신 docs 우선 |
| `docs/old/PROJECT_STATUS_20260619.md` | Archived | 이전 project status archive | 현재 status 아님 |
| `docs/old/UI_VISUAL_IMPLEMENTATION_NOTES_20260619.md` | Archived | 이전 UI visual implementation notes | 현재 UI notes와 identity 우선 |
| `docs/old/PROJECT_STATUS_20260628_01.md` | Archived | 로테이션 전 누적 `PROJECT_STATUS.md` | 자세한 과거 기록 보존 |

## 8. deprecated 후보 / 충돌 후보

이번 작업에서는 각 문서에 deprecated notice를 붙이지 않는다. 아래는 검토 후보 목록이다.

| Path | 이유 | 충돌 가능성 | 추천 후속 조치 |
| --- | --- | --- | --- |
| `docs/CONCENT_GAME_SPEC.md` | 오래된 상위 game spec일 수 있음 | identity의 mouse-click room / power board / hacking split과 충돌 가능 | 내용 확인 후 keep / update / deprecated notice 판단 |
| `docs/PROJECT_DIRECTION_REVISED.md` | 이전 상위 방향 요약 | "해킹 액션 미구현", "쿼터뷰 미구현" 등 일부 문구가 최신 candidate / prototype 상태와 다를 수 있음 | identity 기준으로 notice 추가 검토 |
| `docs/IMPLEMENTATION_ROADMAP_REVISED.md` | 이전 roadmap | 현재 QuarterviewMain / sandbox / atlas 문서 상태와 순서가 다를 수 있음 | 최신 roadmap으로 갱신할지 검토 |
| `docs/DAILY_LOOP_REVISED.md` | 하루 루프 방향 문서 | 최신 hacking / power / hunger 방향과 일부 재정렬 필요 가능 | identity와 맞춰 review |
| `docs/GODOT_DAY1_MVP_PLAN.md` | DAY1 MVP 기준 | Main-only 기준은 유효하지만 QuarterviewMain 방향과 섞이면 혼란 가능 | Main-only label 유지 여부 검토 |
| `docs/DAY1_CONTENT_BRIEF.md` | DAY1 content 기준 | 기존 Light / Fan / multitap 방향과 future power board 방향이 충돌 가능 | current Main-only로 명확히 표시할지 검토 |
| `docs/ROOM_DEVICE_DIRECTION.md` | room device direction | 최신 modular power board 방향과 비교 필요 | 통합 또는 notice 검토 |
| `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md` | top-view Main visual 누적 notes | Quarterview / new UI atlas 방향과 혼동 가능 | Main-only notice 검토 |
| `docs/ASSET_APPLICATION_NOTES.md` | current applied asset notes | future asset / atlas 계획과 혼동 가능 | applied-current 범위 명시 검토 |
| `docs/VISUAL_DIRECTION.md` | old broad visual direction일 수 있음 | 최신 room / power / hacking direction과 충돌 가능 | identity 기준 review |

## 9. Non-goals

- 기존 문서 삭제 없음.
- 기존 세부 문서 대량 이동 없음.
- `docs/old` 삭제 없음.
- deprecated notice 부착 없음.
- 문서 내용을 새 기준에 맞게 전부 다시 쓰지 않음.
