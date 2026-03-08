---
description: Reproduce, classify, minimally repair, and rerun checks
agent: vc-orchestrator
---

Use this order:
1. Load `.ai/state/test-results.json`, `.ai/state/debug-log.json`, `.ai/state/plan.json`
2. Load `.ai/contracts/output-schema.md` and `.ai/contracts/check-matrix.md`
3. Invoke `vc-debugger`
4. Apply the smallest valid repair
5. Rerun targeted checks first, then rerun the full mandatory check set
6. Update `.ai/state/debug-log.json`, `.ai/state/test-results.json`, `.ai/state/changed-files.json`

Rules:
- classify the failure before editing
- add or preserve regression coverage for logic bugs
- do not weaken tests to force green output

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
