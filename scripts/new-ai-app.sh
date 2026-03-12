#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_NAME="$(basename "$0")"
DEFAULT_TARGET_DIR="${HOME}/dev"
DEFAULT_MODE="minimal"
DEFAULT_FRAMEWORK="sveltekit"
DEFAULT_PACKAGE_MANAGER="pnpm"
DEFAULT_PROVIDER="github-copilot"
DEFAULT_MODEL="github-copilot/claude-sonnet-4"
DEFAULT_SMALL_MODEL="github-copilot/claude-sonnet-4"

APP_NAME=""
TARGET_DIR="$DEFAULT_TARGET_DIR"
MODE="$DEFAULT_MODE"
FRAMEWORK="$DEFAULT_FRAMEWORK"
PACKAGE_MANAGER="$DEFAULT_PACKAGE_MANAGER"
TEMPLATE_ROOT=""
PROVIDER="$DEFAULT_PROVIDER"
MODEL="$DEFAULT_MODEL"
SMALL_MODEL="$DEFAULT_SMALL_MODEL"
FORCE=0
INIT_GIT=1
RUN_INSTALL=1
RUN_DEV_DEPS=1
RUN_TAILWIND=1
RUN_SHADCN=0
QUIET=0
PROJECT_DIR=""

log() {
  [[ "$QUIET" -eq 1 ]] && return 0
  printf '%s\n' "$*"
}

