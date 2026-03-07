# AGENTS.md

This repository is operated as a deterministic agent system, not as free-form chat.

## Non-Negotiable Operating Model

**MANDATORY:** Every meaningful change must follow this chain:

`Command -> Workflow -> Agent Contract -> Checks -> Review`

**DO NOT** jump directly from a user request to code edits.

**CRITICAL:** The workflow is part of the system design. Agents are not allowed to invent a new workflow when one already exists under `.ai/workflows/`.

## Priority Order
1. Safety and correctness
2. Architecture integrity
3. Reproducibility
4. Testability
5. Smallest complete increment
6. Readability for non-programmers

## Source of Truth
Always prefer the following sources over conversational guesswork:
- `requirements.md`
- `.ai/specs/product-spec.md`
- `.ai/specs/architecture.md`
- `.ai/specs/domain-model.md`
- `.ai/specs/error-model.md`
- `.ai/specs/test-strategy.md`
- `.ai/contracts/done-criteria.md`
- `.ai/contracts/dependency-policy.md`
- `.ai/contracts/check-matrix.md`
- `.ai/contracts/state-management.md`
- `.ai/contracts/acceptance-traceability.md`
- `.ai/workflows/*.md`
- `.ai/agents/*.md`
- `.ai/stacks/*/stack.json`
- `.ai/state/*.json`
- `.ai/review/*.md`

## Runtime source of truth
- `.opencode/commands/*` and `.opencode/prompts/*` are the runtime prompt layer.
- `.ai/prompts/*` are design references only and must not diverge in intent from the runtime layer.

## Command Enforcement
Custom commands in `.opencode/commands/` are the default entrypoints.

### Required command mapping
- `/intake` -> normalize request and update specs/state
- `/plan-feature` -> produce a bounded plan only
- `/build-small` -> implement one bounded increment only
- `/build-large` -> split large work into phases, then execute phase 1 only unless told otherwise
- `/fix` -> reproduce, classify, regression-test, minimally repair
- `/refactor-safe` -> structure-only improvements with behavior lock
- `/review-release` -> final architecture and release gate
- `/status` -> summarize current task, risks, changed files, and blockers

## Absolute Rules
- **DO NOT** edit code before scope is normalized.
- **DO NOT** add dependencies before dependency review.
- **DO NOT** refactor unrelated code.
- **DO NOT** mark work complete without relevant automated checks.
- **DO NOT** suppress errors, remove assertions, or weaken valid tests to get green output.
- **DO NOT** treat a broad feature request as permission for a whole-project rewrite.
- **DO NOT** leave JSON state files stale after meaningful progress.

## Agent Roles and Handovers

### 1. Intake Normalizer
Purpose: convert ambiguous requests into bounded implementation intent.
Primary artifacts:
- `.ai/specs/product-spec.md`
- `.ai/state/current-task.json`
- `.ai/state/risks.json`

### 2. Architecture Validator
Purpose: block architecture drift before and after implementation.
Primary artifacts:
- `.ai/state/plan.json`
- `.ai/review/architectural-debt.md`

### 3. Dependency Manager
Purpose: explicitly approve or reject package additions.
Primary artifacts:
- `.ai/contracts/dependency-policy.md`
- `.ai/state/plan.json`

### 4. Code Generator
Purpose: implement the smallest complete increment that fits the architecture.
Primary artifacts:
- changed source files
- `.ai/state/changed-files.json`

### 5. Test Generator
Purpose: create deterministic tests for the current increment.
Primary artifacts:
- test files
- `.ai/state/test-results.json`

### 6. Debug Agent
Purpose: minimally repair build, type, test, path, logic, and configuration failures.
Primary artifacts:
- `.ai/state/debug-log.json`
- `.ai/state/test-results.json`

### 7. Refactoring Agent
Purpose: improve structure only when there is evidence of duplication, ambiguity, or rule violation.
Primary artifacts:
- `.ai/review/architectural-debt.md`
- `.ai/state/changed-files.json`

### 8. Release Reviewer
Purpose: run final done-criteria and architecture gate.
Primary artifacts:
- `.ai/review/release-checklist.md`

## Mandatory Handover Format
Every handover must state:
1. current task
2. scope boundary
3. files changed or inspected
4. open risks
5. failed checks or blocking ambiguity
6. exact next action required

## Completion Standard
Work is complete only when all of the following are true:
- the current increment scope is explicit
- changed files are listed
- relevant checks were run
- known risks are documented
- out-of-scope items are listed
- architecture and dependency rules were not violated
- acceptance criteria are traced to automated verification

## Escalation Rule
If the request conflicts with specs, architecture, dependency policy, or done criteria, stop and report the conflict explicitly. Do not resolve it by improvisation.
