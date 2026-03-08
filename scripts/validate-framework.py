#!/usr/bin/env python3
from __future__ import annotations
import json
import subprocess
import sys
from pathlib import Path

from jsonschema import Draft202012Validator

ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / 'templates'
FRAMEWORK_TESTS = ROOT / 'framework-tests'
FAILURES: list[str] = []
WARNINGS: list[str] = []


def check(condition: bool, message: str) -> None:
    if not condition:
        FAILURES.append(message)


def warn(condition: bool, message: str) -> None:
    if not condition:
        WARNINGS.append(message)


def read(path: Path) -> str:
    return path.read_text(encoding='utf-8')


def load_json(path: Path):
    return json.loads(read(path))


def validator_for(path: Path) -> Draft202012Validator:
    return Draft202012Validator(load_json(path))


def schema_check(validator: Draft202012Validator, payload: object, label: str, should_pass: bool) -> None:
    errors = sorted(validator.iter_errors(payload), key=lambda e: list(e.absolute_path))
    if should_pass:
        check(not errors, f'{label} should satisfy schema but failed: ' + '; '.join(err.message for err in errors[:3]))
    else:
        check(bool(errors), f'{label} should fail schema validation but passed')


required_files = [
    TEMPLATES / 'AGENTS.md',
    TEMPLATES / 'opencode.json',
    TEMPLATES / '.ai/contracts/output-schema.md',
    TEMPLATES / '.ai/contracts/check-matrix.md',
    TEMPLATES / '.ai/contracts/state-management.md',
    TEMPLATES / '.ai/contracts/acceptance-traceability.md',
    TEMPLATES / '.ai/contracts/runtime-output.schema.json',
    TEMPLATES / '.ai/contracts/workflow-state.schema.json',
    TEMPLATES / '.ai/contracts/prompt-registry.json',
    TEMPLATES / '.opencode/prompts/vc-runtime-rules.md',
    TEMPLATES / '.opencode/prompts/vc-orchestrator.md',
    FRAMEWORK_TESTS / 'contracts/command-agent-map.json',
]
for path in required_files:
    check(path.exists(), f'missing required file: {path.relative_to(ROOT)}')

runtime_validator = validator_for(TEMPLATES / '.ai/contracts/runtime-output.schema.json')
workflow_validator = validator_for(TEMPLATES / '.ai/contracts/workflow-state.schema.json')
policy_validator = validator_for(TEMPLATES / '.ai/contracts/execution-policy.schema.json')
decision_validator = validator_for(TEMPLATES / '.ai/contracts/execution-decision.schema.json')

# Validate state JSON files individually and aggregate workflow state against schema
state_dir = TEMPLATES / '.ai/state'
state_files = [
    'current-task.json',
    'plan.json',
    'risks.json',
    'changed-files.json',
    'test-results.json',
    'debug-log.json',
    'execution-state.json',
    'execution-ledger.json',
    'checkpoints.json',
    'workflow-state.json',
]
for name in state_files:
    path = state_dir / name
    check(path.exists(), f'missing state file: {path.relative_to(ROOT)}')
    if path.exists():
        try:
            load_json(path)
        except Exception as exc:
            check(False, f'invalid json in {path.relative_to(ROOT)}: {exc}')

workflow_state = load_json(state_dir / 'workflow-state.json')
schema_check(workflow_validator, workflow_state, 'templates/.ai/state/workflow-state.json', True)
schema_check(policy_validator, load_json(TEMPLATES / '.ai/contracts/execution-policy.json'), 'templates/.ai/contracts/execution-policy.json', True)

