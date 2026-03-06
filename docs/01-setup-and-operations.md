# Setup and Operations Guide

## 1. Purpose

This document explains how to install, validate, and operate the VibeCoding Framework on macOS.

It is written as an operational handover document. A new user should be able to set up the environment and create the first project without prior knowledge of the chat history.

## 2. Scope

Included:

- local macOS tool setup
- VS Code extensions
- OpenCode base configuration
- OpenCode command setup
- validation via a doctor script
- new-project bootstrap

Not included:

- team CI/CD
- cloud deployment
- production hosting
- mobile packaging via Capacitor

## 3. Target system

- macOS
- zsh shell
- VS Code installed
- GitHub account with Copilot Pro+

## 4. Standard directory model

The framework uses this directory split:

```text
~/dev     -> application repositories
~/ai      -> reusable templates, prompts, specs
~/tools   -> local setup scripts and Brewfile
```

Reason:

- keeps code separate from reusable AI assets
- reduces confusion between project files and global tooling
- makes onboarding easier for non-developers

## 5. Prerequisites

Before running the scripts:

1. Install Xcode Command Line Tools
2. Install Homebrew
3. Make sure the `code` command is available in PATH

To enable the VS Code CLI command:

- open VS Code
- run `Cmd+Shift+P`
- choose `Shell Command: Install 'code' command in PATH`

## 6. Installation sequence

### 6.1 Run the base setup

```bash
cd scripts
./setup-tools.sh
```

What it does:

- creates `~/dev`, `~/ai`, `~/tools`
- copies the Brewfile into `~/tools/Brewfile`
- installs required packages with `brew bundle`
- installs the required VS Code extensions
- writes a safe global OpenCode base config
- copies reusable templates to `~/ai`
- enables `direnv` in `~/.zshrc`

### 6.2 Install the OpenCode commands

```bash
./setup-opencode-commands.sh
```

What it does:

- creates the command files in `~/.config/opencode/commands`
- installs `/plan`, `/build-small`, `/build-large`, `/review`
- writes a short GSD note file under `~/ai/agents/GSD-NOTES.md`

### 6.3 Validate the machine state

```bash
./check-current-setup.sh
```

What it validates:

- CLI tools
- key directories
- template files
- VS Code extensions
- zsh integration
- OpenCode installation

## 7. Connecting OpenCode to Copilot

Start OpenCode:

```bash
opencode
```

Inside OpenCode:

```text
/connect
```

Choose:

```text
GitHub Copilot
```

This is the default baseline provider strategy.

## 8. Creating a new project

### Minimal mode

```bash
./new-ai-app.sh my-app ~/dev --minimal
```

### UI mode

```bash
./new-ai-app.sh my-app ~/dev --ui
```

The script creates:

- SvelteKit app
- pnpm setup
- AI folder structure
- project-local `opencode.json`
- `AGENTS.md`
- `requirements.md`
- `.env.example`
- `.envrc`
- basic UI starter files
- git repository

## 9. First-run procedure inside a new project

```bash
cd ~/dev/my-app
pnpm dev
opencode
```

Recommended first command:

```text
/plan
```

Only after the plan exists should implementation start.

## 10. Security model

The framework is intentionally conservative.

Global and project-level configurations are designed to:

- ask before edits and shell execution
- block destructive commands
- disable broad data sharing by default
- ignore noisy folders such as `node_modules`, `.git`, `dist`, `.svelte-kit`

This makes the setup safer for non-programmers.

## 11. Updating the framework

When scripts or templates are changed in the repository:

1. pull the latest repo changes
2. rerun `setup-tools.sh` if tooling changed
3. rerun `setup-opencode-commands.sh` if commands changed
4. rerun `check-current-setup.sh`

## 12. Common failure cases

### `code` command not found

Fix in VS Code:

- `Cmd+Shift+P`
- `Shell Command: Install 'code' command in PATH`

### OpenCode starts but no provider is connected

Fix:

- run `opencode`
- use `/connect`
- choose `GitHub Copilot`

### Project exists already

`new-ai-app.sh` will refuse to overwrite an existing target folder.

### CLI prompts change upstream

The bootstrap scripts stay close to upstream tooling, but Svelte and UI CLIs evolve. If a future CLI changes flags or prompts, update `new-ai-app.sh` accordingly.

## 13. Operational recommendation

Use this framework as a controlled engineering system, not as a loose prompt playground.

The highest leverage comes from:

- clear requirements
- small increments
- explicit review steps
- strict project-local guardrails
