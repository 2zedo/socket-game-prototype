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
- Before starting work, confirm the current branch with:

```bash
git status --short --branch
```

- If the current branch is not `main`, stop and report it before making changes.
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
- If there are unrelated local changes, do not stage them. Report them separately.
- Keep commits focused. Separate documentation, refactors, and gameplay changes when practical.
- Do not commit Godot-generated files or local cache output, including:
  - `godot/.godot/`
  - Godot shader cache files
  - editor layout/cache files
  - generated import/cache folders

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

- At the end of every completed task, update `docs/PROJECT_STATUS.md`.
- `docs/PROJECT_STATUS.md` is the living progress artifact for the project.
- The status file should summarize:
  - current branch
  - latest commit
  - current development phase
  - completed work
  - changed files
  - validation results
  - current risks or known issues
  - next recommended task
- Keep the progress file concise and useful. Do not turn it into a long diary.
- If the task changes the development direction, also update `docs/ROADMAP.md`.
- If the task changes the immediate Godot MVP scope, also update `docs/GODOT_DAY1_MVP_PLAN.md`.
- Keep `README.md` concise:
  - project overview
  - repository structure
  - setup/run instructions
  - current development target

- Put detailed game design in `docs/`.
- Put implementation plans or migration notes in `docs/`.
- Update documentation when project structure, run commands, or core development direction changes.
- Do not update README for every small gameplay tweak.

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

- What changed
- Why it changed
- What was not changed
- Validation result
- Next recommended step

Avoid vague claims such as “improved architecture” unless the actual changes are listed.
