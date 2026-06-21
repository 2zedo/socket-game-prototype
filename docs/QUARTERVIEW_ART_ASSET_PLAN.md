# 쿼터뷰 아트 에셋 계획

## 목적

이 문서는 쿼터뷰 방 전환을 검토할 때 필요한 이미지 에셋의 종류와 관리 방식을 정리한다.

현재 작업은 계획 문서화다. 실제 이미지 파일, Godot Resource, import 파일, scene 구조는 만들지 않는다. 현재 `QuarterviewRoomPrototype.tscn`은 placeholder 도형으로 구도, 이동, 충돌, 가림, 상호작용 지점을 검증하는 단계다.

## 기본 원칙

- 최종 게임용 쿼터뷰 방은 한 장짜리 배경 이미지로 끝내지 않는다.
- 방향성 확인용 콘티 이미지는 분위기 참고로만 사용하고, 실제 게임 적용은 분리 에셋 구조를 우선한다.
- 방 구조, 가구, 장치, 캐릭터, FX를 분리해서 관리한다.
- 오브젝트는 scene / node로 분리하고, 이미지는 가능한 atlas나 spritesheet로 묶는다.
- 작은 장치 상태 이미지는 개별 PNG로 계속 늘리기보다 atlas region 또는 overlay로 관리한다.
- 캐릭터 이동은 spritesheet 기반으로 관리한다.
- 비주얼 에셋은 gameplay 상태, collision, interaction range와 분리해 교체 가능하게 둔다.
- collision과 interaction range는 이미지의 알파나 보이는 경계에 의존하지 않고 별도 노드나 데이터로 관리한다.

## 추천 폴더 구조

아래 파일은 이번 작업에서 생성하지 않는다. 쿼터뷰 전환 단계에서 만들 에셋 계획이다.

```text
godot/assets/art/quarterview/
  room/
    qv_floor_base.png
    qv_wall_back.png
    qv_wall_side.png
    qv_wall_front_overlay.png
    qv_window.png
    qv_door.png
    qv_fluorescent_light.png

  atlases/
    qv_furniture_atlas.png
    qv_devices_atlas.png
    qv_props_atlas.png
    qv_fx_atlas.png

  appliances/
    qv_fridge.png
    qv_microwave.png
    qv_aircon.png

  character/yui/
    yui_qv_idle_4dir.png
    yui_qv_walk_4dir.png
```

## 우선순위

### P0: 현재 prototype 단계

- 실제 이미지가 필요 없다.
- placeholder 도형으로 이동, 충돌, 가림, 상호작용을 확인한다.
- `QuarterviewRoomPrototype.tscn`에서 구조와 비율을 먼저 검증한다.
- 이 단계에서는 최종 아트 품질보다 배치 조정 가능성과 기능 대응 관계가 중요하다.

### P1: Main 교체 검토 전 최소 필요

#### Room shell

- `floor`
- `wall back`
- `wall side`
- `wall front overlay`
- `window`
- `door`
- `fluorescent light`

방 shell은 쿼터뷰 공간감을 결정하므로 우선순위가 높다. 단, collision과 interaction은 이미지 자체가 아니라 별도 gameplay 노드로 유지한다.

#### Furniture atlas

- `bed`
- `desk`
- `chair`
- `shelf`
- `small cabinet`

침대와 책상은 유이의 하루 루프와 직접 연결된다. 침대는 수동 하루 종료, 책상은 노트북 작업 공간으로 읽혀야 한다.

#### Devices atlas

- `laptop_off`
- `laptop_on`
- `phone_idle`
- `phone_charging`
- `charger`
- `power_strip_empty`
- `power_strip_active`
- `communication_device_off`
- `communication_device_on`
- `node17_off`
- `node17_on`
- `node17_signal`

작은 장치의 on/off 상태는 개별 PNG를 난발하지 않고, `qv_devices_atlas.png` 안의 region이나 overlay로 관리하는 방향을 우선한다.

#### Appliances

- `fridge`
- `microwave`
- `air conditioner`

큰 가전은 atlas보다 개별 PNG가 자연스러울 수 있다. 냉장고, 전자레인지, 에어컨은 벽 전원 / 전용 회로 장치로 읽히는 크기와 위치가 필요하다.

#### Character

- `yui idle 4dir`
- `yui walk 4dir`

유이는 방 안에서 실제로 걸어 다니는 크기여야 하며, 쿼터뷰 시점에 맞는 발밑 기준과 방향별 실루엣이 필요하다.

#### FX atlas

- `shadow`
- `warm glow`
- `blue window glow`
- `screen glow`

FX는 조명 상태와 장치 활성 상태를 보여주되 gameplay 상태와 분리한다.

