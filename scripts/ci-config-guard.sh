#!/usr/bin/env bash
set -euo pipefail

failures=0

search() {
  local pattern="$1"
  shift

  if command -v rg >/dev/null 2>&1; then
    rg -n --hidden "$pattern" "$@" || true
  else
    grep -RInE "$pattern" "$@" 2>/dev/null || true
  fi
}

check_no_staging_in_ci() {
  local matches
  matches="$(search '\\bstaging\\b' .github/workflows .github/actions)"
  if [ -n "$matches" ]; then
    echo "ERROR: Found disallowed 'staging' references in GitHub Actions config. Use 'preview'."
    echo "$matches"
    failures=1
  fi
}

check_post_merge_lockfile_name() {
  if grep -q 'pnpm-lock.yml' .husky/post-merge; then
    echo "ERROR: .husky/post-merge references pnpm-lock.yml. It should reference pnpm-lock.yaml."
    failures=1
  fi
}

check_env_schema_is_public_only() {
  if grep -q 'APP_BUILD_ONLY_VAR' env.ts; then
    echo "ERROR: env.ts still includes APP_BUILD_ONLY_VAR. Keep env schema limited to EXPO_PUBLIC_* vars."
    failures=1
  fi
}

check_env_gitignore() {
  if ! grep -q '^\.env$' .gitignore; then
    echo "ERROR: .gitignore is missing '.env'."
    failures=1
  fi

  if ! grep -q '^\.env\.\*$' .gitignore; then
    echo "ERROR: .gitignore is missing '.env.*'."
    failures=1
  fi

  if ! grep -q '^!\.env\.example$' .gitignore; then
    echo "ERROR: .gitignore is missing '!.env.example'."
    failures=1
  fi
}

check_new_app_version_token_fallback() {
  local workflow='.github/workflows/new-app-version.yml'

  if grep -q 'token: ${{ secrets.GH_TOKEN }}' "$workflow"; then
    echo "ERROR: new-app-version still uses secrets.GH_TOKEN directly for checkout token."
    failures=1
  fi

  if ! grep -q 'GH_TOKEN: ${{ secrets.GH_TOKEN || github.token }}' "$workflow"; then
    echo "ERROR: new-app-version is missing GH_TOKEN fallback (secrets.GH_TOKEN || github.token)."
    failures=1
  fi

  if ! grep -q 'token: ${{ env.GH_TOKEN }}' "$workflow"; then
    echo "ERROR: new-app-version checkout token should use env.GH_TOKEN."
    failures=1
  fi
}

check_no_staging_in_ci
check_post_merge_lockfile_name
check_env_schema_is_public_only
check_env_gitignore
check_new_app_version_token_fallback

if [ "$failures" -ne 0 ]; then
  printf '\nERROR: CI config guard failed.\n'
  exit 1
fi

echo "OK: CI config guard passed."
