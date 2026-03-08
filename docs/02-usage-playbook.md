# Usage Playbook

## 1. Zweck

Dieses Dokument beschreibt die tägliche Arbeitsweise mit VibeCoding Basic nach abgeschlossenem Setup.

## 2. Arbeitsmodell

Verantwortlichkeiten:

- **VS Code**: Editor und Terminal
- **GitHub Copilot via OpenCode**: Modellzugang
- **OpenCode**: geführte Kommandos für Plan, Build und Review
- **GSD**: optionale Hilfe für größere, klar definierte Arbeitspakete
- **Repo-Dateien**: Source of Truth

Merksatz:

Nicht der Chat ist die Wahrheit. Das Repository ist die Wahrheit.

## 3. Projektstart: Pflichtreihenfolge

1. Projekt mit `new-ai-app.sh` anlegen
2. Projekt in VS Code öffnen
3. `AGENTS.md` lesen
4. `requirements.md` ausfüllen
5. `.ai/specs/architecture.md` lesen
6. `.ai/specs/ui-rules.md` lesen
7. `.ai/context/project-overview.md` ergänzen
8. OpenCode starten
9. `/connect` ausführen
10. `/plan` verwenden
11. erst danach implementieren

## 4. Grundregeln für gute Nutzung

Gut:

- kleine bis mittlere Änderungen
- präzise Anforderungen
- Repo-Kontext aktuell halten
- Review vor Commit
- bewusstes Schneiden von Scope

Schlecht:

- große, unscharfe Einmal-Prompts
- Architekturänderungen ohne Plan
- Projektwissen nur im Chat halten
- mehrere Probleme gleichzeitig in einem Schritt mischen
- unreviewte Massenänderungen

## 5. Wann GSD sinnvoll ist

GSD ist für größere, aber klar definierte Arbeitspakete geeignet.

Gut geeignet:

- neue Feature-Bereiche mit mehreren Teilaufgaben
- strukturierte Phasenarbeit
- Arbeitspakete, die fachlich sauber beschrieben sind

Nicht gut geeignet:

- kleine UI-Fixes
- einfache Textänderungen
- lokale Bugfixes in einem klar begrenzten Bereich

## 6. Standardsequenz für Änderungen

1. Größe der Änderung bestimmen
2. passenden Workflow wählen
3. relevante Dateien lesen
4. planen
5. kleinsten sinnvollen Schritt umsetzen
6. prüfen und reviewen
7. Projektkontext aktualisieren

## 7. Standardsequenz vor Übergabe oder Commit

1. `/review`
2. Build/Check ausführen
3. `.ai/context/current-status.md` aktualisieren
4. offene Punkte in `.ai/context/open-questions.md` dokumentieren
5. Commit nur mit verständlicher Änderungseinheit
