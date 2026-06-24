# Prototype GUI Playtest Checklist

## 목적

이 체크리스트는 본게임 DAY1 플레이테스트가 아니라, 현재 독립 prototype scene들의 GUI / 조작 / SFX / Input Prompt / 시점 blockout 확인용이다.

본게임 확인과 prototype 확인은 섞지 않는다. 기존 기능 prototype과 신규 perspective blockout의 역할을 구분해서 확인한다. `Main.tscn`, DAY1 전력 루프, Phone / Outlet / Result 흐름은 이 문서의 확인 범위가 아니다.

## 사전 조건

- Godot project: `godot/project.godot`
- 최신 `main` 기준으로 확인한다.
- 테스트 전 Godot editor를 재시작해도 좋다.
- GUI 확인은 사용자 수동 확인으로 진행한다.
- Headless startup 통과는 조작감, 시각 가독성, SFX 볼륨을 보장하지 않는다.

확인할 scene 경로:

- `res://scenes/prototypes/PrototypeHub.tscn`
- `res://scenes/prototypes/QuarterviewRoomPrototype.tscn`
- `res://scenes/prototypes/QuarterviewPerspectiveBlockout.tscn`
- `res://scenes/prototypes/HackingActionPrototype.tscn`
- `res://scenes/prototypes/HackingPerspectiveBlockout.tscn`
- `res://scenes/prototypes/TitleMenuPrototype.tscn`
- `res://scenes/prototypes/QuarterviewGameplaySandbox.tscn`
- `res://scenes/prototypes/QuarterviewRoomShellPrototype.tscn`

Main replacement note:

- Before replacing Main, complete `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md` and verify both existing Main / DAY1 and `QuarterviewGameplaySandbox` flows.

## PrototypeHub

- [ ] `PrototypeHub` scene이 정상 실행된다.
- [ ] `Room Object Contract`, `Quarterview Perspective`, `Hacking Action`, `Hacking Perspective`, `Title Menu` 항목이 보인다.
- [ ] `Quarterview Perspective Blockout` 항목이 보인다.
- [ ] `Hacking Perspective Blockout` 항목이 보인다.
- [ ] Hub 설명에서 Room Object Contract Prototype과 Perspective Blockout의 역할 차이가 이해된다.
- [ ] Hacking Action Prototype과 Hacking Perspective Blockout의 설명이 구분된다.
- [ ] `W` / `S` 또는 `Up` / `Down`으로 선택 이동이 된다.
- [ ] `E` 또는 `Enter`로 선택한 prototype에 진입된다.
- [ ] `1` / `Q`로 Room Object Contract Prototype에 진입된다.
- [ ] `2` / `V`로 Quarterview Perspective Blockout에 진입된다.
- [ ] `3` / `H`로 Hacking Action Prototype에 진입된다.
- [ ] `4` / `C`로 Hacking Perspective Blockout에 진입된다.
- [ ] `5` / `T`로 Title / Pause Menu Prototype에 진입된다.
- [ ] `6` / `G`로 Quarterview Gameplay Sandbox에 진입된다.
- [ ] `7` / `S`로 Quarterview Room Shell Prototype에 진입된다.
- [ ] 포커스된 `E` / `Enter` 실행으로 Quarterview Perspective와 Hacking Perspective 항목에도 진입된다.
- [ ] 선택 이동 시 SFX가 너무 크거나 거슬리지 않는다.
- [ ] 실행 confirm SFX가 들린다.
- [ ] Input Prompt icon이 텍스트와 겹치지 않는다.
- [ ] 아이콘이 너무 크거나 작지 않다.
- [ ] `B` / `Backspace` 복귀 안내가 이해된다.

## QuarterviewRoomPrototype

이 scene은 최종 쿼터뷰 시점 검증용이 아니다. object registry, interaction prompt, `ObjectInteractionPanel`, `zone` / `role` / `future_source` 계약 검증용이며, 실제 쿼터뷰 실내 시점 확인은 `QuarterviewPerspectiveBlockout`에서 한다.

