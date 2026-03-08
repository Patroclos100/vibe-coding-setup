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

log "Writing OpenCode Basic commands"

backup_if_exists "$COMMANDS_DIR/plan.md"
cat > "$COMMANDS_DIR/plan.md" <<'MD'
---
description: Analyse the request and produce a small-step implementation plan
---

Read `AGENTS.md`, `requirements.md`, `.ai/specs/*`, `.ai/context/*` and the relevant implementation files first.

Return:
1. current-state diagnosis
2. plan in 5-8 steps
3. assumptions and risks
4. recommended smallest first increment

Do not implement code yet.
MD

backup_if_exists "$COMMANDS_DIR/build-small.md"
cat > "$COMMANDS_DIR/build-small.md" <<'MD'
---
description: Implement only the smallest useful and reviewable increment
---

Read `AGENTS.md`, `requirements.md`, `.ai/specs/*` and the affected files first.

Then:
1. restate the smallest useful outcome
2. implement only that increment
3. keep changes narrow and readable
4. avoid unrelated refactors
5. run check/build if available
6. list changed files and remaining risks briefly
MD

backup_if_exists "$COMMANDS_DIR/build-large.md"
cat > "$COMMANDS_DIR/build-large.md" <<'MD'
---
description: Larger change in controlled phases
---

Read `AGENTS.md`, `requirements.md`, `.ai/specs/*`, `.ai/context/*` and the relevant files first.

Phase A:
- diagnose the current state
- split the work into phases or sub-packages
- identify risks and side effects

Phase B:
- implement only phase 1 or the first 1-2 sub-packages
- keep the change reviewable
- run check/build if available

Avoid broad unreviewed rewrites.
MD

backup_if_exists "$COMMANDS_DIR/review.md"
cat > "$COMMANDS_DIR/review.md" <<'MD'
---
description: Review the current changes critically before the next step
---

Review the current changes for:
- unnecessary complexity
- duplicated logic
- weak naming
- missing error handling
- UI or UX breaks
- violations of repository rules

Return review findings first.
Then propose the smallest safe follow-up action.
MD

backup_if_exists "$COMMANDS_DIR/fix.md"
cat > "$COMMANDS_DIR/fix.md" <<'MD'
---
description: Apply a narrow fix for a clearly identified problem
---

Read the relevant files first.

Then:
1. restate the concrete defect
2. apply only the smallest fix
3. avoid broad cleanup or feature work
4. run the smallest useful validation
5. list changed files briefly
MD

backup_if_exists "$COMMANDS_DIR/status.md"
cat > "$COMMANDS_DIR/status.md" <<'MD'
---
description: Summarize project state from repository files for a clean restart
---

Read:
- `requirements.md`
- `.ai/context/project-overview.md`
- `.ai/context/current-status.md`
- `.ai/context/open-questions.md`
- `.ai/context/known-issues.md`
- `.ai/context/next-step.md`

Return:
1. project goal in 2-3 bullets
2. current status
3. open questions
4. known issues
5. recommended next smallest step
MD

cat <<'MSG'

OpenCode commands installed.

Available commands:
- /plan
- /build-small
- /build-large
- /review
- /fix
- /status
MSG
