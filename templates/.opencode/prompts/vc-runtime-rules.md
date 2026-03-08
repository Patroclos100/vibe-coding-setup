# Shared Runtime Rules

This file is the runtime source of truth for every `.opencode/prompts/*` agent prompt.

## Required repository inputs
- `AGENTS.md`
- `.ai/contracts/output-schema.md`
- `.ai/contracts/runtime-output.schema.json`
- `.ai/contracts/state-management.md`
- `.ai/contracts/workflow-state.schema.json`
- `.ai/contracts/execution-policy.json`
- `.ai/contracts/transition-matrix.json`
- `.ai/contracts/failure-taxonomy.json`
- `.ai/contracts/agent-capabilities.json`
- `.ai/contracts/prompt-registry.json`
- active `.ai/stacks/*/stack.json`

## Non-negotiable runtime behavior
- Return exactly one JSON object that conforms to `.ai/contracts/runtime-output.schema.json`.
- Do not emit markdown or prose outside the JSON object.
- Treat `.ai/state/*.json` and `.ai/state/workflow-state.json` as the canonical state store.
- Load `.ai/state/execution-state.json` before deciding any next step.
- Use `.ai/contracts/execution-policy.json` as the policy authority for retry, replan, rollback, stop, escalation, and review.
- Agents may recommend, but only the policy layer may authorize state transition and next actor.
- Record every meaningful state change in `state_updates`.
- Prefer arrays and explicit IDs over narrative text.
- Use deterministic names, stable key ordering, and bounded scope.

## Decision gates
Apply these gates in order:
1. schema and state validity
2. rollback and safety
3. hard stop budget
4. escalation need
5. retry eligibility
6. replan need
7. continue or review

## JSON output reminders
- `status` must be one of `success`, `blocked`, `failed`, `needs_input`.
- `failure_class`, `severity`, and `progress_state` are mandatory.
- `recommended_action` must be one of `continue`, `retry`, `replan`, `rollback`, `stop`, `escalate`, `review`.
- `recommended_next_actor` must be concrete, for example `vc-debugger`.
- `requires_rollback` and `requires_human` must be explicit booleans.
- `validation.required_checks` must come from the active stack pack or plan state.
- `acceptance.criteria_ids` must list every in-scope criterion ID.
- `files.changed` must be empty until the agent actually modifies files.
- `next_action` must be imperative and concrete.