- [ ] Scene이 정상 실행된다.
- [ ] 화면 안내가 `Room Object Contract Prototype`으로 표시되고, 최종 쿼터뷰 아트 / 시점 검증용이 아니라는 점이 이해된다.
- [ ] 기본 화면에서 전체 label / range / collision이 숨겨져 있다.
- [ ] 가까운 오브젝트에만 `[E]` prompt가 표시된다.
- [ ] `[E]` prompt의 input icon과 텍스트가 겹치지 않는다.
- [ ] `D` 키로 debug overlay ON / OFF가 된다.
- [ ] Debug overlay ON일 때 label / range / collision이 보인다.
- [ ] `BATH DOOR`, `DOOR` 같은 구조 라벨은 기본 화면에 보이지 않는다.
- [ ] `E`로 `ObjectInteractionPanel`이 열린다.
- [ ] Panel은 오른쪽 고정 위치에 표시된다.
- [ ] Panel이 열리면 player 이동이 멈춘다.
- [ ] `Primary`, `Inspect`, `Close` 버튼이 보인다.
- [ ] `Primary` / `Inspect`는 실제 기능 연결 없이 no-op 로그만 남긴다.
- [ ] `Close` 또는 `ESC`로 panel이 닫힌다.
- [ ] `B` / `Backspace`로 `PrototypeHub` 복귀가 우선된다.
- [ ] Panel open / close / button SFX가 너무 과하지 않다.

주의:

- `QuarterviewRoomPrototype`은 아직 `Main` / DAY1을 대체하지 않는다.
- `Bed`, `Laptop`, `Power`, `Phone`, `Outlet`, `Result`, `Hacking`은 실제 기능과 연결하지 않은 상태다.
- 이 scene의 pass 기준은 쿼터뷰처럼 보이는지가 아니라 object / interaction contract가 읽히는지다.

## QuarterviewPerspectiveBlockout 확인 항목

- [ ] Scene이 정상 실행된다.
- [ ] 바닥이 완전 top-down 사각형이 아니라 사선 / 쿼터뷰 평면처럼 보인다.
- [ ] 뒤쪽 벽과 측면 벽이 보인다.
- [ ] 앞쪽 벽이 시야를 과하게 막지 않는다.
- [ ] Bed / Desk / Fridge / Microwave / AC가 pseudo 3D block처럼 보인다.
- [ ] Comm / NODE-17 / Speaker / UPS / Signal Booster가 작업 장비 구역에 속한 block으로 읽힌다.
- [ ] 모든 오브젝트가 같은 방 축을 공유한다.
- [ ] Player와 가구 크기 비율이 괜찮다.
- [ ] Player placeholder 이동과 큰 가구 collision이 동작한다.
- [ ] Desk / Bed 앞뒤를 지나가며 가림 테스트가 가능하다.
- [ ] 방이 너무 넓은 연구실처럼 보이지 않는다.
- [ ] 방이 너무 빈민굴처럼 처참해 보이지 않는다.
- [ ] 좁지만 정돈된 하층민 1인실 + 해커 작업실 느낌이 있는지 확인한다.
- [ ] 기존 `QuarterviewRoomPrototype`과 달리 object / interaction contract가 아니라 시점 검증용이라는 점이 이해된다.
- [ ] `D` 키로 debug overlay ON / OFF가 된다.
- [ ] `B` / `Backspace`로 `PrototypeHub`에 복귀된다.

메모:

- 이 scene은 기능 이식용이 아니라 시점 blockout이다.
- `Bed`, `Laptop`, `Power`, `Phone`, `Outlet`, `Result` 기능 연결 여부는 확인 대상이 아니다.

## QuarterviewRoomShellPrototype

이 scene은 `qv_room_floor_base.png`를 실제 room scene에 적용하기 전에 `1920x1080` same-canvas 기준과 origin / scale 정책을 확인하는 visual prototype이다. 아직 production room shell 적용이 아니다.

