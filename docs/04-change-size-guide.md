# Change Size Guide

## 1. Zweck

Nutzer sollen Änderungen bewusst schneiden. Die wichtigste Schutzmaßnahme in VibeCoding Basic ist nicht Magie, sondern passende Änderungsgröße.

## 2. Kleine Änderung

Typisch:

- Textkorrektur
- kleines UI-Detail
- einzelner Bugfix
- lokaler Formularschritt
- eng begrenzte Komponente

Workflow:

- optional `/plan`
- meist `/build-small`
- danach `/review`

Review-Tiefe:

- kurz, aber verpflichtend

Typische Risiken:

- Scope creep
- Vermischung mit Refactor

Empfohlene AI-Nutzung:

- konkrete Anweisung
- wenige betroffene Dateien
- sichtbares Ziel klar benennen

## 3. Mittlere Änderung

Typisch:

- zusammenhängende Feature-Erweiterung
- mehrere Dateien in einem Bereich
- lokale Architekturberührung ohne Systemumbau

Workflow:

- `/plan`
- `/build-large` oder mehrere `/build-small`-Schritte
- `/review`

Review-Tiefe:

- inhaltlich und strukturell

Typische Risiken:

- Seiteneffekte
- unklare Zuständigkeiten zwischen Dateien

Empfohlene AI-Nutzung:

- erst Plan, dann Phase 1
- klare Teilpakete statt Monolith-Prompt

## 4. Große Änderung

Typisch:

- neue Feature-Area mit vielen Teilaspekten
- Umbau von mehreren Routen, Komponenten und Services
- größere Architekturberührung

Workflow:

- verpflichtend `/plan`
- in Phasen schneiden
- nur erste Phase mit `/build-large`
- nach jeder Phase `/review`

Review-Tiefe:

- deutlich höher
- Konventionen, UX, Seiteneffekte, Testbarkeit prüfen

Typische Risiken:

- Überforderung des Modells
- versteckte Architekturverschiebung
- hoher Kontextverlust

Empfohlene AI-Nutzung:

- Repo-Kontext sauber halten
- GSD nur ergänzend für Phasen- oder Paketstruktur
- nie als unreviewte Komplettausführung verwenden

## 5. Faustregel

Wenn eine Änderung sich nicht klar beschreiben, abgrenzen und reviewen lässt, ist sie für VibeCoding Basic noch zu groß geschnitten.
