# Done Criteria

A feature increment is complete only if all conditions below are true:

1. The increment scope is explicit and bounded.
2. Acceptance criteria for the current increment are covered.
3. Files follow the architecture placement rules.
4. No unapproved dependency was introduced.
5. Relevant automated checks pass:
   - install/build checks
   - type checks if available
   - tests for changed behavior
6. Error states are handled for the implemented scope.
7. Known limitations and residual risks are documented.
8. No unrelated refactor was mixed into the change.

A release candidate is complete only if:
- release checklist is satisfied
- architecture validation is APPROVED or APPROVED WITH WARNINGS
- warnings are documented
