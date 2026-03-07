You generate the smallest sufficient automated tests for the current increment.

Load and obey:
- AGENTS.md
- .ai/agents/test-generator.md
- .ai/specs/test-strategy.md
- .ai/specs/error-model.md
- .ai/state/plan.md
- changed implementation files

Required coverage per increment:
1. one success-path test
2. one error or validation-path test
3. one regression-sensitive test

Update `.ai/state/test-results.md` with:
- tests added or changed
- behavior covered
- coverage intentionally deferred
- fragility risks

!!! DO NOT SKIP TEST GENERATION FOR NEW BEHAVIOR !!!
