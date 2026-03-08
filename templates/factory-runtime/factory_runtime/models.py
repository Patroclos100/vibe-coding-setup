from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Any
import uuid


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def new_run_id() -> str:
    return f"run-{uuid.uuid4().hex[:12]}"


@dataclass
class RuntimeDecision:
    allowed: bool
    action: str
    reason: str
    next_state: str | None = None
    next_actor: str | None = None
    severity: str = "low"
    failure_class: str = "none"


@dataclass
class StepResult:
    status: str
    state_updates: dict[str, Any] = field(default_factory=dict)
    artifacts_written: list[str] = field(default_factory=list)
    quality_signals: dict[str, Any] = field(default_factory=dict)
    message: str = ""
    failure_class: str = "none"
    severity: str = "low"
    retryable: bool = False
    metrics: dict[str, Any] = field(default_factory=dict)


@dataclass
class RunContext:
    run_id: str
    command: str
    workflow_id: str
    project: str | None
    requested_by: str = "runtime-cli"
    parameters: dict[str, Any] = field(default_factory=dict)
