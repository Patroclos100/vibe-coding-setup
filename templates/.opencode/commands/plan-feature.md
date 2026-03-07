---
description: Produce a bounded implementation plan without editing product code
agent: vc-orchestrator
---

!!! PLAN FIRST !!!

Use this sequence:
1. Load `AGENTS.md`
2. Load `.ai/workflows/feature-workflow.md`
3. Invoke `vc-planner`
4. Invoke `vc-architecture-validator`
5. If a package may be needed, invoke `vc-dependency-manager`
6. Update `.ai/state/plan.md`, `.ai/state/current-task.md`, `.ai/state/risks.md`

Feature request:
$ARGUMENTS

Required chat output:
- scope for the next increment only
- acceptance criteria for the next increment only
- files likely to change
- dependencies needed or not needed
- checks that will be run later

!!! DO NOT WRITE PRODUCT CODE !!!
