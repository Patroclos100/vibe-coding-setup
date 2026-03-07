# Architecture

The framework is divided into a **runtime system** and a **framework-testing system**.

## High-level architecture

```text
User Request
  -> Runtime Command
  -> Orchestrator
  -> Specialized Runtime Agent
  -> Structured State Update
  -> Mandatory Checks from Active Stack
  -> Debug / Repair Loop if needed
  -> Release Review
```

## Runtime system

The runtime system is copied into generated projects and governs normal development sessions.

### Runtime layers
1. **Command layer**: `.opencode/commands/*`
2. **Runtime prompt layer**: `.opencode/prompts/*`
3. **Contract layer**: `.ai/contracts/*`
4. **Specification layer**: `.ai/specs/*`
5. **Workflow layer**: `.ai/workflows/*`
6. **State layer**: `.ai/state/*`
7. **Stack-pack layer**: `.ai/stacks/*`
8. **Review layer**: `.ai/review/*`

## Framework-testing system

The framework-testing system stays in the framework repository and verifies that the runtime remains correct.

### Testing layers
1. template and contract presence checks
2. command-to-agent contract checks
3. schema validation against positive and negative scenarios
4. golden-run trace validation
5. fixture manifest validation
6. scaffold smoke validation

## Why the split matters

A generated project uses the runtime system. The framework repository uses the framework-testing system to prove that the runtime system is coherent.

That separation prevents confusion between:
- assets that drive software generation
- assets that verify the framework itself
