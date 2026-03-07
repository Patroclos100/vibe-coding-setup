# Design Decisions

This document explains the architectural decisions behind the hardened framework.

## 1. JSON for runtime contracts instead of narrative-only markdown

### Problem
Markdown is readable but weak as a runtime enforcement mechanism. It is difficult to validate, easy to interpret loosely, and hard to compare deterministically across runs.

### Decision
Use JSON and JSON Schema for machine-validated runtime contracts while keeping markdown for human explanation.

### Result
- runtime outputs can be schema-validated
- workflow state can be validated as a structured registry
- drift becomes easier to detect
- retries and acceptance coverage can be reasoned about programmatically

## 2. Runtime output must be a single JSON object

### Problem
Mixed prose and code-like output made runtime behavior harder to parse and validate.

### Decision
The shared runtime rules require every runtime agent to return exactly one JSON object conforming to `templates/.ai/contracts/runtime-output.schema.json`.

### Result
- deterministic parsing
- easier testing
- cleaner orchestration boundaries

## 3. Workflow state is canonical in JSON

### Problem
Free-form markdown state is useful for readers but too loose for deterministic orchestration.

### Decision
Treat `templates/.ai/state/*.json` and `workflow-state.json` as canonical. Markdown state files are summaries, not the system of record.

### Result
- easier status tracking
- explicit retry budgets
- clearer acceptance and validation linkage

## 4. Runtime prompts and design prompts are separated

### Problem
Prompt duplication created drift risk and ambiguity about the source of truth.

### Decision
Use `.opencode/` as the runtime source of truth and keep `.ai/prompts/` as design-layer mirrors. Record that mapping in `templates/.ai/contracts/prompt-registry.json`.

### Result
- lower drift risk
- clearer extension rules
- easier validator checks

## 5. Stack packs define mandatory checks

### Problem
Validation expectations differed by stack and were easy to leave implicit.

### Decision
Each supported stack defines a `stack.json` file with mandatory checks.

### Result
- stack-aware validation
- more deterministic check selection
- cleaner handoff between planner, code generator, and debugger

## 6. Framework tests verify the framework, not each feature run

### Problem
Without a clear distinction, users could assume framework tests are part of every normal build step.

### Decision
Keep framework tests in `framework-tests/` and describe them as repository-level verification assets.

### Result
- clearer operator mental model
- less runtime confusion
- easier contributor onboarding