# Cross-check aggregate workflow state with split state files
try:
    split_task = load_json(state_dir / 'current-task.json')
    split_plan = load_json(state_dir / 'plan.json')
    split_risks = load_json(state_dir / 'risks.json')
    split_changed = load_json(state_dir / 'changed-files.json')
    split_tests = load_json(state_dir / 'test-results.json')
    split_debug = load_json(state_dir / 'debug-log.json')
    split_execution = load_json(state_dir / 'execution-state.json')
    split_ledger = load_json(state_dir / 'execution-ledger.json')
    split_checkpoints = load_json(state_dir / 'checkpoints.json')
    check(workflow_state.get('task') == split_task, 'workflow-state task section is out of sync with current-task.json')
    check(workflow_state.get('plan') == split_plan, 'workflow-state plan section is out of sync with plan.json')
    check(workflow_state.get('risks') == split_risks, 'workflow-state risks section is out of sync with risks.json')
    check(workflow_state.get('changed_files') == split_changed, 'workflow-state changed_files section is out of sync with changed-files.json')
    check(workflow_state.get('test_results') == split_tests, 'workflow-state test_results section is out of sync with test-results.json')
    check(workflow_state.get('debug_log') == split_debug, 'workflow-state debug_log section is out of sync with debug-log.json')
    check(workflow_state.get('execution') == split_execution, 'workflow-state execution section is out of sync with execution-state.json')
    check(workflow_state.get('checkpoints') == split_checkpoints, 'workflow-state checkpoints section is out of sync with checkpoints.json')
    check(len(split_changed.get('files', [])) == len(set(split_changed.get('files', []))), 'changed-files.json contains duplicate file paths')
    retry_counters = split_debug.get('retry_counters', {})
    total = retry_counters.get('total', 0)
    check(total >= retry_counters.get('syntax', 0), 'debug-log.json total retries is below syntax retries')
    check(total >= retry_counters.get('tests', 0), 'debug-log.json total retries is below test retries')
    check(total >= retry_counters.get('refactor', 0), 'debug-log.json total retries is below refactor retries')
    check(bool(split_ledger.get('decisions')), 'execution-ledger.json must contain at least one decision')
    latest_decision = split_ledger.get('decisions', [])[-1]
    schema_check(decision_validator, latest_decision, 'templates/.ai/state/execution-ledger.json latest decision', True)
    check(workflow_state.get('policy_summary', {}).get('authorized_next_action') == latest_decision.get('authorized_action'), 'policy_summary authorized_next_action is out of sync with execution-ledger.json')
    check(workflow_state.get('policy_summary', {}).get('authorized_next_actor') == latest_decision.get('next_actor'), 'policy_summary authorized_next_actor is out of sync with execution-ledger.json')
except Exception as exc:
    check(False, f'failed to cross-check structured workflow state: {exc}')

# Validate runtime-output example against schema
runtime_example = load_json(TEMPLATES / '.ai/contracts/runtime-output.example.json')
schema_check(runtime_validator, runtime_example, 'templates/.ai/contracts/runtime-output.example.json', True)

# Validate commands and prompts coverage
commands_dir = TEMPLATES / '.opencode/commands'
prompts_dir = TEMPLATES / '.opencode/prompts'
required_commands = [line.strip() for line in read(FRAMEWORK_TESTS / 'contracts/required-commands.txt').splitlines() if line.strip()]
required_prompts = [line.strip() for line in read(FRAMEWORK_TESTS / 'contracts/required-prompts.txt').splitlines() if line.strip()]
command_agent_map = load_json(FRAMEWORK_TESTS / 'contracts/command-agent-map.json')
for name in required_commands:
    path = commands_dir / f'{name}.md'
    check(path.exists(), f'missing command: {path.relative_to(ROOT)}')
    if path.exists():
        content = read(path)
        check('Output Schema Contract' in content or 'output-schema.md' in content, f'command missing output schema reference: {path.relative_to(ROOT)}')
        check('.json' in content, f'command missing JSON-state usage: {path.relative_to(ROOT)}')
        check('runtime-output.schema.json' in content, f'command missing runtime output schema reference: {path.relative_to(ROOT)}')
        check('Return exactly one JSON object' in content, f'command missing strict JSON-only rule: {path.relative_to(ROOT)}')
        check('execution-policy.json' in content, f'command missing execution policy reference: {path.relative_to(ROOT)}')
        expected_agent = command_agent_map.get(name)
        check(bool(expected_agent), f'no command-agent contract declared for {name}')
        if expected_agent:
            check(f'agent: {expected_agent}' in content, f'command agent mismatch in {path.relative_to(ROOT)}; expected {expected_agent}')

for name in required_prompts:
    path = prompts_dir / f'{name}.md'
    check(path.exists(), f'missing prompt: {path.relative_to(ROOT)}')

# Validate stack packs
stacks_dir = TEMPLATES / '.ai/stacks'
stack_ids = []
for path in sorted(stacks_dir.glob('*/stack.json')):
    data = load_json(path)
    stack_id = data.get('stack-id')
    stack_ids.append(stack_id)
    checks = data.get('mandatory_checks', [])
    check(bool(stack_id), f'stack-id missing in {path.relative_to(ROOT)}')
    check(bool(checks), f'mandatory_checks missing in {path.relative_to(ROOT)}')
    for entry in checks:
        check(all(key in entry for key in ['id', 'command', 'required']), f'invalid mandatory check entry in {path.relative_to(ROOT)}')
check(set(stack_ids) == {'sveltekit-web', 'fastapi-api', 'python-automation'}, 'stack packs are incomplete or renamed unexpectedly')

