# Fixtures

Fixtures are stored under `framework-tests/fixtures/`.

## Purpose

A fixture defines the minimum expected artifact set and command expectations for a supported stack or scenario.

## Fixture manifests

Each fixture includes a `fixture.manifest.json` file describing:
- required artifacts
- expected commands
- expected stack identity

## Why fixtures exist

Fixtures give the framework validator something stable to check without depending on an external model runtime.
