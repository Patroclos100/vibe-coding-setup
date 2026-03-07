# Shared Runtime Rules

This file is the runtime source of truth for every `.opencode/prompts/*` agent prompt.

## Required repository inputs
- `AGENTS.md`
- `.ai/contracts/output-schema.md`
- `.ai/contracts/runtime-output.schema.json`
- `.ai/contracts/state-management.md`
- `.ai/contracts/workflow-state.schema.json`
- `.ai/contracts/prompt-registry.json`
- active `.ai/stacks/*/stack.json`

## Non-negotiable runtime behavior
- Return exactly one JSON object that conforms to `.ai/contracts/runtime-output.schema.json`.
- Do not emit markdown or prose outside the JSON object.
- Treat `.ai/state/*.json` and `.ai/state/workflow-state.json` as the canonical state store.
- Prefer arrays and explicit IDs over narrative text.
- Record every meaningful state change in `state_updates`.
- Escalate explicit spec or policy conflicts instead of improvising around them.
- Use deterministic names, stable key ordering, and bounded scope.

## JSON output reminders
- `status` must be one of `success`, `blocked`, `failed`, `needs_input`.
- `validation.required_checks` must come from the active stack pack or plan state.
- `acceptance.criteria_ids` must list every in-scope criterion ID.
- `files.changed` must be empty until the agent actually modifies files.
- `next_action` must be imperative and concrete.
