---
description: Reproduce, classify, minimally repair, and regression-protect a defect
agent: vc-orchestrator
---

!!! BUGFIX WORKFLOW !!!

Use this exact sequence:
1. Load `AGENTS.md`
2. Load `.ai/workflows/bugfix-workflow.md`
3. Invoke `vc-planner` to bound the bugfix scope
4. Invoke `vc-debugger`
5. If missing, add a regression test via `vc-test-generator`
6. Re-run relevant checks
7. Update `.ai/state/debug-log.md`, `.ai/state/test-results.md`, `.ai/state/changed-files.md`

Bug or failure:
$ARGUMENTS

Required chat output:
- defect class
- root cause
- minimal fix applied
- regression protection added or why not
- check results

!!! DO NOT MIX BUGFIXING WITH UNRELATED REFACTORING !!!
