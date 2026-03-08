# Troubleshooting

Diese Datei ist absichtlich in einfacher Sprache gehalten.

## Regel 1: Erst prüfen, ob das Problem im Setup oder in der Aufgabe liegt

### Setup prüfen
```bash
./scripts/check-current-setup.sh
```

### Framework intern prüfen
```bash
python3 scripts/validate-framework.py
```

## Häufige Probleme und erste Maßnahmen

### 1. `brew`, `pnpm`, `opencode` oder `python3` fehlen
Bedeutung:
Ein Basis-Tool ist nicht installiert oder nicht im Pfad.

Maßnahme:
- `./scripts/setup-tools.sh` erneut ausführen
- neues Terminal öffnen
- `./scripts/guided-setup.sh` erneut laufen lassen

### 2. OpenCode-Kommandos fehlen
Bedeutung:
Die globalen Fallback-Commands oder die Projektdateien wurden nicht korrekt kopiert.

Maßnahme:
```bash
./scripts/setup-opencode-commands.sh
```

Danach prüfen:
- `~/.config/opencode/commands/`
- Projektordner `.opencode/commands/`

### 3. Das Projekt wurde erzeugt, aber OpenCode findet die Regeln nicht
Bedeutung:
Lokale Projektdateien fehlen oder du bist im falschen Ordner.

Maßnahme:
Prüfen, ob im Projekt vorhanden:
- `AGENTS.md`
- `requirements.md`
- `.ai/`
- `.opencode/`

### 4. `/build-small` wirkt zu groß oder chaotisch
Bedeutung:
Meist war `/intake` oder `/plan-feature` zu breit.

Maßnahme:
- zurück zu `/intake`
- Aufgabe kleiner formulieren
- nur ein sehr kleines Inkrement erlauben

### 5. Es ist unklar, was als Nächstes sinnvoll ist
Maßnahme:
In OpenCode:
```text
/status
```

Danach den Golden Path fortsetzen.

### 6. JSON-/Schema-/Validation-Fehler
Bedeutung:
Meist stimmen Struktur oder Pflichtfelder nicht.

Erste Stellen zum Nachsehen:
- `templates/.ai/state/test-results.json`
- `templates/.ai/state/debug-log.json`
- `framework-tests/scenarios/`
- `docs/framework-testing/validator.md`

## Einfache Fehlerdiagnose nach Ebenen

### Ebene A: Tool fehlt
Problem vor dem Framework.

### Ebene B: Datei fehlt
Problem bei Setup oder Kopierpfad.

### Ebene C: Command unklar
Problem bei Onboarding oder Scope.

### Ebene D: JSON/Schema schlägt fehl
Problem in Runtime-/State-Artefakten.

## Wenn du nur eine Sache tust

Nutze zuerst immer diese Reihenfolge:

```bash
./scripts/check-current-setup.sh
python3 scripts/validate-framework.py
```
