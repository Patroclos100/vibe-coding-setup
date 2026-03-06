#!/usr/bin/env bash
set -euo pipefail

OPENCODE_DIR="$HOME/.config/opencode"
COMMANDS_DIR="$OPENCODE_DIR/commands"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

log() {
  printf "\n[%s] %s\n" "$(date '+%H:%M:%S')" "$1"
}

ensure_dir() {
  [[ -d "$1" ]] || mkdir -p "$1"
}

backup_if_exists() {
  local file="$1"
  [[ -f "$file" ]] && cp "$file" "${file}.backup-${TIMESTAMP}"
}

ensure_dir "$COMMANDS_DIR"

log "Writing OpenCode Golden Path commands"

backup_if_exists "$COMMANDS_DIR/plan.md"
cat > "$COMMANDS_DIR/plan.md" <<'MD'
---
description: Analyse the request and produce an implementation plan
---

Read AGENTS.md, requirements.md and relevant files first.

Return:
1. current-state diagnosis
2. implementation plan in 5-8 steps
3. assumptions and risks
4. recommended smallest first increment

Do not implement code yet.
MD

backup_if_exists "$COMMANDS_DIR/build-small.md"
cat > "$COMMANDS_DIR/build-small.md" <<'MD'
---
description: Implement only the smallest useful and testable increment
---

Read AGENTS.md, requirements.md and the affected files first.

Then:
1. implement only the smallest useful increment
2. keep changes narrow and readable
3. run check/build if available
4. list changed files briefly
MD

backup_if_exists "$COMMANDS_DIR/build-large.md"
cat > "$COMMANDS_DIR/build-large.md" <<'MD'
---
description: Large change in controlled phases
---

Phase A:
- read AGENTS.md, requirements.md and relevant files
- create a plan with risks, side effects and sub-packages

Phase B:
- implement only the first 1-2 sub-packages
- run check/build if available

Avoid broad unreviewed rewrites.
MD

backup_if_exists "$COMMANDS_DIR/review.md"
cat > "$COMMANDS_DIR/review.md" <<'MD'
---
description: Review the current changes critically
---

Review the current changes for:
- unnecessary complexity
- duplicated logic
- weak naming
- missing error handling
- UI or UX breaks

Return review findings first.
Then propose the smallest safe refactor.
MD

cat <<'MSG'

OpenCode commands installed.

Available commands:
- /plan
- /build-small
- /build-large
- /review
MSG