warn() {
  printf 'WARN: %s\n' "$*" >&2
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<USAGE
Usage:
  ${SCRIPT_NAME} <app-name> [target-dir] [options]

Examples:
  ${SCRIPT_NAME} my-app
  ${SCRIPT_NAME} my-app ~/dev --ui
  ${SCRIPT_NAME} my-app ~/work --template-root ~/ai/templates
  ${SCRIPT_NAME} my-app --provider github-copilot --model github-copilot/claude-sonnet-4

Options:
  --minimal                 Bootstrap lean V2+OpenCode project skeleton (default)
  --ui                      Bootstrap V2+OpenCode project and try shadcn-svelte setup
  --framework <name>        Currently supported: sveltekit (default)
  --pm <name>               Package manager: pnpm (default)
  --template-root <path>    Root directory containing V2+OpenCode template files
  --provider <id>           OpenCode provider id (default: github-copilot)
  --model <id>              OpenCode default model id (default: github-copilot/claude-sonnet-4)
  --small-model <id>        OpenCode small_model id (default: github-copilot/claude-sonnet-4)
  --force                   Allow creating into an existing empty target dir path
  --no-install              Skip package installation and generator side effects
  --no-dev-deps             Skip dev dependency installation
  --no-tailwind             Skip Tailwind add step
  --no-git                  Do not initialize a git repository
  --quiet                   Reduce output
  -h, --help                Show this help

Behavior:
  - Creates a deterministic app skeleton for AI-assisted development.
  - Copies the full V2 framework + .opencode command/agent structure into the new project.
  - Configures OpenCode for a GitHub Copilot-first workflow.
  - Enforces .ai/contracts, .ai/specs, .ai/workflows, .ai/agents, .ai/state, and .opencode/commands.
USAGE
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

realpath_fallback() {
  python3 - <<'PY' "$1"
import os, sys
print(os.path.realpath(sys.argv[1]))
PY
}

abspath() {
  local path="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$path"
  else
    realpath_fallback "$path"
  fi
}

is_empty_dir() {
  local dir="$1"
  [[ -d "$dir" ]] || return 1
  [[ -z "$(find "$dir" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]
}

append_if_missing() {
  local file="$1"
  local marker="$2"
  local block="$3"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  if ! grep -Fq "$marker" "$file"; then
    printf '\n%s\n' "$block" >> "$file"
  fi
}

write_file_if_missing() {
  local dest="$1"
  local content="$2"
  if [[ ! -e "$dest" ]]; then
    mkdir -p "$(dirname "$dest")"
    printf '%s\n' "$content" > "$dest"
  fi
}

copy_tree_contents() {
  local src="$1"
  local dest="$2"
  [[ -d "$src" ]] || die "Template source does not exist: $src"
  mkdir -p "$dest"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a "$src"/ "$dest"/
  else
    (cd "$src" && tar -cf - .) | (cd "$dest" && tar -xf -)
  fi
}

resolve_template_root() {
  local script_dir candidate
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [[ -n "$TEMPLATE_ROOT" ]]; then
    [[ -d "$TEMPLATE_ROOT" ]] || die "--template-root not found: $TEMPLATE_ROOT"
    TEMPLATE_ROOT="$(abspath "$TEMPLATE_ROOT")"
    return 0
  fi

  for candidate in \
    "$HOME/ai/templates" \
    "$HOME/ai/v2/templates" \
    "$script_dir/../templates" \
    "$script_dir/../../templates"; do
    if [[ -f "$candidate/AGENTS.md" && -d "$candidate/.ai" && -d "$candidate/.opencode" ]]; then
      TEMPLATE_ROOT="$(abspath "$candidate")"
      return 0
    fi
  done

  die "Could not resolve template root containing AGENTS.md, .ai, and .opencode. Pass --template-root <path>."
}

parse_args() {
  local positional=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --minimal)
        MODE="minimal"
        RUN_SHADCN=0
        shift
        ;;
      --ui)
        MODE="ui"
        RUN_SHADCN=1
        shift
        ;;
      --framework)
        FRAMEWORK="${2:-}"
        [[ -n "$FRAMEWORK" ]] || die "Missing value for --framework"
        shift 2
        ;;
      --pm)
        PACKAGE_MANAGER="${2:-}"
        [[ -n "$PACKAGE_MANAGER" ]] || die "Missing value for --pm"
        shift 2
        ;;
      --template-root)
        TEMPLATE_ROOT="${2:-}"
        [[ -n "$TEMPLATE_ROOT" ]] || die "Missing value for --template-root"
        shift 2
        ;;
      --provider)
        PROVIDER="${2:-}"
        [[ -n "$PROVIDER" ]] || die "Missing value for --provider"
        shift 2
        ;;
      --model)
        MODEL="${2:-}"
        [[ -n "$MODEL" ]] || die "Missing value for --model"
        shift 2
        ;;
      --small-model)
        SMALL_MODEL="${2:-}"
        [[ -n "$SMALL_MODEL" ]] || die "Missing value for --small-model"
        shift 2
        ;;
      --force)
        FORCE=1
        shift
        ;;
      --no-install)
        RUN_INSTALL=0
        shift
        ;;
      --no-dev-deps)
        RUN_DEV_DEPS=0
        shift
        ;;
      --no-tailwind)
        RUN_TAILWIND=0
        shift
        ;;
      --no-git)
        INIT_GIT=0
        shift
        ;;
      --quiet)
        QUIET=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      --)
        shift
        while [[ $# -gt 0 ]]; do positional+=("$1"); shift; done
        ;;
      -*)
        die "Unknown option: $1"
        ;;
      *)
        positional+=("$1")
        shift
        ;;
    esac
  done

  [[ ${#positional[@]} -ge 1 ]] || { usage; exit 1; }
  APP_NAME="${positional[0]}"
  if [[ ${#positional[@]} -ge 2 ]]; then
    TARGET_DIR="${positional[1]}"
  fi
}

validate_args() {
  [[ "$APP_NAME" =~ ^[a-z0-9][a-z0-9._-]*$ ]] || die "App name must match: ^[a-z0-9][a-z0-9._-]*$"
  [[ "$FRAMEWORK" == "sveltekit" ]] || die "Unsupported framework: $FRAMEWORK"
  [[ "$PACKAGE_MANAGER" == "pnpm" ]] || die "Unsupported package manager: $PACKAGE_MANAGER"
  [[ "$PROVIDER" =~ ^[a-z0-9._-]+$ ]] || die "Provider must match: ^[a-z0-9._-]+$"
  [[ "$MODEL" == */* ]] || die "Model must be a full OpenCode model id like provider/model"
  [[ "$SMALL_MODEL" == */* ]] || die "Small model must be a full OpenCode model id like provider/model"
}

bootstrap_sveltekit() {
  log "==> Bootstrapping SvelteKit app"
  require_cmd node
  require_cmd npx

  local create_args=(create "$APP_NAME" --types ts --template minimal)
  if [[ "$RUN_INSTALL" -eq 0 ]]; then
    npx sv@latest "${create_args[@]}" --no-install
  else
    npx sv@latest "${create_args[@]}"
  fi
}

install_dependencies() {
  [[ "$RUN_INSTALL" -eq 1 ]] || { log "==> Skipping install (--no-install)"; return 0; }

  log "==> Installing base dependencies"
  "$PACKAGE_MANAGER" install

  if [[ "$RUN_TAILWIND" -eq 1 ]]; then
    if command -v npx >/dev/null 2>&1; then
      log "==> Adding Tailwind"
      npx sv add tailwindcss || warn "Tailwind setup failed; continuing"
    else
      warn "npx not found; skipping Tailwind add step"
    fi
  fi

  if [[ "$RUN_DEV_DEPS" -eq 1 ]]; then
    log "==> Installing deterministic DX dependencies"
    "$PACKAGE_MANAGER" add -D prettier prettier-plugin-svelte eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin vitest @vitest/coverage-v8 playwright || warn "Dev dependency install failed; continuing"
  fi

  if [[ "$MODE" == "ui" && "$RUN_SHADCN" -eq 1 ]]; then
    if command -v npx >/dev/null 2>&1; then
      log "==> Initializing shadcn-svelte"
      npx shadcn-svelte@latest init || warn "shadcn-svelte init failed; continuing"
      npx shadcn-svelte@latest add button input dialog card form || warn "shadcn component add failed; continuing"
    else
      warn "npx not found; skipping shadcn-svelte setup"
    fi
  fi
}

copy_v2_framework() {
  log "==> Copying V2 + OpenCode framework templates from $TEMPLATE_ROOT"
  copy_tree_contents "$TEMPLATE_ROOT" "$PROJECT_DIR"
}

ensure_project_structure() {
  log "==> Ensuring deterministic project structure"
  mkdir -p \
    "$PROJECT_DIR/src/lib/components" \
    "$PROJECT_DIR/src/lib/components/ui" \
    "$PROJECT_DIR/src/lib/server" \
    "$PROJECT_DIR/src/lib/domain" \
    "$PROJECT_DIR/src/lib/services" \
    "$PROJECT_DIR/src/lib/utils" \
    "$PROJECT_DIR/src/routes" \
    "$PROJECT_DIR/tests" \
    "$PROJECT_DIR/tests/unit" \
    "$PROJECT_DIR/tests/integration" \
    "$PROJECT_DIR/tests/e2e" \
    "$PROJECT_DIR/.opencode/sessions"

  write_file_if_missing "$PROJECT_DIR/src/lib/utils/cn.ts" $'export function cn(...parts: Array<string | false | null | undefined>) {\n  return parts.filter(Boolean).join(" ");\n}'

  write_file_if_missing "$PROJECT_DIR/src/routes/+page.svelte" $'<script lang="ts">\n  const title = "AI-first app";\n  const subtitle = "Bootstrap complete. Fill requirements.md before implementation.";\n</script>\n\n<svelte:head>\n  <title>{title}</title>\n  <meta name="description" content={subtitle} />\n</svelte:head>\n\n<div class="mx-auto max-w-3xl px-6 py-16">\n  <h1 class="text-3xl font-bold tracking-tight">{title}</h1>\n  <p class="mt-4 text-base opacity-80">{subtitle}</p>\n</div>'
}

configure_local_files() {
  log "==> Writing local development guardrails"

  append_if_missing "$PROJECT_DIR/.gitignore" "# VIBECODING_V2_PLUS_LOCAL" "# VIBECODING_V2_PLUS_LOCAL
.env
.env.*
!.env.example
.direnv/
.opencoderc
.DS_Store
coverage/
playwright-report/
.test-results/
"

  write_file_if_missing "$PROJECT_DIR/.envrc" '# Review before allowing: direnv allow
export PNPM_HOME="$HOME/Library/pnpm"
layout node
export OPENCODE_CONFIG_DIR=".opencode"
'

  if [[ ! -f "$PROJECT_DIR/.env.example" ]]; then
    printf '# Copy to .env.local or .env as needed. Never commit secrets.\n' > "$PROJECT_DIR/.env.example"
  fi

  write_file_if_missing "$PROJECT_DIR/.opencode/README.md" "# OpenCode project config

This directory is loaded by OpenCode as project-local config.

Key folders:
- commands/ -> user-invoked workflow entry points
- prompts/  -> orchestrator and subagent prompts
- sessions/ -> optional local notes/state snapshots

Operational rule:
Do not bypass commands with ad-hoc freeform implementation prompts unless you are explicitly debugging the framework itself.
"

  write_file_if_missing "$PROJECT_DIR/.opencode/sessions/session-start.md" "# Session start

1. Read AGENTS.md.
2. Confirm requirements.md contains explicit scope and acceptance criteria.
3. Start with /intake or /plan-feature.
4. Use /build-small before /build-large.
5. Use /fix for failing checks.
6. Use /review-release before merge.
"
}

hydrate_template_variables() {
  log "==> Hydrating project metadata"

  python3 - <<'PY' "$PROJECT_DIR" "$APP_NAME"
from pathlib import Path
import sys
project_dir = Path(sys.argv[1])
app_name = sys.argv[2]
replacements = {
    "__APP_NAME__": app_name,
    "{{APP_NAME}}": app_name,
    "<APP_NAME>": app_name,
}
skip_ext = {'.png', '.jpg', '.jpeg', '.gif', '.webp', '.ico', '.woff', '.woff2', '.ttf', '.eot', '.zip'}
for path in project_dir.rglob('*'):
    if not path.is_file() or path.suffix.lower() in skip_ext:
        continue
    try:
        data = path.read_text(encoding='utf-8')
    except Exception:
        continue
    new_data = data
    for old, new in replacements.items():
        new_data = new_data.replace(old, new)
    if new_data != data:
        path.write_text(new_data, encoding='utf-8')
PY
}

configure_opencode_json() {
  [[ -f "$PROJECT_DIR/opencode.json" ]] || die "opencode.json missing after template copy"
  log "==> Configuring OpenCode for provider=$PROVIDER model=$MODEL"

  python3 - <<'PY' "$PROJECT_DIR/opencode.json" "$PROVIDER" "$MODEL" "$SMALL_MODEL"
import json, sys
from pathlib import Path
path = Path(sys.argv[1])
provider = sys.argv[2]
model = sys.argv[3]
small_model = sys.argv[4]

data = json.loads(path.read_text(encoding='utf-8'))
data['$schema'] = 'https://opencode.ai/config.json'
data['model'] = model
data['small_model'] = small_model
data['default_agent'] = data.get('default_agent', 'vc-orchestrator')
data['share'] = data.get('share', 'manual')
provider_cfg = data.setdefault('provider', {})
provider_cfg.setdefault(provider, {})
provider_cfg[provider].setdefault('options', {})
provider_cfg[provider]['options'].setdefault('timeout', 600000)
data['enabled_providers'] = [provider]
data['disabled_providers'] = [p for p in data.get('disabled_providers', []) if p != provider]
permission = data.setdefault('permission', {})
permission.setdefault('bash', 'allow')
permission.setdefault('edit', 'allow')
permission.setdefault('write', 'allow')
permission.setdefault('webfetch', 'deny')

instr = data.setdefault('instructions', [])
required_instr = [
    'AGENTS.md',
    'requirements.md',
    '.ai/contracts/*.md',
    '.ai/specs/*.md',
    '.ai/workflows/*.md',
    '.ai/agents/*.md',
    '.ai/review/*.md',
]
for item in required_instr:
    if item not in instr:
        instr.append(item)

agent_cfg = data.setdefault('agent', {})
orch = agent_cfg.setdefault('vc-orchestrator', {})
orch['mode'] = 'primary'
orch.setdefault('description', 'Main workflow orchestrator for deterministic VibeCoding.')
orch['prompt'] = '{file:.opencode/prompts/vc-orchestrator.md}'
orch['steps'] = max(int(orch.get('steps', 20)), 20)
orch['temperature'] = 0
orch_permission = orch.setdefault('permission', {})
orch_task = orch_permission.setdefault('task', {})
orch_task['*'] = 'deny'
orch_task['vc-*'] = 'allow'
for agent_name in [
    'vc-planner',
    'vc-architecture-validator',
    'vc-dependency-manager',
    'vc-code-generator',
    'vc-test-generator',
    'vc-debugger',
    'vc-refactorer',
    'vc-release-reviewer',
]:
    cfg = agent_cfg.setdefault(agent_name, {})
    cfg.setdefault('mode', 'subagent')
    cfg['hidden'] = True
    cfg['temperature'] = 0
path.write_text(json.dumps(data, indent=2) + '\n', encoding='utf-8')
PY
}

write_project_readme() {
  log "==> Writing README"
  cat > "$PROJECT_DIR/README.md" <<EOF2
# $APP_NAME

AI-first application scaffold with V2 autonomous-development guardrails and OpenCode command orchestration.

## Golden path
1. Fill \\`requirements.md\\`
2. Review \\`AGENTS.md\\`
3. Review \\`.ai/specs/*\\` and adapt only where the project truly differs
4. Open OpenCode and connect GitHub Copilot with \\`/connect\\`
5. Select a Copilot-supported model with \\`/models\\` if needed
6. Start with \\`/intake\\` or \\`/plan-feature\\`
7. Use \\`/build-small\\` before \\`/build-large\\`
8. Run \\`/review-release\\` before merge

## Required workflow discipline
- Do not start coding directly from chat.
- Commands orchestrate workflows; workflows orchestrate agents.
- Do not bypass \\`.ai/workflows/*\\` or \\`.ai/agents/*\\`.
- Use \\`/fix\\` for build or test failures.
- Use \\`/refactor-safe\\` only when evidence exists.

## OpenCode project commands
- \\`/intake\\`
- \\`/plan-feature\\`
- \\`/build-small\\`
- \\`/build-large\\`
- \\`/fix\\`
- \\`/refactor-safe\\`
- \\`/review-release\\`
- \\`/status\\`

## Standard runtime commands
- \\`$PACKAGE_MANAGER dev\\`
- \\`$PACKAGE_MANAGER build\\`
- \\`$PACKAGE_MANAGER check\\`
- \\`$PACKAGE_MANAGER test\\` (after you add concrete tests)

## Notes
- The framework is optimized for deterministic, bounded AI-assisted delivery.
- Treat the state files in \\`.ai/state\\` as operational control artifacts.
- GitHub Copilot model availability can vary by plan; if the configured model is unavailable, switch it in \\`/models\\` or update \\`opencode.json\\`.
EOF2
}

normalize_package_json() {
  [[ -f "$PROJECT_DIR/package.json" ]] || return 0
  log "==> Normalizing package metadata"

  python3 - <<'PY' "$PROJECT_DIR/package.json" "$APP_NAME"
import json, sys
from pathlib import Path
path = Path(sys.argv[1])
app_name = sys.argv[2]
data = json.loads(path.read_text(encoding='utf-8'))
data['name'] = app_name
scripts = data.setdefault('scripts', {})
scripts.setdefault('check:all', 'pnpm check && pnpm build')
scripts.setdefault('test', 'vitest run')
scripts.setdefault('test:watch', 'vitest')
scripts.setdefault('test:e2e', 'playwright test')
scripts.setdefault('ai:intake', 'echo "In OpenCode run: /intake"')
scripts.setdefault('ai:plan', 'echo "In OpenCode run: /plan-feature"')
scripts.setdefault('ai:build-small', 'echo "In OpenCode run: /build-small"')
scripts.setdefault('ai:fix', 'echo "In OpenCode run: /fix"')
scripts.setdefault('ai:review', 'echo "In OpenCode run: /review-release"')
path.write_text(json.dumps(data, indent=2) + '\n', encoding='utf-8')
PY
}

init_git_repo() {
  [[ "$INIT_GIT" -eq 1 ]] || { log "==> Skipping git init (--no-git)"; return 0; }
  require_cmd git

  if [[ ! -d "$PROJECT_DIR/.git" ]]; then
    log "==> Initializing git repository"
    git -C "$PROJECT_DIR" init >/dev/null 2>&1 || warn "git init failed"
  fi

  git -C "$PROJECT_DIR" add . >/dev/null 2>&1 || true
  git -C "$PROJECT_DIR" commit -m "Initialize V2+OpenCode AI-first app scaffold" >/dev/null 2>&1 || true
}

postflight_checks() {
  log "==> Running postflight checks"
  [[ -f "$PROJECT_DIR/AGENTS.md" ]] || die "AGENTS.md missing after bootstrap"
  [[ -f "$PROJECT_DIR/requirements.md" ]] || die "requirements.md missing after bootstrap"
  [[ -f "$PROJECT_DIR/opencode.json" ]] || die "opencode.json missing after bootstrap"
  [[ -d "$PROJECT_DIR/.ai/agents" ]] || die ".ai/agents missing after bootstrap"
  [[ -d "$PROJECT_DIR/.ai/contracts" ]] || die ".ai/contracts missing after bootstrap"
  [[ -d "$PROJECT_DIR/.ai/specs" ]] || die ".ai/specs missing after bootstrap"
  [[ -d "$PROJECT_DIR/.ai/workflows" ]] || die ".ai/workflows missing after bootstrap"
  [[ -d "$PROJECT_DIR/.ai/state" ]] || die ".ai/state missing after bootstrap"
  [[ -d "$PROJECT_DIR/.opencode/commands" ]] || die ".opencode/commands missing after bootstrap"
  [[ -d "$PROJECT_DIR/.opencode/prompts" ]] || die ".opencode/prompts missing after bootstrap"

  local required_cmds=(intake.md plan-feature.md build-small.md build-large.md fix.md refactor-safe.md review-release.md status.md)
  local cmd
  for cmd in "${required_cmds[@]}"; do
    [[ -f "$PROJECT_DIR/.opencode/commands/$cmd" ]] || die "Missing OpenCode command: $cmd"
  done
}

print_next_steps() {
  cat <<EOF2

Project created: $PROJECT_DIR
Template root:   $TEMPLATE_ROOT
Mode:            $MODE
Framework:       $FRAMEWORK
Package manager: $PACKAGE_MANAGER
Provider:        $PROVIDER
Model:           $MODEL
Small model:     $SMALL_MODEL

Next steps:
  cd '$PROJECT_DIR'
  direnv allow                     # optional; review .envrc first
  $PACKAGE_MANAGER dev
  opencode
  /connect                         # choose GitHub Copilot
  /models                          # verify configured model is available
  /intake                          # start the enforced workflow

Operational rule:
  Do not implement features before requirements.md contains explicit scope,
  acceptance criteria, constraints, and out-of-scope boundaries.
  Do not bypass .opencode/commands with ad-hoc freeform coding prompts.
EOF2
}

main() {
  parse_args "$@"
  validate_args
  resolve_template_root

  mkdir -p "$TARGET_DIR"
  TARGET_DIR="$(abspath "$TARGET_DIR")"
  PROJECT_DIR="$TARGET_DIR/$APP_NAME"

  if [[ -e "$PROJECT_DIR" ]]; then
    if [[ "$FORCE" -eq 1 && -d "$PROJECT_DIR" ]] && is_empty_dir "$PROJECT_DIR"; then
      log "==> Reusing existing empty directory: $PROJECT_DIR"
    else
      die "Target already exists and is not an empty reusable directory: $PROJECT_DIR"
    fi
  fi

  if [[ ! -d "$PROJECT_DIR" ]]; then
    mkdir -p "$PROJECT_DIR"
  fi

  if ! is_empty_dir "$PROJECT_DIR"; then
    die "Target directory must be empty before bootstrap: $PROJECT_DIR"
  fi

  case "$FRAMEWORK" in
    sveltekit)
      (
        cd "$TARGET_DIR"
        bootstrap_sveltekit
      )
      ;;
  esac

  cd "$PROJECT_DIR"
  install_dependencies
  copy_v2_framework
  ensure_project_structure
  configure_local_files
  hydrate_template_variables
  configure_opencode_json
  normalize_package_json
  write_project_readme
  init_git_repo
  postflight_checks
  print_next_steps
}

main "$@"