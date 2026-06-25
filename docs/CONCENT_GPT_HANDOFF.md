# CONCENT GPT Handoff

이 문서는 새 ChatGPT / Codex 세션에서 `CONCENT / 전력 부족의 시대` 작업을 이어받을 때 붙여넣어 쓰기 위한 인계 문서다. repo 구조, 현재 Quarterview 진행 상태, asset 배치 규칙, 다음 작업 방향을 추측하지 않도록 실제 현재 구조를 기준으로 요약한다.

## 1. 프로젝트 개요

- 게임명: `CONCENT / 전력 부족의 시대`
- 장르: 작은 방에서 제한된 전력을 관리하며 살아남는 2D 내러티브 생존 어드벤처
- 핵심 컨셉: THE GRID 하층 주거구의 좁은 1인실에서 전력, 정보, 생존, 관계, 위험 사이의 선택을 다룬다.
- 현재 안정 경로: 기존 `godot/scenes/Main.tscn` / DAY1 탑뷰 흐름
- 현재 새 작업 우선순위: 기존 Main을 바로 갈아엎는 것이 아니라, 새 본방 후보 `QuarterviewMain`을 구축하고 검증하는 것
- 기존 Main / Apartment / DAY1은 당장 삭제하지 않는다. legacy / reference / rollback 기준으로 유지한다.
- `project.godot` start scene은 아직 QuarterviewMain으로 바꾸지 않는다.

## 2. Repo 작업 규칙

AGENTS.md 기준 핵심 요약:

- 기본 작업 브랜치: `main`
- 작업 시작 전 확인:

```bash
git status --short --branch
git rev-parse --short HEAD
git fetch origin
git log --oneline HEAD..origin/main
```

- `origin/main`에 새 commit이 있으면 pull / merge / rebase하지 말고 중단 보고한다.
- `git add .` 금지.
- unrelated local change는 stage하지 않는다.
- raw Asset Library addon folder는 stage하지 않는다.
- unrelated `.import`, `.uid`, generated cache, `godot/.godot/`는 stage하지 않는다.
- `.tscn`을 텍스트로 추측 수정하지 않는다.
- scene / UI 작업은 가능하면 Godot Editor 또는 Godot AI MCP로 hierarchy / node path / property를 먼저 확인한다.
- Godot AI MCP가 불가능하면 그 사실을 보고하고 filesystem 확인과 headless validation으로 보수적으로 진행한다.
- 문서 전체 재작성 금지. 필요한 문서만 최소 수정한다.

주의해야 할 현재 unrelated local 상태:

- `godot/scripts/Apartment.gd`가 modified 상태로 남아 있을 수 있다. 현재 작업과 무관하면 절대 stage하지 않는다.
- `godot/addons/kenney_*`, `godot/addons/simplelicense/` 같은 raw addon folder가 untracked일 수 있다. stage하지 않는다.
- `godot/LICENSE.txt`, `godot/licenses/`, audio `.wav.import`, 여러 `.gd.uid`, test `.uid`가 untracked일 수 있다. 명시 작업 전까지 stage하지 않는다.

## 3. 실제 폴더 구조

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

현재 `godot/assets/art/` 하위 실제 구조:

```text
godot/assets/art/
  characters/yui/idle/
  characters/yui/walk/
  environment/room/
  maps/apartment/
  maps/apartment/wires/
  objects/comm_device/
  objects/fan/
  objects/laptop/
  objects/light/
  objects/outlet/
  objects/phone/
  objects/powerstrip/
  objects/powerstrip/adapters/
  overlays/lighting/
  portraits/yui/
  ui/badges/
  ui/icons/
  ui/panels/
```

현재 `godot/assets/art/quarterview/`는 없을 수 있다. 새 콘티 / reference / room background를 넣을 때는 존재하지 않는 `godot/assets/images/` 같은 경로를 전제로 삼지 말고, 실제 구조에 맞춰 `godot/assets/art/quarterview/...`를 만들어 사용하는 방향이 적절하다.

현재 추천 경로:

```text
godot/assets/art/quarterview/reference/qv_room_concept_reference.png
godot/assets/art/quarterview/room/temp_qv_room_background.png
```

구분:

- 인물(Yui/person)이 포함된 콘티 이미지는 production background가 아니라 `reference/qv_room_concept_reference.png`로 두고 낮은 opacity overlay로 사용한다.
- 실제 runtime 임시 방 배경으로 쓰는 이미지라면 인물 / UI / 설명 라벨을 제거한 뒤 `room/temp_qv_room_background.png`로 둔다.

## 4. Quarterview 현재 상태

관련 scene / script:

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

현재 구현된 기능:

- `QuarterviewMain.tscn`은 단독 실행 가능한 본방 후보 scene이다.
- `QuarterviewMain.gd`는 `QuarterviewRoom`의 `interaction_requested`와 `nearest_interactable_changed` signal을 받는다.
- 현재 `QuarterviewMain`은 object key / role / action을 status/log에 표시만 한다.
- `QuarterviewMain`에서 `R`은 scene restart다.
- `B` / `Backspace` PrototypeHub 복귀는 본방 후보에는 넣지 않는다.
- `QuarterviewRoom.tscn`은 아래 레이어 구조를 가진다.

