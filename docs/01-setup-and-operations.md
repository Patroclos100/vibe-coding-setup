# Setup and Operations Guide

## 1. Zweck

Dieses Dokument erklärt den Standard-Setup für VibeCoding Basic auf macOS sowie den schnellsten belastbaren Start ohne Chat-Nachhilfe.

## 2. Scope

Enthalten:

- lokaler Tool-Setup
- VS-Code-Erweiterungen
- OpenCode-Basis-Konfiguration
- OpenCode-Kommandos
- Setup-Validierung
- Projekt-Bootstrap

Nicht enthalten:

- Deployment
- CI/CD
- Cloud-Hosting
- Mobile-Paketierung
- versteckte Runtime-Logik

## 3. Standard-Umgebung

- macOS
- zsh
- Visual Studio Code
- GitHub Copilot Abo
- Homebrew

## 4. Standardverzeichnisse

```text
~/dev     -> Projekt-Repositories
~/ai      -> wiederverwendbare Templates, Regeln, Prompts
~/tools   -> lokale Setup-Artefakte
```

## 5. Voraussetzungen vor dem Start

1. Xcode Command Line Tools installieren
2. Homebrew installieren
3. `code`-CLI in VS Code aktivieren
4. GitHub-Login und Copilot-Zugriff prüfen

VS-Code-CLI aktivieren:

- VS Code öffnen
- `Cmd+Shift+P`
- `Shell Command: Install 'code' command in PATH`

## 6. Setup-Reihenfolge

### 6.1 Tooling installieren

```bash
cd scripts
./setup-tools.sh
```

Erwartetes Ergebnis:

- Standardverzeichnisse existieren
- Brewfile wurde nach `~/tools` kopiert
- benötigte Tools sind installiert
- VS-Code-Erweiterungen sind installiert
- sichere globale OpenCode-Basiskonfiguration ist geschrieben
- Templates sind nach `~/ai` kopiert

### 6.2 OpenCode-Kommandos installieren

```bash
./setup-opencode-commands.sh
```

Erwartetes Ergebnis:

- `/plan`
- `/build-small`
- `/build-large`
- `/review`
- optional `/fix`
- optional `/status`

### 6.3 Setup validieren

```bash
./check-current-setup.sh
```

Erwartetes Ergebnis:

- Kern-Tools vorhanden
- Verzeichnisse vorhanden
- Templates vorhanden
- VS-Code-Erweiterungen vorhanden
- OpenCode-Kommandos vorhanden

## 7. OpenCode mit Copilot verbinden

```bash
opencode
```

Dann in OpenCode:

```text
/connect
```

Provider:

```text
GitHub Copilot
```

## 8. Neues Projekt erstellen

### Minimaler Standardpfad

```bash
./new-ai-app.sh my-app ~/dev --minimal
```

### UI-orientierter Start

```bash
./new-ai-app.sh my-app ~/dev --ui
```

Das Skript erzeugt ein Web-Projekt mit:

- SvelteKit
- pnpm
- Projekt-README
- `AGENTS.md`
- `requirements.md`
- `.ai/specs`
- `.ai/prompts`
- `.ai/review`
- `.ai/context`
- `.env.example`
- `.envrc`
- lokalem `opencode.json`

## 9. Erste Schritte im Projekt

```bash
cd ~/dev/my-app
pnpm dev
opencode
```

Dann:

1. `requirements.md` füllen
2. `.ai/context/project-overview.md` prüfen
3. `/plan` nutzen
4. erste kleine Änderung mit `/build-small`
5. Review mit `/review`

## 10. Troubleshooting

### `code` command not found

In VS Code den Shell Command für `code` aktivieren und neues Terminal öffnen.

### `opencode` vorhanden, aber kein Provider verbunden

`opencode` starten und `/connect -> GitHub Copilot` ausführen.

### Zielordner existiert bereits

`new-ai-app.sh` überschreibt keine bestehenden Projekte. Neuen Namen oder neuen Pfad verwenden.

### Bootstrap-CLI ändert sich upstream

`new-ai-app.sh` nutzt bewusst konservative Defaults und prüft Fehler stärker. Wenn Svelte-CLI Flags ändert, das Skript anpassen statt still weiterzulaufen.

### `direnv` greift nicht

Neues Terminal öffnen oder `source ~/.zshrc` ausführen.

## 11. Betriebslogik

Dieses Repo ist kein autonomes System. Die Nutzer arbeiten geführt, dokumentiert und reviewbar. Gute Nutzung heißt:

- Anforderungen schriftlich festhalten
- kleine Änderungen sauber schneiden
- vor Code zuerst lesen und planen
- nach Änderungen prüfen und reviewen
