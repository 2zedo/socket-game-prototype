# UI Visual Implementation Notes

## Current Presentation

- The apartment uses the no-wire reference map as its visible background.
- Yui is rendered from the processed four-direction sprite sheet.
- Exploration remains keyboard-based top-down movement with proximity `E` interaction.
- Interaction, dialogue, multitap, and result UI remain separate states rather than appearing simultaneously.
- Existing UI tone remains dark brown-gray with muted brass lines and warm off-white text.

## Current Multitap UI

- The old card-selection presentation is no longer the active interaction model.
- Device connection uses draggable adapter PNGs placed into four physical slots.
- Slot occupancy and connected-device state come from `SurvivalState.gd`.
- Laptop occupies two adjacent slots and cannot begin at slot 4.
- Fan, Charger, and Communication Device currently occupy one slot each.
- Current code also presents Light/Lamp as a one-slot adapter, but that design decision is still unresolved.
- Only connected devices reveal their corresponding map wire overlays.
- Connection changes outlet load and slot occupancy; using the room object spends daily power.

## Remaining Visual Risks

- Adapter insertion masks and connected placement need live Godot review.
- Laptop desk-wire and several wire endpoints may need small anchor adjustments.
- Interaction hotspots and collision overlays need alignment review against the map art.
- Communication Device, Fan, and Laptop may eventually need dedicated world variants separate from UI preview art.
- Result presentation still needs a dedicated final survival-log skin.

## Developer Test Overlay

- `P` toggles a developer-only overlay; it is hidden during normal presentation.
- The upper-right readout reports movement, power/outlet state, nearest interaction, and the active modal.
- Colored world overlays distinguish player collision, interaction range, blockers, interactables, the nearest target, and wire anchors.
- Outlet Mode uses the same Test Mode state to reveal slot, adapter, and plug-anchor hitboxes.
- These overlays are diagnostic only and do not replace the final interaction prompts or visual treatment.
- `F1` 도움말은 테스트 모드에서만 우측 진단 정보 아래에 표시되며, 실제 적용된 시간·배터리·전력 조정 키를 한국어로 안내한다.
- 기본 진단 정보는 도움말을 닫아도 `[F1] 테스트 키 도움말` 안내를 유지한다.

## Test Mode 2차 확장 패스

반복 테스트용 상태 세팅과 진단 출력을 기존 Test Mode 입력 흐름에 추가했다. 일반 플레이 UI와 게임 규칙은 바꾸지 않았고, 상태 변경 키는 탐색 중에만 동작한다.

## Test Mode 2차 확장 조정

- `F8`은 대량 상태 시뮬레이션 없이 시계를 `01:50`으로 옮겨 기존 `02:00` 자동 종료 흐름을 빠르게 확인하게 한다.
- 숫자 키는 배터리 경고 직전 값과 `0.5` 전력을 세팅하며, 기존 감소·경고·전력 고갈 경로는 그대로 사용한다.
- `O`는 연결과 기록을 보존한 채 작동 장치만 끄고, `U`는 기존 연결 상태 갱신 경로로 장치·부하·슬롯·전선을 함께 초기화한다.
- `L`은 현재 시간, 자원, 연결·작동 장치, 모달 상태를 Godot 출력에 기록한다.
- 신규 상태 변경 키와 기존 조정 키는 Phone, Outlet, Interaction, End Day, 자동 종료 대사, Result 모달 중 무시된다.
- 키 입력과 도움말 표시에는 수동 확인이 필요하다.

## Next Visual Check

- Verify empty, one-device, Laptop two-slot, multiple-device, and disconnect states in Godot.
- Confirm each wire appears and disappears with the matching adapter state.
- Confirm no adapter or prompt overlaps the surrounding UI at the target resolution.
- Use Test Mode to capture exact collision gaps before changing blocker geometry.

## Outlet Drag Feedback Pass

The existing outlet hitboxes and connection rules remain unchanged. Drag feedback now renders above the power-strip art and focuses on the adapter's current target rather than coloring every possible slot.

## Outlet Drag Feedback Adjustments

