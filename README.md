# VibeCoding AI Factory

AI-first development framework for IT professionals without classical programming experience, evolved into a deterministic **AI Factory**.

This repository preserves the hardened VibeCoding runtime and extends it into a factory-level operating model with:
- factory orchestration across projects and modules
- blueprint-based product creation
- module registry and reuse rules
- release, deployment, and monitoring workflows
- governance, quality gates, and rollback criteria

## Core execution chain

`Command -> Workflow -> Agent Contract -> State Update -> Quality Gate -> Review -> Release`

## Factory execution chain

`Idea -> Intake -> Blueprint Selection -> Product Initialization -> Module Plan -> Build -> Test -> Review -> Release -> Deploy -> Monitor`

## Repository map

- `templates/` runtime payload copied into generated projects
- `templates/.ai/factory/` factory orchestration, governance, portfolio, and pipeline rules
- `templates/.ai/blueprints/` reusable product blueprints
- `templates/.ai/modules/` module registry, metadata model, reuse policy, and dependency rules
- `templates/.ai/projects/` project portfolio and initialization state
- `templates/.ai/releases/` release, deployment, and monitoring artifacts
- `templates/.opencode/commands/` deterministic runtime commands, now including factory/module/release commands
- `framework-tests/` assets that verify the framework itself
- `scripts/` setup, scaffolding, and validation tools
- `docs/` end-user and contributor documentation

## What was added in the AI Factory migration

### Existing runtime retained
- command-driven workflow execution
- machine-readable runtime state and execution policy
- stack-aware validation
- framework self-tests and smoke tests

### New factory capabilities
- multi-project factory orchestration
- blueprint catalog for standardized product creation
- module registry with dependency and reuse controls
- factory-level agent hierarchy
- quality gates with blocker/warning/manual-review classification
- release, deployment, and monitoring workflows
- project/release/state registries for deterministic traceability

## Runtime features vs framework-test features

### Runtime features
Runtime features are part of normal AI-assisted development and are expected to be used in every generated project.

Examples:
- `templates/.opencode/commands/*`
- `templates/.opencode/prompts/*`
- `templates/.ai/contracts/*`
- `templates/.ai/factory/*`
- `templates/.ai/blueprints/*`
- `templates/.ai/modules/*`
- `templates/.ai/projects/*`
- `templates/.ai/releases/*`
- `templates/.ai/state/*`
- `templates/.ai/stacks/*`

### Framework-test features
Framework-test features exist to verify that the framework itself remains correct. They are **not** part of the normal feature-development loop inside a generated project.

Examples:
- `framework-tests/*`
- `scripts/validate-framework.py`
- golden runs, negative scenarios, and fixture manifests

## Where to start

- Read `docs/quickstart.md` for first use
- Read `docs/architecture.md` for the system model
- Read `docs/design-decisions.md` for rationale behind JSON contracts and prompt separation
- Read `docs/09-ai-factory-overview.md` for the factory operating model
- Read `docs/runtime/overview.md` to understand the runtime flow
- Read `docs/framework-testing/overview.md` to understand framework self-verification

## Deterministic Factory Runtime

This repository now includes an executable runtime layer under `templates/factory-runtime/` and scaffolded runtime state under `templates/.factory/`.

The runtime is the execution authority for:
- workflow orchestration
- state transition enforcement
- policy evaluation
- quality gates
- run persistence
- audit logging

CLI examples:

```bash
python3 factory-runtime/cli.py status
python3 factory-runtime/cli.py run intake --project billing-app --request "Build a billing platform"
python3 factory-runtime/cli.py run build-module --project billing-app --module auth-service
python3 factory-runtime/cli.py run release --project billing-app --release-id v0.1.0
```

