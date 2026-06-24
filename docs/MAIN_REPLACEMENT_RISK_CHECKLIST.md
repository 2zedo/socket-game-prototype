# Main Replacement Risk Checklist

## Purpose

이 체크리스트는 현재 `Main` / DAY1 흐름을 쿼터뷰 기반 흐름으로 교체하기 전에 반드시 완료해야 하는 위험 점검 기준이다.

현재 `Main.tscn` / DAY1은 모든 항목이 통과될 때까지 golden path로 유지한다. `QuarterviewGameplaySandbox`는 production replacement가 아니라 prototype / sandbox 검증 scene이다.

Main replacement must not be done opportunistically during unrelated work. It must be a dedicated task after this checklist is reviewed and explicitly approved.

## Scope

포함 범위:

- Main scene replacement readiness
- `QuarterviewGameplaySandbox` maturity check
- `SurvivalState` compatibility
- Phone / Outlet / Result / Test Mode / `02:00` auto end compatibility
- input / modal priority check
- asset readiness check
- automated test, manual test, and rollback criteria

제외 범위:

- 실제 Main 교체 작업
- 실제 asset import 작업
- 실제 UI atlas 적용
- 실제 Hacking mission 연결
- 실제 Grid Credit / Story flag / save / load 구현
- production feature implementation

## Non-goals

- `Main.tscn` 교체 아님
- `project.godot` start scene 변경 아님
- `Apartment.gd` 제거 아님
- `SurvivalState.gd` 수정 아님
- Phone / Outlet / Result / Hacking production 연결 아님
- 쿼터뷰 최종 아트 적용 아님

## Current Golden Path

현재 보호해야 할 Main / DAY1 golden path:

- `godot/scenes/Main.tscn` starts correctly.
- `Main.gd` owns modal / input / UI routing.
- `Apartment.gd` owns current top-view room object, collision, nearest interaction, and wire overlay behavior.
- `Player.gd` movement works in the current room.
- `SurvivalState.gd` remains the source of truth for day, time, power, device connection, active state, phone battery, and result data.
- `PhoneUI` opens with `Tab`, closes with `Tab` or `ESC`, and shows current status from `SurvivalState`.
- `OutletMode` opens from the existing power strip / outlet flow, controls device connection / active state, and preserves slot policy.
- Bed manual end flow opens the current confirmation / result route. Verify manually before replacement.
- `02:00` auto end pauses time / power and routes to the current end/result flow. Verify manually before replacement.
- `DayResultPanel` displays DAY result data.
- Main Test Mode works with its current `P` / helper-key behavior. Verify manually before replacement.
- Modal open state locks player movement and pauses the display clock.

## Replacement Candidate

Current quarterview-side candidate pieces:

- `res://scenes/prototypes/QuarterviewGameplaySandbox.tscn`
- `res://scripts/prototypes/QuarterviewGameplaySandbox.gd`
- `RoomSceneContract`
- `QuarterviewSandboxRoomStub`
- `SandboxInteractionPanel`
- `SandboxEndDayPanel`
- `SandboxPhonePanel`
- `SandboxOutletPanel`
- `SandboxResultPanel`
- `SandboxTestModePanel`
- sandbox-local clock
- sandbox-only `02:00` auto end

These are replacement candidates or validation pieces only. They are not production replacements until this checklist passes and a dedicated Main replacement task begins.

## Risk Categories

### A. Scene Entry Risk

- project start scene path can break.
- PrototypeHub scene paths can be confused with production entry paths.
- replacement failure must be revertible without deleting current Main.
- `project.godot` main scene changes, if any, must be isolated in a dedicated replacement commit.

### B. State Ownership Risk

- `SurvivalState` must remain source of truth.
- sandbox-local state must not mix with production state.
- sandbox-only clock, result, Test Mode, and mock panels must not leak into production flow.
- `RoomSceneContract` should define requests and visual sync, not power calculation.

### C. UI Routing Risk

- Phone UI routing can overlap with other modals.
- Outlet UI routing can desync connected / active state.
- Result UI can accidentally use sandbox summary instead of production result data.
- Main Test Mode and sandbox Test Mode can be confused.
- `InteractionPanel` and End Day confirmation must preserve modal priority.

### D. Input Risk