- [ ] Scene이 정상 실행된다.
- [ ] `PrototypeHub`에서 `7` / `S` 또는 버튼으로 진입된다.
- [ ] 화면에 `Quarterview Room Shell Prototype` 제목이 보인다.
- [ ] Expected canvas `1920x1080` 정보가 보인다.
- [ ] expected path `res://assets/rooms/quarterview/shell/qv_room_floor_base.png`가 보인다.
- [ ] `qv_room_floor_base.png`가 있으면 floor texture가 표시된다.
- [ ] `qv_room_walls_back.png`가 있으면 back wall texture가 floor 위에 표시된다.
- [ ] `qv_room_walls_side.png`가 있으면 side wall texture가 floor / back wall 위에 표시된다.
- [ ] 누락된 layer는 missing status로 표시되고 scene이 깨지지 않는다.
- [ ] asset이 있으면 image size와 canvas match 여부가 status에 표시된다.
- [ ] asset이 `1920x1080`이 아니면 size warning이 표시된다.
- [ ] `1` / `2` / `3`으로 floor / back wall / side wall layer visibility를 toggle할 수 있다.
- [ ] `D` 키로 guide overlay ON / OFF가 된다.
- [ ] `R`로 prototype이 reload된다.
- [ ] `B` / `Backspace`로 `PrototypeHub`에 복귀된다.

주의:

- PNG asset, `.import`, production scene 적용은 이번 확인 범위가 아니다.
- guide overlay는 floor alignment 확인용이며 최종 art가 아니다.
- player 이동, collision, object interaction은 이 scene의 확인 대상이 아니다.

Future window city view check:

- [ ] window layer appears through the room window area.
- [ ] wall / window frame remains separate.
- [ ] missing window layer does not crash prototype.
- [ ] layer can be toggled independently if implemented.
- [ ] city view does not overpower interactable objects.
- [ ] glow / reflection is not baked too strongly into the window layer.

Future foreground occluder check:

- [ ] foreground layer appears above player / object placeholders.
- [ ] interact prompts remain visible.
- [ ] missing foreground layer does not crash prototype.
- [ ] layer can be toggled independently if implemented.

Future static lighting overlay check:

- [ ] lighting overlay appears above room visual layers but below UI.
- [ ] missing lighting layer does not crash prototype.
- [ ] layer can be toggled independently if implemented.
- [ ] overlay does not hide player / object readability.
- [ ] warm interior and cold window contrast are visible.
- [ ] glow / shadow are not baked in ways that block future dynamic lighting.

Future Yui qv spritesheet check:

- [ ] idle / walk sheets load correctly.
- [ ] down / up / left / right row order is correct.
- [ ] foot anchor does not jitter.
- [ ] scale matches room shell.
- [ ] foreground occluder does not hide Yui too much.
- [ ] lighting overlay does not destroy readability.

Future furniture atlas check:

- [ ] Atlas regions display without cropping.
- [ ] Region keys match `docs/QV_FURNITURE_ATLAS_REGION_MAPPING.md`.
- [ ] Furniture, device, and appliance categories are not mixed.
- [ ] Pivot / anchor placement is stable.
- [ ] Player scale and occlusion remain readable.

Future appliances atlas check:

- [ ] Atlas regions display without cropping.
- [ ] Appliance region keys match `docs/QV_APPLIANCES_ATLAS_REGION_MAPPING.md`.
- [ ] Appliance, furniture, and work-device categories are not mixed.
- [ ] State variations keep stable anchors.
- [ ] Glow / FX are not over-baked into appliance body sprites.
- [ ] Player scale and occlusion remain readable.

Future work devices atlas check:

- [ ] Atlas regions display without cropping.
- [ ] Work device region keys match `docs/QV_WORK_DEVICES_ATLAS_REGION_MAPPING.md`.
- [ ] Work device, furniture, appliance, and cable categories are not mixed.
- [ ] State variations keep stable anchors.
- [ ] Screen glow / signal FX are not over-baked into device body sprites.
- [ ] Player scale and occlusion remain readable.
- [ ] Speaker is treated as audio hacking device, not decoration.

Future FX atlas check:

- [ ] FX regions display without cropping.
- [ ] Animated frames keep stable anchors.
- [ ] FX, body atlas, cable, and static lighting categories are not mixed.
- [ ] Glow / signal / spark effects do not overpower interactable objects.
- [ ] Prompt / UI readability remains clear.
- [ ] Full-room lighting is not accidentally baked into localized FX.

Future props / cable atlas check:

- [ ] Props do not overpower interactable objects.
- [ ] Cables do not clutter the player path or room readability.
- [ ] Cable visuals are not mistaken for actual power logic.
- [ ] Props / cable categories are not mixed with furniture, appliance, work-device, or FX atlases.

Future hacking arena tiles check:

