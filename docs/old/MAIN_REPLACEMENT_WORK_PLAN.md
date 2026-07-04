# Main Replacement Work Plan

## Purpose

This document defines the work plan for replacing the current top-view `Main` / DAY1 flow with a future quarterview room flow.

It does not perform the replacement. The current `Main.tscn` / DAY1 path remains the golden path until this plan and `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md` are reviewed, the Must Pass items are completed, the No-Go items are false, and the user explicitly approves a dedicated replacement task.

Main replacement must be a dedicated work unit. Do not perform it opportunistically during asset, prototype, UI atlas, hacking, or documentation work.

## Scope

This plan covers:

- the recommended replacement strategy
- the phase order for production candidate work
- the file impact plan
- state ownership boundaries
- Phone / Outlet / Result / Test Mode / `02:00` routing expectations
- sandbox-only versus production-ready behavior checks
- validation, commit, push, and rollback strategy

This plan assumes `QuarterviewGameplaySandbox` has already proven the sandbox-only signal flow, but still treats it as a migration candidate rather than production code.

## Non-goals

- No actual `Main.tscn` replacement in this task.
- No `project.godot` start scene change in this task.
- No production scene, script, Resource, UI, or asset modification in this task.
- No `Apartment.gd`, `Player.gd`, `SurvivalState.gd`, Phone, Outlet, or Result rewrite in this task.
- No room shell PNG, Yui spritesheet, atlas, UI atlas, or import-file application in this task.
- No Hacking mission, Grid Credit, story flag, save/load, or reward wiring in this task.

## Current State

### Production Golden Path

Current production DAY1 is still the top-view path:

- `godot/scenes/Main.tscn`
- `godot/scripts/Main.gd`
- `godot/scripts/Apartment.gd`
- `godot/scripts/Player.gd`
- `godot/scripts/SurvivalState.gd`
- `PhoneUI`
- `OutletMode`
- `DayResultPanel`
- current Test Mode
- current `02:00` auto end

`Main.gd` owns modal, input, and UI routing. `Apartment.gd` owns current room objects, collision, interaction, nearest-object detection, and wire overlays. `SurvivalState.gd` remains the source of truth for day, time, power, connected devices, active devices, phone battery, and result data.

### Quarterview Sandbox Candidate

Current quarterview migration candidates are sandbox-only:

- `res://scenes/prototypes/QuarterviewGameplaySandbox.tscn`
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
- PrototypeHub entry

These pieces are useful for flow validation, but they must not be copied into production blindly. Sandbox-local time, result, Test Mode, mock UI, and no-op state must be replaced or connected deliberately.

## Replacement Target

### Strategy A: New QuarterviewMain Scene

Create a new production candidate scene, for example:

```text
res://scenes/QuarterviewMain.tscn
res://scripts/QuarterviewMain.gd
```

Pros:

- preserves old `Main.tscn` and `Main.gd`
- makes rollback simple
- allows production candidate validation before `project.godot` changes
- avoids mixing old top-view and quarterview room logic in one scene

Cons:

- eventually requires an isolated `project.godot` start scene change
- requires explicit migration of production UI and state routing
- may duplicate some controller structure during transition

### Strategy B: Existing Main Internal Replacement

Modify existing `Main.tscn` / `Main.gd` internals to host the quarterview room.

Pros:

- keeps the entry path unchanged
- may avoid a separate start-scene switch

Cons:

- high regression risk
- harder rollback
- mixes old golden path and replacement work
- makes accidental `Apartment.gd` / modal / input coupling more likely

### Recommendation

Use Strategy A for the first production replacement attempt.

The first replacement should create a new `QuarterviewMain` candidate while preserving old `Main.tscn` and `Main.gd`. The `project.godot` start-scene change should be the final isolated commit after candidate validation. Old Main should not be deleted in the first replacement pass.

Validate the candidate through direct scene startup and, if useful, a PrototypeHub or temporary launch path before changing the production entry.

## Preconditions

Before a replacement task starts:

