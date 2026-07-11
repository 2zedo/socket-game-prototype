---
name: concent-godot-validation
description: CONCENT repository-only Godot validation workflow. Use after CONCENT .gd, .tscn, .tres, test, addon, or project changes, or when asked to run project parse, QuarterviewMain/apartment-shell startup, or Full GUT; use quick only for Markdown, AGENTS, Codex settings, or repository Skills. Choose and run scripts/validate_concent.sh without Git mutation or deployment.
---

# CONCENT Godot Validation

Confirm this is the CONCENT repository and that `scripts/validate_concent.sh` exists. If it is missing, report that validation cannot use the shared runner; do not recreate its commands or add a replacement script.

## Choose the mode

Run `--full` for `.gd`, `.tscn`, `.tres`, Godot test, addon, or `project.godot` changes; gameplay/UI/movement/collision/save/combat changes; refactors affecting multiple files or an execution flow; or whenever the user requests full validation.

Run `--quick` only for Markdown, `AGENTS.md`, Codex configuration, or repository Skill-only changes that cannot affect Godot runtime behavior. Prefer `--full` whenever impact is uncertain or the user asks for stronger validation. Never lower validation merely to save time.

## Run the shared validator

From the repository root, run one of:

```bash
scripts/validate_concent.sh --full
scripts/validate_concent.sh --quick
```

Only when the validator cannot find Godot, inspect the actual installation path and provide it with `GODOT_BIN` or `--godot-bin`:

```bash
GODOT_BIN="/actual/path/to/Godot" scripts/validate_concent.sh --full
scripts/validate_concent.sh --godot-bin "/actual/path/to/Godot" --full
```

Use `--keep-logs` when logs must remain after a successful run. The validator preserves logs automatically after failures.

## Handle results

Treat the validator's exit code and per-step summary as authoritative. On failure, record the failed step, actual exit code, log path, and relevant log tail; distinguish the known Phone PNG direct-load export warning from a real failure. Do not hide warnings, ignore tests, delete `.import`/`.uid`, or bypass the runner. After an in-scope fix, rerun the same mode and report both the first failure and final result.

Report concise results in this shape:

```text
Validation:
- Mode: full|quick
- Result: PASS|FAIL
- Git diff checks: PASS|FAIL
- Godot project parse: PASS|FAIL|SKIP
- QuarterviewMain startup: PASS|FAIL|SKIP
- Apartment shell startup: PASS|FAIL|SKIP
- Full GUT: PASS|FAIL|SKIP
- Known warnings: Phone PNG warning present|not present
- Git status: tracked / staged / untracked summary
- Duration: validator summary value
```

In quick mode, report Full GUT as `SKIP`; do not hardcode test or assertion counts.

## Boundaries

Use this Skill only to select a mode, run `scripts/validate_concent.sh`, inspect failure logs, and summarize results. Do not duplicate validation commands, modify validation logic, stage/commit/push, clean/restore, delete files, suppress warnings, or automatically change game code. Keep any fix within the user's current task scope.
