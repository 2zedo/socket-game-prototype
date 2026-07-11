---
name: concent-docs-sync
description: CONCENT 저장소 전용 문서 동기화 workflow. 구현·게임 설계·기술 구조 변경 뒤 적절한 docs/reference 정본, GAME_INFO 요약 필요 여부, PROJECT_STATUS·PROJECT_WORK_LOG 갱신, docs/old 회전, 불필요한 수정·중복 방지를 판단하며 검증과 Git 반영은 기존 전용 Skill에 위임한다.
---

# CONCENT Documentation Synchronization

Use `$concent-docs-sync` after a CONCENT implementation, game-design, or
technical-structure change to decide whether documentation needs a minimal
update. This Skill is repository-only and does not make game-design decisions,
implement code, run validation commands, or perform Git operations.

## 1. Inspect before writing

1. Inspect the actual changed files and diff.
2. Compare the result with the user request; do not document an unapproved idea,
   failed experiment, or inferred implementation.
3. Decide whether documentation is required.
4. Select one or more canonical documents only when a real change requires it.
5. Keep the detailed explanation in one canonical document and use a short
   reference elsewhere only when it prevents confusion.

Do not update documentation merely because a task changed files. A no-change
decision is valid; do not force an entry into PROJECT_STATUS or
PROJECT_WORK_LOG unless the user explicitly requests one.

## 2. Decide whether documentation is required

Documentation is normally required for a changed game rule or player flow,
confirmed world/story/character setting, room-object role or interaction,
art/asset rule, Scene/Script/Resource responsibility, major system or data
contract, production/candidate boundary, development/validation/Git/Skill
procedure, or a materially changed current status, blocker, or next step.

Documentation is normally unnecessary for a behavior-preserving refactor,
comment/typo/text correction, contract-neutral test addition, tiny coordinate
or numeric tune, generated metadata, information already recorded accurately,
unapproved idea, or failed/abandoned temporary experiment.

If the scope is ambiguous, report the affected canonical document and ask for
the decision instead of creating a speculative document update.

## 3. Use the current document structure

Keep exactly these active root documents:

- `docs/GAME_INFO.md`
- `docs/PROJECT_STATUS.md`
- `docs/PROJECT_WORK_LOG.md`

Do not create a new root-level design document or automatically create a new
reference document. Integrate information into the most suitable current
reference:

| Change type | Canonical document |
| --- | --- |
| World, society, city, living environment | `docs/reference/WORLD.md` |
| Act, episode, event progression, story flow | `docs/reference/STORY.md` |
| Yui or other character settings and relationships | `docs/reference/CHARACTERS.md` |
| Loop, power, hunger, time, combat, hacking, win/loss rules | `docs/reference/GAME_RULES.md` |
| Room structure, facilities, interactable objects | `docs/reference/ROOM_OBJECTS.md` |
| Viewpoint, pixel art, color, animation, asset rules | `docs/reference/ART_DIRECTION.md` |
| Scene/Script/Resource roles, tests, Skills, development procedures | `docs/reference/TECHNICAL_MAP.md` |

`docs/old/` is archival history, not current source of truth. Never put local
absolute paths or user attachment paths into repository documentation.

## 4. Update summaries only when their role requires it

Update `GAME_INFO.md` only when the project direction, confirmed major
feature/mode/character/world setting, or newcomer-critical top-level structure
is stale. Keep it brief; exclude coordinates, debug options, exhaustive file
lists, Resource fields, test counts, commit history, and temporary candidate
details.

Update `PROJECT_STATUS.md` only for current completed major features, active
candidates, blockers/known issues, pending manual confirmation, next priority,
or important recent technical state. Do not turn it into chronological history.
Record candidate state clearly as `GRADUATE`, `KEEP_CANDIDATE`, or `ABANDON`,
with `Manual confirmation: REQUIRED`, `COMPLETED`, or `NOT_NEEDED` as
applicable. Do not present an unapproved visual result as production-complete.

Update `PROJECT_WORK_LOG.md` only for actual completed work. Keep each entry to
date, purpose, result, important validation, commit when available, and any
remaining confirmation. Do not copy prompts, long logs, or exhaustive file
lists, and do not report a failed or unchanged task as completed.

## 5. Rotate only when needed

Before rotating PROJECT_STATUS or PROJECT_WORK_LOG, inspect their line count
and the existing `docs/old/` examples. Follow the established
`PROJECT_STATUS_<YYYYMMDD>_<NN>.md` and
`PROJECT_WORK_LOG_<YYYYMMDD>_<NN>.md` naming/header convention; do not guess a
new format. Around 200 lines is a readability signal, not an automatic trigger.

When rotation is warranted, preserve old content in `docs/old/`, retain only
current state or recent work in the active document, preserve current blockers
and next steps, check links/paths, and avoid duplicating the archived content.
Do not rotate GAME_INFO or reference documents by default.

## 6. Write with clear ownership

- Prefer natural Korean for people; use IDs and paths only as supporting detail.
- Distinguish candidate, backlog, confirmed, and abandoned work.
- Treat code and Resources as canonical for exact coordinates, pixel values,
  field defaults, signals, Node paths, assertion counts, and command details.
- Treat documentation as canonical for design intent, setting, object roles,
  system ownership, policy, production/candidate boundaries, technical map, and
  current status.
- Point to code/Resource locations when technical values are needed rather than
  duplicating them across documents.
- Remove or avoid obsolete duplicate statements instead of copying the same
  detailed content into several documents.

## 7. Follow the order and delegate boundaries

After deciding the minimal updates, check line counts and stale/duplicate/local
path content. Delegate validation selection and execution to
`$concent-godot-validation`, and selective staging, commit, and push to
`$concent-safe-git`.

Follow `$concent-candidate-workflow` for candidate status and graduation
decisions. This Skill records an established candidate status; it never grants
promotion, manual visual approval, or a new game-design decision.

Do not copy validation commands, Safe Git procedures, or candidate graduation
rules into this Skill.

## 8. Report

```text
Docs Sync:
- Documentation required: YES | NO
- Change category:
- Canonical document:
- Updated documents:
- GAME_INFO updated: YES | NO
- PROJECT_STATUS updated: YES | NO
- PROJECT_WORK_LOG updated: YES | NO
- Rotation performed: YES | NO
- Candidate status recorded:
- Avoided duplication:
- Validation:
- Remaining manual confirmation:
```

For a no-change decision, report `Documentation required: NO`, the reason, and
`Updated documents: none`.
