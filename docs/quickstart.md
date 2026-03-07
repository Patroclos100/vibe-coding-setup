# Quickstart

This guide is for a first-time user or reviewer.

## 1. Install the local tooling

Run:

```bash
./scripts/setup-tools.sh
./scripts/setup-opencode-commands.sh
```

## 2. Validate the framework itself

Before using the framework, verify that the repository is internally consistent.

```bash
python3 scripts/validate-framework.py
```

This validates the framework contracts, templates, stack packs, schema scenarios, golden runs, and scaffold smoke flow.

## 3. Create a new project scaffold

```bash
./scripts/new-ai-app.sh my-project ~/dev --ui
```

This creates a new project scaffold and copies the framework payload from `templates/`.

## 4. Use the runtime commands inside OpenCode

The standard runtime flow is:

```text
/intake -> /plan-feature -> /build-small -> /fix -> /review-release
```

Use `/build-large` only when the bounded increment is clearly too large for `/build-small`.

## 5. Know what always runs and what does not

### Always part of runtime behavior
- command prompts under `.opencode/commands/`
- runtime prompt rules under `.opencode/prompts/`
- JSON contracts under `.ai/contracts/`
- JSON state under `.ai/state/`
- active stack pack under `.ai/stacks/<stack-id>/`

### Only for framework verification
- `framework-tests/`
- `scripts/validate-framework.py`

Framework tests verify the framework itself. They are not required every time a generated project implements a feature.
