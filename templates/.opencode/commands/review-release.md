---
description: Run the final release gate with acceptance traceability and stack checks
agent: vc-orchestrator
---

Required flow:
1. load `AGENTS.md`
2. load `.ai/contracts/output-schema.md`, `.ai/contracts/check-matrix.md`, `.ai/contracts/acceptance-traceability.md`
3. load `.ai/review/release-checklist.md`
4. inspect `.ai/state/current-task.json`, `.ai/state/plan.json`, `.ai/state/test-results.json`, `.ai/state/changed-files.json`, `.ai/state/risks.json`
5. invoke `vc-release-reviewer`

Reject completion when any of the following is true:
- mandatory checks are missing or failed
- in-scope acceptance criteria are not traced to automation
- blocking risks remain open
- architecture violations are unresolved

Output must follow the Output Schema Contract.


Runtime output rule:
- Return exactly one JSON object that conforms to `.ai/contracts/runtime-output.schema.json`.
- Do not add markdown, narrative, or commentary outside the JSON object.
