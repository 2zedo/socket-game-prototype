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

## Archive

- Previous visual-pass history: `docs/old/UI_VISUAL_IMPLEMENTATION_NOTES_20260619.md`
