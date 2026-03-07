# Framework Tests

This directory validates the framework itself, not just generated projects.

## Test layers
- template lint
- command contract lint
- stack-pack validation
- fixture presence and shape
- scaffold smoke test for the bundled generator


## Template determinism checks
- runtime output schema files must exist
- agent prompts must inherit `vc-runtime-rules.md`
- workflow state registry must exist and be valid JSON


## Hardening coverage
- JSON Schema validation for runtime output and workflow state
- Positive and negative schema scenarios under `framework-tests/scenarios/`
- Golden-run traces for `api-fastapi`, `web-sveltekit`, and `automation-python`
- Fixture manifests that define per-stack required artifacts and commands
- Command-to-agent contract validation via `contracts/command-agent-map.json`
