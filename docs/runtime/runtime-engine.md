# Runtime Engine

The repository now contains an executable runtime layer under `templates/factory-runtime/`.

## Modules

- `runtime.py` — top-level runtime façade
- `workflow_executor.py` — deterministic workflow runner
- `policy_engine.py` — machine-evaluable retry, rollback, replan, and escalation logic
- `state_machine.py` — finite state machine enforcement
- `agent_router.py` — agent/action dispatch
- `artifact_registry.py` — project/module/release/build registry persistence
- `run_store.py` — run persistence
- `audit_logger.py` — append-only audit trail
- `quality_gate_engine.py` — executable quality gates
- `cli.py` — command-line entrypoint

## Project-local runtime files

Scaffolded projects now include:

- `.factory/registries/*`
- `.factory/runs/*`
- `.factory/audit/audit-log.jsonl`
- `.ai/workflows/executable/*.workflow.json`
- `.ai/agents/interfaces/*.json`
