---
description: Create deterministic module plan from blueprint and registry
agent: factory-orchestrator-agent
---

Use this workflow exactly:
1. Load `AGENTS.md`
2. Load `.ai/factory/factory.ai`, `.ai/factory/factory-governance.md`, `.ai/contracts/quality.ai`, `.ai/contracts/output-schema.md`
3. Load `.ai/contracts/execution-policy.json`, `.ai/contracts/transition-matrix.json`, `.ai/contracts/failure-taxonomy.json`, `.ai/contracts/agent-capabilities.json`
4. Load the relevant blueprint, module, project, and release artifacts
5. Invoke the agents required for `module-planning.ai`
6. Update `.ai/state/workflow-state.json`, `.ai/state/factory-state.json`, and the relevant registry artifacts

Task request:
$ARGUMENTS

Required output in chat:
- command name: /factory-plan-modules
- purpose: Create deterministic module plan from blueprint and registry
- trigger: explicit operator request or pipeline continuation authorized by policy
- workflow invoked: module-planning.ai
- agents involved: system-architect-agent, module-registry-agent
- expected artifacts: module plan, reuse decisions
- failure behavior: stop or escalate when governance, compatibility, or gate evidence is insufficient

Output must follow the Output Schema Contract.

Execution policy gate:
- Commands declare intent only. The execution policy authorizes the next action and next actor.
- Update state and registry artifacts when a transition, retry, replan, rollback, stop, or escalation occurs.

Runtime output rule:
- Return exactly one JSON object that conforms to `.ai/contracts/runtime-output.schema.json`.
- Do not add markdown, narrative, or commentary outside the JSON object.
