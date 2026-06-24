# Quarterview Room Shell Prototype

## 목적

`QuarterviewRoomShellPrototype`은 `qv_room_floor_base.png`를 실제 방 scene에 적용하기 전에 `1920x1080` same-canvas 기준으로 확인하는 visual prototype이다.

현재는 room shell의 첫 레이어인 floor base만 확인한다. Main / DAY 1, `QuarterviewGameplaySandbox`, `QuarterviewPerspectiveBlockout`에는 연결하지 않는다.

## Scene Path

- `res://scenes/prototypes/QuarterviewRoomShellPrototype.tscn`

## Expected Asset Path

```text
res://assets/rooms/quarterview/shell/qv_room_floor_base.png
```

이번 작업에서는 이 PNG를 추가하지 않는다. 파일이 이미 존재하면 prototype이 runtime에서 로드하고, 없으면 missing placeholder를 표시한다.

## Scene Structure

```text
QuarterviewRoomShellPrototype
  WorldRoot
    RoomShellRoot
      FloorLayer
      FloorFallback
      FutureLayerGuide
    ReferenceGuideRoot
      CanvasBounds
      CenterGuide
  UILayer
    TitleLabel
    StatusLabel
    HelpLabel
```

`RoomShellRoot`는 `1920x1080` 기준 canvas다. scene script가 viewport에 맞춰 canvas 전체를 스케일해 보여 주지만, floor layer 자체의 기준 좌표와 크기는 `1920x1080`으로 유지한다.

## Controls

| Input | Behavior |
| --- | --- |
| `B` / `Backspace` | `PrototypeHub`로 복귀 |
| `R` | 현재 prototype reload |
| `D` | guide overlay 표시 / 숨김 |

새 project input action은 추가하지 않는다. 기존 prototype 공통 helper인 `PrototypeSceneUtils`를 사용한다.

## Loaded / Missing Behavior

asset이 있으면:

- `FloorLayer`에 texture를 표시한다.
- `StatusLabel`에 loaded 상태, image size, expected size, canvas match 여부를 표시한다.

asset이 없으면:

- `FloorFallback`을 표시한다.
- `StatusLabel`과 fallback label에 expected path를 표시한다.
- scene은 깨지지 않는다.

## Guide Overlay

`D` toggle guide는 아래 확인을 돕는다.

- `1920x1080` canvas bounds
- center cross
- rough safe area guide
- future layer placement hints for back wall, side wall, window, foreground occluder, lighting overlay

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

1. `qv_room_floor_base.png` 실제 asset 추가
2. floor alignment 확인
3. `qv_room_walls_back.png` layer 추가 prototype
4. side wall / window / foreground / lighting 순서로 확장
5. `QuarterviewPerspectiveBlockout` 또는 별도 `RoomShellPrototype`으로 통합 검토

## 이번 단계에서 하지 않는 것

- PNG asset 추가
- placeholder PNG 생성
- 이미지 변환 / 리사이즈
- production scene 적용
- Main / DAY 1 배경 교체
- `QuarterviewGameplaySandbox` 기능 연결
- collision / object anchor 조정
