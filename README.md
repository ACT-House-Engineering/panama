# Panama

![expo](https://img.shields.io/github/package-json/dependency-version/ACT-House-Engineering/panama/expo?label=expo) ![react-native](https://img.shields.io/github/package-json/dependency-version/ACT-House-Engineering/panama/react-native?label=react-native) ![GitHub Repo stars](https://img.shields.io/github/stars/ACT-House-Engineering/panama) ![GitHub commit activity (branch)](https://img.shields.io/github/commit-activity/m/ACT-House-Engineering/panama) ![GitHub issues](https://img.shields.io/github/issues/ACT-House-Engineering/panama) ![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/ACT-House-Engineering/panama)

📱 A template for your next React Native project 🚀, made with developer experience and performance first: Expo, TypeScript, TailwindCSS, Husky, lint-staged, Expo Router, React Query, TanStack Form, I18n.

> Panama is ACT House Engineering's Expo / React Native harness, based on the Obytes starter template and extended for multi-agent development.

## 🚀 Motivation

Our goal with this starter is to streamline the process of building React Native apps for both our internal team and client projects. We want a shared foundation that helps us ship high-quality apps faster while maintaining consistent code standards and architecture.

The benefits are practical: developers can switch between projects with less friction, focus on product logic instead of boilerplate, and keep maintainability high over time.

Panama adds an agentic layer to that foundation. We incorporate OpenClaw-style task scoping and Pete Steinberger-style safety practices so multiple coding agents can work in parallel with clear guardrails, scoped commits, and minimal merge risk.

## ✍️ Philosophy

When creating this harness, we use these guiding principles:

- **🚀 Production-ready:** built for real delivery, not demo-only setups.
- **🥷 Developer experience and productivity:** optimize day-to-day flow for teams.
- **🧩 Minimal code and dependencies:** keep complexity low and intentional.
- **💪 Well-maintained third-party libraries:** prioritize long-term reliability.
- **🤖 Agent-safe execution:** design workflows that support parallel agent work safely.

## ⭐ Key Features

- ✅ Latest Expo SDK with Custom Dev Client.
- 🎉 [TypeScript](https://www.typescriptlang.org/) for static type safety.
- 💅 Minimal UI kit built with [NativeWind](https://www.nativewind.dev/).
- ⚙️ Multi-environment build support (production, staging, development).
- 🦊 Husky for Git hooks and repo standards.
- 💡 Clean project structure with absolute imports.
- 🚫 lint-staged for fast staged-file quality checks.
- ☂️ Pre-installed [Expo Router](https://docs.expo.dev/router/introduction/).
- 💫 Auth flow patterns using [Zustand](https://github.com/pmndrs/zustand) and [react-native-mmkv](https://github.com/mrousavy/react-native-mmkv).
- 🛠 GitHub Actions workflows for build, release, test, and verification.
- 🔥 [React Query](https://tanstack.com/query/v4) and [Axios](https://github.com/axios/axios) for data-fetching.
- 🧵 Robust forms with [TanStack Form](https://tanstack.com/form/latest) and [Zod](https://github.com/colinhacks/zod).
- 🎯 Localization support with [i18next](https://www.i18next.com/).
- 🧪 Unit testing with [Jest](https://jestjs.io/) and [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/).
- 🔍 E2E testing with [Maestro](https://maestro.mobile.dev/).
- 🤖 Agent harness conventions via `AGENTS.md` and `scripts/committer`.

## Quick Start

```sh
git clone https://github.com/ACT-House-Engineering/panama.git
cd panama
pnpm install
cp .env.example .env
pnpm ios   # or: pnpm android
```

## Is this starter for me?

Yes.

This starter can help a wide range of React Native developers:

1. **For beginners:** it provides a strong baseline with practical defaults.
2. **For experienced developers:** it saves time on setup and architecture decisions.
3. **For teams:** it enforces consistency and improves onboarding.
4. **For explorers:** it is a reference implementation you can adapt selectively.
5. **For AI-assisted development:** it provides structure that keeps generated code maintainable.

## Why Expo and not React Native CLI?

We use Expo as the default framework, especially with [Continuous Native Generation (CNG)](https://docs.expo.dev/workflow/continuous-native-generation/), and we consider it the most pragmatic choice for new React Native projects.

The React Native team explicitly recommended using a framework for new projects in their June 25, 2024 post:

- https://reactnative.dev/blog/2024/06/25/use-a-framework-to-build-react-native-apps

## 🤖 Agent Workflow

This repo is designed for parallel agent execution in one shared codebase.

1. Read `AGENTS.md`.
2. Keep changes scoped to a small blast radius.
3. Commit only touched files with:

```sh
scripts/committer "feat(feed): add pull-to-refresh" src/features/feed/feed-screen.tsx src/features/feed/api.ts
```

4. Run checks before pushing:

```sh
pnpm guard:ci-config
pnpm check-all
pnpm doctor
```

## 🧑‍💻 Stay up to date

Watch or star the repository for updates:

- https://github.com/ACT-House-Engineering/panama

Track releases directly on GitHub:

- https://github.com/ACT-House-Engineering/panama/releases

## 💎 Libraries used

- [Expo](https://docs.expo.io/)
- [Expo Router](https://docs.expo.dev/router/introduction/)
- [NativeWind](https://www.nativewind.dev/v4/overview)
- [FlashList](https://github.com/Shopify/flash-list)
- [React Query](https://tanstack.com/query/v4)
- [Axios](https://axios-http.com/docs/intro)
- [TanStack Form](https://tanstack.com/form/latest)
- [i18next](https://www.i18next.com/)
- [Zustand](https://github.com/pmndrs/zustand)
- [React Native MMKV](https://github.com/mrousavy/react-native-mmkv)
- [React Native Gesture Handler](https://docs.swmansion.com/react-native-gesture-handler/docs/)
- [React Native Reanimated](https://docs.swmansion.com/react-native-reanimated/docs/)
- [React Native SVG](https://github.com/software-mansion/react-native-svg)
- [React Error Boundary](https://github.com/bvaughn/react-error-boundary)
- [Expo Image](https://docs.expo.dev/versions/latest/sdk/image/)
- [React Native Keyboard Controller](https://github.com/kirillzyusko/react-native-keyboard-controller)
- [Moti](https://moti.fyi/)
- [React Native Safe Area Context](https://github.com/th3rdwave/react-native-safe-area-context)
- [React Native Screens](https://github.com/software-mansion/react-native-screens)
- [Tailwind Variants](https://www.tailwind-variants.org/)
- [Zod](https://zod.dev/)

## Documentation

- Docs folder: https://github.com/ACT-House-Engineering/panama/tree/master/docs
- Main repository: https://github.com/ACT-House-Engineering/panama

## Contributors

This starter is maintained by ACT House Engineering, and contributions are welcome.

- Repository: https://github.com/ACT-House-Engineering/panama

## 🔥 How to contribute?

1. Star the project: https://github.com/ACT-House-Engineering/panama
2. Open issues: https://github.com/ACT-House-Engineering/panama/issues
3. Use discussions for Q&A and proposals: https://github.com/ACT-House-Engineering/panama/discussions
4. Submit focused pull requests: https://github.com/ACT-House-Engineering/panama/pulls

## ❓ FAQ

If you have questions, check discussions:

- https://github.com/ACT-House-Engineering/panama/discussions

## 🔖 License

This project is MIT licensed.
