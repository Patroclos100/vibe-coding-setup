# State Directory

JSON files in this directory are the canonical state store.

## Canonical files
- `current-task.json`: task-level execution state
- `plan.json`: bounded increment plan and acceptance criteria
- `risks.json`: tracked risks and mitigations
- `changed-files.json`: machine-readable change ledger
- `test-results.json`: executed and required check results
- `debug-log.json`: failure classification and retries
- `workflow-state.json`: aggregated orchestration registry

Markdown files may exist as human summaries, but commands and agents must treat the JSON files as the source of truth.