- [ ] Tile regions display without cropping.
- [ ] Floor / wall / hazard / objective categories are clear.
- [ ] Collision / navigation hints match visual intent.
- [ ] Cyber / network arena style is preserved.
- [ ] Tiles do not look like fantasy dungeon assets.
- [ ] Player / enemy / projectile readability remains clear.

Future hack avatar spritesheet check:

- [ ] Idle / walk sheets load correctly.
- [ ] Down / up / left / right row order is correct.
- [ ] Anchor does not jitter.
- [ ] Scale matches hack arena tiles.
- [ ] Avatar is readable against arena floor / hazards.
- [ ] Avatar is distinct from enemies / projectiles / FX.
- [ ] Avatar does not look like a fantasy dungeon hero.

## HackingActionPrototype

이 scene은 조작 / 상태 / 피드백 prototype이다. 현재 시점은 정수리뷰에 가까울 수 있으며, 최종 `3/4 top-down cyber action view` 시점 확인은 `HackingPerspectiveBlockout`에서 한다.

- [ ] Scene이 정상 실행된다.
- [ ] `WASD` / 방향키 이동이 된다.
- [ ] `J` 또는 Mouse Left로 hacking shot이 발사된다.
- [ ] `Shift` 또는 `K`로 roll이 된다.
- [ ] `Space`로 hop이 된다.
- [ ] `D` 키로 debug overlay ON / OFF가 된다.
- [ ] Enemy에 projectile이 맞으면 hit feedback과 SFX가 나온다.
- [ ] Player가 damage를 받으면 HP가 줄고 event message가 나온다.
- [ ] Hazard / scan에 닿으면 Trace가 오른다.
- [ ] `E`로 data node를 추출할 수 있다.
- [ ] Objective 추출 후 exit가 활성화된다.
- [ ] Exit에 도달하면 `SUCCESS` 상태가 된다.
- [ ] HP `0` 또는 Trace `100`이면 `FAILED` 상태가 된다.
- [ ] `R`로 restart된다.
- [ ] `B` / `Backspace`로 `PrototypeHub`에 복귀된다.
- [ ] UI에서 HP / Trace / Objective / State / Event가 읽힌다.
- [ ] Input Prompt icon이 너무 많아 화면을 가리지 않는다.
- [ ] Shot / hit / damage / success / fail SFX가 구분된다.

조작감 판단:

- [ ] 이동 속도가 너무 빠르거나 느리지 않은가.
- [ ] Roll이 의미 있는가.
- [ ] Hop이 함정 회피처럼 느껴지는가.
- [ ] Shot이 맞는 느낌이 있는가.
- [ ] Trace / HP 실패가 이해되는가.

주의:

- 이 scene의 pass 기준은 `3/4` 시점처럼 보이는지가 아니라 move / shot / roll / hop / objective / exit / HP / Trace 흐름이 이해되는지다.

## Future hack enemies atlas check

- [ ] Enemy regions display without cropping.
- [ ] Animated frames keep stable anchors.
- [ ] Enemy / player / projectile / FX categories are not mixed.
- [ ] Enemies read as cyber security programs, not fantasy monsters.
- [ ] Enemy silhouettes are distinct from player avatar.
- [ ] Enemy visual danger role is readable.

## Future hack objects atlas check

- [ ] Object regions display without cropping.
- [ ] Animated frames keep stable anchors.
- [ ] Object / tile / enemy / avatar / FX categories are not mixed.
- [ ] Objectives and exits are visually readable.
- [ ] Objects read as cyber terminals / nodes, not fantasy dungeon props.
- [ ] Interaction prompt placement remains clear.

## Future hack FX atlas check

- [ ] FX regions display without cropping.
- [ ] Animated frames keep stable anchors.
- [ ] FX / body atlas categories are not mixed.
- [ ] FX read as cyber / infiltration feedback, not fantasy magic.
- [ ] FX do not overpower avatar / enemy / object readability.
- [ ] Blend / alpha values remain readable against arena tiles.

## Future ui_common_atlas check

- [ ] Panel / button / icon regions display without cropping.
- [ ] 9-slice margins preserve corners and borders.
- [ ] Button state regions keep consistent size.
- [ ] Icons remain readable on dark UI.
- [ ] Localization text is not baked into UI images.
- [ ] Kenney input prompt icons remain separate unless intentionally wrapped by a common prompt frame.

