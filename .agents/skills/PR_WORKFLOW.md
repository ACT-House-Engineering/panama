# PR Workflow

Use this flow when handling pull requests end-to-end with coding agents.

## 1. review-pr

Goal: understand risk and request only necessary changes.

Commands:
```bash
git fetch origin
git diff --stat origin/master...HEAD
pnpm guard:ci-config
pnpm lint
pnpm type-check
```

Checklist:
- Verify architecture conventions (`src/features`, thin `src/app` routes).
- Verify user-facing strings are translatable.
- Verify no accidental environment/secret file changes.
- Verify CI config uses `preview` (not `staging`) and workflows still pass guard checks.
- If docs drift from behavior, align docs or record explicit follow-up before merge.

## 2. prepare-pr

Goal: land requested fixes and produce a clean commit series.

Commands:
```bash
pnpm check-all
scripts/committer "fix(pr): address review feedback" <file...>
```

Checklist:
- Keep commits atomic.
- Keep commit messages conventional.
- Keep PR description aligned with shipped behavior.

## 3. merge-pr

Goal: merge with latest upstream state and no red checks.

Commands:
```bash
git pull origin master --rebase
pnpm check-all
git push fork HEAD
```

Checklist:
- CI/local checks are green.
- Merge strategy is agreed by maintainers.
- No unrelated file drift in final diff.
