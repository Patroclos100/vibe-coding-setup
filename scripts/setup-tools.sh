#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOOLS_DIR="$HOME/tools"
AI_DIR="$HOME/ai"
DEV_DIR="$HOME/dev"
OPENCODE_DIR="$HOME/.config/opencode"
OPENCODE_FILE="$OPENCODE_DIR/opencode.json"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

log() {
  printf "\n[%s] %s\n" "$(date '+%H:%M:%S')" "$1"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1"
    exit 1
  }
}

ensure_dir() {
  [[ -d "$1" ]] || mkdir -p "$1"
}

append_if_missing() {
  local line="$1"
  local file="$2"
  touch "$file"
  grep -Fqs "$line" "$file" || echo "$line" >> "$file"
}

backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    cp "$file" "${file}.backup-${TIMESTAMP}"
  fi
}

install_code_ext() {
  local ext="$1"
  if code --list-extensions | grep -qi "^${ext}$"; then
    log "VS Code extension already installed: $ext"
  else
    log "Installing VS Code extension: $ext"
    code --install-extension "$ext"
  fi
}

copy_template() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

log "Checking base prerequisites"
need_cmd brew
need_cmd git
need_cmd node
need_cmd pnpm

ensure_dir "$TOOLS_DIR"
ensure_dir "$AI_DIR"
ensure_dir "$DEV_DIR"
ensure_dir "$AI_DIR/templates"
ensure_dir "$AI_DIR/prompts"
ensure_dir "$AI_DIR/specs"
ensure_dir "$AI_DIR/review"
ensure_dir "$AI_DIR/agents"
ensure_dir "$OPENCODE_DIR"

if ! command -v code >/dev/null 2>&1; then
  cat <<'MSG'
The command 'code' is missing.
Open VS Code and run once:
Cmd+Shift+P -> Shell Command: Install 'code' command in PATH
Then rerun this script.
MSG
  exit 1
fi

log "Copying Brewfile to ~/tools/Brewfile"
cp "$ROOT_DIR/scripts/Brewfile" "$TOOLS_DIR/Brewfile"

log "Installing toolchain via brew bundle"
brew bundle --file "$TOOLS_DIR/Brewfile"

log "Installing recommended VS Code extensions"
EXTENSIONS=(
  "GitHub.copilot"
  "GitHub.copilot-chat"
  "svelte.svelte-vscode"
  "bradlc.vscode-tailwindcss"
  "esbenp.prettier-vscode"
  "dbaeumer.vscode-eslint"
  "EditorConfig.EditorConfig"
)
for ext in "${EXTENSIONS[@]}"; do
  install_code_ext "$ext"
done

log "Enabling direnv hook in ~/.zshrc"
append_if_missing 'eval "$(direnv hook zsh)"' "$HOME/.zshrc"

log "Writing safe global OpenCode base config"
backup_file "$OPENCODE_FILE"
cat > "$OPENCODE_FILE" <<'JSON'
{
  "$schema": "https://opencode.ai/config.json",
  "enabled_providers": ["github-copilot"],
  "permission": {
    "bash": {
      "*": "ask",
      "git status*": "allow",
      "git diff*": "allow",
      "git log*": "allow",
      "pnpm build*": "ask",
      "pnpm check*": "ask",
      "pnpm dev*": "ask",
      "node *": "ask",
      "rm *": "deny",
      "sudo *": "deny",
      "git push *": "deny",
      "git reset --hard *": "deny",
      "git clean -fd*": "deny",
      "curl *": "ask"
    },
    "edit": "ask",
    "webfetch": "deny",
    "websearch": "deny"
  },
  "watcher": {
    "ignore": [
      "node_modules/**",
      "dist/**",
      "build/**",
      ".git/**",
      ".svelte-kit/**",
      ".env*"
    ]
  }
}
JSON

log "Installing reusable templates into ~/ai"
copy_template "$ROOT_DIR/templates/AGENTS.md" "$AI_DIR/templates/AGENTS.md"
copy_template "$ROOT_DIR/templates/requirements.md" "$AI_DIR/templates/requirements.md"
copy_template "$ROOT_DIR/templates/opencode.json" "$AI_DIR/templates/opencode.json"
copy_template "$ROOT_DIR/templates/.env.example" "$AI_DIR/templates/.env.example"
copy_template "$ROOT_DIR/templates/.ai/specs/architecture.md" "$AI_DIR/specs/architecture.md"
copy_template "$ROOT_DIR/templates/.ai/specs/ui-rules.md" "$AI_DIR/specs/ui-rules.md"
copy_template "$ROOT_DIR/templates/.ai/review/release-checklist.md" "$AI_DIR/review/release-checklist.md"
copy_template "$ROOT_DIR/templates/.ai/prompts/feature-small.md" "$AI_DIR/prompts/feature-small.md"
copy_template "$ROOT_DIR/templates/.ai/prompts/feature-large.md" "$AI_DIR/prompts/feature-large.md"
copy_template "$ROOT_DIR/templates/.ai/prompts/refactor.md" "$AI_DIR/prompts/refactor.md"

cat > "$AI_DIR/agents/GSD-NOTES.md" <<'EOF2'
# GSD Notes

Use GSD mainly for larger work packages.

Recommended project start:
1. /gsd:new-project
2. /gsd:discuss-phase 1
3. /gsd:plan-phase 1
4. /gsd:execute-phase 1
5. /gsd:verify-work

For small changes prefer:
- /plan
- /build-small
- /review
EOF2

cat <<'MSG'

Setup complete.

Next steps:
1. Open a new terminal or run: source ~/.zshrc
2. Run: opencode
3. In OpenCode: /connect -> GitHub Copilot
4. Run: ./setup-opencode-commands.sh

Standard directories:
- ~/dev   for projects
- ~/ai    for templates and prompts
- ~/tools for local setup assets
MSG