## Future ui_hud_atlas check

- [ ] HUD regions display without cropping.
- [ ] Meter frames / fills align correctly.
- [ ] Warning / status chips remain readable.
- [ ] HUD respects safe area assumptions.
- [ ] Room HUD does not hide interactable objects.
- [ ] Hacking HUD does not hide action readability.
- [ ] Localization text is not baked into HUD images.

## Future ui_phone_atlas check

- [ ] Phone frame / card / message regions display without cropping.
- [ ] 9-slice margins preserve corners and borders.
- [ ] App tile / card state regions keep consistent size.
- [ ] Battery / signal / warning icons remain readable.
- [ ] Localization text is not baked into Phone UI images.
- [ ] Sandbox phone panel can test visuals before replacing existing PhoneUI.

## Future ui_outlet_atlas check

- [ ] Outlet panel / slot / device card regions display without cropping.
- [ ] 9-slice margins preserve corners and borders.
- [ ] Slot / device card state regions keep consistent size.
- [ ] 1-slot and 2-slot devices are visually distinct.
- [ ] Connected and active states are visually distinct.
- [ ] Drag / drop valid and invalid states are readable.
- [ ] Localization text is not baked into Outlet UI images.
- [ ] Sandbox outlet panel can test visuals before replacing existing OutletMode.

## Future ui_result_log_atlas check

- [ ] Result / log card regions display without cropping.
- [ ] 9-slice margins preserve corners and borders.
- [ ] Success / fail / warning / neutral states are visually distinct.
- [ ] Reward / Grid Credit / story log rows remain readable.
- [ ] Localization text is not baked into Result / Log UI images.
- [ ] Sandbox result mock can test visuals before replacing existing DayResultPanel.

## Future ui_dialogue_atlas check

- [ ] Dialogue panel / choice regions display without cropping.
- [ ] 9-slice margins preserve corners and borders.
- [ ] Choice button states keep consistent size.
- [ ] System / narration / thought panels are visually distinct.
- [ ] Localization text is not baked into Dialogue UI images.
- [ ] Dialogue UI does not hide room / hacking readability too much.
- [ ] Sandbox dialogue mock can test visuals before implementing a dialogue system.

## Future ui_device_icons_atlas check

- [ ] Device icons display without cropping.
- [ ] Small sizes remain readable.
- [ ] Device-specific icons are not mixed with generic UI icons.
- [ ] Room object sprites are not used directly as UI icons.
- [ ] Required / recommended mission devices can be shown with icons.
- [ ] State icons or overlays remain distinguishable.

## HackingPerspectiveBlockout 확인 항목

- [ ] Scene이 정상 실행된다.
- [ ] 완전 정수리뷰보다 `3/4 top-down` 느낌이 난다.
- [ ] 사이버 공간 바닥이 사선 / 기울어진 평면처럼 보인다.
- [ ] 보안벽 / 장벽 / 플랫폼에 앞면 또는 측면이 조금 보인다.
- [ ] Player / Enemy / Data Node / Exit Gate가 평면 도형만으로 보이지 않고 약간의 높이감이 있다.
- [ ] Cyber arena 축이 일관적이다.
- [ ] Security Program / Sentry / Signal Relay가 보안 시스템 내부 오브젝트처럼 읽힌다.
- [ ] 큰 장벽 collision이 있다.
- [ ] 낮은 벽이나 data node 주변에서 깊이감 테스트가 가능하다.
- [ ] Foreground barrier 앞뒤를 지나갈 때 깊이감이나 일부 가림 테스트가 가능하다.
- [ ] Player placeholder 이동이 가능하다.
- [ ] 기존 `HackingActionPrototype`과 달리 gameplay 조작감 확인이 아니라 시점 확인용이라는 점이 이해된다.
- [ ] `D` 키로 debug overlay ON / OFF가 된다.
- [ ] `B` / `Backspace`로 `PrototypeHub`에 복귀된다.

메모:

- 이 scene은 gameplay 조작감 확인용이 아니라 시점 blockout이다.
- Shot / roll / hop / objective / trace가 없어도 실패가 아니다.
- Gameplay 확인은 `HackingActionPrototype`에서 한다.

## TitleMenuPrototype

