from __future__ import annotations

from pathlib import Path
from typing import Any

from .models import RunContext, new_run_id
from .run_store import RunStore
from .workflow_executor import WorkflowExecutor


class FactoryRuntime:
    def __init__(self, project_root: str | Path) -> None:
        self.project_root = Path(project_root).resolve()
        self.executor = WorkflowExecutor(self.project_root)
        self.store = RunStore(self.project_root)

    def run_command(self, command: str, **parameters: Any) -> dict[str, Any]:
        workflow_id = WorkflowExecutor.COMMAND_TO_WORKFLOW[command]
        run = RunContext(
            run_id=new_run_id(),
            command=command,
            workflow_id=workflow_id,
            project=parameters.get("project"),
            parameters=parameters,
        )
        return self.executor.execute(run)

    def resume(self, run_id: str) -> dict[str, Any]:
        run = self.store.load_run(run_id)
        if run.get("status") == "completed":
            return run
        return self.run_command(run["command"], **run.get("parameters", {}))

    def status(self) -> dict[str, Any]:
        runs = self.store.list_runs()
        return {
            "project_root": str(self.project_root),
            "run_count": len(runs),
            "latest_run": runs[-1] if runs else None,
        }
