# Repository Guidelines

## 1. Project Direction

* The active project is the Godot project under `godot/`.
* `src/` is a legacy React / Vite / Phaser prototype. Do not edit it unless the user explicitly asks.
* The current product direction is `CONCENT / 전력 부족의 시대`.
* The game is a 2D narrative survival adventure about living in a small lower-grid room while managing scarce power, work devices, and information-risk choices.
* The existing `Main.tscn` / DAY1 top-view flow is still the protected golden path.
* `QuarterviewMain.tscn` is the current production candidate path, but it is not the project start scene.
* Quarterview, hacking, atlas, UI replacement, and economy work must pass through candidate / prototype / Resource / documentation stages before production wiring.

## 2. Current Documentation Structure

Root `docs/` is intentionally small. Keep only these active Markdown files at root:

* `docs/GAME_INFO.md`
* `docs/PROJECT_STATUS.md`
* `docs/PROJECT_WORK_LOG.md`

Current reference docs live under `docs/reference/`:

* `docs/reference/WORLD.md`
* `docs/reference/STORY.md`
* `docs/reference/CHARACTERS.md`
* `docs/reference/GAME_RULES.md`
* `docs/reference/ROOM_OBJECTS.md`
* `docs/reference/ART_DIRECTION.md`
* `docs/reference/TECHNICAL_MAP.md`

Use this priority order when reading project direction:

1. `AGENTS.md`
2. `docs/GAME_INFO.md`
3. The directly relevant `docs/reference/*.md`
4. `docs/PROJECT_STATUS.md`
5. Actual repo files, Godot scenes, Resources, and tests

`docs/old/` is historical archive. Do not treat old docs as current source of truth unless the task explicitly asks to recover historical details.

When a game decision changes:

1. Update the relevant `docs/reference/*.md`.
2. Reflect the top-level summary in `docs/GAME_INFO.md` if needed.
3. Update `docs/PROJECT_STATUS.md` and `docs/PROJECT_WORK_LOG.md` only with current progress and completion notes.

Do not create new root-level docs without explicit user approval. If a new reference is needed, prefer `docs/reference/`.

If `PROJECT_STATUS.md` or `PROJECT_WORK_LOG.md` grows past about 200 lines, rotate it to `docs/old/<NAME>_<YYYYMMDD>_<NN>.md` and recreate a short active file. Do not rotate `AGENTS.md` or `docs/GAME_INFO.md`.

## 3. Basic Folder Map

* `godot/`: active Godot project and primary work area.
* `godot/scenes/`: Godot scenes.
* `godot/scripts/`: GDScript files.
* `godot/resources/`: `.tres` Resource files.
* `godot/test/unit/`: GUT unit tests.
* `docs/`: current project entry, status, and work log only.
* `docs/reference/`: current world, story, rules, art, object, and technical references.
* `docs/old/`: archived historical docs.
* `src/`: legacy web prototype; reference-only by default.
* `README.md`: broad project overview and run notes.

## 4. Protected Production Files

Do not modify these by default:

* `godot/scenes/Main.tscn`
* `godot/scripts/Main.gd`
* `godot/scripts/Apartment.gd`
* `godot/scripts/Player.gd`
* `godot/scripts/SurvivalState.gd`
* `godot/scenes/ui/PhoneUI.tscn`
* `godot/scripts/ui/PhoneUI.gd`
* `godot/scenes/ui/OutletMode.tscn`
* `godot/scripts/ui/OutletMode.gd`
* `godot/scenes/ui/DayResultPanel.tscn`
* `godot/scripts/ui/DayResultPanel.gd`
* `godot/project.godot`

These files belong to production Main / DAY1 or an explicitly approved Main replacement task.

## 5. Main Replacement Gate

Do not replace Main or change `project.godot` start scene until all are true:

* Existing Main / DAY1 manual check passes.
* QuarterviewMain manual check passes.
* Relevant GUT / headless validation passes, or failures are documented.
* The user explicitly approves Main replacement.
* The start-scene change is isolated as a final dedicated step.

First replacement attempts should preserve old Main and use a new candidate scene rather than deleting or overwriting the golden path.

## 6. Git Rules

Unless the user asks for a different branch, work on `main`.

Before work:

```bash
git status --short --branch
git rev-parse --short HEAD
git fetch origin
git log --oneline HEAD..origin/main
```

Stop and report if:

* the current branch is not `main`
* `origin/main` has new commits
* a conflict appears
* a push fails

Do not pull, merge, rebase, reset, force push, or resolve conflicts unless explicitly asked.

Never use `git add .`.

Stage only the files intentionally changed for the current task. Do not stage unrelated local changes, raw addon folders, unrelated `.import` files, `.uid` files, generated cache files, license folders, or unrelated `Apartment.gd` edits.

Before commit:

```bash
git status --short
git diff --cached --name-only
```

Commits should be small, named clearly, and pushed to `origin main` when validation succeeds.

## 7. Godot Rules

* Godot 4.5.x is the target.
* `godot/` is the current source of truth.
* For scene / UI work, prefer Godot AI MCP read-only hierarchy checks before editing.
* Do not guess-edit `.tscn` text when scene hierarchy or property inspection is needed.
* If Godot AI MCP is unavailable, report it and use filesystem inspection plus headless validation conservatively.
* Keep scene scripts focused on scene behavior.
* Move repeated definitions, tuning data, and structured values into `Resource` files when it helps without causing a large refactor.
* Prefer small, reviewable changes over broad rewrites.
* Add comments only where they explain engine behavior, intent, or non-obvious decisions.

## 8. Production State Ownership

Production day / time / power / connected device / active device / phone / result state belongs to `SurvivalState.gd`.