```text
FloorLayer
WallBackLayer
WallSideLayer
ObjectBackLayer
ObjectLayer
PlayerLayer
ForegroundLayer
DebugLayer
PromptLayer
```

- `QuarterviewRoom.gd`는 `RoomObjectDefinition` resources를 읽어 key / role / display_name / interaction data를 사용한다.
- 현재 visual은 polygon / placeholder blockout 기반이며, 이는 임시다.
- player placeholder 이동은 `QuarterviewPlayer.gd`가 담당한다.
- 이동: `WASD` / 방향키
- prompt: 가까운 object가 있으면 `[E] DisplayName`
- interaction: `E` / Enter 입력 시 `interaction_requested(object_key, "primary", payload)` emit
- debug overlay: `D`로 `DebugLayer` 표시 / 숨김
- debug overlay에는 object label, interaction radius, collision / blocker guide가 들어간다.
- production Phone / Outlet / Result / SurvivalState는 아직 연결하지 않았다.

## 5. 현재 하면 안 되는 작업

- `godot/project.godot` start scene 변경 금지
- 기존 `Main.tscn`, `Main.gd`, `Apartment.gd`, `Player.gd`, `SurvivalState.gd` 삭제 또는 무리한 수정 금지
- 기존 PhoneUI / OutletMode / DayResultPanel production flow에 바로 연결 금지
- Hacking mission 연결 금지
- Grid Credit / story flag / save-load 연결 금지
- qv atlas 전체 적용 금지
- 실제 atlas PNG / mapping Resource 대량 생성 금지
- 이미지 레이어를 한 번에 많이 생성하거나 적용하지 말 것
- polygon blockout을 계속 “예쁜 방 아트”로 다듬는 데 시간을 쓰지 말 것

## 6. 현재 이미지 / 콘티 작업 방향

현재 판단:

- polygon blockout으로 방을 예쁘게 만드는 방향은 중단한다.
- 우선 콘티 이미지 1장을 `QuarterviewRoom` 배경 또는 reference overlay로 깔고, invisible wall / interaction area를 얹는 방식으로 진행한다.
- Godot 작업은 이미지 생성이 아니라 적용 구조, visibility, collision, interaction 정리에 집중한다.
- 기본 화면은 “방 배경 + player + 최소 prompt/status”만 보이게 한다.
- polygon / blockout object / label / interaction radius / collision guide는 기본 화면에서 숨기고, `D` debug overlay ON일 때만 보이게 한다.

추천 asset 배치:

```text
godot/assets/art/quarterview/reference/qv_room_concept_reference.png
godot/assets/art/quarterview/room/temp_qv_room_background.png
```

적용 기준:

- `temp_qv_room_background.png`가 있으면 기본 visible background로 사용한다.
- `qv_room_concept_reference.png`만 있으면 낮은 opacity reference overlay로 사용한다.
- 콘티 이미지 안에 이미 Yui/person이 포함되어 있으면 production background처럼 쓰지 말고 reference overlay로만 사용한다.
- 실제 final room shell PNG는 나중에 별도 작업에서 `qv_room_floor_base.png`, `qv_room_walls_back.png`, `qv_room_walls_side.png` 등으로 분리한다.

현재 repo에는 `godot/assets/art/quarterview/`가 아직 없을 수 있다. 새 세션에서 이미지 적용을 요청받으면 먼저 해당 파일 존재 여부를 확인하고, 없으면 임의 생성하지 말고 보고한다.

## 7. 다음 구현 작업 후보

1. 콘티 이미지를 `QuarterviewRoom` 배경 또는 reference overlay로 적용한다.
2. 기존 polygon / blockout visual은 기본 화면에서 숨긴다.
3. `D` debug ON일 때만 collision / interaction / object label / polygon blockout을 표시한다.
4. invisible wall과 interaction area를 조정하기 쉬운 구조로 정리한다.
5. player placeholder는 유지하되, 이미지 위에서 크기 / 시작 위치를 조정한다.
6. 이후 production 연결은 `SurvivalState`, `PhoneUI`, `OutletMode`, `DayResultPanel` 순서로 별도 승인 작업에서 진행한다.

## 8. 새 GPT 세션 시작용 문장

아래 문장을 새 ChatGPT 세션의 첫 메시지에 붙여넣고, 그 아래에 이 문서 내용을 함께 붙여넣으면 된다.

```text
이 대화는 Godot 게임 프로젝트 CONCENT / 전력 부족의 시대 작업 이어받기용입니다. 아래 CONCENT_GPT_HANDOFF 내용을 기준으로 답변해 주세요. repo 경로는 추측하지 말고, 이 문서에 적힌 실제 구조를 기준으로만 말해 주세요.
```
