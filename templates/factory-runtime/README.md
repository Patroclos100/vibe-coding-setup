# Factory Runtime

This runtime is the deterministic execution layer of the AI Software Factory.

It is responsible for:
- workflow execution
- state transition validation
- policy evaluation
- agent routing
- artifact registry updates
- run persistence
- audit logging
- quality gate enforcement
- retry, rollback, and escalation decisions

## CLI examples

```bash
python3 factory-runtime/cli.py status
python3 factory-runtime/cli.py run intake --project billing-app --request "Build a billing platform"
python3 factory-runtime/cli.py run build-module --project billing-app --module auth-service
python3 factory-runtime/cli.py run release --project billing-app --release-id v0.1.0
python3 factory-runtime/cli.py resume <run-id>
```
