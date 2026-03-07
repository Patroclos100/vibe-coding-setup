# Validator

The main validator is `scripts/validate-framework.py`.

## Purpose

It performs repository-level verification that the framework remains consistent after changes.

## Current responsibilities
- validate required template presence
- validate command and prompt presence
- validate stack pack structure
- validate JSON scenario files against schemas
- validate command-agent contract assets
- validate fixture manifests and golden-run traces
- run a scaffold smoke test

## When to run it

Run it after any framework change, especially changes to templates, schemas, prompts, commands, or stacks.

```bash
python3 scripts/validate-framework.py
```
