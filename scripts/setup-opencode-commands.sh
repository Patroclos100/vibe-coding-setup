#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AI_TEMPLATE_DIR="${HOME}/ai/templates"
OPENCODE_HOME="${HOME}/.config/opencode"
COMMANDS_DIR="${OPENCODE_HOME}/commands"
PROMPTS_DIR="${OPENCODE_HOME}/prompts"
CONFIG_FILE="${OPENCODE_HOME}/opencode.json"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
DEFAULT_PROVIDER="github-copilot"
DEFAULT_MODEL="github-copilot/claude-sonnet-4"
DEFAULT_SMALL_MODEL="github-copilot/claude-sonnet-4"

log() { printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$1"; }
warn() { printf 'WARN: %s\n' "$1" >&2; }
die() { printf 'ERROR: %s\n' "$1" >&2; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"; }

copy_tree() {
  local src="$1" dst="$2"
  [[ -d "$src" ]] || die "Missing source directory: $src"
  mkdir -p "$dst"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$src"/ "$dst"/
  else
    rm -rf "$dst"/*
    (cd "$src" && tar -cf - .) | (cd "$dst" && tar -xf -)
  fi
}

resolve_template_dir() {
  local candidate
  for candidate in \
    "$AI_TEMPLATE_DIR/.opencode" \
    "$ROOT_DIR/templates/.opencode"; do
    if [[ -d "$candidate/commands" && -d "$candidate/prompts" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

backup_file() {
  local file="$1"
  [[ -f "$file" ]] && cp "$file" "${file}.backup-${TIMESTAMP}"
}

patch_global_config() {
  mkdir -p "$OPENCODE_HOME"
  [[ -f "$CONFIG_FILE" ]] || printf '{}\n' > "$CONFIG_FILE"
  backup_file "$CONFIG_FILE"

  python3 - <<'PY' "$CONFIG_FILE" "$DEFAULT_PROVIDER" "$DEFAULT_MODEL" "$DEFAULT_SMALL_MODEL"
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
permission = data.setdefault('permission', {})
permission.setdefault('bash', 'ask')
permission.setdefault('edit', 'ask')
permission.setdefault('write', 'ask')
permission.setdefault('webfetch', 'deny')
instructions = data.setdefault('instructions', [])
for item in ['AGENTS.md', 'requirements.md', '.ai/contracts/*.md', '.ai/specs/*.md', '.ai/workflows/*.md', '.ai/agents/*.md', '.ai/review/*.md']:
    if item not in instructions:
        instructions.append(item)
agent = data.setdefault('agent', {})
def upsert(name, prompt_file, mode, steps, hidden, tools):
    cfg = agent.setdefault(name, {})
    cfg['mode'] = mode
    cfg['prompt'] = prompt_file
    cfg['steps'] = max(int(cfg.get('steps', steps)), steps)
    cfg['temperature'] = 0
    cfg['hidden'] = hidden
    cfg.setdefault('tools', {}).update(tools)
    return cfg
orch = upsert('vc-orchestrator', '{file:prompts/vc-orchestrator.md}', 'primary', 20, False, {'bash': True, 'write': True, 'edit': True})
orch.setdefault('description', 'Main workflow orchestrator for deterministic VibeCoding.')
orch_permission = orch.setdefault('permission', {})
orch_task = orch_permission.setdefault('task', {})
orch_task['*'] = 'deny'
orch_task['vc-*'] = 'allow'
upsert('vc-planner', '{file:prompts/vc-planner.md}', 'subagent', 8, True, {'bash': False, 'write': True, 'edit': True})
upsert('vc-architecture-validator', '{file:prompts/vc-architecture-validator.md}', 'subagent', 6, True, {'bash': False, 'write': False, 'edit': False})
upsert('vc-dependency-manager', '{file:prompts/vc-dependency-manager.md}', 'subagent', 6, True, {'bash': False, 'write': False, 'edit': False})
upsert('vc-code-generator', '{file:prompts/vc-code-generator.md}', 'subagent', 14, True, {'bash': True, 'write': True, 'edit': True})
upsert('vc-test-generator', '{file:prompts/vc-test-generator.md}', 'subagent', 10, True, {'bash': True, 'write': True, 'edit': True})
upsert('vc-debugger', '{file:prompts/vc-debugger.md}', 'subagent', 12, True, {'bash': True, 'write': True, 'edit': True})
upsert('vc-refactorer', '{file:prompts/vc-refactorer.md}', 'subagent', 10, True, {'bash': True, 'write': True, 'edit': True})
upsert('vc-release-reviewer', '{file:prompts/vc-release-reviewer.md}', 'subagent', 8, True, {'bash': True, 'write': True, 'edit': True})
path.write_text(json.dumps(data, indent=2) + '\n', encoding='utf-8')
PY
}

main() {
  need_cmd python3
  mkdir -p "$COMMANDS_DIR" "$PROMPTS_DIR"

  local source_dir
  source_dir="$(resolve_template_dir)" || die "Could not find .opencode templates. Run setup-tools.sh first or execute from the repo root."

  log "Syncing global fallback OpenCode commands from $source_dir/commands"
  copy_tree "$source_dir/commands" "$COMMANDS_DIR"

  log "Syncing global fallback OpenCode prompts from $source_dir/prompts"
  copy_tree "$source_dir/prompts" "$PROMPTS_DIR"

  log "Patching global OpenCode config"
  patch_global_config

  cat <<MSG

Global fallback OpenCode assets installed.

Installed paths:
- $COMMANDS_DIR
- $PROMPTS_DIR
- $CONFIG_FILE

Notes:
- Project-local .opencode/ files are still preferred.
- These global commands are mainly a safety net for older repos or ad-hoc work.
- The main path remains: new-ai-app.sh -> project-local .opencode/ -> /intake -> /plan-feature -> /build-small.
MSG
}

main "$@"
