# Acceptance Traceability Contract

Every bounded increment must map acceptance criteria to verification.

## Required fields per acceptance criterion
- `id`
- `description`
- `verification_method`
- `status`
- `covered_by`

## Allowed verification methods
- `lint`
- `typecheck`
- `unit`
- `integration`
- `e2e`
- `smoke`
- `build`
- `manual-proof-not-allowed`

## Rules
- New behavior requires at least one automated verification method.
- `manual-proof-not-allowed` may only appear to flag an invalid plan.
- `/review-release` must reject completion if any in-scope acceptance criterion remains `pending` or `manual-proof-not-allowed`.
