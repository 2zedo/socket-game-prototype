# Git LFS / 에셋 관리 정책

## 목적

이 문서는 `CONCENT / 전력 부족의 시대` Godot 프로젝트에서 Git LFS를 언제 도입할지, 어떤 에셋을 일반 Git으로 관리할지, Godot import metadata와 외부 Asset Library 원본 폴더를 어떻게 다룰지 정리한다.

이번 문서는 정책 정리다. 이 작업에서는 `git lfs install`, `git lfs track`, `.gitattributes` 생성 / 수정, 기존 파일 LFS 마이그레이션을 하지 않는다.

## 현재 Repo 에셋 상태

현재는 prototype용 SFX와 input prompt icon이 선별 적용되기 시작한 단계다. 본격적인 쿼터뷰 room shell, atlas, spritesheet, 장기 audio pack은 아직 들어오지 않았다.

### 커밋된 에셋 개요

- `godot/assets/art/`: 현재 DAY 1 / prototype에 쓰이는 PNG 중심 아트가 관리된다.
- `godot/assets/audio/third_party/kenney/`: Kenney SFX 중 prototype에서 쓰는 소형 `.wav`만 선별 복사되어 있다.
- `godot/assets/ui/third_party/kenney/input_prompts/`: Kenney Input Prompts 중 prototype UI에 쓰는 소형 `.png`만 선별 복사되어 있다.
- `godot/addons/gut/`: GUT 테스트 addon과 addon 내부 font / icon 파일이 관리된다.
- `godot/assets/**/*.png.import`, `godot/assets/**/*.wav.import`, `godot/scripts/**/*.gd.uid`: 실제 tracked source asset / script에 대응하는 Godot source-side metadata는 함께 관리된다.

### 현재 1MB 이상 tracked 후보

현재 tracked 파일 중 1MB 이상인 파일은 대부분 기존 PNG 아트다. 대표 예시는 아래와 같다.

| 파일 | 대략 크기 | 비고 |
| --- | ---: | --- |
| `godot/assets/art/environment/room/room_floor_base.png` | 2.68 MiB | 현재 room underlay |
| `godot/assets/art/objects/outlet/outlet_slot_active.png` | 1.92 MiB | outlet UI |
| `godot/assets/art/maps/apartment/apartment_map_reference.png` | 1.89 MiB | reference / map art |
| `godot/assets/art/maps/apartment/map_base_no_wires.png` | 1.84 MiB | current apartment base |
| `godot/assets/art/objects/outlet/outlet_slot_empty.png` | 1.79 MiB | outlet UI |
| `godot/assets/art/portraits/yui/yui_portrait_neutral.png` | 1.63 MiB | Yui portrait |
| `godot/assets/art/objects/powerstrip/adapters/adapter_2slot_laptop-Photoroom.png` | 1.62 MiB | adapter art |
| `godot/assets/art/characters/yui/yui_source_sheet.png` | 1.42 MiB | Yui source sheet |

이 파일들은 이미 일반 Git에 들어온 상태다. 이번 정책 작업에서는 기존 파일을 LFS로 마이그레이션하지 않는다.

### 현재 local installed / untracked 에셋

아래 Asset Library 원본 폴더는 설치되어 있으나 전체를 커밋하지 않는다.

| 경로 | 대략 크기 | 현재 처리 |
| --- | ---: | --- |
| `godot/addons/kenney_input_prompts/` | 24 MiB | 원본 addon 전체는 local installed / not committed |
| `godot/addons/kenney_particle_pack/` | 5.4 MiB | local installed / not committed |
| `godot/addons/kenney_interface_sounds/` | 3.8 MiB | selected SFX만 `godot/assets/audio/...`로 복사 |
| `godot/addons/kenney_ui_audio/` | 2.6 MiB | selected SFX만 `godot/assets/audio/...`로 복사 |
| `godot/addons/kenney_prototype_textures/` | 792 KiB | local installed / not committed |
| `godot/addons/simplelicense/` | 324 KiB | local installed / not committed |

현재 untracked 상태에는 원본 addon 폴더, `godot/LICENSE.txt`, `godot/licenses/`, 일부 unrelated `.wav.import`, `godot/scripts/prototypes/PrototypeSfx.gd.uid`, 기존 unrelated `godot/scripts/Apartment.gd` local change가 남아 있다. 이번 정책과 무관하므로 stage하지 않는다.

### 현재 관리 중인 외부 에셋

프로젝트 관리 경로로 선별 복사된 외부 에셋은 아래와 같다.

- `godot/assets/audio/third_party/kenney/interface/*.wav`
- `godot/assets/audio/third_party/kenney/ui/*.wav`
- `godot/assets/audio/third_party/kenney/LICENSES/*.txt`
- `godot/assets/ui/third_party/kenney/input_prompts/*.png`
- `godot/assets/ui/third_party/kenney/input_prompts/*.png.import`
- `godot/assets/ui/third_party/kenney/LICENSES/kenney_input_prompts_LICENSE.txt`

이 파일들은 작은 prototype용 선별 에셋이므로 현재는 일반 Git으로 유지한다.

## 지금 당장 LFS를 적용하지 않는 이유

