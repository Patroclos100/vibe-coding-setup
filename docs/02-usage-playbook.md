# Usage Playbook

## 1. Purpose

This document explains how to use the VibeCoding Framework in day-to-day work after the base setup is complete.

It focuses on:

- how to start a new project correctly
- how to work with OpenCode commands
- when to use GSD
- how to keep changes small, understandable and reviewable
- which anti-patterns to avoid

## 2. Daily operating model

The framework follows a strict division of responsibilities:

- **VS Code** is the editor and terminal
- **Copilot Pro+** is the model provider accessed through OpenCode `/connect`
- **OpenCode** is the execution layer for planning, implementation and review
- **GSD** is the process layer for larger work packages
- **Project files** (`AGENTS.md`, `requirements.md`, `.ai/`) are the source of truth for the agent

Do not treat the model as the source of truth.
The source of truth is always the project documentation and the current codebase.

## 3. Project start: required sequence

When creating a new application, always follow this sequence:

1. create the project with `new-ai-app.sh`
2. open the created repository in VS Code
3. review `AGENTS.md`
4. fill `requirements.md`
5. review `.ai/specs/architecture.md`
6. review `.ai/specs/ui-rules.md`
7. start OpenCode
8. connect provider with `/connect`
9. run `/plan`
10. only then start implementation

## 4. Golden path commands

### `/plan`

Use for:

- first understanding of a new feature
- breaking down a task
- checking risks before coding
- architecture-sensitive changes

Expected outcome:

- current-state diagnosis
- 5–8 implementation steps
- assumptions and risks
- smallest useful first increment

### `/build-small`

Use for:

- single components
- form fields
- basic CRUD steps
- local UI improvements
- clearly understood bug fixes

Expected behavior:

- reads the relevant files first
- implements only the smallest useful increment
- keeps file changes narrow
- runs checks or build where available

### `/build-large`

Use only for:

- larger but already-understood work packages
- multi-file work that cannot be sensibly reduced to one tiny change
- controlled expansion after `/plan`

Do not use as the first command of a new feature.

### `/review`

Use for:

- validating recent changes
- catching complexity growth
- checking naming, duplication and error handling
- preparing for commit or release

Expected outcome:

- review findings first
- smallest safe refactor second

## 5. How to use GSD correctly

GSD is not the default tool for every tiny change.
Use GSD when work needs more structure than a short OpenCode command sequence.

Good use cases:

- new feature area with multiple sub-features
- unclear scope that needs discussion before implementation
- work that spans UI, state and data handling
- phased delivery with explicit verification

Recommended GSD flow for larger work:

1. `/gsd:new-project`
2. `/gsd:discuss-phase 1`
3. `/gsd:plan-phase 1`
4. `/gsd:execute-phase 1`
5. `/gsd:verify-work`

For small and medium tasks, prefer:

- `/plan`
- `/build-small`
- `/review`

## 6. File roles and responsibilities

### `AGENTS.md`

Purpose:

- defines workflow rules for the agent
- sets coding principles
- defines done criteria
- sets safety expectations

This file should stay short, stable and authoritative.
Do not overload it with project history or long feature notes.

### `requirements.md`

Purpose:

- defines the business and product contract
- clarifies users, goals, scope and non-goals
- prevents the model from inventing features

This file should be updated when project scope changes.

### `.ai/specs/architecture.md`

Purpose:

- explains structural decisions
- defines the intended layering and module boundaries
- reduces architecture drift

### `.ai/specs/ui-rules.md`

Purpose:

- defines UI principles
- prevents arbitrary styling changes
- keeps generated screens consistent

### `.ai/prompts/*`

Purpose:

- reusable prompt fragments for standard work modes
- keeps request phrasing stable
- reduces accidental prompt drift

### `.ai/review/release-checklist.md`

Purpose:

- final verification before broader rollout or release

## 7. Recommended feature workflow

For most work, use this sequence:

1. update `requirements.md` if needed
2. run `/plan`
3. implement via `/build-small`
4. run `/review`
5. repeat until the feature is complete
6. run local checks
7. commit

This is intentionally repetitive.
Repetition is a control mechanism, not waste.

## 8. What to tell the agent

Good requests are:

- specific
- bounded
- grounded in the existing files
- phrased as one change at a time

Good example:

> Read `requirements.md` and `.ai/specs/ui-rules.md`. Add a basic create form for items with name and description. Use the smallest useful increment only.

Bad example:

> Build the whole app for me.

Good follow-up example:

> Review the latest changes for complexity, duplication and missing validation. Suggest the smallest safe next step.

## 9. Anti-patterns

Avoid these patterns completely:

### 9.1 Prompt-and-pray

Do not ask for complete applications in one step.
This produces drift, hidden assumptions and inconsistent architecture.

### 9.2 Skipping `/plan`

If the task is not trivial, skipping planning increases rework.

### 9.3 Using `/build-large` too early

This is one of the fastest ways to lose control of the codebase.

### 9.4 Mixing too many tools

Do not add more agent frameworks, IDE helpers or code generators unless a real problem exists.

### 9.5 Letting documentation lag behind

If `requirements.md` and the actual feature scope diverge, output quality drops quickly.

## 10. Review standard before commit

Before committing changes, verify:

- feature behavior matches `requirements.md`
- no obvious TypeScript or build issues remain
- file changes are understandable
- no unnecessary dependencies were added
- naming is clear
- the change can be explained in a few sentences

If this cannot be done, the change is too large.

## 11. Escalation rules

Escalate from normal workflow to stronger structure when:

- the feature crosses several domains
- the plan exceeds 8–10 steps
- architecture changes are required
- repeated rework appears
- the model starts drifting between options

Then:

- update specs first
- use GSD for phased discussion and planning
- reduce implementation into smaller packages again

## 12. Team handover note

When handing a project to another person, provide at minimum:

- repository link
- this playbook
- `AGENTS.md`
- `requirements.md`
- current project status
- known open decisions

The framework is only reproducible if the next person receives both the code and the operating model.
