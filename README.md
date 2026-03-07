# VibeCoding Framework

AI-first development framework for IT professionals without classical programming experience.

This repository is the hardened version of the framework described and iteratively improved in the implementation work packages. It is designed to move from a prompt-led setup to an **AI development runtime framework** with explicit contracts, structured workflow state, stack-aware validation, and framework-level self-tests.

## What this framework does

The framework defines how AI coding agents should:

- normalize a request into a bounded implementation task
- choose the correct workflow
- write and update structured runtime state
- generate code and tests within a controlled scope
- run mandatory validation checks from the active stack pack
- repair failures through a bounded self-healing loop
- perform release review before work is considered done

## What changed across the hardening phases

The current repository includes all previously implemented changes, not just the latest JSON hardening work.

### Phase 1 — State architecture hardening
- canonical runtime state moved to `templates/.ai/state/*.json`
- human-readable `.md` state files kept as summaries only
- state-management, check-matrix, and acceptance-traceability contracts added

### Phase 2 — Runtime prompt and command enforcement
- `.opencode/commands/*` strengthened to rely on the output schema contract
- runtime prompt layer separated from design-layer mirrors
- command behavior made more deterministic

### Phase 3 — Stack packs and validation gates
- stack packs added for `sveltekit-web`, `fastapi-api`, and `python-automation`
- each stack now defines mandatory checks in `stack.json`

### Phase 4 — Framework-level validation and smoke tests
- `framework-tests/` introduced for framework self-verification
- `scripts/validate-framework.py` added for template, contract, and smoke validation
- scaffold flow made offline-safe enough for local smoke testing

### Phase 5 — Machine-readable runtime contracts
- `runtime-output.schema.json` added and enforced by shared runtime rules
- `workflow-state.schema.json` added for the aggregate state registry
- `prompt-registry.json` added to reduce prompt drift
- `vc-runtime-rules.md` introduced as the shared runtime source of truth

### Phase 6 — Framework regression hardening
- golden-run traces added for API, web, and automation scenarios
- negative test scenarios added for schema and state validation
- fixture manifests and command-to-agent contracts added

### Phase 7 — Documentation hardening
- runtime documentation separated from framework-test documentation
- design decisions documented, including the move to JSON contracts
- architecture, quickstart, extension model, and contributor flow clarified for third parties

## Core execution chain

`Command -> Workflow -> Agent Contract -> State Update -> Mandatory Checks -> Review`

## Repository map

- `templates/` runtime payload copied into generated projects
- `templates/.opencode/` runtime commands and runtime prompts
- `templates/.ai/` contracts, specs, workflows, stacks, and canonical runtime state
- `framework-tests/` assets that verify the framework itself
- `scripts/` setup, scaffolding, and validation tools
- `docs/` end-user and contributor documentation

## Runtime features vs framework-test features

### Runtime features
Runtime features are part of normal AI-assisted development and are expected to be used in every generated project.

Examples:
- `templates/.opencode/commands/*`
- `templates/.opencode/prompts/*`
- `templates/.ai/contracts/*`
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
- Read `docs/runtime/overview.md` to understand the runtime flow
- Read `docs/framework-testing/overview.md` to understand framework self-verification
