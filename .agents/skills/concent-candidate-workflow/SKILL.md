---
name: concent-candidate-workflow
description: CONCENT 저장소 전용 실험적 Godot candidate 개발 workflow. production 보호, 범위·완료 기준, custom agent 선택, 자동·수동 검증 분리, GRADUATE/KEEP_CANDIDATE/ABANDON 판단을 다루며 검증과 Git은 기존 Skill에 위임한다.
---

# CONCENT Candidate Development and Graduation Workflow

Use `$concent-candidate-workflow` before changing a CONCENT experimental Godot
candidate or deciding whether one should move toward production. This workflow
does not itself validate, stage, commit, push, or promote production files.

## 1. Decide the delivery path

Create or extend a candidate when the request involves a new loop or screen
flow, production-connection-changing scene restructure, major UI or
interaction, room/camera/movement/collision experiment, visual iteration,
data/Resource contract prevalidation, or a risk of breaking game progression.

Direct production work is appropriate only for a small approved bug fix,
text/comments/docs, test-only work, validator/Skill/Git procedure work, an
approved local numeric coordinate adjustment, or a clearly contract-neutral
one-file production change.

For ambiguous work, report the impact and the decision needed. Do not
automatically turn it into a candidate or production change.

## 2. Define the candidate before implementation

Record all of the following before work begins. Do not start when automated and
manual done criteria are absent.

- Candidate name and explicit path
- Named goal
- In-scope and out-of-scope behavior
- Protected production files, systems, and state
- Automated completion criteria
- Manual completion criteria
- Graduation criteria and known leftovers

## 3. Choose agents deliberately

For a small, clear docs or Skill task, the main agent works alone. For a
medium structural change across Scenes, Scripts, or Resources, call
`codebase_explorer` first for a read-only impact map. Use one writer in a
shared checkout. Request `qa_reviewer` only for production-boundary work,
complex contracts, migrations, or high-regression changes. Do not call agents
habitually for simple documentation or Skill work.

## 4. Keep the candidate boundary intact

- Give each candidate an explicit name and path.
- Do not automatically connect it to production or set it as the project main
  scene.
- Do not copy large portions of production code into a candidate.
- Split reusable structured data into a small shared data or Resource contract
  before sharing behavior.
- Do not load or preload assets that are not confirmed to exist.
- Do not claim production completion from an unconfirmed candidate result.
- Do not consider visual work final before visual confirmation.

Candidate paths must not mutate production Main/DAY1 state, `SurvivalState`,
production PhoneUI, OutletMode, DayResultPanel, save-load, Grid Credit, story
flags, or real hacking transitions unless the user has separately approved
production wiring.

## 5. Validate automatically, then confirm manually

Delegate automated validation to `$concent-godot-validation`:

- Godot code, Scene, Resource, or test changes require `full` validation.
- Documentation, AGENTS, Codex settings, or Skill-only changes use `quick`.
- When scope is uncertain, use `full`.

Automated evidence should cover applicable parse, candidate-scene startup,
Resource loading, GUT tests, signals/state transitions, input lock,
movement/collision, production-dependency checks, and working-tree checks.

Visual layout, camera framing, object placement, readability, interaction feel,
and user-facing flow require a human Godot-window check. Report exactly:

`Manual confirmation: REQUIRED`

Do not promote a candidate before the required manual confirmation and user
approval.

## 6. Decide the candidate status

- `GRADUATE`: its purpose is met; automated validation passes; no critical
  blocker remains; the production boundary is confirmed; manual confirmation
  and user approval are complete; a production impact list exists; and any
  remaining polish/backlog is recorded.
- `KEEP_CANDIDATE`: the structure and automated tests are sound, but visual
  confirmation is incomplete, usability is uncertain, production wiring is not
  agreed, or a specific blocker remains.
- `ABANDON`: a debug shortcut grew beyond its purpose, production behavior was
  duplicated, iterations do not improve the result, a simpler alternative is
  available, or the work is no longer needed.

Do not change an existing candidate to `GRADUATE` merely because this workflow
was run. Current Apartment candidate work remains a candidate until its visual
confirmation and explicit approval are complete.

## 7. Run the anti-overbuild check

Before another iteration, ask whether it advances the named purpose or user
experience, is debug-only, introduces production duplication, has a credible
graduation criterion, and is proportionate in complexity. If not, stop and
choose one of: reduce scope, simplify, request approval, keep as candidate, or
abandon.

## 8. Treat promotion as a separate task

Never promote automatically. A separately approved promotion task must state
the candidate, approved behavior, production files to change, candidate files
to retain or remove, data migration, regression and rollback plan, and
validation plan.

Explicit user approval is required before changing Main/DAY1, Apartment,
SurvivalState, the project start scene, production data contracts, or
production UI.

## 9. Report the decision

Use this concise report shape:

```text
Candidate Goal:
Status: GRADUATE | KEEP_CANDIDATE | ABANDON
Changed:
Protected production:
Automated validation:
Manual confirmation: REQUIRED | complete
Graduation / blockers:
Known leftovers:
```

After validation succeeds, delegate selective staging, commit, and push to
`$concent-safe-git`. Keep validation and Safe Git procedures in those Skills;
do not duplicate their command sequences here.
