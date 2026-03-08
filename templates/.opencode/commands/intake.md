---
description: Normalize a request into specs and machine-readable state before implementation
agent: vc-orchestrator
---

!!! CRITICAL !!!
This command is for request normalization only.

Use this workflow exactly:
1. Load `AGENTS.md`
2. Load `.ai/contracts/output-schema.md`, `.ai/contracts/state-management.md`, `.ai/contracts/acceptance-traceability.md`
3. Load the relevant specs under `.ai/specs/`
4. Load the active stack pack under `.ai/stacks/`
5. Invoke `vc-planner`
6. Update:
   - `.ai/specs/product-spec.md`
   - `.ai/state/current-task.json`
   - `.ai/state/plan.json`
   - `.ai/state/risks.json`

Task request:
$ARGUMENTS

Required output in chat:
- normalized scope
- acceptance criteria with IDs
- assumptions
- likely files to change
- checks required before completion
- next action

Output must follow the Output Schema Contract.

!!! DO NOT IMPLEMENT CODE IN THIS COMMAND !!!


Runtime output rule:
- Return exactly one JSON object that conforms to `.ai/contracts/runtime-output.schema.json`.
- Do not add markdown, narrative, or commentary outside the JSON object.


Execution policy gate:
- Load `.ai/contracts/execution-policy.json`, `.ai/contracts/transition-matrix.json`, `.ai/contracts/failure-taxonomy.json`, `.ai/contracts/agent-capabilities.json`.
- Load `.ai/state/execution-state.json`, `.ai/state/execution-ledger.json`, `.ai/state/checkpoints.json`, `.ai/state/workflow-state.json`.
- Commands declare intent only. The execution policy authorizes the next action and next actor.
- Update `.ai/state/execution-state.json`, `.ai/state/execution-ledger.json`, and `.ai/state/workflow-state.json` whenever a state transition, retry, replan, rollback, stop, or escalation occurs.
- Populate `failure_class`, `severity`, `progress_state`, `recommended_action`, `recommended_next_actor`, `requires_rollback`, and `requires_human` in the runtime output.