- [ ] `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md` Must Pass items are complete.
- [ ] `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md` No-Go items are all false.
- [ ] `QuarterviewGameplaySandbox` manual flow is checked: interaction, Bed end, Phone, Outlet, `02:00`, Result, Test Mode, movement lock, restart, Hub return.
- [ ] Existing `Main.tscn` manual flow is checked: movement, interaction, Phone, Outlet, connected / active state, Bed end, `02:00`, Result, Test Mode, modal lock.
- [ ] GUT suite passes or failures are understood and unrelated.
- [ ] Godot headless project parse and relevant scene startup checks pass.
- [ ] Old Main preservation and rollback path are written down.
- [ ] User explicitly approves the dedicated Main replacement task.

## Replacement Strategy

The replacement should move from sandbox evidence to production wiring in controlled phases:

- keep `SurvivalState` as the only power / time / device / result source of truth
- treat `RoomSceneContract` as the interface boundary between room scene and controller
- connect production UI one surface at a time
- avoid copying sandbox-local mock state into production
- keep every phase revertible
- isolate `project.godot` start scene changes

## Phase Plan

### Phase 0: Freeze and Backup

- Record current branch and commit.
- Confirm `origin/main` has no new commits.
- Confirm unrelated local changes are not part of the replacement.
- Confirm old `Main.tscn` and `Main.gd` will remain in place.
- Run pre-change validation from the risk checklist.

### Phase 1: Create Production Candidate Scene

- Create `QuarterviewMain.tscn` and `QuarterviewMain.gd`.
- Host a quarterview room scene or room stub behind `RoomSceneContract`.
- Add only the minimum controller shell needed to run independently.
- Do not change `project.godot` yet.
- Do not delete or rename old Main.

### Phase 2: Move Sandbox Flow into Production Candidate

- Replace sandbox-only panels with production decisions or explicit temporary production candidates.
- Keep interaction request flow through `RoomSceneContract`.
- Preserve modal movement lock.
- Keep no-op logs only where production behavior is intentionally not ready.

### Phase 3: SurvivalState Integration

- Connect production time, power, connected devices, active devices, phone battery, and result data through `SurvivalState`.
- Do not let the room scene calculate power drain.
- Do not keep sandbox-local clock or sandbox result state in production.

### Phase 4: UI Integration

- Decide whether to reuse existing `PhoneUI`, `OutletMode`, and `DayResultPanel` or create production quarterview variants.
- Connect one UI at a time.
- Preserve modal priority and input lock.
- Keep existing production behavior verifiable after each step.

### Phase 5: Project Entry Switch

- Only after the candidate scene passes manual and automated checks, change `project.godot` start scene in an isolated commit.
- Record previous `application/run/main_scene` value.
- Do not combine this with asset imports, atlas work, hacking mission wiring, or broad cleanup.

### Phase 6: Verification and Rollback Readiness

- Re-run all pre-change checks.
- Manually play through the DAY1 path in the new entry.
- Confirm old Main is still present and launchable if needed.
- Confirm rollback instructions still work.

## File Impact Plan

| File | Action | Timing | Risk | Notes |
| --- | --- | --- | --- | --- |
| `godot/scenes/Main.tscn` | Preserve | All phases | High | Do not delete or broad-edit in first replacement pass. |
| `godot/scripts/Main.gd` | Preserve / reference | All phases | High | Use as behavior reference; avoid mixing old and new controllers. |
| `godot/scenes/QuarterviewMain.tscn` | Create candidate | Phase 1 | Medium | Recommended new production candidate scene. |
| `godot/scripts/QuarterviewMain.gd` | Create candidate controller | Phase 1 | Medium | Owns production candidate routing, not sandbox-local state. |
| `godot/scripts/SurvivalState.gd` | Reuse, minimal changes only if unavoidable | Phase 3 | High | Must remain source of truth; changes require tests. |
| `godot/scenes/ui/PhoneUI.tscn` / `godot/scripts/ui/PhoneUI.gd` | Reuse or wrap | Phase 4 | Medium | Decide whether current UI is production reusable. |
| `godot/scenes/ui/OutletMode.tscn` / `godot/scripts/ui/OutletMode.gd` | Reuse or wrap | Phase 4 | High | Must preserve connected / active / slot behavior. |
| `godot/scenes/ui/DayResultPanel.tscn` / `godot/scripts/ui/DayResultPanel.gd` | Reuse or replace deliberately | Phase 4 | Medium | Production result must use `SurvivalState` data. |
| `godot/project.godot` | Start scene switch only | Phase 5 | High | Isolate in its own commit after candidate validation. |
| `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md` | Update with actual check result | Phase 0 / 6 | Low | Keep Must Pass / No-Go accurate. |
| `docs/MAIN_REPLACEMENT_WORK_PLAN.md` | Update if strategy changes | All phases | Low | This is the working plan. |

