---
description: Implement one bounded increment with validation, tests, and debug loop
agent: vc-orchestrator
---

!!! CRITICAL WORKFLOW !!!
You must implement only one bounded increment.

Use this exact sequence:
1. Load `AGENTS.md`
2. Load `.ai/workflows/feature-workflow.md`
3. Read `.ai/state/plan.md`
4. Invoke `vc-architecture-validator`
5. If dependencies are needed, invoke `vc-dependency-manager`
6. Invoke `vc-code-generator`
7. Invoke `vc-test-generator`
8. Run relevant checks
9. If checks fail, invoke `vc-debugger`
10. If structure violations remain, invoke `vc-refactorer`
11. Update:
    - `.ai/state/changed-files.md`
    - `.ai/state/test-results.md`
    - `.ai/state/risks.md`

Task:
$ARGUMENTS

Required constraints:
- keep scope bounded
- do not skip tests
- do not skip architecture validation
- maximum 3 debug repair attempts per error class

Required chat output:
- what was implemented now
- changed files
- checks run and results
- remaining risks
- what remains out of scope
