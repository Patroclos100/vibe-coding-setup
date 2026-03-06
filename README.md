# VibeCoding Framework

A reproducible macOS setup for AI-first app development with:

- Visual Studio Code
- GitHub Copilot Pro+
- OpenCode via `/connect`
- Get Shit Done (GSD)
- SvelteKit + TypeScript + Tailwind + pnpm

This repository bundles the full setup, operational scripts, project templates, and usage documentation in one place.

## Target audience

This framework is designed for IT professionals with limited or no programming experience who want a controlled, production-oriented AI development workflow.

## Architecture at a glance

- **VS Code** = editor and terminal
- **Copilot Pro+** = model access and IDE assistance
- **OpenCode** = agentic execution layer
- **GSD** = spec-driven process layer
- **Project templates** = deterministic starting point for every app

## Repository structure

```text
.
├── README.md
├── docs/
│   ├── 01-setup-and-operations.md
│   └── 02-usage-playbook.md
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
        │   ├── architecture.md
        │   └── ui-rules.md
        ├── prompts/
        │   ├── feature-small.md
        │   ├── feature-large.md
        │   └── refactor.md
        └── review/
            └── release-checklist.md
```

## Installation order

1. Read `docs/01-setup-and-operations.md`
2. Run `scripts/setup-tools.sh`
3. Run `scripts/setup-opencode-commands.sh`
4. Validate with `scripts/check-current-setup.sh`
5. Create a new project with `scripts/new-ai-app.sh`

## Quickstart

```bash
cd scripts
chmod +x setup-tools.sh setup-opencode-commands.sh check-current-setup.sh new-ai-app.sh
./setup-tools.sh
./setup-opencode-commands.sh
./check-current-setup.sh
./new-ai-app.sh my-app ~/dev --minimal
```

Then inside the created project:

```bash
cd ~/dev/my-app
pnpm dev
opencode
```

In OpenCode:

```text
/connect
```

Choose **GitHub Copilot**.

## Golden path for every project

1. Fill `requirements.md`
2. Review `.ai/specs/architecture.md`
3. Review `.ai/specs/ui-rules.md`
4. Start OpenCode and run `/plan`
5. Use `/build-small`
6. Run `/review`
7. Only use `/build-large` for larger, already-understood changes

## Design principles

- Correctness over speed
- Small, reviewable increments
- Minimal tool count
- Project-local guardrails
- No hidden magic

## Important operational notes

- Copilot is the default model provider via OpenCode `/connect`
- A separate Claude API key is **not** required for the baseline workflow
- `opencode.json` is stored **per project** for reproducibility
- GSD is recommended for larger feature work, not for every tiny change

## Hand-off intent

This repository is meant to be cloned and handed to additional team members as the single source of truth for setup, scripts, templates, and operating model.