- [ ] Scene이 정상 실행된다.
- [ ] 메뉴 항목이 보인다.
- [ ] `PrototypeHub`로 진입할 수 있다.
- [ ] 선택 / 확정 / 취소 흐름이 어색하지 않다.
- [ ] 아직 실제 `Main` 게임 시작과 연결되지 않은 상태가 명확하다.

`TitleMenuPrototype`은 아직 낮은 우선순위의 UI 방향 prototype이다. 실제 title scene 승격, save / load, Main 시작 연결, Main ESC menu 통합은 별도 작업이다.

## QuarterviewGameplaySandbox

이 scene은 미래 쿼터뷰 Main 이식 전에 `RoomSceneContract` signal flow를 확인하는 sandbox다. 실제 `Main`, Result, Hacking 연결은 확인 대상이 아니다. Bed End Day, Phone, Power / Outlet은 sandbox-only panel까지만 확인한다.

- [ ] Scene이 정상 실행된다.
- [ ] `PrototypeHub`에서 `6` / `G`, focused `E` / `Enter`, 또는 버튼으로 진입된다.
- [ ] 화면에 `Quarterview Gameplay Sandbox`와 `Not Main` 안내가 보인다.
- [ ] `Room contract connected: yes` 상태가 표시된다.
- [ ] `WASD` / 방향키로 room stub player가 이동한다.
- [ ] 가까운 object에 접근하면 nearest prompt가 표시된다.
- [ ] sandbox time이 `20:00`부터 표시된다.
- [ ] auto end target `02:00`이 표시된다.
- [ ] `T`로 sandbox time이 `30`분 전진한다.
- [ ] `Shift+T`로 sandbox time이 `2`시간 전진한다.
- [ ] `F2`로 sandbox Test Mode panel이 열린다.
- [ ] Test Mode panel에 sandbox time / elapsed / clock / auto end / result state가 표시된다.
- [ ] Test Mode open 중 player movement, `E` interaction, `Tab` Phone toggle이 잠긴다.
- [ ] Test Mode의 `+30 min`이 sandbox-local time만 전진시킨다.
- [ ] Test Mode의 `+2 hours`가 sandbox-local time만 전진시킨다.
- [ ] Test Mode의 `Jump 01:50`이 auto end 직전 시간으로 이동한다.
- [ ] Test Mode의 `Trigger Auto End`가 sandbox-only auto end / Result 흐름을 연다.
- [ ] Test Mode의 `Trigger Manual Result`가 sandbox-only manual result 흐름을 연다.
- [ ] Test Mode의 `Reset Sandbox`가 time `20:00`, end state, result state, modal state를 초기화한다.
- [ ] Test Mode를 닫으면 terminal state가 아닌 경우 player movement와 clock 상태가 복구된다.
- [ ] Test Mode가 Main Test Mode, `SurvivalState`, real `PhoneUI`, real `OutletMode`, real `DayResultPanel`을 조작하지 않는다.
- [ ] `E`를 누르면 `interaction_requested` event log가 표시된다.
- [ ] 가까운 object에서 `E`를 누르면 object interaction panel이 열린다.
- [ ] Panel에 key / role / future_source / visual_state가 표시된다.
- [ ] Primary / Inspect는 실제 기능 연결 없이 no-op 로그만 남긴다.
- [ ] Bed에서 Primary를 누르면 sandbox-only End Day confirmation panel이 열린다.
- [ ] End Day confirmation에서 Confirm을 누르면 `day_end_confirmed = true` 상태가 기록된다.
- [ ] Bed manual end confirm 후 Sandbox Result UI가 열린다.
- [ ] Sandbox Result UI에 end reason `manual_bed` / `Manual Rest`가 표시된다.
- [ ] End Day confirmation에서 Cancel / Close / `ESC`를 누르면 panel이 닫히고 player movement가 복구된다.
- [ ] End Day Confirm 후 real `DayResultPanel`이나 다음 날 진행이 열리지 않는다.
- [ ] Bed manual end reason이 `manual_bed`로 표시된다.
- [ ] `Tab`을 누르면 sandbox Phone panel이 열린다.
- [ ] Phone panel은 sandbox-only이며 Main / DAY1 Phone flow와 연결되지 않았다고 표시한다.
- [ ] Phone panel이 열려 있는 동안 player movement가 잠긴다.
- [ ] `Tab` / `ESC` / Close button으로 Phone panel이 닫힌다.
- [ ] Phone panel을 닫으면 player movement가 복구된다.
- [ ] phone object에서 Primary를 누르면 sandbox Phone panel이 열린다.
- [ ] power object에서 Primary를 누르면 sandbox Outlet panel이 열린다.
- [ ] Outlet panel은 sandbox-only이며 Main / DAY1 Outlet flow와 연결되지 않았다고 표시한다.
- [ ] Outlet panel이 열려 있는 동안 player movement가 잠긴다.
- [ ] `ESC` / Close button으로 Outlet panel이 닫힌다.
- [ ] Outlet panel을 닫으면 player movement가 복구된다.
- [ ] Outlet mock button은 로그 / 문구만 바꾸고 실제 connected / active state를 바꾸지 않는다.
- [ ] Apartment wire overlay가 바뀌지 않는다.
- [ ] sandbox time이 `02:00`에 도달하면 auto end message가 표시된다.
- [ ] `02:00` auto end 후 Sandbox Result UI가 열린다.
- [ ] auto end reason이 `auto_02_00`으로 표시된다.
- [ ] Sandbox Result UI에 end reason `auto_02_00` / `02:00 Auto End`가 표시된다.
- [ ] Sandbox Result UI에 sandbox-only warning이 표시된다.
- [ ] Sandbox Result UI가 기존 `DayResultPanel`을 열지 않는다.
- [ ] auto end가 열린 Interaction / End Day / Phone / Outlet modal을 override한다.
- [ ] auto end 후 movement, `E` interaction, `Tab` Phone, Bed / Phone / Power Primary가 실행되지 않는다.
- [ ] auto end 후 real `DayResultPanel`, Main DAY1 종료, `SurvivalState` day advance가 실행되지 않는다.
- [ ] Result UI open 후 movement, `E`, `Tab`, Phone / Outlet / Bed interaction이 실행되지 않는다.
- [ ] Result UI의 Restart button 또는 `R`이 time / result / end state를 초기화한다.
- [ ] Result UI의 Hub button 또는 `B` / `Backspace`가 PrototypeHub로 복귀한다.
- [ ] Result UI의 Hide Details는 gameplay를 재개하지 않는다.
- [ ] Close 또는 `ESC`로 panel이 닫힌다.
- [ ] Panel이 열려 있는 동안 player movement가 잠긴다.
- [ ] Panel을 닫으면 player movement가 복구된다.
- [ ] InteractionPanel이 열려 있을 때 `Tab`으로 Phone panel이 겹쳐 열리지 않는다.
- [ ] End Day confirmation이 열려 있을 때 Phone / Outlet panel이 겹쳐 열리지 않는다.
- [ ] Phone panel이 열려 있을 때 InteractionPanel이나 Outlet panel이 새로 겹쳐 열리지 않는다.
- [ ] Outlet panel이 열려 있을 때 InteractionPanel이나 Phone panel이 새로 겹쳐 열리지 않는다.
- [ ] `ESC`는 현재 열린 sandbox modal을 닫는다.
- [ ] Panel이 열려 있어도 `B` / `Backspace` Hub 복귀 규칙이 유지된다.
- [ ] Godot output에 no-op interaction 로그가 출력된다.
- [ ] `D` 키로 debug overlay ON / OFF가 된다.
- [ ] Debug ON에서 object label, interaction radius, player position, signal log가 보인다.
- [ ] `R`로 sandbox가 restart된다.
- [ ] Confirmed End Day 상태에서도 `R` restart가 가능하다.
- [ ] Auto End 상태에서도 `R` restart가 가능하고 time / end reason이 초기화된다.
- [ ] `B` / `Backspace`로 `PrototypeHub`에 복귀된다.
- [ ] real Main Phone / Outlet / Result / 실제 Main End Day / Hacking이 실제로 열리지 않는다.
- [ ] Reward / Grid Credit / Story flag / save-load가 실행되지 않는다.

