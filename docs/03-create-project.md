# Create Project

## Empfohlener Basic-Befehl

```bash
./scripts/new-ai-app.sh my-project ~/dev --basic
```

## Was dieser Schritt tut

- erzeugt ein neues Projektverzeichnis
- kopiert die Templates aus `templates/`
- schreibt lokale Guardrails
- konfiguriert OpenCode lokal
- legt die Runtime-Struktur an

## Wann du `--advanced` nutzen solltest

Nur wenn du bewusst mit UI-/erweiterten Generator-Schritten starten willst:

```bash
./scripts/new-ai-app.sh my-project ~/dev --advanced
```

## Wichtige Regel

Der Projekt-Scaffold ist der Startpunkt. Fachliche Anforderungen gehören danach zuerst in `requirements.md` und dann in den Golden Path.
