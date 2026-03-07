---
description: Perform an evidence-based, behavior-preserving refactor
agent: vc-orchestrator
---

!!! SAFE REFACTOR ONLY !!!

Use this exact sequence:
1. Load `AGENTS.md`
2. Load `.ai/workflows/refactor-workflow.md`
3. Bound the refactor scope with `vc-planner`
4. Validate the reason for refactor with `vc-architecture-validator`
5. Invoke `vc-refactorer`
6. Run relevant checks
7. Update `.ai/review/architectural-debt.md` and `.ai/state/changed-files.md`

Refactor target:
$ARGUMENTS

Required chat output:
- evidence for refactor
- files changed
- behavior preserved
- checks run and results
- remaining debt

!!! NO STYLE-ONLY CHURN !!!
