---
description: Split a large request into phases, then execute phase 1 only unless otherwise specified
agent: vc-orchestrator
---

!!! LARGE WORK MUST BE PHASED !!!

Use this exact sequence:
1. Load `AGENTS.md`
2. Load `.ai/workflows/feature-workflow.md`
3. Invoke `vc-planner`
4. Split the request into phases
5. Validate the full phased plan with `vc-architecture-validator`
6. Review dependencies with `vc-dependency-manager` if needed
7. Execute phase 1 only using the same sequence as `/build-small`
8. Update plan and risks to reflect remaining phases

Large request:
$ARGUMENTS

Required chat output:
- phase breakdown
- why phase 1 was selected
- what phase 1 implemented
- checks run and results
- remaining phases

!!! DO NOT ATTEMPT A WHOLE-PROJECT REWRITE IN ONE PASS !!!
