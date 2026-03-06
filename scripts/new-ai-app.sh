#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage:
  $(basename "$0") <app-name> [target-dir] [--minimal|--ui]

Examples:
  $(basename "$0") my-app
  $(basename "$0") my-app ~/dev --minimal
  $(basename "$0") my-app ~/dev --ui
USAGE
}

APP_NAME="${1:-}"
TARGET_DIR="${2:-$HOME/dev}"
MODE="minimal"

for arg in "$@"; do
  case "$arg" in
    --minimal) MODE="minimal" ;;
    --ui) MODE="ui" ;;
  esac
done

if [[ -z "$APP_NAME" ]]; then
  usage
  exit 1
fi

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing required command: $1"; exit 1; }
}

copy_or_write() {
  local src="$1"
  local dest="$2"
  local fallback="$3"
  mkdir -p "$(dirname "$dest")"
  if [[ -f "$src" ]]; then
    cp "$src" "$dest"
  else
    cat > "$dest" <<FALLBACK
$fallback
FALLBACK
  fi
}

require_cmd node
require_cmd pnpm
require_cmd git

mkdir -p "$TARGET_DIR"
PROJECT_DIR="$TARGET_DIR/$APP_NAME"

if [[ -e "$PROJECT_DIR" ]]; then
  echo "Target already exists: $PROJECT_DIR"
  exit 1
fi

echo "==> Creating project in $PROJECT_DIR"
cd "$TARGET_DIR"

pnpm create svelte@latest "$APP_NAME"
cd "$PROJECT_DIR"
pnpm install

if command -v npx >/dev/null 2>&1; then
  npx sv add tailwindcss || true
fi

pnpm add -D prettier prettier-plugin-svelte eslint

mkdir -p .ai/specs .ai/prompts .ai/review src/lib/components src/lib/utils

copy_or_write "$HOME/ai/templates/opencode.json" "./opencode.json" '{"share":"disabled"}'
copy_or_write "$HOME/ai/templates/AGENTS.md" "./AGENTS.md" '# AGENTS.md'
copy_or_write "$HOME/ai/templates/requirements.md" "./requirements.md" '# requirements.md'
copy_or_write "$HOME/ai/specs/architecture.md" "./.ai/specs/architecture.md" '# Architecture'
copy_or_write "$HOME/ai/specs/ui-rules.md" "./.ai/specs/ui-rules.md" '# UI Rules'
copy_or_write "$HOME/ai/review/release-checklist.md" "./.ai/review/release-checklist.md" '# Release Checklist'
copy_or_write "$HOME/ai/prompts/feature-small.md" "./.ai/prompts/feature-small.md" 'Read AGENTS.md and requirements.md and implement only the smallest useful increment.'
copy_or_write "$HOME/ai/prompts/feature-large.md" "./.ai/prompts/feature-large.md" 'Plan first. Then implement only phase 1.'
copy_or_write "$HOME/ai/prompts/refactor.md" "./.ai/prompts/refactor.md" 'Find duplicated logic and complexity. Propose a minimal safe refactor.'
copy_or_write "$HOME/ai/templates/.env.example" "./.env.example" '# No secrets in git.'

cat >> .gitignore <<'GITEOF'

# AI / local tooling
.env
.env.*
.direnv/
.opencoderc
GITEOF

cat > .envrc <<'ENVEOF'
# Review before allowing: direnv allow
export PNPM_HOME="$HOME/Library/pnpm"
layout node
ENVEOF

mkdir -p src/lib/components/ui/button
cat > src/lib/utils/cn.ts <<'UTILEOF'
export function cn(...parts: Array<string | false | null | undefined>) {
  return parts.filter(Boolean).join(' ');
}
UTILEOF

cat > src/lib/components/ui/button/Button.svelte <<'BTNEOF'
<script lang="ts">
  import { cn } from '$lib/utils/cn';
  export let variant: 'primary' | 'secondary' = 'primary';
  export let type: 'button' | 'submit' | 'reset' = 'button';
  export let className = '';
</script>

<button
  {type}
  class={cn(
    'inline-flex items-center justify-center rounded-md px-4 py-2 text-sm font-medium transition',
    variant === 'primary' && 'bg-black text-white',
    variant === 'secondary' && 'border border-gray-300 bg-white text-black',
    className
  )}
>
  <slot />
</button>
BTNEOF

if [[ "$MODE" == "ui" ]]; then
  echo "==> UI mode selected"
  if command -v npx >/dev/null 2>&1; then
    npx shadcn-svelte@latest init || true
    npx shadcn-svelte@latest add button input dialog || true
  fi
fi

cat > README.md <<READEOF
# $APP_NAME

## Golden path
1. Review AGENTS.md
2. Fill requirements.md
3. Review .ai/specs/architecture.md and ui-rules.md
4. Start OpenCode and run /plan
5. Implement via /build-small
6. Run /review before broader changes

## Commands
- pnpm dev
- pnpm build
- pnpm check
READEOF

if [[ ! -d .git ]]; then
  git init
  git add .
  git commit -m "Initial AI-first app bootstrap" || true
fi

echo
echo "Project created: $PROJECT_DIR"
echo "Next steps:"
echo "  cd '$PROJECT_DIR'"
echo "  direnv allow   # optional, review .envrc first"
echo "  pnpm dev"
echo "  opencode"
echo "  /plan"
