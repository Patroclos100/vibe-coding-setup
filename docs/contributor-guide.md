# Contributor Guide

This guide explains how to change the framework without breaking its runtime or test model.

## 1. Preserve the runtime vs framework-test split

Do not mix framework verification assets into the runtime payload copied into generated projects.

- Runtime assets belong under `templates/`
- Framework verification assets belong under `framework-tests/` and `scripts/validate-framework.py`

## 2. When adding a new runtime prompt

1. create the runtime prompt under `templates/.opencode/prompts/`
2. update `templates/.ai/contracts/prompt-registry.json`
3. ensure the prompt inherits the shared rules from `vc-runtime-rules.md`
4. update runtime documentation if command behavior changed

## 3. When adding or changing a command

1. update `.opencode/commands/<command>.md`
2. confirm the expected runtime agent mapping
3. update `framework-tests/contracts/command-agent-map.json` if needed
4. update `docs/runtime/commands.md`

## 4. When adding a new stack

1. create `templates/.ai/stacks/<stack-id>/stack.json`
2. add stack documentation under `docs/stacks/`
3. add fixture or golden-run assets if the stack is first-class supported
4. update validator logic if the stack adds a new enforcement rule

## 5. When changing the JSON schemas

1. update the schema file under `templates/.ai/contracts/`
2. update the example JSON if relevant
3. update positive and negative scenarios under `framework-tests/scenarios/`
4. update documentation under `docs/runtime/`

## 6. Always re-run framework validation

```bash
python3 scripts/validate-framework.py
```

That is the minimum verification step before accepting framework changes.
