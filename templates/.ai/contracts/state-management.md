# State Management Contract

State must be machine-readable first and human-readable second.

## Required state files
- `.ai/state/current-task.json`
- `.ai/state/plan.json`
- `.ai/state/risks.json`
- `.ai/state/changed-files.json`
- `.ai/state/test-results.json`
- `.ai/state/debug-log.json`
- `.ai/state/workflow-state.json`

Optional human summaries may exist as `.md` files, but JSON is the source of truth.

## Global rules
- Every meaningful workflow step updates at least one JSON state file.
- Free-form notes are allowed only in `notes` fields, never as the only state representation.
- Retries must be counted by error class and total retries must be visible in state.
- Every risk needs an `id`, `severity`, `status`, `owner`, and `mitigation`.
- Every changed file entry needs a reason, change type, and linked acceptance criteria IDs.
- Every check result needs a deterministic status, command, and timestamp.
- `workflow-state.json` is the aggregated registry for orchestration and must mirror the latest content of the individual state files.

## Status model
Allowed task statuses:
- `pending`
- `planned`
- `in_progress`
- `blocked`
- `validating`
- `done`

Allowed risk statuses:
- `open`
- `mitigated`
- `accepted`
- `closed`

Allowed check statuses:
- `pending`
- `passed`
- `failed`
- `skipped`

## Validation rule
All state JSON must conform to `.ai/contracts/workflow-state.schema.json` and the file-specific examples in `.ai/state/*.json`.


## Schema validation rules
- Every write to `.ai/state/*.json` and `.ai/state/workflow-state.json` must remain valid against `.ai/contracts/workflow-state.schema.json` when the aggregated state is reconstructed.
- Runtime chat output must remain valid against `.ai/contracts/runtime-output.schema.json`.
- State drift is a failure condition. Never invent alternate keys, free-form status values, or ad-hoc retry buckets.
- Update `changed_files.count` to match the number of unique entries in `changed_files.paths`.
- Keep `debug_log.retry_counters.total` greater than or equal to every individual retry bucket.