- movement input must lock while production modals are open.
- `E` interaction must not fire behind modals.
- `Tab` Phone toggle must not overlap Outlet / Result / End Day.
- `ESC` close behavior must preserve current modal priority.
- `R`, `D`, `B`, `Backspace`, and sandbox-only shortcuts must not enter production unless intentionally designed.
- input map changes must be isolated and reviewed.

### E. Device / Power Risk

- `DeviceDefinition` values must remain unchanged unless a dedicated balance task approves them.
- connected and active separation must remain intact.
- outlet slot policy must remain intact.
- Laptop must remain a 2-slot device unless a dedicated design change approves otherwise.
- active drain calculation must remain `SurvivalState` owned.
- Light / Lamp and Fan / Air Conditioner unresolved design decisions must not leak into replacement code.

### F. Time / End Day Risk

- production `02:00` auto end must remain distinct from sandbox-local auto end.
- Bed manual end must use production day-end flow only after wiring is explicitly approved.
- result transition must use production result data, not sandbox summary.
- future early / late sleep policy is not decided yet.
- sandbox time and production day time must never share mutable state.

### G. Result / Reward Risk

- `DayResultPanel` current flow must be preserved until replacement is proven.
- `SandboxResultPanel` and production `DayResultPanel` must remain clearly separated.
- Grid Credit is currently not wired to Result.
- Story flag is currently not wired to Result.
- save / load is currently not wired to Result.

### H. Asset Risk

- room shell PNG existence must be verified before production visual replacement.
- Yui quarterview spritesheet readiness must be verified before replacing player visuals.
- furniture / appliance / work device atlases are not applied yet.
- missing asset fallback must exist for prototype-only visual checks.
- source-side `.import` files must only be staged when tied to intentionally used assets.
- external addon raw folders must not be staged accidentally.
- asset pipeline docs and actual paths must match.

### I. Test Coverage Risk

- GUT tests must pass before replacement.
- `SurvivalState` tests must pass.
- Resource tests must pass.
- sandbox manual checklist must be completed.
- scene startup checks must pass.
- headless parse must pass.

### J. Rollback Risk

- current `Main.tscn` and `Main.gd` must not be deleted during first replacement attempt.
- replacement commit must be small and revertible.
- visual asset commits should be separated from replacement wiring commits.
- rollback path must be written before changing the production start scene.

## Go / No-Go Checklist

### Must Pass

- [ ] Current `Main.tscn` can still be launched.
- [ ] Current Main / DAY1 player movement works.
- [ ] Current Phone UI opens / closes.
- [ ] Current Outlet UI opens / closes.
- [ ] Current connected / active device flow works.
- [ ] Current Bed manual end works.
- [ ] Current `02:00` auto end works.
- [ ] Current `DayResultPanel` displays result data.
- [ ] Current Main Test Mode works.
- [ ] `QuarterviewGameplaySandbox` can be launched from `PrototypeHub`.
- [ ] `QuarterviewGameplaySandbox` has interaction panel flow.
- [ ] Bed manual end sandbox flow works.
- [ ] Phone sandbox flow works.
- [ ] Outlet sandbox flow works.
- [ ] `02:00` auto end sandbox flow works.
- [ ] Sandbox Result UI flow works.
- [ ] Sandbox Test Mode flow works.
- [ ] Input lock rules are documented and manually verified.
- [ ] `B` / `Backspace` Hub return works in sandbox.
- [ ] `R` restart works in sandbox.
- [ ] No production Main / DAY1 file was modified unintentionally.
- [ ] Existing GUT tests pass.
- [ ] Scene startup check passes.
- [ ] Rollback plan is documented.

### No-Go Conditions

If any item below is true, stop replacement work.

- [ ] `SurvivalState` ownership is unclear.
- [ ] Phone / Outlet / Result production flow cannot be verified.
- [ ] Main replacement requires deleting old Main.
- [ ] Sandbox-only code leaks into production flow.
- [ ] Required assets are missing without fallback.
- [ ] Manual playtest checklist is incomplete.
- [ ] Rollback path is unclear.
- [ ] `project.godot` start scene change is mixed with unrelated edits.
- [ ] Existing tests fail for unrelated reasons and the cause is not understood.

## Pre-Replacement Validation

Run before any production replacement commit:

```bash
git status --short --branch
git diff --check
```

