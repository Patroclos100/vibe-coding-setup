#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok() { printf "${GREEN}OK${NC}  %s\n" "$1"; }
warn() { printf "${YELLOW}WARN${NC} %s\n" "$1"; }
fail() { printf "${RED}FAIL${NC} %s\n" "$1"; }
section() { printf "\n== %s ==\n" "$1"; }

FAILURES=0
WARNINGS=0

check_cmd() {
  local cmd="$1"
  local label="${2:-$1}"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$label found: $(command -v "$cmd")"
  else
    fail "$label missing"
    FAILURES=$((FAILURES+1))
  fi
}

check_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    ok "File exists: $file"
  else
    warn "File missing: $file"
    WARNINGS=$((WARNINGS+1))
  fi
}

check_dir() {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    ok "Directory exists: $dir"
  else
    warn "Directory missing: $dir"
    WARNINGS=$((WARNINGS+1))
  fi
}

check_vscode_ext() {
  local ext="$1"
  if command -v code >/dev/null 2>&1 && code --list-extensions | grep -qi "^${ext}$"; then
    ok "VS Code extension installed: $ext"
  else
    warn "VS Code extension missing: $ext"
    WARNINGS=$((WARNINGS+1))
  fi
}

section "Core CLI tools"
check_cmd brew Homebrew
check_cmd git Git
check_cmd node Node.js
check_cmd pnpm pnpm
check_cmd rg ripgrep
check_cmd fd fd
check_cmd jq jq
check_cmd gh GitHub CLI
check_cmd opencode OpenCode
check_cmd direnv direnv
check_cmd code "VS Code CLI"

section "Global directories"
check_dir "$HOME/dev"
check_dir "$HOME/ai"
check_dir "$HOME/tools"
check_dir "$HOME/.config/opencode"
check_dir "$HOME/.config/opencode/commands"

section "Global templates"
check_file "$HOME/ai/templates/AGENTS.md"
check_file "$HOME/ai/templates/requirements.md"
check_file "$HOME/ai/templates/.env.example"
check_file "$HOME/ai/templates/opencode.json"
check_file "$HOME/ai/specs/architecture.md"
check_file "$HOME/ai/specs/ui-rules.md"
check_file "$HOME/ai/review/release-checklist.md"
check_file "$HOME/ai/prompts/feature-small.md"
check_file "$HOME/ai/prompts/feature-large.md"
check_file "$HOME/ai/prompts/refactor.md"

section "VS Code extensions"
check_vscode_ext "GitHub.copilot"
check_vscode_ext "GitHub.copilot-chat"
check_vscode_ext "svelte.svelte-vscode"
check_vscode_ext "bradlc.vscode-tailwindcss"
check_vscode_ext "esbenp.prettier-vscode"
check_vscode_ext "dbaeumer.vscode-eslint"
check_vscode_ext "EditorConfig.EditorConfig"

section "Shell integration"
if grep -Fqs 'direnv hook zsh' "$HOME/.zshrc" 2>/dev/null; then
  ok "direnv hook present in ~/.zshrc"
else
  warn "direnv hook missing in ~/.zshrc"
  WARNINGS=$((WARNINGS+1))
fi

section "Provider note"
warn "OpenCode provider connection cannot be verified automatically. Run: opencode -> /connect -> GitHub Copilot"
WARNINGS=$((WARNINGS+1))

printf "\nSummary: %s failure(s), %s warning(s).\n" "$FAILURES" "$WARNINGS"
if [[ "$FAILURES" -gt 0 ]]; then
  exit 1
fi