- 현재는 prototype용 소형 SFX와 input prompt icon 선별 파일만 추가된 상태다.
- 전체 쿼터뷰 아트 / audio / atlas 규모가 아직 확정되지 않았다.
- 성급히 LFS를 적용하면 기존 PNG 파일 마이그레이션, `.gitattributes`, 팀 로컬 환경 설정, GitHub LFS quota 확인이 한 번에 엮인다.
- 현재 repo에는 이미 1MB 이상 PNG가 일부 tracked 상태이므로, 기존 파일을 LFS로 옮길지 여부를 별도 판단해야 한다.
- 먼저 이 정책을 기준으로 운영하고, P1 쿼터뷰 아트 제작이 시작될 때 실제 적용 여부를 결정한다.

## LFS 후보 파일

앞으로 아래 파일은 LFS 후보로 본다.

- 큰 PNG atlas
- 큰 spritesheet
- 대용량 `.wav`, `.ogg`, `.mp3`
- 원본 작업 파일
  - `.aseprite`
  - `.psd`
  - `.kra`
  - `.blend`
- 영상 / 녹화 파일
- 대형 texture pack

예상 track 후보 패턴:

```text
*.png
*.wav
*.ogg
*.mp3
*.aseprite
*.psd
*.kra
*.blend
*.mp4
*.mov
```

단, 이번 작업에서는 위 패턴을 `.gitattributes`에 추가하지 않는다.

## 일반 Git 유지 후보

아래 파일은 현재 기준으로 일반 Git 유지가 가능하다.

- 작은 prototype icon
- 작은 UI PNG
- 작은 license `.txt` / `.md`
- `.gd` script
- `.tscn` scene
- `.tres` Resource
- `docs/*.md`
- source-side `.import` / `.uid` 중 실제 tracked source file에 대응하는 metadata

단, 작은 PNG나 audio라도 크기와 개수가 늘어나면 LFS 후보로 재검토한다.

## Godot `.import` / `.uid` 기준

Godot source-side metadata는 무조건 버리거나 무조건 stage하지 않는다.

- 실제로 프로젝트가 사용하는 에셋의 `.import` 파일은 보통 함께 관리 후보로 본다.
- 실제로 프로젝트가 사용하는 `.gd` / Resource에 대응하는 `.uid`는 함께 관리 후보로 본다.
- unrelated 자동 생성 `.import` / `.uid`는 작업 범위 밖이면 stage하지 않는다.
- Godot이 생성한 파일이라도 어떤 원본 에셋과 대응되는지 확인한 뒤 stage한다.
- 원본 addon 전체 import 결과를 무작정 stage하지 않는다.
- `godot/.godot/` 아래 editor/import cache는 계속 commit 금지다.

## 외부 Asset Library 원본 폴더 기준

최근 받은 Asset Library 에셋은 원본 addon 전체를 바로 커밋하지 않는다.

- `godot/addons/kenney_*` 원본 폴더는 현재 local installed 상태로 구분한다.
- 실제 사용하는 파일만 `godot/assets/...` 아래 프로젝트 관리 경로로 선별 복사한다.
- 선별 복사한 파일, 해당 source-side `.import`, 필요한 license evidence만 commit 대상으로 본다.
- 원본 addon 전체는 별도 vendor-assets 결정이 있기 전까지 stage하지 않는다.
- 외부 에셋 설치 / 라이선스 / 실제 사용 여부는 `docs/THIRD_PARTY_ASSET_INVENTORY.md`에서 추적한다.

## 실제 LFS 도입 시점

아래 조건 중 하나 이상이 되면 Git LFS 적용 작업을 별도로 진행한다.

- P1 쿼터뷰 room shell / atlas / character spritesheet 제작 시작
- audio 파일 수가 늘어나고 용량이 커짐
- atlas / spritesheet가 1MB 이상 파일로 다수 생김
- 원본 작업 파일 `.aseprite`, `.psd`, `.kra`, `.blend` 등을 repo에 보관하기로 결정
- repo 용량 증가가 체감되기 시작함
- GitHub LFS quota를 확인하고 관리 비용을 받아들일 수 있음

## 실제 도입 시 별도 작업에서 할 일

나중에 LFS 도입 작업을 진행할 때만 아래를 검토한다.

```bash
git lfs install
git lfs track "*.png"
git lfs track "*.wav"
git lfs track "*.ogg"
git lfs track "*.aseprite"
git add .gitattributes
```

도입 전 필수 확인:

- 기존 파일 마이그레이션 여부 별도 판단
- GitHub / remote LFS quota 확인
- 팀 / 로컬 환경에서 `git lfs` 설치 확인
- 작업 전 백업 또는 별도 branch 분리
- `.gitattributes` diff와 staged 파일 범위 확인
- 기존 binary history rewrite 여부를 절대 즉흥 결정하지 않음

## 현재 결론

현재 repo 상태에서는 Git LFS를 즉시 적용하지 않는다.

작은 prototype용 SFX / input prompt icon은 일반 Git으로 유지한다. P1 쿼터뷰 아트와 큰 atlas / spritesheet / audio가 본격적으로 들어오기 시작하면, 이 문서를 기준으로 별도 Git LFS 도입 작업을 진행한다.
