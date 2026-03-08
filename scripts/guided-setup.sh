#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CHECK_SCRIPT=""
VALIDATOR_CMD="python3 scripts/validate-framework.py"
NEW_APP_CMD="./scripts/new-ai-app.sh my-first-app ~/dev --basic"

for candidate in \
  "$SCRIPT_DIR/check-current-setup.sh" \
  "$HOME/tools/check-current-setup.sh" \
  "$SCRIPT_DIR/../scripts/check-current-setup.sh"; do
  if [[ -x "$candidate" ]]; then
    CHECK_SCRIPT="$candidate"
    break
  fi
done

if [[ -f "$HOME/tools/validate-framework.py" ]]; then
  VALIDATOR_CMD='python3 "$HOME/tools/validate-framework.py"'
fi

if [[ -x "$HOME/tools/new-ai-app.sh" ]]; then
  NEW_APP_CMD='$HOME/tools/new-ai-app.sh my-first-app ~/dev --basic'
fi

section() { printf '\n== %s ==\n' "$1"; }
info() { printf '%s\n' "$1"; }
warn() { printf 'WARN: %s\n' "$1" >&2; }

section "VibeCoding Guided Setup"
info "Dieses Skript ist für den ersten Einstieg gedacht."
info "Es verändert nichts am Framework. Es zeigt den sicheren nächsten Schritt."

section "1. Grundverständnis"
info "Du brauchst nur: Terminal, Homebrew, Logs grob lesen."
info "Du brauchst nicht: tiefes Coding-Wissen oder Runtime-Interna."

section "2. Empfohlene Reihenfolge"
info "1) setup-tools.sh aus dem Repo ausführen"
info "2) guided-setup.sh ausführen"
info "3) ${VALIDATOR_CMD}"
info "4) ${NEW_APP_CMD}"

section "3. Lokaler Setup-Check"
if [[ -n "$CHECK_SCRIPT" ]]; then
  "$CHECK_SCRIPT" || true
else
  warn "check-current-setup.sh wurde nicht gefunden oder ist nicht ausführbar"
fi

section "4. Nächster sinnvoller Schritt"
if [[ -d "$HOME/ai/templates" && -d "$HOME/.config/opencode" && -d "$HOME/tools" ]]; then
  info "Das Grundsetup wirkt vorhanden."
  info "Nächster Schritt: ${VALIDATOR_CMD}"
  info "Danach: ${NEW_APP_CMD}"
else
  warn "Das Grundsetup ist noch nicht vollständig."
  info "Nächster Schritt: setup-tools.sh aus dem Repo ausführen"
fi
