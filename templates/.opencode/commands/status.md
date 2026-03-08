---
description: Summarize current machine-readable state for the active task
agent: vc-orchestrator
---

Read only:
- `.ai/state/current-task.json`
- `.ai/state/plan.json`
- `.ai/state/risks.json`
- `.ai/state/changed-files.json`
- `.ai/state/test-results.json`
- `.ai/state/debug-log.json`

Output must follow the Output Schema Contract and include:
- current task status
- active stack
- mandatory checks summary
- changed files summary
- blockers and next action


Runtime output rule:
- Return exactly one JSON object that conforms to `.ai/contracts/runtime-output.schema.json`.
- Do not add markdown, narrative, or commentary outside the JSON object.


Execution policy gate:
- Load `.ai/contracts/execution-policy.json`, `.ai/contracts/transition-matrix.json`, `.ai/contracts/failure-taxonomy.json`, `.ai/contracts/agent-capabilities.json`.
- Load `.ai/state/execution-state.json`, `.ai/state/execution-ledger.json`, `.ai/state/checkpoints.json`, `.ai/state/workflow-state.json`.
- Commands declare intent only. The execution policy authorizes the next action and next actor.
- Update `.ai/state/execution-state.json`, `.ai/state/execution-ledger.json`, and `.ai/state/workflow-state.json` whenever a state transition, retry, replan, rollback, stop, or escalation occurs.
- Populate `failure_class`, `severity`, `progress_state`, `recommended_action`, `recommended_next_actor`, `requires_rollback`, and `requires_human` in the runtime output.
