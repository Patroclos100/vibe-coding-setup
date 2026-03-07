# Troubleshooting

Start with:

```bash
python3 scripts/validate-framework.py
```

Then inspect:
- `templates/.ai/state/test-results.json`
- `templates/.ai/state/debug-log.json`
- `framework-tests/scenarios/` if schema validation fails

For conceptual guidance, see `docs/framework-testing/validator.md` and `docs/runtime/workflow-state.md`.
