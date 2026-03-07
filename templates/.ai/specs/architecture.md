# Architecture Specification

## Default structure for web applications
- `src/lib/features/<feature>/` for feature-isolated application logic
- `src/lib/domain/` for shared domain entities and rules
- `src/lib/components/` for reusable UI elements
- `src/lib/services/` for integration-oriented services
- `src/lib/utils/` for small stateless helpers
- `src/routes/` for route composition only

## Rules
- Keep route files thin.
- Keep domain logic out of route files and UI components.
- Prefer feature isolation over giant shared folders.
- Shared code must prove reuse across multiple features.
- Infrastructure and configuration code must stay separate from domain logic.
