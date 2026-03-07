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
