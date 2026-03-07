---
description: Normalize a request into specs and state before implementation
agent: vc-orchestrator
---

!!! CRITICAL !!!
This command is for request normalization only.

Use this workflow exactly:
1. Load `AGENTS.md`
2. Load `.ai/prompts/intake-normalizer.md`
3. Load the relevant specs under `.ai/specs/`
4. Invoke `vc-planner`
5. Update:
   - `.ai/specs/product-spec.md`
   - `.ai/state/current-task.md`
   - `.ai/state/plan.md`
   - `.ai/state/risks.md`

Task request:
$ARGUMENTS

Required output in chat:
- normalized scope
- acceptance criteria
- assumptions
- likely files to change
- checks required before completion

!!! DO NOT IMPLEMENT CODE IN THIS COMMAND !!!
