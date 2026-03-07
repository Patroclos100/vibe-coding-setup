---
description: Implement exactly one bounded increment with tests and validation
agent: vc-orchestrator
---

Load and apply in this order:
1. `AGENTS.md`
2. `.ai/contracts/output-schema.md`
3. `.ai/contracts/check-matrix.md`
4. `.ai/contracts/acceptance-traceability.md`
5. `.ai/workflows/feature-workflow.md`
6. active `.ai/stacks/*/stack.json`
7. invoke `vc-code-generator`, `vc-test-generator`, `vc-architecture-validator`
8. run mandatory checks from `.ai/state/plan.json`
9. if checks fail, invoke `vc-debugger`
10. if structural violations remain, invoke `vc-refactorer`

Update:
- `.ai/state/changed-files.json`
- `.ai/state/test-results.json`
- `.ai/state/debug-log.json` when failures occur
- `.ai/review/architectural-debt.md` when debt remains

Rules:
- one increment only
- no broad rewrite
- no unapproved dependencies
- no completion without passed mandatory checks

Output must follow the Output Schema Contract.


Runtime output rule:
- Return exactly one JSON object that conforms to `.ai/contracts/runtime-output.schema.json`.
- Do not add markdown, narrative, or commentary outside the JSON object.
