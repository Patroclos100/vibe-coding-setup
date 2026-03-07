# Implementation History

This file captures the full sequence of framework hardening changes so later readers understand that the current repository is the result of multiple cumulative phases.

## Phase 1 — State architecture hardening
- JSON state files introduced under `templates/.ai/state/`
- state-management, check-matrix, and acceptance-traceability contracts added
- markdown state retained as human-readable summaries

## Phase 2 — Runtime prompt and command enforcement
- `.opencode/commands/*` tightened to use schema-driven output expectations
- runtime prompt responsibilities clarified
- design-layer prompts explicitly marked as non-runtime mirrors

## Phase 3 — Stack packs and validation gates
- stack packs added for SvelteKit, FastAPI, and Python automation
- mandatory checks became stack-defined instead of implicit

## Phase 4 — Framework validation harness
- `framework-tests/` introduced
- `scripts/validate-framework.py` added
- offline-capable scaffold smoke path added to `new-ai-app.sh`

## Phase 5 — Machine-readable runtime contracts
- `runtime-output.schema.json` introduced
- `workflow-state.schema.json` introduced
- `prompt-registry.json` introduced
- `vc-runtime-rules.md` introduced as shared runtime source of truth

## Phase 6 — Regression hardening
- positive and negative schema scenarios added
- golden-run traces added for API, web, and automation use cases
- fixture manifests and command-to-agent contracts added

## Phase 7 — Documentation hardening
- runtime docs separated from framework-test docs
- design rationale documented
- documentation expanded so third parties can understand the current architecture without prior context

## Relationship to `IMPLEMENTATION_REPORT.md`

`IMPLEMENTATION_REPORT.md` is the change log for implementation work packages.
This file explains the architectural evolution in reader-friendly form and is the preferred starting point for third-party reviewers.
