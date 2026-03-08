# VibeCoding AI Factory

Deterministic AI-first development framework for IT-nahe Anwender mit wenig oder keiner Coding-Praxis.

Der Repo-Zustand ist funktionsfähig und leistungsfähig, aber nicht selbsterklärend. Dieses Repository wurde deshalb um einen **Basic-Layer** ergänzt, ohne die bestehende Expertenschicht oder Runtime-Funktionen zu entfernen.

## Start hier

Für den ersten erfolgreichen Durchlauf nutze nur diese Reihenfolge:

1. `docs/start-here.md`
2. `docs/quickstart.md`
3. `docs/basic-mode.md`
4. `docs/golden-path-first-success.md`
5. `docs/07-troubleshooting.md`

## Basic vs Advanced

### Basic-Modus
Gedacht für IT-nahe Nutzer mit Terminal-, Homebrew- und Log-Grundwissen.

Im Basic-Modus sind nur diese Dinge relevant:
- Tooling installieren
- Setup prüfen
- ein Projekt scaffolden
- in OpenCode nur mit dem Golden Path arbeiten
- Fehler zuerst über die einfachen Troubleshooting-Schritte eingrenzen

Empfohlene Basic-Kommandos:
- `/intake`
- `/plan-feature`
- `/build-small`
- `/fix`
- `/review-release`
- `/status`

### Advanced-/Expert-Modus
Hier liegen die erweiterten Factory-Funktionen:
- Blueprint-Auswahl
- Modul-Registry und Wiederverwendung
- Factory-Runtime-CLI
- Release-/Deploy-/Monitoring-Flows
- strukturierte Policy- und State-Maschinen
- Framework-Selbsttests und Runtime-Interna

## Kernprinzip

Dieses Framework arbeitet nicht als freies Chat-System, sondern als kontrollierte Kette:

`Command -> Workflow -> Agent Contract -> State Update -> Quality Gate -> Review -> Release`

Factory-Ebene:

`Idea -> Intake -> Blueprint Selection -> Product Initialization -> Module Plan -> Build -> Test -> Review -> Release -> Deploy -> Monitor`

## Sichtbare Einstiegspfade

### Erster lokaler Setup-Pfad
```bash
./scripts/setup-tools.sh
./scripts/guided-setup.sh
```

### Erster Repo-Check
```bash
./scripts/check-current-setup.sh
python3 scripts/validate-framework.py
```

### Erster Projekt-Scaffold
```bash
./scripts/new-ai-app.sh my-first-app ~/dev --basic
```

### Erster erfolgreicher Use Case
In OpenCode nur diese Folge nutzen:

```text
/intake -> /plan-feature -> /build-small -> /fix -> /review-release
```

## Repository-Orientierung

- `docs/start-here.md` — bester Einstieg ohne Vorwissen zum Framework
- `docs/basic-mode.md` — was Basic wirklich nutzen soll
- `docs/advanced-expert-mode.md` — was bewusst später kommt
- `docs/golden-path-first-success.md` — erster erfolgreicher End-to-End-Pfad
- `docs/command-map.md` — welche Kommandos wann sinnvoll sind
- `docs/runtime/*` — Runtime-Interna
- `docs/framework-testing/*` — Framework-Selbsttests, nicht normales Projekt-Feature-Bauen
- `templates/` — Payload, die in neue Projekte kopiert wird
- `scripts/` — Setup, Checks, Scaffolding
- `framework-tests/` — Tests für das Framework selbst

## Runtime vs Framework-Tests

### Runtime
Diese Teile gehören zur normalen Arbeit in erzeugten Projekten:
- `templates/.opencode/commands/*`
- `templates/.opencode/prompts/*`
- `templates/.ai/contracts/*`
- `templates/.ai/state/*`
- `templates/.ai/stacks/*`
- `templates/factory-runtime/*`

### Framework-Tests
Diese Teile prüfen das Framework selbst und sind **nicht** der normale tägliche Feature-Flow:
- `framework-tests/*`
- `scripts/validate-framework.py`
- Golden-Runs, Fixtures, Negativszenarien

## Deterministic Factory Runtime

Das Repository enthält einen ausführbaren Runtime-Layer unter `templates/factory-runtime/`.

Beispiele:

```bash
python3 factory-runtime/cli.py status
python3 factory-runtime/cli.py run intake --project billing-app --request "Build a billing platform"
python3 factory-runtime/cli.py run build-module --project billing-app --module auth-service
python3 factory-runtime/cli.py run release --project billing-app --release-id v0.1.0
```