메모:

- `docs/QUARTERVIEW_GAMEPLAY_SANDBOX_FLOW_CHECK.md`는 현재 code path와 headless startup 기준의 흐름 점검 결과다.
- GUI 수동 확인에서는 특히 modal priority, movement lock / restore, `T` / `Tab` / `ESC` / `R` / `D` / `B` 우선순위를 본다.

## SFX 확인 항목

- 신규 perspective blockout은 SFX가 없어도 된다.
- SFX 확인은 주로 `PrototypeHub`, `QuarterviewRoomPrototype`, `HackingActionPrototype`에서 한다.
- [ ] UI select 소리가 너무 자주 나와 거슬리지 않는다.
- [ ] Confirm / cancel 소리가 구분된다.
- [ ] Quarterview panel open / close 소리가 어색하지 않다.
- [ ] Hacking shot / hit / damage / success / fail 소리가 구분된다.
- [ ] 전체 볼륨이 너무 크지 않다.
- [ ] 소리가 겹쳐서 지저분하게 들리지 않는다.

SFX는 현재 prototype 전용이다. Main / DAY1 사운드 시스템으로 확정된 것이 아니다.

## Input Prompt Icon 확인 항목

- Perspective blockout scene은 input icon이 최소 안내에만 있어도 된다.
- 시점 확인을 방해할 정도로 icon / label이 많으면 Needs Fix다.
- [ ] 키 아이콘이 텍스트보다 가독성을 해치지 않는다.
- [ ] 아이콘 크기가 적절하다.
- [ ] `PrototypeHub`에서 아이콘이 버튼 / 설명과 겹치지 않는다.
- [ ] Quarterview의 `[E]` prompt가 너무 튀지 않는다.
- [ ] Hacking의 조작 안내가 아이콘 때문에 너무 복잡하지 않다.
- [ ] 필요하다면 아이콘 수를 줄여도 된다.

