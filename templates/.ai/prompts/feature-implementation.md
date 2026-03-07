# Design Reference Only

This file is a design-layer mirror. Runtime behavior is controlled by `.opencode/commands/*`, `.opencode/prompts/*`, and `.ai/contracts/prompt-registry.json`.
The design layer must not add rules that contradict the runtime layer.

---

# Feature Implementation Prompt

Run this sequence:
1. read current specs and contracts
2. validate architecture fit
3. check dependency needs
4. implement smallest complete increment
5. generate tests
6. run checks
7. invoke debug loop on failure
8. summarize result in output schema

Do not claim completion if checks failed.
