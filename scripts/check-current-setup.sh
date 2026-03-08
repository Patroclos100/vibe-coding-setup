#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

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
  local cmd="$1" label="${2:-$1}"
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
    fail "File missing: $file"
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

check_json_expr() {
  local file="$1" expr="$2" label="$3"
  if [[ ! -f "$file" ]]; then
    fail "$label (config missing: $file)"
    FAILURES=$((FAILURES+1))
    return
  fi
  if jq -e "$expr" "$file" >/dev/null 2>&1; then
    ok "$label"
  else
    warn "$label not satisfied"
    WARNINGS=$((WARNINGS+1))
  fi
}

check_vscode_ext() {
  local ext="$1"
  if command -v code >/dev/null 2>&1 && code --list-extensions | grep -qi "^${ext}$"; then
    ok "VS Code extension installed: $ext"
  else
    warn "VS Code extension missing or code CLI unavailable: $ext"
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
check_cmd python3 Python

section "Framework directories"
check_dir "$HOME/dev"
check_dir "$HOME/ai"
check_dir "$HOME/ai/templates"
check_dir "$HOME/ai/templates/.ai"
check_dir "$HOME/ai/templates/.ai/agents"
check_dir "$HOME/ai/templates/.ai/contracts"
check_dir "$HOME/ai/templates/.ai/prompts"
check_dir "$HOME/ai/templates/.ai/specs"
check_dir "$HOME/ai/templates/.ai/state"
check_dir "$HOME/ai/templates/.ai/workflows"
check_dir "$HOME/ai/templates/.ai/review"
check_dir "$HOME/ai/templates/.ai/stacks"
check_dir "$HOME/ai/templates/.opencode"
check_dir "$HOME/ai/templates/.opencode/commands"
check_dir "$HOME/ai/templates/.opencode/prompts"
check_dir "$HOME/ai/framework-docs"
check_dir "$HOME/tools"

section "Framework files"
check_file "$HOME/ai/templates/AGENTS.md"
check_file "$HOME/ai/templates/requirements.md"
check_file "$HOME/ai/templates/.env.example"
check_file "$HOME/ai/templates/opencode.json"
check_file "$HOME/ai/templates/.ai/contracts/done-criteria.md"
check_file "$HOME/ai/templates/.ai/contracts/dependency-policy.md"
check_file "$HOME/ai/templates/.ai/specs/architecture.md"
check_file "$HOME/ai/templates/.ai/specs/product-spec.md"
check_file "$HOME/ai/templates/.ai/specs/test-strategy.md"
check_file "$HOME/ai/templates/.ai/contracts/check-matrix.md"
check_file "$HOME/ai/templates/.ai/contracts/state-management.md"
check_file "$HOME/ai/templates/.ai/contracts/acceptance-traceability.md"
check_file "$HOME/ai/templates/.ai/state/current-task.json"
check_file "$HOME/ai/templates/.ai/state/plan.json"
check_file "$HOME/ai/templates/.ai/stacks/sveltekit-web/stack.json"
check_file "$HOME/ai/templates/.ai/workflows/feature-workflow.md"
check_file "$HOME/ai/templates/.ai/workflows/bugfix-workflow.md"
check_file "$HOME/ai/templates/.ai/agents/code-generator.md"
check_file "$HOME/ai/templates/.ai/agents/debug-agent.md"
check_file "$HOME/ai/templates/.ai/review/release-checklist.md"
check_file "$HOME/ai/templates/.opencode/commands/intake.md"
check_file "$HOME/ai/templates/.opencode/commands/plan-feature.md"
check_file "$HOME/ai/templates/.opencode/commands/build-small.md"
check_file "$HOME/ai/templates/.opencode/commands/build-large.md"
check_file "$HOME/ai/templates/.opencode/commands/fix.md"
check_file "$HOME/ai/templates/.opencode/commands/refactor-safe.md"
check_file "$HOME/ai/templates/.opencode/commands/review-release.md"
check_file "$HOME/ai/templates/.opencode/commands/status.md"
check_file "$HOME/ai/templates/.opencode/prompts/vc-orchestrator.md"
check_file "$HOME/ai/templates/.opencode/prompts/vc-planner.md"
check_file "$HOME/tools/new-ai-app.sh"
check_file "$HOME/tools/check-current-setup.sh"
check_file "$HOME/tools/setup-opencode-commands.sh"
check_file "$HOME/tools/validate-framework.py"

section "OpenCode global fallback"
check_dir "$HOME/.config/opencode"
check_dir "$HOME/.config/opencode/commands"
check_dir "$HOME/.config/opencode/prompts"
check_file "$HOME/.config/opencode/opencode.json"
check_file "$HOME/.config/opencode/commands/intake.md"
check_file "$HOME/.config/opencode/commands/build-small.md"
check_file "$HOME/.config/opencode/prompts/vc-orchestrator.md"
check_json_expr "$HOME/.config/opencode/opencode.json" '.enabled_providers | index("github-copilot") != null' 'GitHub Copilot enabled in global OpenCode config'
check_json_expr "$HOME/.config/opencode/opencode.json" '.agent["vc-orchestrator"].mode == "primary"' 'vc-orchestrator configured globally'
check_json_expr "$HOME/.config/opencode/opencode.json" '.agent["vc-planner"].mode == "subagent"' 'vc-planner configured globally'

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

section "Readiness interpretation"
if [[ "$FAILURES" -eq 0 && "$WARNINGS" -eq 0 ]]; then
  ok "Basic setup looks ready for the first successful run"
elif [[ "$FAILURES" -eq 0 ]]; then
  warn "Basic setup is usable, but clean up the warnings before serious work"
else
  fail "Basic setup is not ready yet; fix the failures first"
fi

printf "\nWhat to do next:\n"
if [[ "$FAILURES" -gt 0 ]]; then
  printf "- Run: ./scripts/setup-tools.sh\n"
  printf "- Then: ./scripts/guided-setup.sh\n"
  printf "- Then repeat this check\n"
else
  printf "- Run: python3 scripts/validate-framework.py\n"
  printf "- Then: ./scripts/new-ai-app.sh my-first-app ~/dev --basic\n"
fi

printf "\nSummary: %s failure(s), %s warning(s).\n" "$FAILURES" "$WARNINGS"
if [[ "$FAILURES" -gt 0 ]]; then
  exit 1
fi
