---
name: concent-safe-git
description: CONCENT 저장소의 구현 작업 완료 후 관련 파일만 선별해 stage하고, 검증 결과를 확인한 뒤 안전하게 commit·push할 때 사용한다. unrelated 파일, 생성 metadata, 강제 push 및 작업 손실 명령은 제외한다.
---

# CONCENT Safe Git

Use this Skill only after completing an authorized CONCENT task. Preserve every unrelated user change and generated file.

## 1. Inspect before Git mutation

Confirm the repository root, current branch, upstream, and whether HEAD is detached. Run the repository's required preflight, including fetch/ahead checks, before staging. Stop on detached HEAD, an unexpected branch, a missing or unexpected upstream, upstream commits, or conflicts.

Inspect `git status --short` and separate staged, tracked unstaged, and untracked paths. Compare them with the files actually changed for the current request; do not infer ownership from status alone.

## 2. Delegate validation

Use `$concent-godot-validation`; do not copy Godot validation commands into this Skill.

- Request `full` for Godot code, Scene, Resource, test, addon, project, gameplay, UI, movement, collision, save, combat, or execution-flow changes.
- Request `quick` only for documentation, `AGENTS.md`, Codex configuration, or repository Skill-only changes.
- Choose `full` when uncertain or when the user requests stronger validation.

Do not stage, commit, or push when validation fails. Record the failed mode, step, exit code, log path, and known warnings.

## 3. Select explicit stage paths

Stage only current-task implementation files, necessary tests, and documentation required by an actual behavior or policy change. Never automatically stage unrelated tracked changes, `.import`, `.uid`, `.godot` output, temporary logs, attached spreadsheets, or files with unclear provenance.

Use explicit quoted paths, for example:

```bash
git add -- \
  ".agents/skills/concent-safe-git/SKILL.md" \
  "docs/reference/TECHNICAL_MAP.md"
```

Never run `git add .`, `git add -A`, `git clean`, `git reset --hard`, broad `git restore`, `git checkout -- .`, `git stash`, `git rebase`, `git commit --amend`, `git push --force`, or `git push --force-with-lease`.

After staging, inspect all of:

```bash
git diff --cached --name-status
git diff --cached --stat
git diff --cached
git diff --cached --check
```

Stop if the staged scope is empty, unexpected, unrelated, or fails the cached diff check.

## 4. Commit

Use the user's message when supplied; otherwise write a short Conventional Commit that describes the staged change. Do not create empty commits. After committing, report the commit hash/message and verify the committed file list matches the reviewed staged list.

## 5. Push

Push normally to the verified current branch's upstream. Stop rather than guessing when HEAD is detached, upstream is absent, the branch is unexpected, or remote state changed. Never force push. After a successful push, compare local `HEAD` with the upstream hash and require equality.

## 6. Report

```text
Safe Git:
- Branch: ...
- Upstream: ...
- Validation mode / result: ...
- Staged files: ...
- Excluded files: ...
- Commit hash / message: ...
- Push result: ...
- HEAD == upstream: yes|no
- Tracked dirty: ...
- Staged remaining: ...
- Untracked remaining: ...
- Known warnings: ...
```

Do not modify game code to make validation pass unless that fix is already within the user's implementation request. This Skill owns selective staging, commit, push, and reporting only; it does not own implementation or Godot validation logic.
