# Example Factory Run

```bash
python3 factory-runtime/cli.py run intake --project billing-app --request "Build a billing platform with auth"
python3 factory-runtime/cli.py run build-module --project billing-app --module auth-service
python3 factory-runtime/cli.py run release --project billing-app --release-id v0.1.0
python3 factory-runtime/cli.py status
```

Expected effects:
- `.ai/state/current-task.json` is updated
- `.ai/state/plan.json` is updated for module builds
- `.factory/registries/projects.json` records the project
- `.factory/registries/build-runs.json` records the build
- `.factory/registries/quality-reports.json` records quality gate outcomes
- `.factory/runs/<run-id>/run.json` persists each run
- `.factory/audit/audit-log.jsonl` stores the execution trail
