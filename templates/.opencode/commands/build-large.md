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
