# Development Workflow

## Basic-Standardablauf

```text
/intake -> /plan-feature -> /build-small -> /fix -> /review-release
```

## Wozu die Schritte dienen

- `/intake` macht aus einer vagen Anforderung einen klaren Scope
- `/plan-feature` begrenzt die Arbeit auf ein kleines Inkrement
- `/build-small` setzt genau dieses Inkrement um
- `/fix` repariert echte Fehler gezielt
- `/review-release` prüft, ob das Inkrement sauber abgeschlossen ist

## Was beim ersten Durchlauf vermieden werden soll

- parallele Features
- breite Refactorings
- direkte freie Coding-Prompts ohne Command
- Nutzung von `/build-large` ohne klaren Grund

Für Details siehe:
- `docs/golden-path-first-success.md`
- `docs/command-map.md`
- `docs/runtime/overview.md`
