# Runtime Output Contract

All runtime commands and all runtime agents must return exactly one JSON object and no surrounding prose.
Markdown headings, bullet lists, fenced code blocks, and narrative text outside the JSON object are forbidden.

## Required top-level schema

```json
{
  "schema_version": "1.0",
  "agent": "vc-planner",
  "command": "/plan-feature",
  "status": "success",
  "current_scope": {
    "summary": "Implement one bounded increment",
    "in_scope": [],
    "out_of_scope": []
  },
  "inputs_used": {
    "contracts": [],
    "specs": [],
    "state_files": [],
    "stack": "sveltekit-web"
  },
  "files": {
    "to_change": [],
    "changed": []
  },
  "acceptance": {
    "criteria_ids": [],
    "coverage": []
  },
  "risks": {
    "assumptions": [],
    "open": []
  },
  "validation": {
    "required_checks": [],
    "executed_checks": [],
    "results": []
  },
  "state_updates": [],
  "remaining_out_of_scope": [],
  "next_action": "Run /build-small"
}
```

## Field rules
- `schema_version`: required, currently `1.0`.
- `agent`: required runtime actor name.
- `command`: required command name, or `subagent` for internal agent-only outputs.
- `status`: one of `success`, `blocked`, `failed`, `needs_input`.
- `current_scope`: required object.
- `inputs_used`: required object with exact repository sources used.
- `files`: required object. Use empty arrays when nothing changes.
- `acceptance`: required object. Every in-scope criterion must be identified by ID.
- `risks`: required object.
- `validation`: required object.
- `state_updates`: required array of updated JSON files.
- `remaining_out_of_scope`: required array.
- `next_action`: required string.

## Determinism rules
- Use stable keys in the exact order shown above.
- Use arrays instead of prose paragraphs where possible.
- Do not invent fields outside the schema unless a stack pack explicitly extends it.
- If a value is unknown, use an empty array, empty object, or explicit string such as `"unknown"`. Never omit required keys.

## Validation rule
The runtime layer in `.opencode/commands/*` and `.opencode/prompts/*` must explicitly require JSON-only output that conforms to this contract.


## Hard validation rules
- The chat response is invalid unless it is a single JSON object that validates against `.ai/contracts/runtime-output.schema.json`.
- `agent` must be the active runtime agent id, for example `vc-planner`.
- `command` must be the invoked slash command, for example `/plan-feature`.
- `acceptance.coverage[*].status` is mandatory and must be one of `planned`, `covered`, `passed`, `failed`.
- `risks.open[*]` entries must include `id`, `severity`, `status`, and `summary`.
- `validation.results[*]` entries must include `check_id`, `status`, and `details`.
