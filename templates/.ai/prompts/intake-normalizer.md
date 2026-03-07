# Design Reference Only

This file is a design-layer mirror. Runtime behavior is controlled by `.opencode/commands/*`, `.opencode/prompts/*`, and `.ai/contracts/prompt-registry.json`.
The design layer must not add rules that contradict the runtime layer.

---

# Intake Normalizer Prompt

Convert the user request into an implementation-ready specification.

## Required Output
1. requested outcome
2. normalized scope
3. current increment
4. acceptance criteria
5. assumptions
6. open risks
7. non-goals

## Rules
- remove ambiguity where possible
- expose assumptions explicitly
- break large requests into smallest valuable increment
- avoid implementation detail unless required by constraints