## State Ownership Plan

`SurvivalState` remains the source of truth for:

- day number
- remaining power
- current game time
- modal pause-sensitive clock progression
- connected devices
- active devices
- active drain
- phone battery and warning thresholds
- result data

Sandbox-local state must not become production state:

- sandbox-local clock
- sandbox manual / auto result flags
- sandbox-only Test Mode values
- mock Phone panel text
- mock Outlet panel text
- no-op interaction logs
- sandbox result summaries

Room scene state should be limited to:

- player position
- nearest interactable
- room visual state
- debug overlay state
- input enabled / disabled state

The controller decides what an interaction means. The room emits requests; it does not open Phone / Outlet / Result or calculate power unless a production controller explicitly wires that route.

## UI Routing Plan

### Phone

- Existing production trigger: `Tab`.
- Sandbox trigger: `Tab` or phone primary action.
- Replacement decision: choose whether production keeps `Tab` only, also allows phone-object primary action, or separates both.
- Production state source: `SurvivalState`.
- SandboxPhonePanel is not automatically production UI.

### Outlet

- Existing production trigger: current apartment outlet / power-strip flow.
- Sandbox trigger: power primary action.
- Replacement decision: reuse existing `OutletMode` if possible; otherwise create a production quarterview outlet wrapper.
- Production state source: `SurvivalState` plus `DeviceDefinition`.
- SandboxOutletPanel is mock-only and must not become the production outlet system without replacement work.

### Result

- Existing production owner: `DayResultPanel`.
- Sandbox owner: `SandboxResultPanel`.
- Replacement decision: production result must either reuse `DayResultPanel` or intentionally replace it with equivalent data coverage.
- Sandbox result summaries are not enough for production.

### End Day

- Manual Bed end should route to production confirmation and result flow.
- `02:00` auto end should remain separate from object interaction.
- Future early / late sleep policy remains undecided and should not block basic replacement if current behavior is preserved.

### Test Mode

- Current Main Test Mode and sandbox `F2` Test Mode are different.
- Production replacement must decide which debug actions remain available and which keys are production-safe.
- Sandbox-only debug state must not alter production `SurvivalState`.

## Input / Modal Plan

Input routing must be decided before entry switch.

Candidate production input rules:

- Movement: allowed only during exploration.
- `E`: nearest interaction only when no blocking modal is open.
- `Tab`: Phone UI toggle only when modal priority allows it.
- `ESC`: close current modal by priority, not all modals at once.
- `R`: production policy must be reviewed; sandbox restart behavior should not automatically enter production.
- `D`: production debug policy must be reviewed.
- `B` / `Backspace`: prototype Hub return should not enter production unless explicitly designed.
- `F2`: Test Mode policy must be reviewed.

Candidate modal priority:

1. Result terminal state
2. Test Mode, if enabled
3. End Day confirmation
4. Phone
5. Outlet
6. Interaction panel
7. Exploration movement / interaction

Final priority must be confirmed during the replacement task against current `Main.gd` behavior.

## Result / End Day Plan

Manual Bed end and `02:00` auto end must both reach production result logic.

Production requirements:

- manual Bed end uses production confirmation
- `02:00` auto end pauses time and power before result transition
- result data is generated from `SurvivalState`
- production result UI is `DayResultPanel` or an intentional replacement
- sandbox result fields do not become production data

Future early sleep buff, late sleep penalty, Grid Credit reward, story flags, and save/load are separate tasks.

