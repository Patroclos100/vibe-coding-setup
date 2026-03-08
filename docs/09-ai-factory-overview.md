# AI Factory Overview

The repository now operates at two layers:

1. **Runtime layer** for deterministic feature delivery inside a project.
2. **Factory layer** for standardized product creation, module reuse, release control, and monitoring across projects.

## Factory additions
- blueprint catalog in `templates/.ai/blueprints/`
- module registry in `templates/.ai/modules/`
- project portfolio in `templates/.ai/projects/`
- release control in `templates/.ai/releases/`
- orchestration and governance in `templates/.ai/factory/`

## Deterministic rule
Factory commands still do not directly authorize arbitrary edits. They declare intent. Workflows and policy remain the control surface.
