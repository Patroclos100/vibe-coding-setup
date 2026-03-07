# SvelteKit Web Stack Pack

Use this stack for UI-heavy web applications.

## Deterministic defaults
- `src/lib/features/<feature>/` for feature code
- `src/lib/domain/` for core entities and shared domain logic
- `src/lib/components/` for reusable UI primitives
- `tests/unit`, `tests/integration`, `tests/e2e` for automated checks

## Command expectations
- New feature work starts with `/intake` then `/plan-feature`.
- `/build-small` must target one increment only.
- Tailwind and shadcn are optional, never assumed unless the requirements ask for them.
