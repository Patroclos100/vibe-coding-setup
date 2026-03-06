# AGENTS.md

## Objective
Build production-grade software through a deterministic AI workflow.

## Workflow
1. Analyse
2. Plan
3. Implement the smallest useful increment
4. Review

Do not skip steps.

## Priorities
Correctness > Simplicity > Speed

## Rules
- Read `requirements.md` and relevant files first
- Prefer small components and explicit data flow
- Avoid new dependencies unless justified
- Avoid hidden side effects and broad refactors
- Keep changes narrow and reviewable
- Use TypeScript consistently

## UI Rules
- Minimal, readable, mobile-friendly
- One primary action per screen where possible
- Avoid noisy animations and unnecessary complexity

## Safety
Never run destructive commands without explicit user approval.

## Done Criteria
- Build succeeds
- TypeScript is clean
- UI behaves predictably
- Code remains understandable to a new team member
