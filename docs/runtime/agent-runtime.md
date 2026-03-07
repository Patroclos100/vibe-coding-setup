# Agent Runtime

The runtime agent system is centered around `.opencode/prompts/` and the shared rules in `vc-runtime-rules.md`.

## Shared runtime rules

`templates/.opencode/prompts/vc-runtime-rules.md` defines the non-negotiable behavior shared by all runtime prompts.

It requires:
- exactly one JSON output object
- use of runtime contracts and state files
- stack-aware validation
- explicit state updates
- deterministic, bounded behavior

## Runtime agents

The configured runtime agents are listed in `templates/opencode.json`.

Key agents include:
- `vc-orchestrator`
- `vc-planner`
- `vc-architecture-validator`
- `vc-dependency-manager`
- `vc-code-generator`
- `vc-test-generator`
- `vc-debugger`
- `vc-refactorer`
- `vc-release-reviewer`

## Design-layer mirrors

Files under `templates/.ai/prompts/` are design-layer mirrors. They explain intent and design, but they are not the runtime source of truth.

## Why the split matters

Without a clear split, a later contributor can accidentally update a design prompt and think runtime behavior changed when it did not.
