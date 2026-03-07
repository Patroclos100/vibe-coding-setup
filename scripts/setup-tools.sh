#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOOLS_DIR="${HOME}/tools"
AI_DIR="${HOME}/ai"
TEMPLATES_DIR="${AI_DIR}/templates"
FRAMEWORK_DOCS_DIR="${AI_DIR}/framework-docs"
DEV_DIR="${HOME}/dev"
OPENCODE_DIR="${HOME}/.config/opencode"
OPENCODE_FILE="${OPENCODE_DIR}/opencode.json"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
DEFAULT_PROVIDER="github-copilot"
DEFAULT_MODEL="github-copilot/claude-sonnet-4"
DEFAULT_SMALL_MODEL="github-copilot/claude-sonnet-4"

log() { printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$1"; }
warn() { printf 'WARN: %s\n' "$1" >&2; }
die() { printf 'ERROR: %s\n' "$1" >&2; exit 1; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

ensure_dir() {
  [[ -d "$1" ]] || mkdir -p "$1"
}

append_if_missing() {
  local line="$1" file="$2"
  touch "$file"
  grep -Fqs "$line" "$file" || echo "$line" >> "$file"
}

backup_file() {
  local file="$1"
  [[ -f "$file" ]] && cp "$file" "${file}.backup-${TIMESTAMP}"
}

copy_tree() {
  local src="$1" dst="$2"
  [[ -d "$src" ]] || die "Missing directory to copy: $src"
  mkdir -p "$dst"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$src"/ "$dst"/
  else
    rm -rf "$dst"/*
    (cd "$src" && tar -cf - .) | (cd "$dst" && tar -xf -)
  fi
}

install_code_ext() {
  local ext="$1"
  if ! command -v code >/dev/null 2>&1; then
    warn "VS Code CLI 'code' not found; skipping extension install for $ext"
    return 0
  fi
  if code --list-extensions | grep -qi "^${ext}$"; then
    log "VS Code extension already installed: $ext"
  else
    log "Installing VS Code extension: $ext"
    code --install-extension "$ext" || warn "Failed to install VS Code extension: $ext"
  fi
}

write_global_opencode_config() {
  ensure_dir "$OPENCODE_DIR"
  [[ -f "$OPENCODE_FILE" ]] || printf '{}\n' > "$OPENCODE_FILE"
  backup_file "$OPENCODE_FILE"

  python3 - <<'PY' "$OPENCODE_FILE" "$DEFAULT_PROVIDER" "$DEFAULT_MODEL" "$DEFAULT_SMALL_MODEL"
import json, sys
from pathlib import Path
path = Path(sys.argv[1])
provider = sys.argv[2]
model = sys.argv[3]
small_model = sys.argv[4]
try:
    data = json.loads(path.read_text(encoding='utf-8') or '{}')
except Exception:
    data = {}
data['$schema'] = 'https://opencode.ai/config.json'
data.setdefault('share', 'manual')
data['model'] = data.get('model', model)
data['small_model'] = data.get('small_model', small_model)
enabled = data.setdefault('enabled_providers', [])
if provider not in enabled:
    enabled.insert(0, provider)
provider_cfg = data.setdefault('provider', {})
provider_cfg.setdefault(provider, {})
provider_cfg[provider].setdefault('options', {})
provider_cfg[provider]['options'].setdefault('timeout', 600000)
permission = data.setdefault('permission', {})
permission.setdefault('bash', 'ask')
permission.setdefault('edit', 'ask')
permission.setdefault('write', 'ask')
permission.setdefault('webfetch', 'deny')
watcher = data.setdefault('watcher', {})
watcher.setdefault('ignore', ['node_modules/**', 'dist/**', 'build/**', '.git/**', '.svelte-kit/**', '.env*'])
path.write_text(json.dumps(data, indent=2) + '\n', encoding='utf-8')
PY
}

main() {
  need_cmd brew
  need_cmd git
  need_cmd python3

  ensure_dir "$TOOLS_DIR"
  ensure_dir "$AI_DIR"
  ensure_dir "$DEV_DIR"
  ensure_dir "$TEMPLATES_DIR"
  ensure_dir "$FRAMEWORK_DOCS_DIR"
  ensure_dir "$OPENCODE_DIR"

  log "Copying Brewfile to $TOOLS_DIR/Brewfile"
  cp "$ROOT_DIR/scripts/Brewfile" "$TOOLS_DIR/Brewfile"

  log "Installing toolchain via brew bundle"
  brew bundle --file "$TOOLS_DIR/Brewfile"

  log "Copying full framework templates into $TEMPLATES_DIR"
  copy_tree "$ROOT_DIR/templates" "$TEMPLATES_DIR"

  if [[ -d "$ROOT_DIR/docs" ]]; then
    log "Copying framework docs into $FRAMEWORK_DOCS_DIR"
    copy_tree "$ROOT_DIR/docs" "$FRAMEWORK_DOCS_DIR"
  fi

  log "Installing helper scripts into $TOOLS_DIR"
  install -m 755 "$ROOT_DIR/scripts/new-ai-app.sh" "$TOOLS_DIR/new-ai-app.sh"
  install -m 755 "$ROOT_DIR/scripts/check-current-setup.sh" "$TOOLS_DIR/check-current-setup.sh"
  install -m 755 "$ROOT_DIR/scripts/setup-opencode-commands.sh" "$TOOLS_DIR/setup-opencode-commands.sh"

  log "Enabling direnv hook in ~/.zshrc"
  append_if_missing 'eval "$(direnv hook zsh)"' "$HOME/.zshrc"

  log "Writing safe global OpenCode base config"
  write_global_opencode_config

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

  log "Installing global fallback OpenCode commands and prompts"
  "$ROOT_DIR/scripts/setup-opencode-commands.sh"

  cat <<MSG

Setup complete.

Next steps:
1. Open a new terminal or run: source ~/.zshrc
2. Run: $TOOLS_DIR/check-current-setup.sh
3. Run: $TOOLS_DIR/new-ai-app.sh my-app ~/dev --ui
4. Run: opencode
5. In OpenCode: /connect -> GitHub Copilot
6. Then inside the project: /intake <your first request>

Installed directories:
- $DEV_DIR                projects
- $AI_DIR                 framework assets
- $TEMPLATES_DIR          current templates used by new-ai-app.sh
- $FRAMEWORK_DOCS_DIR     reference docs
- $TOOLS_DIR              helper scripts
- $OPENCODE_DIR           global fallback OpenCode config
MSG
}

main "$@"
