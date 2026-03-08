---
description: Perform an evidence-based, behavior-preserving refactor only
agent: vc-orchestrator
---

Refactor is allowed only when at least one evidence condition is true:
- duplication exists in 2 or more places
- an architecture rule is violated
- a module is oversized or ambiguous
- test fragility is caused by structure

Required flow:
1. load `.ai/contracts/output-schema.md`
2. load `.ai/workflows/refactor-workflow.md`
3. invoke `vc-architecture-validator` then `vc-refactorer`
4. rerun the full mandatory check set for the active stack
5. update `.ai/state/changed-files.json`, `.ai/state/test-results.json`, `.ai/review/architectural-debt.md`

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