# Validate fixture manifests and their stack bindings
for manifest_path in sorted((FRAMEWORK_TESTS / 'fixtures').glob('*/fixture.manifest.json')):
    manifest = load_json(manifest_path)
    check(manifest.get('stack_id') in stack_ids, f'fixture manifest uses unknown stack: {manifest_path.relative_to(ROOT)}')
    for rel in manifest.get('required_paths', []):
        check((TEMPLATES / rel).exists(), f'fixture manifest references missing template path: {manifest_path.relative_to(ROOT)} -> {rel}')
    for cmd in manifest.get('required_commands', []):
        check(cmd.startswith('/'), f'fixture manifest contains invalid command name: {manifest_path.relative_to(ROOT)} -> {cmd}')
        check((commands_dir / f'{cmd[1:]}.md').exists(), f'fixture manifest references missing command: {manifest_path.relative_to(ROOT)} -> {cmd}')

# Validate opencode config references
config = load_json(TEMPLATES / 'opencode.json')
instructions = config.get('instructions', [])
for item in ['.ai/contracts/*.md', '.ai/specs/*.md', '.ai/workflows/*.md', '.ai/agents/*.md', '.ai/review/*.md', '.ai/stacks/*/README.md', '.ai/contracts/*.json', '.ai/state/*.json']:
    warn(item in instructions, f'opencode.json missing recommended instruction glob: {item}')

# Validate strict JSON runtime prompt rules
shared_runtime = read(TEMPLATES / '.opencode/prompts/vc-runtime-rules.md')
check('Return exactly one JSON object' in shared_runtime, 'shared runtime rules missing strict JSON output instruction')
check('.ai/state/workflow-state.json' in shared_runtime, 'shared runtime rules missing workflow-state reference')
check('execution-policy.json' in shared_runtime, 'shared runtime rules missing execution policy reference')
for path in sorted(prompts_dir.glob('vc-*.md')):
    if path.name == 'vc-runtime-rules.md':
        continue
    content = read(path)
    check('vc-runtime-rules.md' in content, f'prompt does not inherit shared runtime rules: {path.relative_to(ROOT)}')

# Validate prompt registry consistency
prompt_registry = load_json(TEMPLATES / '.ai/contracts/prompt-registry.json')
check(prompt_registry.get('runtime_source_of_truth') == '.opencode', 'prompt registry runtime source of truth is invalid')
check(prompt_registry.get('shared_runtime_prompt') == '.opencode/prompts/vc-runtime-rules.md', 'prompt registry shared runtime prompt is invalid')
for agent_id, rel_path in prompt_registry.get('agents', {}).items():
    check((TEMPLATES / rel_path).exists(), f'prompt registry references missing runtime prompt for {agent_id}: {rel_path}')

# Schema scenario tests: positive and negative
for path in sorted((FRAMEWORK_TESTS / 'scenarios/runtime-output').glob('*.json')):
    schema_check(runtime_validator, load_json(path), str(path.relative_to(ROOT)), path.name.startswith('valid-'))
for path in sorted((FRAMEWORK_TESTS / 'scenarios/workflow-state').glob('*.json')):
    schema_check(workflow_validator, load_json(path), str(path.relative_to(ROOT)), path.name.startswith('valid-'))

# Golden-run validation for three stacks
for path in sorted((FRAMEWORK_TESTS / 'golden-runs').glob('*/*.json')):
    payload = load_json(path)
    schema_check(runtime_validator, payload, str(path.relative_to(ROOT)), True)

# Smoke test generator in offline mode for scaffold integrity
scaffold_dir = ROOT / '.tmp-framework-smoke'
if scaffold_dir.exists():
    subprocess.run(['rm', '-rf', str(scaffold_dir)], check=False)
scaffold_dir.mkdir(parents=True, exist_ok=True)
cmd = [
    'bash', str(ROOT / 'scripts/new-ai-app.sh'), 'smoke-app', str(scaffold_dir),
    '--template-root', str(TEMPLATES), '--no-install', '--no-dev-deps', '--no-tailwind', '--no-git', '--quiet'
]
result = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True, timeout=30)
check(result.returncode == 0, f'new-ai-app.sh smoke test failed: {result.stderr.strip() or result.stdout.strip()}')
project_dir = scaffold_dir / 'smoke-app'
if project_dir.exists():
    expected = [
        project_dir / '.ai/state/current-task.json',
        project_dir / '.ai/stacks/sveltekit-web/stack.json',
        project_dir / '.opencode/commands/intake.md',
        project_dir / 'README.md',
    ]
    for path in expected:
        check(path.exists(), f'smoke project missing expected file: {path.relative_to(ROOT)}')
else:
    check(False, 'smoke project was not created')

# Clean up temporary smoke artifacts after validation
if scaffold_dir.exists():
    subprocess.run(['rm', '-rf', str(scaffold_dir)], check=False)

print('Framework validation report')
print(f'Failures: {len(FAILURES)}')
print(f'Warnings: {len(WARNINGS)}')
if FAILURES:
    for item in FAILURES:
        print(f'FAIL: {item}')
if WARNINGS:
    for item in WARNINGS:
        print(f'WARN: {item}')

sys.exit(1 if FAILURES else 0)
