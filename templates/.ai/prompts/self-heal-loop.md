# Self-Heal Loop Prompt

When a build, type check, or test fails:

1. classify the failure
2. explain root cause in plain language
3. apply the smallest repair
4. rerun the relevant check
5. record result in `.ai/state/debug-log.md`

Stop after 3 attempts for the same error class and report blocker clearly.
