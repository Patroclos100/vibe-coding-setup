# Test Strategy

## Goal
Protect critical behavior with the smallest maintainable automated suite.

## Minimum Per Increment
1. one success-path test
2. one failure-path or validation-path test
3. one regression-sensitive edge case test

## Layer Preference
- pure logic: unit tests first
- feature flow: integration-style tests where behavior matters
- UI: behavior and interaction tests, not implementation trivia

## Avoid
- brittle snapshots
- excessive mocking
- duplicate assertions across layers

## Release Gate
Critical user journey must have automated verification before release.
