# Dependency Policy

## Goal
Preserve simplicity, reproducibility, and maintainability.

## Default Rule
Prefer zero new dependencies.

## Approval Rules
A new dependency is allowed only if all are true:
1. platform or standard library capabilities are insufficient
2. no existing installed package solves the need well
3. maintenance cost is lower with the dependency than without it
4. the dependency is mature and actively maintained
5. the dependency meaningfully reduces implementation or defect risk

## Rejection Rules
Reject a dependency if any are true:
- it only saves a small amount of trivial code
- it duplicates installed capabilities
- it adds a second competing pattern to the stack
- it creates avoidable vendor lock-in for a simple need
- it is weakly maintained or poorly documented

## Required Evaluation Output
For each proposed dependency, document:
- exact use case
- native alternative
- installed alternative
- complexity impact
- build/runtime impact
- maintenance risk
- decision
- version pinning if approved
