---
description: Run the final architecture and release gate for the current increment
agent: vc-orchestrator
---

!!! FINAL QUALITY GATE !!!

Use this exact sequence:
1. Load `AGENTS.md`
2. Load `.ai/workflows/release-workflow.md`
3. Invoke `vc-architecture-validator`
4. Invoke `vc-release-reviewer`
5. If structural issues remain, invoke `vc-refactorer` for the minimal necessary correction
6. Re-run relevant checks
7. Update `.ai/review/release-checklist.md`

Review focus:
$ARGUMENTS

Required chat output:
- release gate result: pass, warn, or fail
- architecture concerns
- open risks
- required next actions, if any

!!! DO NOT CLAIM RELEASE-READY WITHOUT CHECK EVIDENCE !!!
