# Repository Guidelines

## Project Direction

- The main development target is the Godot project under `godot/`.
- The React/Vite/Phaser web prototype is legacy/reference material.
- Do not modify React/Vite/Phaser web files unless the user explicitly asks for web-side work.
- The current product direction is `CONCENT / 전력 부족의 시대`: a 2D narrative survival adventure focused on power management in a small apartment.
- The first playable goal is a Godot-based `DAY 1 MVP`, not a full DAY 1~12 implementation.

## Repository Map

- `godot/`: Main Godot project. Prioritize work here.
- `godot/scenes/`: Godot scenes.
- `godot/scripts/`: Godot GDScript files.
- `src/`: React/Vite/Phaser web prototype. Treat as reference unless instructed otherwise.
- `docs/`: Planning, specifications, implementation notes, and handoff documents.
- `README.md`: High-level project entry point and run instructions.

## Source Control Rules

- This repository is currently developed directly on `main` unless the user explicitly asks for a separate branch.
- Before starting any development work, complete the startup check:
  - run `git status --short --branch`
  - confirm the current branch
  - record the task-start commit with `git rev-parse --short HEAD`
  - run `git fetch origin`
  - run `git log --oneline HEAD..origin/main`
  - read `AGENTS.md`
  - read existing relevant tracking docs when present:
    - `docs/PROJECT_STATUS.md`
    - `docs/ROADMAP.md`
    - `docs/GODOT_DAY1_MVP_PLAN.md`
    - `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`
    - `docs/ASSET_APPLICATION_NOTES.md`
    - `docs/YUI_ANIMATION_NOTES.md`
- Preserve each document's existing heading structure, tone, bullet style, and level of detail.
- Do not invent missing tracking documents. Do not create `NEXT_TASKS.md`, `WORK_LOG.md`, or similar files unless the user explicitly asks for them.
- Modify only the documents relevant to the current task.
- If the current branch is not `main`, stop and report it before making changes.
- If `git log --oneline HEAD..origin/main` shows any commits, stop before making changes.
- Do not automatically pull, merge, rebase, or reset when new remote commits exist.
- Report the new commit list and ask the user what to do next.
- Only continue when local `main` is already up to date with `origin/main`.
- After completing a task, stage only the files that are necessary for the requested change.
- Do not use `git add .` unless the task clearly requires every changed file.
- Before committing, inspect the changed files with `git status --short`.
- Run relevant validation commands before committing when practical.
- Commit only when the task is complete and validation has passed, or when validation is impossible and that limitation is clearly reported.
- Use concise commit messages such as:
  - `chore: update project instructions`
  - `docs: add project progress tracking`
  - `docs: add Godot DAY 1 MVP plan`
  - `feat: add Godot power loop`
- Push completed commits to `origin main`.
- If push fails, do not force push. Report the error and stop.
- Before pushing, check remote state. If remote changes exist, stop and report instead of overwriting or force pushing.
- If conflicts occur, stop and report the conflicted files, likely cause, and required next action. Do not delete or overwrite someone else's work to resolve a conflict.
- If there are unrelated local changes, do not stage them. Report them separately.
- Keep commits focused. Separate documentation, refactors, and gameplay changes when practical.
- For a meaningful work unit, commit the related code, scene, and documentation updates together. Do not split documentation into a separate commit unless the task is documentation-only.
- Do not commit Godot-generated files or local cache output, including:
  - `godot/.godot/`
  - Godot shader cache files
  - editor layout/cache files
  - generated import/cache folders
- Commit user-provided reference images only when they are intended to remain project documentation assets.

- Before finishing a task, report:
  - branch name
  - changed files
  - reason for each change
  - validation commands and results
  - remaining risks or TODOs

## Implementation Guardrails

- Do not remove existing comments casually.
- Preserve existing code comments unless they are clearly obsolete because of the current change.
- Add comments to new code when they clarify gameplay intent, engine behavior, or non-obvious decisions.
- When the user names reference images as implementation specifications, open and inspect those images before editing. If the files cannot be read, stop and report that before making code, scene, or asset changes.
- When reference images contain written labels, layout notes, proportions, or numbered object guides, treat those notes as the primary implementation source for that task unless the user explicitly says otherwise.
- Avoid broad refactors unless the user explicitly asks for them.
- Before making a large structural change, summarize:
  - what will change
  - why it is needed
  - what files are likely to be affected