### P2: 상태 표현 보강

- `signal_booster_off`
- `signal_booster_on`
- `ups_idle`
- `ups_charging`
- `ups_full`
- `speaker_off`
- `speaker_on`
- `node17_signal_pulse`
- `microwave_running_overlay`
- `aircon_wind_fx`
- `device_led_variants`
- `props atlas`

P2는 상태 표현을 강화하는 단계다. 장치가 늘어날수록 개별 PNG보다 atlas region과 overlay 조합을 우선 검토한다.

### P3: 분위기 / 개성 강화

- cat ornament
- posters
- stickers
- dust particles
- Yui desk sitting pose
- extra decoration props

P3는 방의 개성과 밀도를 높이는 단계다. 이 단계의 장식은 플레이어가 주요 상호작용 대상을 읽는 데 방해되지 않아야 한다.

## Atlas 기준

개별 PNG 목록은 논리적 설명을 위한 이름일 수 있다. 실제 운영에서는 작은 장치와 상태 변화 이미지를 아래처럼 묶는 방향을 우선한다.

```text
qv_devices_atlas.png
- laptop_off
- laptop_on
- node17_off
- node17_on
- node17_signal
- speaker_off
- speaker_on
- ups_idle
- ups_charging
- ups_full
```

핵심 기준은 아래와 같다.

```text
오브젝트는 분리한다.
이미지는 가능한 atlas로 묶는다.
상태 변화는 atlas region 또는 overlay로 관리한다.
```

예를 들어 노트북은 `Laptop` scene / node로 분리하되, off / on 이미지는 같은 atlas의 region으로 관리할 수 있다. NODE-17도 하나의 gameplay 오브젝트로 두고, off / on / signal 상태만 atlas region 또는 pulse overlay로 바꾼다.

## 개별 PNG가 허용되는 경우

아래 경우에는 개별 PNG도 허용한다.

- 방 구조 레이어
- 큰 가전
- 큰 고유 오브젝트
- 임시 prototype 확인용 이미지
- atlas로 묶기 전 초기 테스트 에셋

단, 작은 장치 상태가 늘어나는 경우는 atlas 우선이다. 예를 들어 `node17_off.png`, `node17_on.png`, `node17_signal.png`를 장기적으로 계속 개별 파일로 늘리는 것보다 `qv_devices_atlas.png` 안에서 region으로 관리하는 쪽을 우선 검토한다.

## Godot Resource 매핑 후보

나중에 쿼터뷰 비주얼을 gameplay Resource와 분리하기 위해 아래 같은 visual mapping Resource를 검토한다.

```text
godot/resources/visuals/quarterview/
  qv_room_visuals.tres
  qv_device_visuals.tres
  qv_object_visuals.tres
```

예시 매핑:

```text
laptop:
  off: qv_devices_atlas / laptop_off
  on: qv_devices_atlas / laptop_on

node17:
  off: qv_devices_atlas / node17_off
  on: qv_devices_atlas / node17_on
  signal: qv_devices_atlas / node17_signal

phone:
  idle: qv_devices_atlas / phone_idle
  charging: qv_devices_atlas / phone_charging

room:
  floor: qv_floor_base.png
  wall_back: qv_wall_back.png
  wall_side: qv_wall_side.png
  wall_front_overlay: qv_wall_front_overlay.png
```

이번 작업에서는 위 Resource를 만들지 않는다. 실제 Resource 구조는 prototype 검증 후, 기존 `DeviceDefinition` gameplay Resource와 충돌하지 않도록 별도로 설계한다.

## 현재 구현과의 구분

- 현재 구현: 탑뷰 Apartment와 독립 쿼터뷰 placeholder prototype
- 현재 쿼터뷰 단계: 이미지 없이 도형으로 공간과 기능 대응을 검증
- 장기 방향: atlas / spritesheet / room layer 기반 아트 구조
- 이번 작업에서 하지 않음: 이미지 생성, atlas 생성, Resource 생성, scene 수정, import 파일 추가

## 다음 확인 기준

- `QuarterviewRoomPrototype.tscn`의 placeholder 배치가 P1 room shell과 furniture atlas로 교체 가능한 구조인지 확인한다.
- Yui 쿼터뷰 spritesheet는 캐릭터 크기와 발밑 기준을 먼저 고정한 뒤 제작한다.
- 장치 상태가 늘어나는 시점에는 개별 PNG 추가보다 `qv_devices_atlas.png`와 overlay 구조를 먼저 검토한다.
- 실제 Main 교체 전에는 `docs/QUARTERVIEW_APARTMENT_MAPPING.md`와 이 문서를 함께 확인한다.
