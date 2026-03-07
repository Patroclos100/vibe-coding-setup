# Development Workflow

Detailed runtime flow now lives in `docs/runtime/overview.md` and `docs/runtime/commands.md`.

Default command sequence:

```text
/intake -> /plan-feature -> /build-small -> /fix -> /review-release
```

The runtime writes structured JSON state and uses the active stack pack for mandatory checks.
