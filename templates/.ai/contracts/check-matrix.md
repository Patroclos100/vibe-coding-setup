# Check Matrix Contract

Every implementation command must load the active stack pack from `.ai/stacks/<stack-id>/` and execute the mandatory checks defined there.

## Required rules
- No implementation step may finish with `checks not run` unless the current command is `/intake` or `/plan-feature`.
- The active stack must be recorded in `.ai/state/current-task.json`.
- Mandatory checks must be copied into `.ai/state/plan.json` before implementation begins.
- `vc-debugger` may run targeted checks first, but final completion requires the full mandatory check set.

## Standard check categories
1. format / lint
2. typecheck or static validation
3. unit tests
4. integration tests where applicable
5. e2e or smoke tests where applicable
6. build / package validation

## Completion rule
A task may be marked complete only when all mandatory checks for the active stack are recorded as `passed` in `.ai/state/test-results.json`.
