from __future__ import annotations

from pathlib import Path
from typing import Any

from .json_io import append_jsonl, read_json, write_json
from .models import utc_now


class RunStore:
    def __init__(self, project_root: Path) -> None:
        self.project_root = project_root
        self.runs_root = project_root / ".factory" / "runs"

    def start_run(self, run_id: str, payload: dict[str, Any]) -> Path:
        run_dir = self.runs_root / run_id
        run_dir.mkdir(parents=True, exist_ok=True)
        payload = {**payload, "started_at": utc_now(), "updated_at": utc_now()}
        write_json(run_dir / "run.json", payload)
        return run_dir

    def load_run(self, run_id: str) -> dict[str, Any]:
        return read_json(self.runs_root / run_id / "run.json")

    def save_run(self, run_id: str, payload: dict[str, Any]) -> None:
        payload["updated_at"] = utc_now()
        write_json(self.runs_root / run_id / "run.json", payload)

    def append_event(self, run_id: str, event: dict[str, Any]) -> None:
        event = {**event, "timestamp": utc_now()}
        append_jsonl(self.runs_root / run_id / "events.jsonl", event)

    def list_runs(self) -> list[dict[str, Any]]:
        runs: list[dict[str, Any]] = []
        if not self.runs_root.exists():
            return runs
        for path in sorted(self.runs_root.glob('*/run.json')):
            runs.append(read_json(path))
        return runs
