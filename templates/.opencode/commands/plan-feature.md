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
