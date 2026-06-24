# Quarterview Room Shell Prototype

## 목적

`QuarterviewRoomShellPrototype`은 room shell layer를 실제 방 scene에 적용하기 전에 `1920x1080` same-canvas 기준으로 확인하는 visual prototype이다.

현재는 floor base, back wall, side wall layer를 확인한다. Main / DAY 1, `QuarterviewGameplaySandbox`, `QuarterviewPerspectiveBlockout`에는 연결하지 않는다.

Window city view layer is not yet applied. A future prototype step will add `qv_room_window_city_view.png` after floor / back / side validation.

Foreground occluder layer is not yet applied. A future prototype step will add `qv_room_foreground_occluders.png` after floor / back / side validation.

## Scene Path

- `res://scenes/prototypes/QuarterviewRoomShellPrototype.tscn`

## Expected Asset Paths

```text
res://assets/rooms/quarterview/shell/qv_room_floor_base.png
res://assets/rooms/quarterview/shell/qv_room_walls_back.png
res://assets/rooms/quarterview/shell/qv_room_walls_side.png
```

이번 작업에서는 PNG를 추가하지 않는다. 파일이 이미 존재하면 prototype이 runtime에서 로드하고, 없으면 missing 상태를 표시한다.

## Scene Structure

```text
QuarterviewRoomShellPrototype
  WorldRoot
    RoomShellRoot
      FloorLayer
      BackWallLayer
      SideWallLayer
      FloorFallback
      FutureLayerGuide
    ReferenceGuideRoot
      CanvasBounds
      CenterGuide
  UILayer
    TitleLabel
    StatusLabel
    LayerStatusLabel
    HelpLabel
```

`RoomShellRoot`는 `1920x1080` 기준 canvas다. scene script가 viewport에 맞춰 canvas 전체를 스케일해 보여 주지만, floor / back wall / side wall layer 자체의 기준 좌표와 크기는 `1920x1080`으로 유지한다.

Layer order:

| Layer | z-index | Purpose |
| --- | --- | --- |
| `FloorLayer` | `0` | floor base |
| `BackWallLayer` | `10` | back wall shell |
| `SideWallLayer` | `15` | side wall shell |
| `FutureLayerGuide` | `100` | future layer guide / debug overlay |

## Controls

| Input | Behavior |
| --- | --- |
| `1` | floor layer visibility toggle |
| `2` | back wall layer visibility toggle |
| `3` | side wall layer visibility toggle |
| `B` / `Backspace` | `PrototypeHub`로 복귀 |
| `R` | 현재 prototype reload |
| `D` | guide overlay 표시 / 숨김 |

새 project input action은 추가하지 않는다. 기존 prototype 공통 helper인 `PrototypeSceneUtils`를 사용한다.

## Loaded / Missing Behavior

asset이 있으면:

- 해당 layer의 `TextureRect`에 texture를 표시한다.
- `LayerStatusLabel`에 loaded 상태, image size, expected size, canvas match 여부를 표시한다.

asset이 없으면:

- 해당 layer는 숨긴다.
- floor가 없으면 `FloorFallback`을 표시한다.
- `LayerStatusLabel`에 missing path를 표시한다.
- scene은 깨지지 않는다.

asset이 `1920x1080`이 아니면:

- 표시는 유지한다.
- `LayerStatusLabel`에 size warning을 표시한다.
- scene을 실패시키지 않는다.

## Guide Overlay

`D` toggle guide는 아래 확인을 돕는다.

- `1920x1080` canvas bounds
- center cross
- rough safe area guide
- future layer placement hints for window, foreground occluder, lighting overlay

Guide는 실제 room shell art가 아니다.

## PrototypeHub 등록

`PrototypeHub`에는 아래 항목으로 등록한다.

```text
key: quarterview_room_shell_prototype
title: Quarterview Room Shell Prototype
shortcut: 7 / S
scene_path: res://scenes/prototypes/QuarterviewRoomShellPrototype.tscn
```

## Next Steps

1. `qv_room_floor_base.png`, `qv_room_walls_back.png`, `qv_room_walls_side.png` 실제 asset 추가
2. floor / back wall / side wall alignment 확인
3. `qv_room_window_city_view.png` layer 추가 prototype
4. foreground / lighting 순서로 확장
5. `QuarterviewPerspectiveBlockout` 또는 별도 `RoomShellPrototype`으로 통합 검토

## 이번 단계에서 하지 않는 것

- PNG asset 추가
- placeholder PNG 생성
- 이미지 변환 / 리사이즈
- production scene 적용
- Main / DAY 1 배경 교체
- `QuarterviewGameplaySandbox` 기능 연결
- collision / object anchor 조정
- window / foreground / lighting layer 적용
