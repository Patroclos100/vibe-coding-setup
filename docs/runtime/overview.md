# Runtime Overview

The runtime system is the part of the framework used during normal AI-assisted development.

## Runtime flow

```text
User request
  -> /intake
  -> /plan-feature
  -> /build-small or /build-large
  -> mandatory stack checks
  -> /fix if checks fail
  -> /review-release
```

## Runtime source of truth

The runtime source of truth is recorded in `templates/.ai/contracts/prompt-registry.json`.

- runtime prompt source of truth: `.opencode`
- design-layer mirrors: `.ai/prompts`
- shared runtime rules: `.opencode/prompts/vc-runtime-rules.md`

## Runtime assets

- commands: `.opencode/commands/*`
- runtime prompts: `.opencode/prompts/*`
- contracts: `.ai/contracts/*`
- state: `.ai/state/*`
- workflows: `.ai/workflows/*`
- stack packs: `.ai/stacks/*`

## Runtime guarantees the framework is trying to enforce

- bounded scope per increment
- deterministic JSON output
- stack-aware validation
- explicit state updates
- bounded retry behavior
- release review before done status
