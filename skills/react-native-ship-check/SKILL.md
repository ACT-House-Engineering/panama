---
name: react-native-ship-check
description: Run pre-push and pre-release quality gates for this Expo React Native repository, summarize failures, and ensure deploy readiness across linting, type checks, tests, translations checks, and Expo doctor/build sanity. Use before pushes, PR creation, release branches, and EAS build triggers.
---

# React Native Ship Check

Use this checklist before push, PR, or release-related actions.

## Fast Path

For small scoped changes:
```bash
pnpm guard:ci-config
pnpm lint
pnpm type-check
pnpm test
```

## Full Gate

Use the full project gate for branch handoff and PRs:
```bash
pnpm check-all
pnpm doctor
```

## Optional E2E/Device Checks

Run when flows are high risk:
```bash
pnpm e2e-test
```

For native behavior changes, run at least one platform smoke pass:
```bash
pnpm ios
pnpm android
```

## Failure Handling

When checks fail:

1. Capture first actionable error.
2. Fix root cause (do not bypass lint/test hooks).
3. Re-run only failed step.
4. Re-run `pnpm check-all` before final commit/push.

## Commit Handoff

- Keep commit scopes narrow.
- Use:
```bash
scripts/committer "<type(scope): summary>" <changed-file...>
```
