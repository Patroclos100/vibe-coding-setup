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
