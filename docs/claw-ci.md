## The CI Pipeline: What Runs and When

Based on the GitHub Actions workflow runs and the repo's `package.json`, the OpenClaw repo runs **at least 6 distinct GitHub Actions workflows** on every PR:

1. **CI** (`ci.yml`) — the main gate, with over 18,000 runs. This is the core build/lint/test pipeline.
2. **Install Smoke** — a Docker-based smoke test that installs OpenClaw from scratch and verifies it works (`pnpm test:install:smoke`)
3. **Formal models (informational conformance)** — validates protocol schemas and generated types stay in sync
4. **Workflow Sanity** — validates the GitHub Actions workflow files themselves
5. **Labeler** — auto-labels PRs based on which files were touched (configured in `.github/labeler.yml`)
6. **Auto response** — triggered by the `openclaw-barnacle` bot, which handles automated PR triage and responses

The CI pipeline triggers on both **PR synchronize** (every push to a PR branch) and **push to main** (every direct commit). There's also a separate **Docker Release** workflow that runs on every commit pushed to main — so when steipete merges or pushes directly, Docker images get rebuilt automatically.

## What the `pnpm check` Gate Actually Runs

The `package.json` reveals the exact composition of the local and CI check commands:

`"check": "pnpm format:check && pnpm tsgo && pnpm lint"` — this combines formatting verification (via Oxfmt), type checking (via `tsgo`, the Go-based TypeScript checker), and linting (via Oxlint).

There's also a separate docs check: `"check:docs": "pnpm format:docs:check && pnpm lint:docs && pnpm docs:check-links"` and a file size guardrail: `"check:loc": "node --import tsx scripts/check-ts-max-loc.ts --max 500"`.

The test suite is tiered: unit tests via Vitest, E2E tests, gateway tests, extension tests, live tests (requiring real API keys), and Docker-based install smoke tests. There's even a `"test:macmini"` script that runs tests in serial mode for resource-constrained environments.

## Pre-commit Hooks: The Local CI Layer

The repo uses `prek` (a fast pre-commit hook tool) with a comprehensive set of checks that mirror CI: basic hygiene (trailing whitespace, end-of-file fixing, YAML validation, large file detection, merge conflict detection), security checks (detect-secrets, zizmor for GitHub Actions auditing), linting (shellcheck, actionlint, oxlint, swiftlint), and formatting (oxfmt, swiftformat).

The AGENTS.md explicitly tells coding agents about this: "Pre-commit hooks: `prek install` (runs same checks as CI)" — and separately instructs them to "run the repo's package-manager install command (prefer lockfile/README-defined PM), then rerun the exact requested command once" when deps are missing.

The contributor who added pre-commit hooks noted: "pre-commit hooks have been a god-send for getting a tighter build-test-deploy lifecycle with LLMs. This should ease the pain on your CI and get more people to PR you code that passes tests."

## How Agents Are Told to Use CI

This is where it gets interesting — there are **three layers** of instruction:

**Layer 1: AGENTS.md (read by every coding agent on session start)**

The AGENTS.md tells agents to run `pnpm check` before commits and use the scoped committer script. It also points to the full PR workflow: "Full maintainer PR workflow (optional): If you want the repo's end-to-end maintainer workflow (triage order, quality bar, rebase rules, commit/changelog conventions, co-contributor policy, and the review-pr > prepare-pr > merge-pr pipeline), see `.agents/skills/PR_WORKFLOW.md`."

The `.agents/skills/PR_WORKFLOW.md` defines a **3-step skill pipeline** for handling PRs: `review-pr` → `prepare-pr` → `merge-pr`. This is the harness that lets agents participate in the full CI lifecycle autonomously.

**Layer 2: Steipete's custom slash commands**

Steipete uses `/automerge` (process one PR at a time, react to bot comments, reply, get CI green and squash when green) and `/massageprs` (same as automerge but without the squashing so he can parallelize the process if he has a lot of PRs).

These are agent-level slash commands — meaning the coding agent itself is the one monitoring CI status, responding to review bot comments, fixing issues, and eventually squash-merging. The agent becomes the CI feedback loop operator.

**Layer 3: The `openclaw-barnacle` bot**

The `openclaw-barnacle` bot auto-labels PRs based on which files are touched and triggers the Auto response workflow. There's a `trigger-response` label described as: "This label just triggers the auto-response workflow and should be ignored otherwise." This is the automated triage layer — PRs get categorized before a human or agent even looks at them.

## How CI Landing Actually Works

The PR #1720 merge comment reveals the landing protocol in action. When steipete merges a PR from the coding agent, the commit message shows: "Landed via temp rebase onto main. Gate: `pnpm lint && pnpm build && pnpm test`. Land commit: ad5df9e. Merge commit: 48aea87."

So the actual gate for landing is: lint passes, build succeeds, tests pass. This is run locally before the merge, and then CI validates it again on push to main.

For releases, the bar is higher: the release checklist requires `OPENCLAW_INSTALL_SMOKE_SKIP_NONROOT=1 pnpm test:install:smoke` (Docker install smoke test), which is described as "required before release."

## The Non-Obvious Pattern Here

What's striking is how the CI interactions map to the parallel agent workflow. The agents working in the same folder on `main` don't interact with CI at all during their working phase — CI only enters the picture in two scenarios:

1. **Pre-commit hooks** catch obvious issues locally before they even get committed
2. **The `/automerge` and `/massageprs` commands** turn the agent itself into a CI babysitter that processes PRs from external contributors

For steipete's own work (direct commits to main from parallel agents), the CI feedback loop is: agent commits atomically → pre-commit hooks validate → push to main → CI runs → Docker Release rebuilds → Vercel deploys. If CI breaks, he sees it quickly because his dev server is running live on main. The blast radius mental model works bidirectionally — small, focused commits mean small, focused CI failures that are easy to attribute to a specific agent's work and easy to revert.

This is a fundamentally different relationship with CI than the traditional "PR → CI gate → merge" flow. It's closer to continuous deployment with post-commit validation, where the speed of the feedback loop (Vercel deploys in ~2 minutes) substitutes for the safety of pre-merge gating.