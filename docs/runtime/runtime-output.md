# Runtime Output Contract

The runtime output contract is defined by:
- `templates/.ai/contracts/output-schema.md`
- `templates/.ai/contracts/runtime-output.schema.json`
- `templates/.ai/contracts/runtime-output.example.json`

## Purpose

Every runtime agent must return exactly one JSON object so that:
- the output can be validated automatically
- orchestrators can parse the result deterministically
- state updates are explicit instead of implied

## Important fields

### Identity and context
- `schema_version`
- `agent`
- `command`
- `status`

### Scope
- `current_scope.summary`
- `current_scope.in_scope`
- `current_scope.out_of_scope`

### Inputs used
- `inputs_used.contracts`
- `inputs_used.specs`
- `inputs_used.state_files`
- `inputs_used.stack`

### Output traceability
- `files`
- `acceptance`
- `risks`
- `validation`
- `state_updates`
- `remaining_out_of_scope`
- `next_action`

## Why JSON-only output is enforced

Mixed markdown and prose are easy for humans but weak for deterministic automation. The single-JSON-object rule is a deliberate runtime design decision, not a stylistic preference.

## When this contract applies

This contract applies to runtime agents and runtime commands. It does **not** mean that the framework documentation or framework tests must also output JSON.