- Prefer small, reviewable changes over one large all-in-one implementation.

## Godot Development Rules

- Target Godot 4.x unless the project files indicate otherwise.
- Treat `godot/` as the source of truth for active development.
- Keep gameplay state and tuning data out of large monolithic scripts when practical.
- Prefer Godot `Resource` files (`.tres`) or data files for:
  - power costs
  - object definitions
  - day/event definitions
  - dialogue data
  - tuning values

- Keep scene scripts focused on scene behavior. Move shared state and reusable logic into managers/resources when useful.
- Do not over-engineer the prototype. The first priority is a working DAY 1 loop.

## Current Godot MVP Target

The DAY 1 MVP should prove the core loop:

1. Start the game.
2. Enter the apartment/room scene.
3. Show current power.
4. Interact with room objects.
5. Choose whether to spend power.
6. Reduce power when a choice is confirmed.
7. Block actions when power is insufficient.
8. Show dialogue or event feedback.
9. End the day.
10. Show a simple result summary.

Initial interactable objects may include:

- Light
- Laptop
- Fan
- Charger
- Communication device
- Door/window/power strip as optional later objects

## Narrative and Design Direction

- The intended tone is dark, quiet, lonely, and grounded.
- Avoid bright arcade-like UI unless explicitly requested.
- Avoid visual or structural similarity to existing top-down survival/management games. References such as Among Us are only useful for the abstract idea of top-down movement plus proximity interaction, not for art style, UI layout, or room composition.
- Treat prison/facility-management survival games and bright pixel life-sim/task HUDs as anti-references. `CONCENT` should read as a quiet one-room power-shortage narrative adventure, not a facility/task-management clone.
- The core fantasy is not “defeating enemies”; it is surviving through limited power and difficult choices.
- Power usage should feel like a tradeoff:
  - survival
  - information
  - comfort
  - relationship
  - risk

- Key characters/concepts:
  - Yui: player protagonist and survivor
  - Delivery robot: support NPC and possible clue carrier
  - Management office staff: grounded human pressure and information source
  - Grid: mysterious power/network system tied to the larger truth

## Web Prototype Rules

- The Phaser prototype may be useful as a design reference for:
  - power strip interactions
  - power limits
  - day/night cycle
  - needs/status values
  - daily events
  - upgrades

- Do not port everything blindly.
- When moving ideas from Phaser to Godot, first identify the smallest system needed for the current Godot MVP.
- Do not edit `src/`, `package.json`, or Vite-related files unless the task explicitly requires it.
- If web files are modified, run the web validation commands before finishing.

## Documentation Rules

- Update documentation after a meaningful work unit is complete, not after every tiny edit.
- Meaningful work units include examples such as player scale/walk animation improvement, apartment map tone revision, multitap placement/cable presentation, multitap UI revision, or dialogue portrait structure revision.
- At the end of every completed development task, update `docs/PROJECT_STATUS.md`.
- `docs/PROJECT_STATUS.md` is the living progress artifact for the project.
- Keep `docs/PROJECT_STATUS.md` as the current status board, not a long diary.
- Preserve the existing structure and update these sections to match the actual result:
  - `Snapshot`: current phase, current branch, and latest commit at task start
  - `Latest Completed Work`: only work actually completed, preferably 3-7 concise bullets for the current unit
  - `Current Goal`: 2-4 active goals; move completed goals to completed work
  - `Changed Files`: important changed files only, excluding caches and unrelated files
  - `Validation Results`: commands run, Godot/manual checks, and explicit `Not verified` or `Manual check required` notes when validation was not possible
  - `Current Risks or Known Issues`: remaining bugs, manual checks, structural risks, and temporary implementations
  - `Next Recommended Task`: 1-3 immediately actionable tasks
