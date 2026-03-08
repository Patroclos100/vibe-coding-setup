# Advanced / Expert Mode

## Zweck

Dieser Modus enthält die vollständige Leistungsfähigkeit des Frameworks. Er bleibt vollständig erhalten.

## Gehört in Advanced / Expert

- Factory-Runtime-CLI unter `templates/factory-runtime/`
- Factory-Orchestrierung unter `templates/.ai/factory/`
- Blueprints unter `templates/.ai/blueprints/`
- Modul-Registry unter `templates/.ai/modules/`
- Projekt- und Release-Registries
- Deployment- und Monitoring-Workflows
- Execution Policy, Transition Matrix, Failure Taxonomy
- Framework-Selbsttests und Golden Runs

## Woran man erkennt, dass Advanced sinnvoll ist

Advanced ist sinnvoll, wenn mindestens eines davon zutrifft:
- mehrere Projekte oder Module sollen gesteuert werden
- Wiederverwendung über Modul-Registry ist wichtig
- Release-/Deploy-/Monitoring-Flows sollen standardisiert werden
- Runtime-CLI soll aktiv verwendet werden
- Policy-Entscheidungen und State-Maschine sollen direkt nachvollzogen werden

## Was sich gegenüber Basic ändert

- mehr sichtbare Kommandos
- mehr strukturierte Artefakte
- höhere Begriffs- und Prozessdichte
- mehr explizite Qualitäts- und Governance-Schritte
- mehr operative Verantwortung beim Anwender

## Regel

Advanced ist eine Erweiterung von Basic, kein Ersatz. Der Golden Path bleibt auch hier der stabile Einstieg.
