# Product Scope: VibeCoding Basic

## 1. Ziel

VibeCoding Basic ist eine eigenständige, bewusst einfache Produktstufe für AI-assistierte Web-Entwicklung.

Sie soll Nutzern helfen, Projekte sauber zu starten, AI-Arbeit klar zu führen, kleine Änderungen sicher zu machen und Projektwissen im Repository zu halten.

## 2. Primäre Zielgruppe

- IT-Fachleute
- Product Owner
- technische Projektleiter
- Prozess- und Fachspezialisten
- technisch versierte Nicht-Programmierer
- Einsteiger mit solider Tool-Affinität

## 3. Voraussetzungen

- macOS
- Terminal-Grundverständnis
- VS-Code-Nutzung
- Git-Grundlagen
- grobes Verständnis von Logs und Fehlermeldungen
- Bereitschaft, geführt und dokumentiert mit AI zu arbeiten

## 4. Enthalten

- Standard-Stack für Web-Projekte
- SvelteKit + TypeScript + Tailwind + pnpm
- Visual Studio Code + GitHub Copilot via OpenCode `/connect`
- klare OpenCode-Kommandos
- projektlokale Regeln und Projektkontext
- einfache Setup- und Bootstrap-Skripte
- nachvollziehbare Review- und Änderungslogik

## 5. Bewusst nicht enthalten

- Mobile-App-Build-Logik
- Store-Release-Flows
- Signing- oder Deployment-Komplexität
- Multi-Agent-Runtime
- Retry/Replan/Rollback-Policy-System
- komplexe Run-State-Verwaltung
- generische Plugin-Architektur
- Multi-Framework-Support
- autonome End-to-End-Planung ohne menschliche Prüfung

## 6. Leitprinzipien

- Einfachheit ist ein Feature.
- Repo-first vor Chat-first.
- Führung vor Freiheit.
- Kleine, reviewbare Änderungen vor großen Würfen.
- Lokal verständlich vor abstrakt-generisch.

## 7. Wann diese Basic Version gut passt

Sie passt gut, wenn:

- ein Web-Projekt sauber gestartet werden soll
- die Zielgruppe eine geführte Arbeitsweise braucht
- kleine bis mittlere Änderungen dominieren
- AI-Unterstützung gewünscht ist, aber keine autonome Plattform
- der Kontext im Repo stabil gepflegt werden soll

## 8. Wann ein Wechsel auf Advanced sinnvoll ist

Ein Wechsel ist sinnvoll, wenn das Vorhaben echte Zusatzkomplexität verlangt, etwa:

- mehrere Plattformen oder Frameworks parallel
- komplexe Release- oder Deployment-Automation
- technische Runtime-Orchestrierung
- ausgeprägte Team- und Governance-Anforderungen
- tiefe, systemische Agentensteuerung

## 9. Entscheidungsregel

Wenn eine Idee das Repo in Richtung Factory, Runtime, Agentenplattform oder Plattform-Abstraktion verschiebt, ist sie für VibeCoding Basic in der Regel falsch und soll durch eine einfachere repo-zentrierte Lösung ersetzt werden.
