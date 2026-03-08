# Basic Mode

## Zweck

Der Basic-Modus ist für motivierte Einsteiger mit IT-Hintergrund gedacht. Er reduziert nicht die Fähigkeiten des Frameworks, sondern nur die **sichtbare Komplexität**.

## Was im Basic-Modus sichtbar und aktiv sein sollte

### Setup
- `./scripts/setup-tools.sh`
- `./scripts/guided-setup.sh`
- `./scripts/check-current-setup.sh`

### Projektstart
- `./scripts/new-ai-app.sh <app-name> ~/dev --basic`

### Dokumente
- `README.md`
- `docs/start-here.md`
- `docs/quickstart.md`
- `docs/golden-path-first-success.md`
- `docs/07-troubleshooting.md`

### OpenCode-Kommandos
Nur diese Kommandos sollen aktiv empfohlen werden:
- `/intake`
- `/plan-feature`
- `/build-small`
- `/fix`
- `/review-release`
- `/status`

## Was Basic voraussetzen darf

Basic darf voraussetzen:
- Terminal öffnen und Skripte starten
- Homebrew und Tool-Installation ausführen
- einfache Pfade verstehen
- Logs lesen und Fehler grob einordnen
- einen Editor wie VS Code bedienen

Basic darf **nicht** voraussetzen:
- Verständnis aller Agentenrollen
- Verständnis der Policy-Engine
- manuelle Arbeit an State-Schemata
- Entscheidung zwischen vielen Workflow-Varianten am Anfang
- freie Architekturentscheidungen ohne Leitplanken

## Was im Basic-Modus verborgen, vereinfacht oder später erklärt werden sollte

### Erst später
- `factory-runtime` intern
- Blueprint-Auswahl im Detail
- Modul-Registry und Wiederverwendung
- Release-/Deploy-/Monitoring-Workflows
- Framework-Testsystem im Detail
- Runtime-State-Machine und Policy-Artefakte

### Vereinfacht darstellen
- "Deterministic runtime" zuerst als "kontrollierter Ablauf statt freiem Chat"
- "Contracts" zuerst als "Regeln und Prüfkriterien"
- "State" zuerst als "maschinenlesbarer Arbeitsstand"
- "Quality gates" zuerst als "Pflichtprüfungen vor fertig"

## Basic-Erfolgskriterien

Ein Nutzer ist im Basic-Modus erfolgreich, wenn er ohne Hilfe:
- ein Projekt anlegen kann
- den Golden Path nutzen kann
- typische Setup-Fehler findet
- nachvollziehen kann, was der nächste sinnvolle Schritt ist
