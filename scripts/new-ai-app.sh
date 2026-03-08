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

log() {
  printf "\n==> %s\n" "$1"
}

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

append_if_missing() {
  local line="$1"
  local file="$2"
  touch "$file"
  grep -Fqs "$line" "$file" || echo "$line" >> "$file"
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

log "Creating project in $PROJECT_DIR"
cd "$TARGET_DIR"

if ! pnpm create svelte@latest "$APP_NAME" --template minimal --types ts --no-add-ons; then
  cat <<'MSG'
Project bootstrap failed.
The Svelte CLI may have changed its prompts or flags.
Update scripts/new-ai-app.sh to the current upstream CLI behavior instead of forcing broad workarounds.
MSG
  exit 1
fi

cd "$PROJECT_DIR"
pnpm install

if command -v npx >/dev/null 2>&1; then
  log "Adding TailwindCSS via Svelte CLI"
  if ! npx sv add tailwindcss; then
    echo "Tailwind setup failed. Check the CLI output and rerun manually in the project directory."
    exit 1
  fi
fi

pnpm add -D prettier prettier-plugin-svelte eslint

mkdir -p .ai/specs .ai/prompts .ai/review .ai/context src/lib/components src/lib/utils src/lib/services

copy_or_write "$HOME/ai/templates/opencode.json" "./opencode.json" '{"share":"disabled"}'
copy_or_write "$HOME/ai/templates/AGENTS.md" "./AGENTS.md" '# AGENTS.md'
copy_or_write "$HOME/ai/templates/requirements.md" "./requirements.md" '# Requirements'
copy_or_write "$HOME/ai/specs/architecture.md" "./.ai/specs/architecture.md" '# Architecture Rules'
copy_or_write "$HOME/ai/specs/ui-rules.md" "./.ai/specs/ui-rules.md" '# UI Rules'
copy_or_write "$HOME/ai/review/release-checklist.md" "./.ai/review/release-checklist.md" '# Review Checklist'
copy_or_write "$HOME/ai/prompts/feature-small.md" "./.ai/prompts/feature-small.md" 'Implement only the smallest useful increment.'
copy_or_write "$HOME/ai/prompts/feature-large.md" "./.ai/prompts/feature-large.md" 'Split the work into phases and implement only phase 1.'
copy_or_write "$HOME/ai/prompts/refactor.md" "./.ai/prompts/refactor.md" 'Propose and implement only the smallest safe refactor.'
copy_or_write "$HOME/ai/context/project-overview.md" "./.ai/context/project-overview.md" '# Project Overview'
copy_or_write "$HOME/ai/context/current-status.md" "./.ai/context/current-status.md" '# Current Status'
copy_or_write "$HOME/ai/context/open-questions.md" "./.ai/context/open-questions.md" '# Open Questions'
copy_or_write "$HOME/ai/context/known-issues.md" "./.ai/context/known-issues.md" '# Known Issues'
copy_or_write "$HOME/ai/context/next-step.md" "./.ai/context/next-step.md" '# Next Step'
copy_or_write "$HOME/ai/templates/.env.example" "./.env.example" '# No secrets in git.'

append_if_missing '' .gitignore
append_if_missing '# AI / local tooling' .gitignore
append_if_missing '.env' .gitignore
append_if_missing '.env.*' .gitignore
append_if_missing '.direnv/' .gitignore
append_if_missing '.opencoderc' .gitignore

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
  log "UI mode selected"
  if command -v npx >/dev/null 2>&1; then
    if ! npx shadcn-svelte@latest init; then
      echo "shadcn-svelte init failed. Continue with the base UI starter or rerun manually."
    fi
    if ! npx shadcn-svelte@latest add button input dialog; then
      echo "shadcn-svelte component add failed. Continue with the base UI starter or rerun manually."
    fi
  fi
fi

cat > README.md <<READEOF
# $APP_NAME

This project was bootstrapped with VibeCoding Basic.

## Golden path
1. Read AGENTS.md
2. Fill requirements.md
3. Review .ai/specs/architecture.md and .ai/specs/ui-rules.md
4. Fill .ai/context/project-overview.md
5. Start OpenCode and run /plan
6. Use /build-small for the first increment
7. Run /review before broader follow-up work

## Project memory
Keep these files up to date:
- .ai/context/project-overview.md
- .ai/context/current-status.md
- .ai/context/open-questions.md
- .ai/context/known-issues.md
- .ai/context/next-step.md

## Commands
- pnpm dev
- pnpm build
- pnpm check
READEOF

if [[ ! -d .git ]]; then
  git init
fi

git add .
git commit -m "Initial VibeCoding Basic app bootstrap" >/dev/null 2>&1 || true

echo
echo "Project created: $PROJECT_DIR"
echo "Next steps:"
echo "  cd '$PROJECT_DIR'"
echo "  direnv allow   # optional, review .envrc first"
echo "  pnpm dev"
echo "  opencode"
echo "  /plan"
