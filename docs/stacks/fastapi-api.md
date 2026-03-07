# FastAPI API Stack

Location: `templates/.ai/stacks/fastapi-api/`

## Mandatory checks
- `python -m ruff check .`
- `python -m mypy .`
- `python -m pytest tests/unit -q`
- `python -m pytest tests/integration -q`
- `python -m pytest tests/smoke -q`

## Intended use
Use this stack for HTTP APIs where static checks, unit coverage, integration coverage, and API smoke verification are required.
