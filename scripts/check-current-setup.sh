#!/usr/bin/env bash
set -euo pipefail

FAILURES=0
WARNINGS=0

section() {
  printf "\n== %s ==\n" "$1"
}

ok() {
  printf "[OK] %s\n" "$1"
}

warn() {
  printf "[WARN] %s\n" "$1"
}

fail() {
  printf "[FAIL] %s\n" "$1"
}

check_cmd() {
  local cmd="$1"
  local label="${2:-$1}"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$label available"
  else
    fail "$label missing"
    FAILURES=$((FAILURES+1))
  fi
}

check_dir() {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    ok "Directory exists: $dir"
  else
    fail "Directory missing: $dir"
    FAILURES=$((FAILURES+1))
  fi
}

check_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    ok "File exists: $file"
  else
    fail "File missing: $file"
    FAILURES=$((FAILURES+1))
  fi
}

check_vscode_ext() {
  local ext="$1"
  if code --list-extensions 2>/dev/null | grep -qi "^${ext}$"; then
    ok "VS Code extension present: $ext"
  else
    warn "VS Code extension missing: $ext"
    WARNINGS=$((WARNINGS+1))
  fi
}

section "CLI tools"
check_cmd git git
check_cmd brew Homebrew
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

section "Global templates and guides"
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
check_file "$HOME/ai/context/project-overview.md"
check_file "$HOME/ai/context/current-status.md"
check_file "$HOME/ai/context/open-questions.md"
check_file "$HOME/ai/context/known-issues.md"
check_file "$HOME/ai/context/next-step.md"
check_file "$HOME/ai/PRODUCT-SCOPE.md"
check_file "$HOME/ai/CHANGE-SIZE-GUIDE.md"

section "OpenCode commands"
check_file "$HOME/.config/opencode/commands/plan.md"
check_file "$HOME/.config/opencode/commands/build-small.md"
check_file "$HOME/.config/opencode/commands/build-large.md"
check_file "$HOME/.config/opencode/commands/review.md"
check_file "$HOME/.config/opencode/commands/fix.md"
check_file "$HOME/.config/opencode/commands/status.md"

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
