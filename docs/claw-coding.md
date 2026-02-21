# How OpenClaw Agent Harnessing

This is a fascinating repo to study, Sam — and it turns out the story of how OpenClaw enables parallel agent work operates at **two distinct levels** that are worth separating cleanly: the *product architecture* (how OpenClaw-the-assistant handles concurrent sessions) and the *development workflow* (how steipete and contributors actually build the codebase itself with multiple coding agents). Both are relevant to your research.

## How the *repo itself* gets built: steipete's "same folder" trunk-based approach

This is the contrarian piece, and it's the most directly relevant to your research on non-obvious patterns. Peter Steinberger (steipete) has written extensively about this, most comprehensively in his October 2025 post ["Just Talk To It"](https://steipete.me/posts/just-talk-to-it).

**The core setup:** He runs between 3-8 agents in parallel in a 3x3 terminal grid, most of them in the same folder, with some experiments going in separate folders. He experimented with worktrees and PRs but always reverts back to this setup because it gets stuff done the fastest.

**Why this works without branches:** The key mechanism is **atomic commits per agent**. His agents do git atomic commits themselves. In order to maintain a mostly clean commit history, he iterated a lot on his agent file, which makes git ops sharper so each agent commits exactly the files it edited.

This is directly reflected in the repo's `AGENTS.md`, which instructs coding agents to create commits with `scripts/committer "<msg>" <file...>` and avoid manual `git add`/`git commit` so staging stays scoped. That `scripts/committer` wrapper is the critical harness — it enforces that each agent only stages and commits the specific files it touched, preventing the classic problem where Agent A's `git add .` accidentally scoops up Agent B's half-finished work.

**Why not worktrees?** Steipete has a pragmatic reason: He works directly on main with atomic commits because merge conflicts plus worktrees cost speed, and small, well-scoped commits keep things safe. From the deeper blog post, he explains he runs one dev server and clicks through it to test multiple changes at once — having a tree/branch per change would mean spawning multiple dev servers, which gets annoying fast, plus he has limitations like Twitter OAuth callback domains that only work with one URL.

**The "blast radius" mental model** is how he decides how to partition work across agents. He thinks about each task in terms of how many files it will touch and how long it will take. Many small, focused changes can coexist safely in the same working directory. If something takes longer than anticipated, he hits escape and asks for a status update, then either helps redirect, aborts, or continues. He also uses a `/commit` slash command with custom text explaining that multiple agents work in the same folder and to only commit your changes, so he gets clean commits and the agent doesn't freak out about other changes or try to revert things if a linter fails.

## How the repo's coding-agent SKILL enables parallel work at the harness level

The repo ships a `coding-agent` skill (in the separate `openclaw/skills` repo) that documents *two* parallel execution strategies:

**Strategy 1: Git worktrees + tmux** (for when isolation matters). For fixing multiple issues in parallel, the skill prescribes using git worktrees with isolated branches plus tmux sessions — clone to a temp location, create worktrees for each issue, set up tmux sessions with a shared socket, then launch agents in each. The skill explicitly notes: "Why worktrees? Each agent works in an isolated branch, no conflicts. Can run 5+ parallel fixes!"

**Strategy 2: Background processes** for coding agents launched via `bash` with `background:true`, which is what steipete himself gravitates toward for his day-to-day work where he wants maximum speed and the ability to see changes live.

The skill also has important guardrails: never start coding agents in the live workspace directory (it'll read your soul docs and "get weird ideas about the org chart"), and never checkout branches in the live instance — clone to `/tmp` or use git worktree for PR reviews.

## How OpenClaw's *product architecture* handles parallelism

At the product/framework level, OpenClaw takes a deliberately conservative approach to concurrency, which is philosophically interesting given how aggressively steipete himself runs parallel agents during development.

**"Default Serial, Explicit Parallel" philosophy.** OpenClaw adopts a "Default Serial, Explicit Parallel" philosophy with session isolation (each session has its own "lane"), serial execution by default to prevent state corruption, and controlled parallelism only for explicitly marked low-risk tasks like scheduled background checks. The Lane Queue is the critical reliability layer that enforces this.

**Sub-agents for parallel work within the product.** OpenClaw's sub-agent architecture allows spawning independent workers that handle long-running tasks in the background while the main conversation continues uninterrupted. Sub-agents operate as completely isolated worker sessions. The `/subagents` command provides list, stop, and log operations for managing these background workers.

**`sessions_*` tools for inter-agent coordination.** The repo includes `sessions_list`, `sessions_history`, and `sessions_send` tools that let agents discover each other, read transcripts, and exchange messages — essentially a lightweight message-passing system between parallel sessions.

**Multi-agent routing** allows routing different inbound channels/accounts to completely isolated agents, each with their own workspace and sessions. But interestingly, the FAQ notes that multi-agent routing is "best seen as a fun experiment" — it's token-heavy and often less efficient than using one bot with separate sessions, which can spawn sub-agents when needed.

**Parallel session processing is still evolving.** An open feature request (#1159) describes configurable `sessionConcurrency` with options for workspace write coordination including lock files during writes, atomic operations, and per-session scratch directories. The current workaround is running separate Gateway instances on different ports.

## The key non-obvious insights for your research

There are a few things here that connect directly to the patterns you've been tracking:

**The divergence between the harness the creator uses vs. what the product recommends.** Steipete himself works in the most aggressive possible mode — same folder, no branches, 3-8 agents, atomic commits as the only coordination primitive. But the product he builds defaults to serial execution with explicit opt-in for parallelism. This maps directly to your "oversight vs. speed" divergence point.

**`scripts/committer` is the real harness, not any fancy orchestration.** The single most important infrastructure enabling parallel work in this repo is a shell script that scopes `git add` to specific files. That's it. This perfectly illustrates your "simple over complex" principle — no elaborate agentic toolchains, just a basic tool that enforces the right constraint.

**The "blast radius" framing is the mental model for partitioning work.** This is a richer version of what you've been documenting about how experienced practitioners think about task decomposition. It's not about task size — it's about *how many files will be affected* and *how much surface area for conflict exists*.

**The repo literally develops itself with its own patterns.** The AGENTS.md file trains incoming coding agents to follow the parallel-safe workflow, creating a self-reinforcing loop where the repo's own development conventions become encoded as agent instructions that produce more contributions following those same conventions.