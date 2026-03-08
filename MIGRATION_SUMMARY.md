# Migration Summary

## Ausgangsstruktur
Das Eingangs-Repository war ein gehärtetes VibeCoding Framework mit:
- `templates/.ai/` für Contracts, Specs, Workflows, Stacks und State
- `templates/.opencode/` für Commands und Runtime-Prompts
- `scripts/` für Setup, Scaffolding und Validierung
- `framework-tests/` für Selbsttests
- `docs/` für Dokumentation

## Wichtigste Änderungen
- AI-Factory-Ebene ergänzt, ohne die bestehende Runtime-Struktur zu entfernen
- neue Factory-Artefakte unter `templates/.ai/factory/`, `blueprints/`, `modules/`, `projects/`, `releases/`
- neue Factory-Level-Agents hinzugefügt
- neue deterministische Workflows für Blueprint-Auswahl, Produktinitialisierung, Modulplanung, Release, Deployment und Monitoring ergänzt
- Command-System um Factory-, Module-, Quality-, Release- und Monitoring-Commands erweitert
- Quality-Gate-Vertrag (`.ai/contracts/quality.ai`) ergänzt
- Scaffolding-/Instruction-Layer so erweitert, dass die neuen Bereiche in generierte Projekte übernommen werden
- Framework-Validierung um zentrale Factory-Dateien ergänzt

## Neue Komponenten
- `.ai/factory/factory.ai`
- `.ai/contracts/quality.ai`
- `.ai/workflows/release.ai`
- `.ai/agents/factory-orchestrator-agent.ai`
- `.ai/blueprints/saas-webapp.ai`
- `.ai/modules/module-registry.ai`
- `.opencode/commands/factory-create-product.md`
- `.opencode/commands/factory-build-module.md`
- `templates/.ai/projects/project-portfolio.json`
- `templates/.ai/releases/release-registry.json`
- `templates/.ai/state/factory-state.json`

## Migrationslogik
- Bestehende Runtime-Artefakte wurden beibehalten.
- Erweiterung vor Ersetzung wurde bevorzugt.
- Neue Factory-Fähigkeiten wurden in neue Verzeichnisse ausgelagert, damit bestehende Flows kompatibel bleiben.
- Vorhandene Runtime-Prompts wurden für neue Factory-Agenten wiederverwendet, wo eine semantisch passende Zuordnung ausreichend war.

## Offene Annahmen
- Das bestehende Repository enthielt noch keinen separaten ausführbaren Factory-Controller. Die Migration ergänzt daher die Factory primär auf Artefakt-, Policy- und Command-Ebene.
- Deployment- und Monitoring-Artefakte sind generisch gehalten, da keine konkrete Zielplattform im Input-Repository vorlag.
- Die bestehenden Prompt-Dateien wurden nicht komplett neu geschrieben, sondern für neue Agenten gemappt, um Kompatibilität zu priorisieren.
