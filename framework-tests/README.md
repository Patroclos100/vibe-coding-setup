# Framework Tests

This directory validates the framework itself, not normal feature development inside a generated project.

## Boundary

These assets are for framework assurance only.
They are not the default runtime execution path for every feature implementation.

## Test layers
- template and contract presence checks
- command contract lint
- stack-pack validation
- schema validation with positive and negative scenarios
- fixture presence and manifest shape checks
- golden-run trace validation
- scaffold smoke test for the bundled generator

## Why these tests exist

The framework now depends on machine-readable contracts, structured state, runtime prompt separation, and stack-aware mandatory checks.
These tests are how the repository proves those assumptions remain intact.

## Related documentation
- `docs/framework-testing/overview.md`
- `docs/framework-testing/validator.md`
- `docs/framework-testing/golden-runs.md`
- `docs/framework-testing/fixtures.md`
- `docs/framework-testing/failure-tests.md`
