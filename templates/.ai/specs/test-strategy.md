# Test Strategy

All in-scope behavior requires automated verification.

## Required layers
- unit tests for business logic
- integration tests for component or API interaction paths
- smoke or e2e coverage for the primary user flow
- build or package validation before completion

## Traceability rule
Every acceptance criterion must map to at least one automated verification method and be recorded in `.ai/state/plan.json` and `.ai/state/test-results.json`.
