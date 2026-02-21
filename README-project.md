# Panama (React Native / Expo)

> This project is based on the [Obytes starter](https://starter.obytes.com).

## Requirements

- [React Native dev environment](https://reactnative.dev/docs/environment-setup)
- [Node.js LTS](https://nodejs.org/en/)
- [Git](https://git-scm.com/)
- [Watchman](https://facebook.github.io/watchman/docs/install#buildinstall) (macOS/Linux)
- [pnpm](https://pnpm.io/installation)
- [Cursor](https://www.cursor.com/) or [VS Code](https://code.visualstudio.com/download)

## Quick Start

```sh
git clone https://github.com/ACT-House-Engineering/panama.git
cd panama
pnpm install
cp .env.example .env
pnpm ios   # or: pnpm android
```

## Agent Harness (OpenClaw-Style)

This repository is configured to support parallel coding agents with scoped, atomic commits.

- Canonical agent instructions: `AGENTS.md`
- Claude compatibility file: `claude.md` (symlink to `AGENTS.md`)
- Scoped commit helper: `scripts/committer`
- Optional PR pipeline: `.agents/skills/PR_WORKFLOW.md`
- Reusable skills:
  - `skills/react-native-coding-agent/SKILL.md`
  - `skills/react-native-feature-builder/SKILL.md`
  - `skills/react-native-ship-check/SKILL.md`

### Parallel Session Pattern

1. Run multiple agent sessions in this same repo for small, focused tasks.
2. Keep blast radius small (few files per task).
3. Commit only task files:

```sh
scripts/committer "feat(feed): add pull-to-refresh" src/features/feed/feed-screen.tsx src/features/feed/api.ts
```

4. Run gates before push:

```sh
pnpm guard:ci-config
pnpm check-all
pnpm doctor
```

5. Sync from upstream and push fork:

```sh
git pull origin master --rebase
git push fork HEAD
```

## Default Dev Commands

```sh
pnpm start
pnpm ios
pnpm android
pnpm lint
pnpm guard:ci-config
pnpm type-check
pnpm test
pnpm check-all
```

## Documentation

- [Rules and Conventions](https://starter.obytes.com/getting-started/rules-and-conventions/)
- [Project Structure](https://starter.obytes.com/getting-started/project-structure)
- [Environment Vars and Config](https://starter.obytes.com/getting-started/environment-vars-config)
- [UI and Theming](https://starter.obytes.com/ui-and-theme/ui-theming)
- [Components](https://starter.obytes.com/ui-and-theme/components)
- [Forms](https://starter.obytes.com/ui-and-theme/forms)
- [Data Fetching](https://starter.obytes.com/guides/data-fetching)
- [Contribute to Starter](https://starter.obytes.com/how-to-contribute/)
