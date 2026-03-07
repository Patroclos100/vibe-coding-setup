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
