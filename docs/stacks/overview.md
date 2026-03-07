# Stack Packs Overview

Stack packs define stack-specific validation requirements for runtime execution.

## Supported stacks
- `sveltekit-web`
- `fastapi-api`
- `python-automation`

## What a stack pack contains
- `README.md` with stack notes
- `stack.json` with runtime, framework, and mandatory checks

## Why stack packs exist

A single generic validation policy is too weak. Web apps, APIs, and automation scripts need different mandatory checks.

## Runtime rule

The active stack pack supplies the mandatory checks that the runtime output contract must report under validation.
