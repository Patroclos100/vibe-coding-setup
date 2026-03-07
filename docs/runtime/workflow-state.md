# Workflow State

Canonical runtime state lives under `templates/.ai/state/`.

## Canonical JSON files

- `current-task.json`
- `plan.json`
- `risks.json`
- `changed-files.json`
- `test-results.json`
- `debug-log.json`
- `workflow-state.json`

## Aggregate registry

`workflow-state.json` is the aggregate registry. It summarizes the major state domains in one machine-readable object.

## Why both individual files and aggregate state exist

The individual files make focused updates easier. The aggregate file makes consistency checks and schema validation easier.

## Main state domains

### Task
Tracks current command, stack, workflow, scope, acceptance IDs, and next action.

### Plan
Tracks bounded increment, allowed paths, candidate files, mandatory checks, dependencies, and retry budget.

### Risks
Tracks open, mitigated, or blocked risks.

### Changed files
Tracks file-level impact.

### Test results
Tracks check outcomes and summary counts.

### Debug log
Tracks repair history and retry counters.

## Markdown summaries

Markdown files with matching names are retained for human readability. They are not the canonical runtime source of truth.
