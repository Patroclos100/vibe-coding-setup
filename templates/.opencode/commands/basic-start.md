---
description: Guided entrypoint for first-time users. Use this before trying advanced commands.
agent: vc-orchestrator
---

Read only:
- `START-HERE.md`
- `docs/basic-mode.md`
- `AGENTS.md`
- `requirements.md`
- `.ai/state/current-task.json`
- `.ai/state/plan.json`

Then do exactly this:
1. Explain the current project state in simple language.
2. Tell the user whether the next correct step is `/intake`, `/plan-feature`, `/build-small`, `/fix`, or `/review-release`.
3. If requirements are too vague, recommend `/intake`.
4. If the task is too large, explicitly say so.
5. Do not implement code in this command.

Return exactly one JSON object that conforms to `.ai/contracts/runtime-output.schema.json`.
