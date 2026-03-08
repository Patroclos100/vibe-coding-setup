from __future__ import annotations

from pathlib import Path
from typing import Any

from .json_io import append_jsonl
from .models import utc_now


class AuditLogger:
    def __init__(self, project_root: Path) -> None:
        self.audit_path = project_root / ".factory" / "audit" / "audit-log.jsonl"

    def record(self, run_id: str, event_type: str, payload: dict[str, Any]) -> None:
        append_jsonl(
            self.audit_path,
            {
                "timestamp": utc_now(),
                "run_id": run_id,
                "event_type": event_type,
                "payload": payload,
            },
        )
