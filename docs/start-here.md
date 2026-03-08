# Start Here

Das ist der beste Einstieg für IT-nahe Anwender ohne Coding-Praxis.

## Ziel dieses Dokuments

Du sollst mit möglichst wenig Entscheidungsdruck zu einem ersten erfolgreichen Durchlauf kommen.

Nicht nötig beim Einstieg:
- die komplette Runtime-Architektur zu verstehen
- alle Agenten zu kennen
- alle Commands zu benutzen
- Factory-Interna zu lernen

## Was du voraussetzen darfst

Dieses Framework setzt nur Folgendes voraus:
- Terminal-Grundlagen
- Homebrew-Grundlagen
- einfache Logs und Fehlermeldungen lesen

Es setzt **nicht** voraus:
- professionelle Softwareentwicklung
- Architekturdesign aus dem Stand
- Python- oder TypeScript-Wissen
- Verständnis aller JSON-Verträge vor dem ersten Start

## Der sichere Einstieg

Arbeite genau in dieser Reihenfolge:

### 1. Tools installieren
```bash
./scripts/setup-tools.sh
```

### 2. Geführten Setup-Check ausführen
```bash
./scripts/guided-setup.sh
```

### 3. Framework intern prüfen
```bash
python3 scripts/validate-framework.py
```

### 4. Erstes Projekt anlegen
```bash
./scripts/new-ai-app.sh my-first-app ~/dev --basic
```

### 5. In das Projekt wechseln und nur den Golden Path nutzen
```bash
cd ~/dev/my-first-app
opencode
```

Dann in OpenCode:

```text
/connect
/models
/intake
/plan-feature
/build-small
/fix
/review-release
```

## Was du am Anfang ignorieren sollst

Ignoriere beim ersten Durchlauf bewusst:
- Factory-Runtime-CLI
- Modul-Registry
- Blueprints
- Release-/Deploy-/Monitoring-Flows
- Framework-Tests im Detail
- alle Kommandos außerhalb des Golden Path

## Wann du im Basic-Modus erfolgreich bist

Der Basic-Modus ist erfolgreich, wenn du Folgendes schaffst:
- das lokale Setup läuft
- der Setup-Check zeigt keine Blocker
- ein Projekt wurde erzeugt
- `/intake` und `/plan-feature` liefern eine klare Aufgabe
- `/build-small` arbeitet an genau einem kleinen Inkrement
- Fehler können mit `/fix` nachvollziehbar eingegrenzt werden

## Wenn du hängen bleibst

Nutze zuerst:
- `docs/07-troubleshooting.md`
- `docs/golden-path-first-success.md`
- `./scripts/check-current-setup.sh`