## Asset Readiness Plan

Main replacement can proceed with placeholder or blockout visuals only if the fallback is clear and approved.

Assets that may still be future-only:

- room shell PNG layers
- Yui quarterview spritesheet
- furniture atlas
- appliance atlas
- work-device atlas
- UI atlases
- FX atlases

Do not mix asset import with Main replacement. Asset commits should be separate from production wiring commits.

Source-side `.import` files should only be staged when tied to intentionally used assets. External addon raw folders must not be staged accidentally.

## Test Plan

### Pre-change

Run:

```bash
git status --short --branch
git diff --check
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --quit-after 2
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_survival_state.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
```

Manually verify current Main / DAY1 and `QuarterviewGameplaySandbox` before production changes.

### Post-change

Verify:

- new candidate scene starts
- movement works
- nearest interaction works
- Phone opens / closes and reads production state
- Outlet opens / closes and preserves connected / active behavior
- Bed manual end reaches production result
- `02:00` auto end reaches production result
- Result locks input and can continue as designed
- Test Mode / debug policy matches the approved plan
- old Main remains available for fallback
- no null node path errors appear

## Commit Strategy

Keep replacement commits small and reversible.

Recommended split:

1. create `QuarterviewMain` candidate without changing `project.godot`
2. connect production state and UI gradually
3. verify and update docs
4. isolate `project.godot` start scene switch
5. cleanup only after the replacement is stable

Do not combine Main replacement with:

- visual asset import
- UI atlas application
- hacking mission wiring
- Grid Credit / reward wiring
- broad refactors
- unrelated local changes

Before each commit:

```bash
git status --short
git diff --cached --name-only
```

## Rollback Plan

Rollback principles:

- do not delete old `Main.tscn` or `Main.gd` in the first replacement pass
- keep replacement commits revertible
- isolate start-scene switch
- record the pre-replacement commit hash
- keep PrototypeHub and `QuarterviewGameplaySandbox` available for diagnostics

Candidate rollback:

```bash
git revert <replacement_commit>
```

If the start scene was switched, restore `godot/project.godot` `application/run/main_scene` to the previous `Main.tscn` path or revert the isolated start-scene commit.

## Go / No-Go Gate

### Go

- Risk checklist reviewed and complete.
- Work plan reviewed.
- Existing Main / DAY1 manual playtest passed.
- QuarterviewGameplaySandbox manual playtest passed.
- GUT and headless checks passed or failures are understood.
- Rollback path is clear.
- Old Main is preserved.
- User explicitly approves the dedicated replacement task.

### No-Go

- `SurvivalState` ownership is unclear.
- Phone / Outlet / Result routing is unclear.
- sandbox-only state would leak into production.
- rollback path is unclear.
- missing visual fallback would block playability.
- old Main would be deleted or overwritten.
- start-scene switch would be mixed with unrelated edits.
- asset import or hacking mission wiring is bundled with replacement.

## Open Questions

- Should the first production candidate be `QuarterviewMain.tscn` or an internal `Main.tscn` replacement? Current recommendation: new `QuarterviewMain`.
- Should production reuse `PhoneUI`, `OutletMode`, and `DayResultPanel`, or introduce quarterview-specific wrappers?
- Does `SandboxResultPanel` stay sandbox-only, or become a prototype for a future Result UI replacement?
- Which Test Mode keys are allowed in production replacement?
- Does `02:00` route immediately to Result or preserve the current dialogue-only transition?
- Are early sleep buff and late sleep penalty part of replacement or a later design task?
- Can Main replacement proceed before final room shell / Yui quarterview visuals, using approved placeholders?
- Should Laptop -> Hacking happen before or after Main replacement? Current recommendation: after.

## Final Notes

This plan is a preparation document only. It does not change `Main`, `project.godot`, production scenes, scripts, Resources, or assets.

Main replacement should start only after the risk checklist, this work plan, manual GUI checks, automated validation, rollback plan, and user approval are all aligned. The safest first move is a new production candidate scene that preserves the current Main golden path until the final entry switch.
