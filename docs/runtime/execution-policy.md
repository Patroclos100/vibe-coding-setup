# Execution Policy Engine

The execution policy engine is the deterministic runtime authority of the framework.

## Core artifacts
- `templates/.ai/contracts/execution-policy.json`
- `templates/.ai/contracts/transition-matrix.json`
- `templates/.ai/contracts/failure-taxonomy.json`
- `templates/.ai/contracts/agent-capabilities.json`
- `templates/.ai/state/execution-state.json`
- `templates/.ai/state/execution-ledger.json`
- `templates/.ai/state/checkpoints.json`

## Rules
- Commands propose intent; policy authorizes transitions.
- Agents recommend; policy authorizes.
- Retries are bounded by normalized failure class and severity.
- Replans happen after retry exhaustion or plan-invalidating failure.
- Rollback requires a known-good checkpoint.
- Stop and escalation are first-class outcomes.