- Valid targets use a bright green fill and outline; invalid or occupied targets use red.
- Two-slot adapters highlight both affected slots and receive one shared outer frame.
- Starting a two-slot Laptop at slot 4 shows an invalid red target instead of implying a valid placement.
- Releasing or cancelling the drag clears feedback through the existing empty `dragging_device` state.
- Manual drag checks remain required for one-slot, occupied-slot, Laptop two-slot, slot-4 rejection, connect, and disconnect behavior.

## Outlet Slot LED Pass

Normal outlet presentation no longer outlines every slot. The built-in LED artwork in `powerstrip_4slot.png` is now the visual source, while slot coordinates, adapter placement, hitboxes, and drag/drop rules remain unchanged.

## Outlet Slot LED Adjustments

- Empty slots darken the corresponding built-in LED region in the power-strip texture.
- Occupied slots leave the original green LED artwork visible; two-slot Laptop placement reveals both occupied LEDs.
- The previously drawn green circles and glow were removed rather than layered over the source art.
- Connected adapters do not retain an outline after placement; green/red outlines are reserved for active drag targets.
- Existing drag-time green/red target frames remain visible only while an adapter is moving.
- Test Mode continues to draw diagnostic slot rectangles independently of normal presentation.
- Manual checks remain required for connect, two-slot connect, disconnect, and drag-feedback transitions.

## Connected Adapter Placement Tuning

- `OutletMode.gd` keeps per-device connected `offset` and `scale` values in `CONNECTED_ADAPTER_TUNING`.
- Fan, Charger, Communication Device, Lamp, and Laptop can be adjusted independently without changing slot coordinates.
- Laptop retains its separate two-slot base size and anchor, with an additional independent connected scale and offset.
- All tuning defaults are zero offset and unit scale, preserving the current presentation until manually adjusted.

## Phone Battery Feedback Pass

Phone battery thresholds now use the existing HUD warning area for short, non-modal messages. The Phone UI remains openable at zero battery but replaces its detailed status readout with a charging-required message.

## Phone Battery Feedback Adjustments

- Warnings appear slightly above the screen center when battery crosses `20%`, `10%`, `5%`, or `0%`.
- Each threshold is limited to one warning per day and the warning clears automatically after a short delay.
- Charging restores the regular Phone status readout without changing the existing Phone modal flow.
- Manual checks remain required for warning timing, daily duplicate suppression, zero-battery display, and recovery after charging.

## 02:00 자동 종료 대사 패스

`02:00` 자동 한계 도달은 플레이어가 선택하는 수동 휴식과 분리한다. 오른쪽 확인 패널을 숨기고 하단 유이 대사 패널만 사용하며, 기존 Result와 수동 침대 종료 흐름은 변경하지 않는다.

## 02:00 자동 종료 대사 조정

- 자동 한계 상태에서는 `피곤하니 슬슬 자야겠다.` 대사와 `[E] 계속` 힌트만 표시한다.
- `[E] 계속` 힌트는 대사-only 상태에서만 보인다.
- `ESC` 취소는 제공하지 않으며 `E` 입력으로 기존 Result 흐름에 진입한다.
- 침대 상호작용의 수동 하루 종료 확인/취소 패널은 그대로 유지한다.

## DAY 1 결과 화면 1차 개선 패스

기존 결과 계산과 하루 진행 흐름은 유지하면서 결과 표현을 점수표보다 유이의 생존 기록과 정전 일지에 가까운 한국어 문장으로 정리했다.

## DAY 1 결과 화면 1차 개선 조정

- 제목을 `DAY n 생존 기록`으로 바꾸고 남은 전력, 사용한 장치, 확인한 정보, 상태 변화를 기록 섹션으로 구성한다.
- 장치 Resource 표시명과 기존 결과 플래그를 사용해 내부 key를 노출하지 않는 자연문을 만든다.
- 사용 장치, 남은 전력, 노트북 및 통신 장치 기록에 따라 짧은 하루 요약 문장이 달라진다.
- 계속 안내는 `[E] 계속`으로 통일하며 기존 결과 진입 및 계산 로직은 변경하지 않는다.
- 전용 생존 기록 이미지 스킨은 아직 적용하지 않았으며 실제 줄바꿈과 가독성은 수동 확인이 필요하다.

## Archive

- Previous visual-pass history: `docs/old/UI_VISUAL_IMPLEMENTATION_NOTES_20260619.md`
