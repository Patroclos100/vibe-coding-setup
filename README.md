# VibeCoding Basic

VibeCoding Basic ist ein bewusst einfaches, repo-first AI-Development-Basissystem für kleine bis mittlere Web-Projekte.

Es richtet sich an IT-nahe Anwender ohne klassische Programmiererfahrung, die mit klaren Schritten, lokalen Regeln und AI-Unterstützung arbeiten wollen.

## Wofür diese Basic Version gedacht ist

Enthalten:

- Web-first Standard-Setup mit SvelteKit, TypeScript, Tailwind und pnpm
- Arbeiten in Visual Studio Code
- GitHub Copilot Abo über OpenCode `/connect`
- OpenCode-Kommandos für Planen, kleine Änderungen, größere Änderungen und Review
- repo-lokale Templates, Regeln und Projektkontext
- leichte, nachvollziehbare Setup- und Helper-Skripte
- Unterstützung für GSD / get-shit-done bei größeren, klar abgegrenzten Arbeitspaketen

Bewusst **nicht** enthalten:

- Mobile-Factory oder native App-Build-Logik
- Runtime Engine oder Policy Controller
- Multi-Agent-Plattform
- autonome Delivery-Pipeline
- Multi-Framework- oder Multi-Stack-Abstraktion
- schwer nachvollziehbare Hintergrundlogik

## Für wen es passt

Geeignet für:

- IT-Fachleute
- Product Owner
- technische Projektleiter
- Prozess- und Fachspezialisten
- technisch versierte Nicht-Programmierer
- Einsteiger mit solider Tool-Affinität

Vorausgesetzt werden:

- Terminal-Grundverständnis
- VS-Code-Nutzung
- Git-Grundlagen
- grobes Lesen von Logs und Fehlermeldungen
- Bereitschaft, strukturiert statt frei-chaotisch mit AI zu arbeiten

Nicht geeignet für:

- komplette Computer-Laien
- Entwickler mit Bedarf an maximaler technischer Freiheit
- Teams mit Fokus auf native Mobile-Apps oder komplexe Plattformarchitekturen
- Nutzer, die vollautonome Softwareentwicklung ohne Review erwarten

## Golden Path

1. `docs/00-product-scope.md` lesen
2. `docs/01-setup-and-operations.md` ausführen
3. `scripts/check-current-setup.sh` laufen lassen
4. `scripts/new-ai-app.sh my-app ~/dev --minimal` ausführen
5. Im Projekt `requirements.md` und `.ai/context/project-overview.md` pflegen
6. In OpenCode mit `/plan` starten
7. Kleine Änderungen mit `/build-small` umsetzen
8. Vor Commit oder Übergabe `/review` verwenden

## Repository-Struktur

```text
.
├── README.md
├── docs/
│   ├── 00-product-scope.md
│   ├── 01-setup-and-operations.md
│   ├── 02-usage-playbook.md
│   ├── 03-workflows.md
│   ├── 04-change-size-guide.md
│   └── 05-project-memory.md
├── scripts/
│   ├── Brewfile
│   ├── setup-tools.sh
│   ├── setup-opencode-commands.sh
│   ├── check-current-setup.sh
│   └── new-ai-app.sh
└── templates/
    ├── AGENTS.md
    ├── requirements.md
    ├── opencode.json
    ├── .env.example
    └── .ai/
        ├── specs/
        ├── prompts/
        ├── review/
        └── context/
```

## Standard-Tools

- Visual Studio Code
- GitHub Copilot Abo mit OpenCode `/connect`
- OpenCode
- gsd-build / get-shit-done
- SvelteKit + TypeScript + Tailwind + pnpm

## Arbeitsmodell

- Repo-first statt Chat-first
- kleine bis mittlere, reviewbare Änderungen
- klare Schritte vor maximaler Flexibilität
- Templates und Projektkontext im Repo halten
- AI assistiert, Mensch entscheidet und prüft

## Wann auf etwas „Advanced“ gewechselt werden sollte

Wechsle nicht wegen Neugier, sondern erst wenn das Vorhaben real braucht:

- mehrere Frameworks oder Plattformen gleichzeitig
- komplexe Build-/Release-Steuerung
- Runtime-Orchestrierung oder Policies
- umfassende Team-Automatisierung
- hochgradig autonome Agentenabläufe

Dann ist dieses Repo nicht zu klein, sondern bewusst nicht dafür gebaut.
