# Quickstart

Diese Version des Quickstarts ist auf einen realistischen Basic-Modus reduziert.

## Schritt 1: Tools installieren

```bash
./scripts/setup-tools.sh
```

## Schritt 2: Geführten Setup-Check ausführen

```bash
./scripts/guided-setup.sh
```

## Schritt 3: Framework selbst validieren

```bash
python3 scripts/validate-framework.py
```

Wichtig:
`validate-framework.py` prüft das **Framework selbst**. Das ist kein normaler täglicher Feature-Schritt, aber vor dem ersten Einsatz sinnvoll.

## Schritt 4: Erstes Projekt erzeugen

```bash
./scripts/new-ai-app.sh my-project ~/dev --basic
```

## Schritt 5: In OpenCode nur den Golden Path nutzen

```text
/intake -> /plan-feature -> /build-small -> /fix -> /review-release
```

## Was du am Anfang nicht brauchst

Für den ersten Erfolg brauchst du nicht:
- `/build-large`
- `/refactor-safe`
- Factory-Runtime-CLI
- Modul-Registry
- Release-/Monitoring-Details

## Erfolgskontrolle

Der Quickstart ist erfolgreich, wenn:
- das Setup läuft
- das Framework valide ist
- ein Projekt scaffolded wurde
- der Golden Path in OpenCode nachvollziehbar ausführbar ist
