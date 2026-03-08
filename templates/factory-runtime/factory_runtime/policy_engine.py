from __future__ import annotations

from pathlib import Path
from typing import Any

from .json_io import read_json
from .models import RuntimeDecision


class PolicyEngine:
    def __init__(self, project_root: Path) -> None:
        self.project_root = project_root
        self.policy = read_json(project_root / ".ai" / "contracts" / "execution-policy.json")
        self.transitions = read_json(project_root / ".ai" / "contracts" / "transition-matrix.json")
        self.agent_caps = read_json(project_root / ".ai" / "contracts" / "agent-capabilities.json")

    def max_retries(self, failure_class: str, severity: str) -> int:
        retry_policy = self.policy.get("retry_policy", {})
        return int(retry_policy.get(failure_class, {}).get(severity, 0))

    def evaluate_failure(self, *, failure_class: str, severity: str, attempts: int, has_checkpoint: bool) -> RuntimeDecision:
        retry_budget = self.max_retries(failure_class, severity)
        if failure_class == "unsafe_change_risk" and has_checkpoint:
            return RuntimeDecision(True, "rollback", "unsafe change detected, rollback authorized", next_state="rollback_pending", severity=severity, failure_class=failure_class)
        if attempts < retry_budget:
            return RuntimeDecision(True, "retry", "retry budget available", next_state="repair_pending", severity=severity, failure_class=failure_class)
        if failure_class in {"dependency_violation", "architecture_violation", "missing_required_input", "rollback_failure"}:
            return RuntimeDecision(True, "escalate", "policy requires escalation", next_state="escalated", severity=severity, failure_class=failure_class)
        return RuntimeDecision(True, "replan", "retry budget exhausted, replan authorized", next_state="replan_pending", severity=severity, failure_class=failure_class)

    def evaluate_success(self, current_state: str, next_state: str, actor: str | None = None) -> RuntimeDecision:
        if actor:
            allowed_actions = set(self.agent_caps.get("agents", {}).get(actor, []))
            if not allowed_actions:
                return RuntimeDecision(False, "stop", f"actor {actor} is unknown")
        return RuntimeDecision(True, "continue", "transition authorized", next_state=next_state, next_actor=actor)

    def release_blocked(self, quality_results: list[dict[str, Any]]) -> bool:
        return any(item.get("classification") == "blocker" and item.get("status") != "passed" for item in quality_results)