Godot project parse:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --quit-after 2
```

Main and candidate scene startup checks:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/Main.tscn --quit-after 2
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/prototypes/QuarterviewGameplaySandbox.tscn --quit-after 2
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/prototypes/PrototypeHub.tscn --quit-after 2
```

Targeted GUT:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_survival_state.gd -gexit
```

Full GUT:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
```

## Replacement Plan Gate

Before starting Main replacement:

- [ ] All Must Pass checklist items completed.
- [ ] No-Go conditions are all false.
- [ ] Current Main / DAY1 branch and commit are known.
- [ ] User has manually approved replacement.
- [ ] Replacement is done in a small dedicated commit.
- [ ] Old Main scene is not deleted in the same commit.
- [ ] `project.godot` start scene change, if any, is isolated.
- [ ] Rollback command / path is documented.

Main replacement must not be done opportunistically during unrelated work. It must be a dedicated task after this checklist is reviewed.

## Rollback Plan

Rollback principles:

- Keep old `Main.tscn` and `Main.gd` untouched until replacement is proven.
- Keep replacement wiring in a revertible commit.
- Keep visual asset commits separate from production entry replacement.
- Isolate `project.godot` start scene change, if any.
- Use `PrototypeHub` and `QuarterviewGameplaySandbox` for fallback testing.
- Do not delete production Main during the first replacement attempt.

Rollback candidates:

```bash
git revert <replacement_commit>
```

Or restore `godot/project.godot` `application/run/main_scene` to the previous `Main.tscn` path if a start scene change was isolated.

## Manual Playtest Checklist

### Existing Main / DAY1

- [ ] Main starts.
- [ ] Player moves.
- [ ] Interaction prompt appears near existing objects.
- [ ] Phone opens / closes.
- [ ] Outlet opens / closes.
- [ ] Device connect / active flow works.
- [ ] Phone reflects current time, battery, remaining power, and active devices.
- [ ] Bed manual end works.
- [ ] `02:00` auto end works.
- [ ] Result screen appears.
- [ ] Test Mode works, if present.
- [ ] Modal input lock works.

### QuarterviewGameplaySandbox

- [ ] Opens from `PrototypeHub`.
- [ ] Player moves.
- [ ] Nearest prompt appears.
- [ ] `E` interaction opens panel.
- [ ] Bed manual result flow works.
- [ ] `02:00` auto end flow works.
- [ ] Sandbox Result UI appears.
- [ ] Sandbox Test Mode opens with `F2`.
- [ ] Phone panel opens / closes.
- [ ] Outlet panel opens / closes.
- [ ] Modal input lock works.
- [ ] `R` restart works.
- [ ] `B` / `Backspace` returns to Hub.
- [ ] Sandbox UI clearly says it is not Main.

## Automated Test Checklist

- [ ] `git diff --check` passes.
- [ ] Godot headless project parse passes.
- [ ] Main scene startup passes.
- [ ] `QuarterviewGameplaySandbox` startup passes.
- [ ] `PrototypeHub` startup passes.
- [ ] `test_survival_state.gd` passes.
- [ ] Full `godot/test/unit/` GUT suite passes.
- [ ] Any new replacement-specific tests pass.

## Files That Must Not Be Changed Accidentally

Production protected:

```text
godot/scenes/Main.tscn
godot/scripts/Main.gd
godot/scripts/Apartment.gd
godot/scripts/Player.gd
godot/scripts/SurvivalState.gd
godot/scenes/ui/PhoneUI.tscn
godot/scripts/ui/PhoneUI.gd
godot/scenes/ui/OutletMode.tscn
godot/scripts/ui/OutletMode.gd
godot/scenes/ui/DayResultPanel.tscn
godot/scripts/ui/DayResultPanel.gd
```

Project-level protected:

```text
godot/project.godot
```

Asset / import caution:

```text
*.import
godot/addons/
large generated PNG assets
third-party raw addon folders
```

These files may be intentionally changed only in a dedicated replacement task, never as part of checklist / documentation work.

## Final Approval Notes

- Main replacement is blocked until this checklist is reviewed.
- The user must explicitly approve the dedicated replacement task.
- The replacement task must report changed production files, validation results, rollback path, and remaining risks before push.
- If any No-Go condition becomes true during replacement, stop and return to the current Main / DAY1 golden path.
