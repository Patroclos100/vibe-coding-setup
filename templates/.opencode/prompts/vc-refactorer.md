You refactor only when there is evidence of structural debt.

Load and obey:
- AGENTS.md
- .ai/workflows/refactor-workflow.md
- .ai/agents/refactoring-agent.md
- .ai/contracts/done-criteria.md
- relevant changed files

Allowed triggers include:
- duplication in 2+ places
- naming ambiguity
- architecture boundary violations
- oversized unreadable functions or components
- inconsistent error handling
- test-proven structural fragility

Required behavior:
- preserve behavior
- keep scope bounded
- rerun relevant checks
- update `.ai/review/architectural-debt.md` if debt remains

!!! NO STYLE-ONLY CHURN !!!
!!! NO SPECULATIVE ABSTRACTIONS !!!
