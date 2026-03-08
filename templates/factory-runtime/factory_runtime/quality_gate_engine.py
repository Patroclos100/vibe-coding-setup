from __future__ import annotations

from pathlib import Path
from typing import Any

from .json_io import read_json


class QualityGateEngine:
    def __init__(self, project_root: Path) -> None:
        self.project_root = project_root
        self.definition = read_json(project_root / ".ai" / "contracts" / "quality-gates.json")

    def evaluate(self, command: str, context: dict[str, Any]) -> list[dict[str, Any]]:
        results: list[dict[str, Any]] = []
        for gate in self.definition.get("gates", []):
            applies_to = set(gate.get("applies_to", []))
            if applies_to and command not in applies_to:
                continue
            actual = self._evaluate_gate(gate, context)
            results.append(actual)
        return results

    def _evaluate_gate(self, gate: dict[str, Any], context: dict[str, Any]) -> dict[str, Any]:
        metric = gate["metric"]
        threshold = gate.get("threshold")
        status = "passed"
        observed: Any = None
        if metric == "project_registered":
            observed = bool(context.get("project_registered"))
            status = "passed" if observed else "failed"
        elif metric == "module_plan_exists":
            observed = bool(context.get("module_plan_exists"))
            status = "passed" if observed else "failed"
        elif metric == "workflow_definition_exists":
            observed = bool(context.get("workflow_definition_exists"))
            status = "passed" if observed else "failed"
        elif metric == "rollback_checkpoint_available":
            observed = bool(context.get("rollback_checkpoint_available"))
            status = "passed" if observed else "failed"
        elif metric == "release_approval_present":
            observed = bool(context.get("release_approval_present"))
            status = "passed" if observed else "failed"
        elif metric == "test_coverage":
            observed = float(context.get("test_coverage", 0.0))
            status = "passed" if observed >= float(threshold) else "failed"
        elif metric == "lint_status":
            observed = context.get("lint_status", "unknown")
            status = "passed" if observed == "passed" else "failed"
        elif metric == "dependency_risk_score":
            observed = float(context.get("dependency_risk_score", 100.0))
            status = "passed" if observed <= float(threshold) else "failed"
        else:
            observed = "not_implemented"
            status = "failed"
        return {
            "id": gate["id"],
            "name": gate["name"],
            "classification": gate["classification"],
            "status": status,
            "metric": metric,
            "observed": observed,
            "threshold": threshold,
            "runtime_response": gate["runtime_response"],
        }
