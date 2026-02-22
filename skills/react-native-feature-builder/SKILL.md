---
name: react-native-feature-builder
description: Build and refactor features in this ACT House Expo template while following repository conventions for feature-oriented structure, Expo Router re-export routes, TanStack Form + Zod, React Query kit hooks, MMKV-backed persistence, and absolute imports. Use when implementing screens, forms, API hooks, feature stores, or route wiring.
---

# React Native Feature Builder

Use this workflow when shipping product features in this repository.

## Build Location Rules

- Put product logic in `src/features/<feature-name>/`.
- Keep route files in `src/app/**` as thin re-export wrappers.
- Promote only shared primitives to `src/components/ui/**`.
- Keep cross-cutting infrastructure in `src/lib/**`.

## Naming and Imports

- Use kebab-case file names (`checkout-screen.tsx`).
- Use absolute imports (`@/features/...`) for cross-feature/shared usage.
- Use relative imports only inside the same feature.
- Avoid introducing barrel exports for feature internals.

## Data and Forms

- Create feature API hooks in `src/features/<feature>/api.ts`.
- Prefer `createQuery`/`createMutation` with `react-query-kit`.
- Build forms with TanStack Form and Zod schemas.
- Keep auth/storage behavior aligned with `src/lib/auth` and `src/lib/storage.tsx`.

## Route Pattern

Route files should re-export the feature screen:
```tsx
export { CheckoutScreen as default } from '@/features/checkout/checkout-screen';
```

## Testing Pattern

- Add or update tests when behavior changes.
- For UI-heavy changes, prioritize interaction/state tests over snapshots.
- Run targeted tests first, then run full gate before PR/push.

## Done Checklist

1. Feature code in correct folder.
2. Route files stay thin.
3. Lint, type-check, and tests pass.
4. Translation keys added for user-facing strings.
5. Commit is atomic and scoped with `scripts/committer`.
