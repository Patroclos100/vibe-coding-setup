---
description: Split large work into phases, then execute phase 1 only with bounded checks
agent: vc-orchestrator
---

Use `vc-planner` to split the request into phases.
Only phase 1 may be implemented in this command unless the user explicitly requests more.

Required artifacts:
- `.ai/state/current-task.json`
- `.ai/state/plan.json`
- `.ai/state/risks.json`
- `.ai/state/changed-files.json`
- `.ai/state/test-results.json`

Mandatory flow:
1. plan phases
2. validate architecture and dependency impact
3. implement phase 1 only
4. generate tests
5. run active-stack mandatory checks
6. debug and repair if needed

Output must follow the Output Schema Contract.


Runtime output rule:
- Return exactly one JSON object that conforms to `.ai/contracts/runtime-output.schema.json`.
- Do not add markdown, narrative, or commentary outside the JSON object.


Execution policy gate:
- Load `.ai/contracts/execution-policy.json`, `.ai/contracts/transition-matrix.json`, `.ai/contracts/failure-taxonomy.json`, `.ai/contracts/agent-capabilities.json`.
- Load `.ai/state/execution-state.json`, `.ai/state/execution-ledger.json`, `.ai/state/checkpoints.json`, `.ai/state/workflow-state.json`.
- Commands declare intent only. The execution policy authorizes the next action and next actor.
- Update `.ai/state/execution-state.json`, `.ai/state/execution-ledger.json`, and `.ai/state/workflow-state.json` whenever a state transition, retry, replan, rollback, stop, or escalation occurs.
- Populate `failure_class`, `severity`, `progress_state`, `recommended_action`, `recommended_next_actor`, `requires_rollback`, and `requires_human` in the runtime output.
