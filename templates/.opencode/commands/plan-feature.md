---
description: Produce a bounded implementation plan with acceptance traceability and exact checks
agent: vc-orchestrator
---

Load and apply in this order:
1. `AGENTS.md`
2. `.ai/contracts/output-schema.md`
3. `.ai/contracts/check-matrix.md`
4. `.ai/contracts/acceptance-traceability.md`
5. `.ai/workflows/feature-workflow.md`
6. active `.ai/stacks/*/stack.json`
7. invoke `vc-planner`, `vc-architecture-validator`, and `vc-dependency-manager`

Update these state files:
- `.ai/state/current-task.json`
- `.ai/state/plan.json`
- `.ai/state/risks.json`

Required plan content:
- one bounded increment
- allowed paths only
- candidate files only
- explicit acceptance criteria IDs
- mandatory checks copied from the active stack pack
- dependency decision

Do not implement code.
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
