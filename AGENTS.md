# Repository Guidelines

- Repo: `https://github.com/ACT-House-Engineering/panama`
- Upstream template: `origin -> https://github.com/obytes/react-native-template-obytes.git`
- Team fork: `fork -> https://github.com/ACT-House-Engineering/panama.git`

## Project Focus

- Build Expo + React Native apps using the Obytes starter architecture.
- Keep features small, testable, and easy for parallel coding agents to modify.

## Project Structure

- App routes: `src/app/**` (Expo Router file-based routes).
- Features: `src/features/**` (screen, local components, feature API hooks, feature store).
- Shared UI: `src/components/ui/**`.
- Shared infra: `src/lib/**` (`api`, `auth`, `i18n`, hooks, storage, test utils).
- Translation files: `src/translations/*.json`.

## Build, Test, and Run Commands

- Install: `pnpm install`
- Dev server: `pnpm start`
- iOS: `pnpm ios`
- Android: `pnpm android`
- Lint: `pnpm lint`
- CI config guard: `pnpm guard:ci-config`
- Types: `pnpm type-check`
- Unit tests: `pnpm test`
- Full gate: `pnpm check-all`
- Expo dependency doctor: `pnpm doctor`

## React Native Conventions

- Keep route files in `src/app/**` thin; re-export screen components from `src/features/**`.
- Use feature folders for product code. Avoid cross-feature coupling where possible.
- Use absolute imports with `@/` for cross-feature/shared imports.
- Use TanStack Form + Zod for forms.
- Use React Query (`react-query-kit`) for server state in feature `api.ts` files.
- Use MMKV via `src/lib/storage.tsx` for persisted app data.
- Keep naming kebab-case for files and folders.
- Do not edit `ios/` or `android/` directly unless explicitly asked. Prefer Expo config/plugins.

## Multi-Agent Workflow (OpenClaw Style)

- Default mode: run multiple agents in parallel in the same repo and keep each task narrow.
- Think in blast radius: fewer touched files means safer parallel work.
- Use atomic commits so each agent lands only its own scoped changes.
- Always commit with `scripts/committer "<message>" <file...>`.
- Never use `git add .` for agent-driven commits.
- If a task grows too large, stop and split into smaller prompts/tasks.
- If you touch `.github/**`, `.husky/**`, `env.ts`, or `.gitignore`, run `pnpm guard:ci-config` before committing.
- If docs and code disagree, trust code first and either update docs in the same change or log a follow-up task.

## Commit and Branch Rules

- Commit format follows Conventional Commits (`feat:`, `fix:`, `refactor:`, etc.).
- Pre-commit hook blocks direct commits on `main`/`master` unless `SKIP_BRANCH_PROTECTION` is set.
- Commit only files you changed.
- Before commit, run the smallest meaningful checks for touched areas; before push/PR, run `pnpm check-all`.

## Safety Rules

- Never run destructive git operations unless user explicitly asks (`git reset --hard`, deleting history, force checkout of old states).
- Never revert or remove changes you did not author without explicit user approval.
- Never edit `.env` or secret files unless the user explicitly asks.
- Do not delete files just to silence lint/type errors without user confirmation.
- If unknown changes exist, continue your scoped task and avoid touching unrelated files.

## Skills in This Repo

- `skills/react-native-coding-agent/SKILL.md`: spawn and operate coding agents in parallel.
- `skills/react-native-feature-builder/SKILL.md`: implement features with repo conventions.
- `skills/react-native-ship-check/SKILL.md`: pre-push and release quality checks.
- `.agents/skills/PR_WORKFLOW.md`: optional review -> prepare -> merge flow.