## 판정 기준

### Pass 기준

- 각 prototype scene이 실행된다.
- Hub에서 각 prototype에 진입 / 복귀할 수 있다.
- PrototypeHub에서 각 prototype의 목적을 구분할 수 있다.
- Quarterview 기본 화면이 지나치게 지저분하지 않다.
- 기존 contract prototype과 perspective blockout의 역할 차이가 명확하다.
- Quarterview Perspective Blockout이 실제 쿼터뷰 시점 검증용으로 구분된다.
- Quarterview Perspective Blockout이 기존 QuarterviewRoomPrototype보다 실제 쿼터뷰 실내 시점에 가깝다.
- Quarterview Perspective Blockout이 채택 콘티 방향에 더 가까운 쿼터뷰 실내 느낌을 준다.
- Hacking prototype의 기본 미션 흐름이 이해된다.
- Hacking Perspective Blockout이 Hacking Action 조작 prototype과 구분된다.
- Hacking Perspective Blockout이 기존 HackingActionPrototype보다 완전 정수리뷰에서 벗어난 `3/4 top-down` 느낌을 준다.
- Hacking Perspective Blockout이 완전 정수리뷰보다 내려다보는 액션 시점에 가깝다.
- SFX와 input prompt가 prototype 확인을 방해하지 않는다.

### Needs Fix 기준

- 아이콘이나 라벨이 화면을 과하게 가린다.
- SFX가 너무 크거나 반복이 거슬린다.
- Quarterview panel이 조작을 방해한다.
- Hacking 조작 안내가 너무 복잡하다.
- Hub에서 진입 / 복귀가 헷갈린다.
- Perspective blockout이 다시 평면 / 정수리뷰처럼 보인다.
- QuarterviewPerspectiveBlockout이 다시 평면 / 정수리뷰처럼 보인다.
- HackingPerspectiveBlockout이 기존 HackingActionPrototype과 시점 차이가 거의 없다.
- 오브젝트 축이 서로 다르다.
- 앞벽이나 가구가 시야를 과하게 막는다.
- 방이 너무 넓거나 하층 주거 공간보다 기관 연구실처럼 보인다.
- 방이 너무 빈민굴처럼 처참해 보인다.
- Perspective blockout에 label / icon이 너무 많아 시점 확인을 방해한다.

## Bug Report Template

```text
[Prototype Bug]
- Scene: PrototypeHub / QuarterviewRoomPrototype / QuarterviewPerspectiveBlockout / HackingActionPrototype / HackingPerspectiveBlockout / TitleMenuPrototype
- Steps:
- Expected:
- Actual:
- Screenshot/Video:
- Severity:
- Notes:
```
