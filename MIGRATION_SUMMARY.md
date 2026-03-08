# Migration Summary

## Structured migration outcome

The repository was migrated from prompt-described orchestration to runtime-enforced orchestration without replacing the repository wholesale.

## Added execution layer

- `templates/factory-runtime/` executable runtime package
- `templates/factory` wrapper entrypoint
- `templates/.ai/contracts/runtime-state-machine.json`
- `templates/.ai/contracts/quality-gates.json`
- `templates/.ai/contracts/agent-interface.schema.json`
- `templates/.ai/agents/interfaces/*.json`
- `templates/.ai/workflows/executable/*.workflow.json`
- `templates/.factory/registries/*.json`
- `.factory/runs` and `.factory/audit` scaffolding

## Runtime responsibilities now implemented

- workflow execution
- state validation
- retry/replan/escalation policy decisions
- quality gate execution
- artifact registry persistence
- run logging and auditability

## Preserved artifacts

Existing `.ai`, `.opencode`, stack packs, commands, contracts, and documentation were retained and extended.
