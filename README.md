# VibeCoding Framework

AI-first development framework for IT professionals without classical programming experience.

This version upgrades the framework from prompt-only guidance to a more enforceable system with:
- machine-readable JSON state
- active stack packs with mandatory checks
- acceptance-traceability contracts
- framework-level validation and smoke tests
- runtime prompt layer separated from design references

## Core execution chain

`Command -> Workflow -> Agent Contract -> Checks -> Review`

## What changed in this version
- `.ai/state/*.json` is now the canonical state store.
- `.ai/stacks/*/stack.json` defines stack-specific validation commands.
- `.opencode/commands/*` explicitly enforce the Output Schema Contract.
- `scripts/validate-framework.py` validates the framework itself.
- `framework-tests/` contains fixture scenarios and contract expectations.

## Key directories
- `templates/` project template payload copied into new projects
- `framework-tests/` framework regression assets
- `scripts/` setup, scaffolding, and validation scripts
- `docs/` usage and architecture notes