- Each `Next Recommended Task` entry should include what to change, why it is needed, which files or systems to inspect first, and completion criteria.
- Keep the progress file concise and useful. Do not turn it into a long diary.
- Update `docs/ROADMAP.md` only when broad direction or stage changes, such as demo scope, development phase, core system priority, long-term/release target, or a shift from DAY 1 MVP to a broader DAY 1-12 demo.
- Do not update `docs/ROADMAP.md` for ordinary UI tweaks or small feature changes.
- Update `docs/GODOT_DAY1_MVP_PLAN.md` only when the current Godot MVP feature plan changes.
- Preserve the MVP plan order: `Purpose`, `Success Criteria`, `Required Systems`, `Implementation Order`, and `Out Of Scope`.
- If work changes actual success criteria or implementation status, reflect that in `docs/GODOT_DAY1_MVP_PLAN.md`.
- Update `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md` when the task changes the map, UI, dialogue window, multitap screen, layout, camera, lighting, or other visual presentation.
- For visual work, add a new pass instead of deleting older pass history:
  - `## <Work Name> Pass`
  - one short paragraph describing what changed and what existing systems were not changed
  - `## <Work Name> Adjustments`
  - bullets for actual changes, preserved behavior, changed scenes/UI structure, and manual checks needed
- Update `docs/ASSET_APPLICATION_NOTES.md` only when applying new image/pixel assets, replacing temporary assets, changing resources from references, or changing SpriteFrames, textures, atlases, or font application.
- Asset notes should list applied assets, file paths, scene/node usage, scale handling, whether assets are temporary, and future replacement needs.
- Update `docs/YUI_ANIMATION_NOTES.md` only when Yui's in-game sprite or animation changes.
- Yui animation notes should include changed directions/animations, frame count, frame rate, sprite size/scale, movement-to-idle behavior, remaining awkwardness, and next animation tasks.
- Keep `README.md` concise:
  - project overview
  - repository structure
  - setup/run instructions
  - current development target

- Put detailed game design in `docs/`.
- Put implementation plans or migration notes in `docs/`.
- Update documentation when project structure, run commands, or core development direction changes.
- Do not update README for every small gameplay tweak.
- Do not add excessive dates/times to document bodies. Use Git commits and `git log` as the source of truth for dates and authors.
- Record commit hashes in document bodies only when they are useful reference points, such as `Latest commit at task start`.
- Do not guess past dates or authors.
- Do not delete completed pass history just because it is old. If a document becomes too long, report a proposed split before reorganizing it.

## Work Unit Closeout

At the end of each meaningful work unit:

1. Check the actual changed files.
2. Run practical validation.
3. Update the relevant detailed document for the task type.
4. Update `docs/PROJECT_STATUS.md`.
5. Re-evaluate `Next Recommended Task` from the current code, docs, validation results, roadmap, MVP plan, reference images, and remaining blockers.
6. Inspect `git diff`.
7. Stage only the files required for that work unit.
8. Commit with a clear message.
9. Push to `origin main`.

Before ending a work session, confirm:

- related code and scenes are saved
- validation was run where possible
- `docs/PROJECT_STATUS.md` matches the current state
- the relevant detailed docs were updated
- `Next Recommended Task` is current
- changed files are reflected in the docs
- commit and push succeeded, or failure was reported clearly
- incomplete work was not recorded as completed

## Validation Commands

Run only the commands relevant to the files changed.

For web prototype changes:

```bash
npm run lint
npm run build
```

For Godot changes:

- Open the Godot project under `godot/` and run the main scene when GUI validation is needed.
- If a Godot CLI is available locally, use an appropriate headless or syntax-check command for the installed version.
- Always mention when Godot validation could not be run in the current environment.

For repository hygiene:

```bash
git status --short --branch
```

## Communication Style for Task Reports

When finishing a task, keep the report short and concrete:

- `Completed`: completed work
- `Changed Files`: important changed files
- `Documentation Updated`: updated docs and why
- `Validation`: commands/tests and manual checks still needed
- `Next Recommended Tasks`: 1-3 next tasks
- `Git`: branch, commit, and push result

Avoid vague claims such as “improved architecture” unless the actual changes are listed.
