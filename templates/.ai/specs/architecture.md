# Architecture

## Target Principles
- Keep project structure simple and predictable.
- Separate UI, application logic, and domain logic.
- Keep side effects at boundaries.
- Prefer composition over framework-heavy abstraction.
- Prefer one clear path over optional patterns.

## Recommended Layers
- `app/` or routing layer: page orchestration only
- `components/`: reusable UI elements
- `features/<feature>/`: feature-specific flows and glue
- `lib/`: shared utilities, integrations, pure helpers
- `domain/`: business rules and core data transformations
- `tests/` or colocated tests: behavior verification

## Rules
1. UI components must not contain hidden business rules.
2. Domain logic must not import UI modules.
3. External integrations must be wrapped behind small adapter functions.
4. State management should stay local until proven shared.
5. Shared abstractions are allowed only after a second proven reuse case.
6. New folders require explicit justification.
7. Prefer deterministic naming:
   - noun for entities
   - verbNoun for actions
   - `<feature>-service` only for actual service logic

## Placement Guide
- pure calculations -> `domain/` or `lib/`
- API wrappers -> `lib/integrations/`
- page orchestration -> `app/` or route file
- feature workflows -> `features/<feature>/`
