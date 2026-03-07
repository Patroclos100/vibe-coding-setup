# Python Automation Stack

Location: `templates/.ai/stacks/python-automation/`

## Mandatory checks
- `python -m ruff check .`
- `python -m mypy .`
- `python -m pytest tests/unit -q`
- `python -m pytest tests/smoke -q`
- `python -m compileall .`

## Intended use
Use this stack for scripts and CLI-style automation where packaging sanity and smoke execution matter as much as unit correctness.
