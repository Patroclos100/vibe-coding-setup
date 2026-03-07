# Golden Runs

Golden runs are reference traces stored under `framework-tests/golden-runs/`.

## Purpose

They describe expected valid runtime traces for representative project categories:
- API
- web app
- automation script

## Why they matter

Golden runs help detect drift in the runtime contract and state model without requiring a live LLM run during repository validation.

## Important limitation

A golden run is not the same thing as a full live-model end-to-end execution. It is a contract fixture used to validate that the framework still understands its expected runtime trace shapes.
