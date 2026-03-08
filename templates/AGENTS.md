# AGENTS.md

## Purpose

This repository is operated as a guided AI-assisted web project.

The goal is not maximum autonomy. The goal is controlled, reviewable progress in small to medium increments.

## Working mode

Always:

1. read the relevant files first
2. follow the repository rules
3. prefer the smallest useful increment
4. explain risks when scope grows
5. keep project context in `.ai/context`
6. review before broader follow-up work

## Source of truth order

1. current codebase
2. `requirements.md`
3. `.ai/specs/*`
4. `.ai/context/*`
5. `.ai/review/*`

Do not treat chat history as the primary source of truth when repository files say something else.

## Scope discipline

Prefer:

- narrow file changes
- explicit decisions
- simple solutions
- local readability
- stable conventions

Avoid:

- hidden framework magic
- speculative abstractions
- large rewrites without phase cut
- mixing feature, refactor and bugfix in one step
- introducing advanced platform concepts unless explicitly required by the repo

## Change-size behavior

- Small change: usually `/build-small`
- Medium change: `/plan` first, then phased implementation
- Large change: must be split into phases, implement phase 1 only

## Required outputs for implementation work

When implementing:

- state what you changed
- keep file list short
- mention checks run, if any
- mention open risks if they remain

## Escalation rule

If the task drifts toward runtime orchestration, multi-agent logic, generic platform design or hidden automation, stop and recommend a simpler repo-first alternative.
