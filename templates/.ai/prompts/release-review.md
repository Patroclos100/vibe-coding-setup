# Design Reference Only

This file is a design-layer mirror. Runtime behavior is controlled by `.opencode/commands/*`, `.opencode/prompts/*`, and `.ai/contracts/prompt-registry.json`.
The design layer must not add rules that contradict the runtime layer.

---

# Release Review Prompt

Validate:
- done criteria
- architecture rules
- dependency policy
- critical checks
- known risks

Return:
1. release status
2. passed checks
3. warnings
4. unresolved risks
5. recommended next step
