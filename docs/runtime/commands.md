# Runtime Commands

The command layer is under `templates/.opencode/commands/`.

## Command list

### `/intake`
Purpose: normalize a user request into an implementation-ready task.

### `/plan-feature`
Purpose: create a bounded plan, select relevant workflow details, and define mandatory validation expectations.

### `/build-small`
Purpose: implement the smallest complete increment that delivers value.

### `/build-large`
Purpose: implement a larger bounded increment when `/build-small` is insufficient.

### `/fix`
Purpose: repair a failing implementation using the smallest correct change.

### `/refactor-safe`
Purpose: perform evidence-based structural improvement without changing behavior.

### `/review-release`
Purpose: verify that done criteria, acceptance linkage, and validation evidence are adequate.

### `/status`
Purpose: summarize current runtime state and next action.

## Command behavior rules

Every runtime command is expected to:
- read the relevant contracts and state
- obey the active stack pack
- return exactly one JSON object
- record intended state updates
- avoid narrative output outside the JSON contract

## Current command-to-agent contract

The framework-test layer currently expects each runtime command to be handled by `vc-orchestrator`, which coordinates specialized subagents.
That mapping is recorded in `framework-tests/contracts/command-agent-map.json`.
