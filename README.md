# VibeCoding Framework

AI-first development framework that allows **IT professionals without classical programming experience** to build production-ready software using structured AI agents.

The framework enforces deterministic development workflows using:

- structured context
- command orchestration
- specialized AI agents
- automated validation loops

Instead of free prompting, development follows a controlled system:

User → Command → Workflow → Agents → Code

---

# Key Principles

## Deterministic AI Development

AI never decides the workflow.

The system enforces:

Command  
↓  
Workflow  
↓  
Agents  
↓  
Code  

This prevents:

- random architecture
- unstable code generation
- uncontrolled dependencies
- fragile projects

---

## Spec-Driven Development

All AI work happens against structured specifications.

```
.ai/specs
.ai/contracts
.ai/workflows
.ai/state
```

The AI must follow these definitions.

---

## Multi-Agent System

The framework uses specialized agents.

```
vc-orchestrator
│
├ planner
├ architecture-validator
├ dependency-manager
├ code-generator
├ test-generator
├ debug-agent
└ refactoring-agent
```

Each agent has a specific responsibility.

---

# Architecture Overview

Every generated project contains:

```
project
│
├ AGENTS.md
├ requirements.md
├ opencode.json
│
├ .ai
│   ├ contracts
│   ├ specs
│   ├ workflows
│   ├ agents
│   └ state
│
└ .opencode
    ├ commands
    └ prompts
```

---

# Installation

## 1 Clone repository

```bash
git clone <repo>
cd vibecoding-framework
```

---

## 2 Run setup

```bash
./scripts/setup-tools.sh
```

This installs:

- required system tools
- OpenCode CLI
- framework templates
- command definitions
- agent prompts

---

## 3 Verify setup

```bash
~/tools/check-current-setup.sh
```

---

## 4 Connect GitHub Copilot

Start OpenCode:

```bash
opencode
```

Then connect Copilot:

```
/connect
```

Select:

```
GitHub Copilot
```

---

# Create your first AI project

Generate a new project:

```bash
~/tools/new-ai-app.sh my-project ~/dev --ui
```

Project structure:

```
my-project
│
├ AGENTS.md
├ requirements.md
├ opencode.json
│
├ .ai
│   ├ contracts
│   ├ specs
│   ├ workflows
│   └ agents
│
└ .opencode
    ├ commands
    └ prompts
```

---

# Development Workflow

Development must follow the command workflow.

Never directly prompt the AI.

Available commands:

```
/intake
/plan-feature
/build-small
/build-large
/fix
/refactor-safe
/review-release
/status
```

---

# Golden Path

## 1 Define feature

```
/intake
```

---

## 2 Create plan

```
/plan-feature
```

Creates:

```
.ai/state/plan.md
```

---

## 3 Implement feature

```
/build-small
```

Workflow:

```
Architecture Validator
↓
Dependency Manager
↓
Code Generator
↓
Test Generator
↓
Build
↓
Debug Agent
```

---

## 4 Fix problems

```
/fix
```

---

## 5 Review release

```
/review-release
```

---

# Example Workflow

```
/intake
→ describe feature

/plan-feature

/build-small

/review-release
```

---

# AI Workflow Model

All commands enforce a strict development loop.

```
Plan
↓
Generate Code
↓
Generate Tests
↓
Run Checks
↓
Debug
↓
Review
```

This ensures:

- stable code generation
- minimal refactoring
- predictable architecture

---

# Framework Philosophy

Most AI coding workflows fail because the AI decides everything.

This framework reverses that.

The system defines:

- architecture
- workflow
- validation
- dependency rules

The AI only executes within those constraints.

---

# Troubleshooting

## Commands not available

Check:

```
.opencode/commands
```

---

## Copilot not connected

Run:

```
/connect
```

---

## Agents not running

Verify:

```
opencode.json
```

---

# Extending the Framework

You can extend the system by adding:

New commands

```
.opencode/commands
```

New agents

```
.ai/agents
```

New workflows

```
.ai/workflows
```

---

# Who is this for?

This framework is designed for:

- IT product owners
- analysts
- architects
- non-developer engineers
- technical domain experts

who want to build software **without writing large amounts of code manually**.

---

# Project Status

Experimental but production-oriented.

The goal is **AI-driven software development with minimal manual refactoring**.

---

# License

MIT