Connected devices and active devices are different concepts. Keep them separate.

Room scenes may:

* expose interaction requests
* update visual sync
* report nearest interactables
* show local candidate UI when explicitly scoped to a candidate scene

Room scenes must not own production power drain, day advancement, Result flow, save-load, Grid Credit reward, or story flags.

QuarterviewMain mock HUD and candidate overlays are local candidate state. Do not copy them into production without a dedicated task.

## 9. Quarterview / Prototype Boundary

* `QuarterviewMain` is a production candidate, not the shipped entry point.
* `QuarterviewGameplaySandbox` is sandbox-only.
* `QuarterviewRoomPrototype` is an object / interaction contract prototype.
* `QuarterviewPerspectiveBlockout` is a viewpoint / depth / proportion blockout.
* `QuarterviewRoomShellPrototype` is a room shell layer path and missing-status prototype.
* `HackingActionPrototype` is an action / state / feedback prototype.
* `PrototypeSceneUtils`, `PrototypeSfx`, and `PrototypeInputPrompts` are prototype helpers.

Until explicitly approved, candidate / sandbox UI must not call or mutate:

* `Main.gd`
* `SurvivalState.gd`
* production `PhoneUI`
* production `OutletMode`
* production `DayResultPanel`
* save-load
* Grid Credit rewards
* story flags
* real Hacking scene transitions

## 10. QuarterviewMain Current Policy

QuarterviewMain is mouse-click first:

* object click -> Yui moves -> candidate panel / overlay
* `P` opens portable Phone candidate
* Desk / Laptop is the job and hacking-entry hub
* Power Board is a local no-op modular puzzle candidate
* Bed, Food / Kitchen, Door, Day Result, and Hacking Entry overlays are candidate-only

Keep overlay input lock behavior intact:

* overlay open locks room movement and object click
* ESC / close button / backdrop click closes when supported
* closing restores room input

Do not wire QuarterviewMain to production `PhoneUI`, `OutletMode`, `DayResultPanel`, `SurvivalState`, Hacking, Grid Credit, save-load, or story flags without explicit approval.

## 11. Asset / Atlas Policy

* Create or apply PNGs only in explicit asset tasks.
* Do not copy images from `/mnt/data` or temporary external paths unless the user explicitly asks.
* Do not regenerate existing atlases or spritesheets unless the task asks.
* Do not stage raw Asset Library addon folders.
* Third-party assets must be selected copies under `godot/assets/.../third_party/...` with license files.
* Stage `.import` and `.uid` files only when they are directly required by the current asset or script change.
* Never commit `godot/.godot/`, cache files, or generated editor output.
* Git LFS is not enabled; large art / audio additions need a separate size/LFS decision.

Most atlas mapping references are planning data. Do not create mapping Resources, Themes, StyleBoxes, SpriteFrames, or scene wiring unless the task explicitly asks.

## 12. Room Shell Image Rules

Quarterview room shell images are not atlases. They are same-canvas transparent PNG layers.

Core layer names:

* `qv_room_floor_base.png`
* `qv_room_walls_back.png`
* `qv_room_walls_side.png`
* `qv_room_foreground_occluders.png`
* `qv_room_window_city_view.png`
* `qv_room_static_lighting_overlay.png`

Rules:

* Same canvas size and origin.
* Same camera angle.
* Transparent background.
* Only include the requested layer's content.
* No character, UI, text, labels, unrelated furniture, unrelated props, or atlas layout.
* Foreground occluders are a foreground layer, not a props atlas.
* Window city view and lighting / FX must stay in their own layers.

## 13. Validation Commands

Run validation appropriate to the changed scope.

Godot project parse:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --quit-after 2
```

QuarterviewMain startup:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot res://scenes/QuarterviewMain.tscn --quit-after 2
```

Full GUT:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
```

For implementation tasks, run `scripts/validate_concent.sh --full` before completion; documentation-only or simple configuration work may use `--quick` when Godot tests are unnecessary.

Common targeted GUT examples:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_survival_state.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_power_board_candidate_state.gd -gexit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot -s res://addons/gut/gut_cmdln.gd -gtest=res://test/unit/test_quarterview_job_definition.gd -gexit
```

For docs-only tasks, targeted `git diff --check` is enough unless the user requests Godot validation. If full `git diff --check` fails because of unrelated dirty files, report the unrelated file and run targeted checks for the current work.

Web prototype commands are only for explicit `src/` work:

```bash
npm run lint
npm run build
```

## 14. Task Completion Checklist

For meaningful work:

1. Inspect actual changed files.
2. Run appropriate validation.
3. Update the relevant `docs/reference/*.md` if direction changed.
4. Update `docs/GAME_INFO.md` if top-level project info changed.
5. Update `docs/PROJECT_STATUS.md` and `docs/PROJECT_WORK_LOG.md` for progress.
6. Check `git diff`.
7. Stage only current-task files.
8. Commit with a clear message.
9. Push to `origin main`.

Before reporting completion, make sure docs match the actual repo state and no unrelated files are staged.

## 15. Reporting

Keep reports short and concrete.

Recommended shape:

* Completed
* Changed Files
* Documentation Updated
* Validation
* Manual Checks Still Needed
* Risks / TODO
* Git

Avoid vague claims such as "architecture improved" unless you name the actual files and behavior that changed.

## 16. Custom Agent Delegation

* Before changes spanning multiple domains, use `codebase_explorer` to map the impact surface.
* Do not let two writer agents modify the same file concurrently in one checkout.
* Run independent parallel writes only in separate worktrees.
* After implementation, request a read-only review from `qa_reviewer`.
* The main agent normally owns final staging, committing, and pushing.
* Do not use subagents unnecessarily for a simple one-file change.
