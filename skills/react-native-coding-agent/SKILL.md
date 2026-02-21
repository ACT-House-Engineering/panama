---
name: react-native-coding-agent
description: Run Codex or Claude Code as coding agents for this Expo React Native repository, including same-folder parallel sessions, blast-radius task splitting, scoped commits through scripts/committer, and safe sync with upstream/fork remotes. Use when implementing, refactoring, debugging, or reviewing code with agent-driven workflows.
---

# React Native Coding Agent

Use this workflow to run multiple coding agents quickly without losing repository safety.

## Prepare Session

1. Start from repo root and ensure remotes are correct:
```bash
git remote -v
```
2. Confirm clean enough working tree for your task:
```bash
git status --short
```
3. Install dependencies if needed:
```bash
pnpm install
```

## Pick Execution Mode

Use same-folder mode for speed:
- Launch multiple agent sessions in the same repository.
- Keep each session on a focused task that touches a small file set.

Use worktree mode for isolation:
```bash
git worktree add /tmp/panama-task-1 -b task/feature-1 master
```

## Prompt Shape

Use short, direct prompts:
- Define one concrete outcome.
- Name target files or folders.
- State acceptance checks (`pnpm lint`, `pnpm type-check`, tests).

Example:
```txt
Add pull-to-refresh to feed list in src/features/feed/feed-screen.tsx.
Keep route files unchanged. Run pnpm lint and pnpm test for feed tests.
Commit with scripts/committer when done.
```

## Commit Pattern

Always commit atomically with explicit paths:
```bash
scripts/committer "feat(feed): add pull-to-refresh" src/features/feed/feed-screen.tsx src/features/feed/api.ts
```

Never stage all files with `git add .` in agent sessions.

## Sync Pattern

1. Pull latest upstream template updates:
```bash
git pull origin master --rebase
```
2. Push your team fork:
```bash
git push fork HEAD
```

## Guardrails

- Do not reset/revert unrelated working tree changes.
- Do not edit `.env` unless explicitly asked.
- Do not delete files to silence lint/type errors without explicit approval.
- If blast radius expands, stop and split into smaller tasks.
- For changes in `.github/**`, `.husky/**`, `.gitignore`, or `env.ts`, run `pnpm guard:ci-config`.
