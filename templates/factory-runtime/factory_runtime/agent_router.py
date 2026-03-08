from __future__ import annotations

from pathlib import Path
from typing import Any

from .artifact_registry import ArtifactRegistry
from .json_io import read_json, write_json
from .models import StepResult, utc_now


class AgentRouter:
    def __init__(self, project_root: Path) -> None:
        self.project_root = project_root
        self.registries = ArtifactRegistry(project_root)
        self.interfaces = read_json(project_root / ".ai" / "agents" / "interfaces" / "registry.json")

    def execute(self, agent_id: str, step: dict[str, Any], context: dict[str, Any]) -> StepResult:
        handler = getattr(self, f"_handle_{step['action']}", None)
        if handler is None:
            return StepResult(status="failed", message=f"No handler for action {step['action']}", failure_class="missing_required_input", severity="high")
        return handler(agent_id, step, context)

    def _handle_normalize_intake(self, agent_id: str, step: dict[str, Any], context: dict[str, Any]) -> StepResult:
        request = context["parameters"].get("request", "")
        project = context["project"] or context["parameters"].get("project")
        if not request or not project:
            return StepResult(status="failed", message="request and project are required", failure_class="missing_required_input", severity="high")
        task_state = {
            "project": project,
            "request": request,
            "workflow": context["workflow_id"],
            "next_action": "select-blueprint",
            "updated_at": utc_now(),
        }
        write_json(self.project_root / ".ai" / "state" / "current-task.json", task_state)
        return StepResult(status="passed", state_updates={"current_task": task_state}, artifacts_written=[".ai/state/current-task.json"], message="intake normalized")

    def _handle_select_blueprint(self, agent_id: str, step: dict[str, Any], context: dict[str, Any]) -> StepResult:
        request = context["parameters"].get("request", "").lower()
        if any(token in request for token in ["api", "backend", "service"]):
            blueprint = "api-platform"
        elif any(token in request for token in ["automation", "script", "job"]):
            blueprint = "ai-agent-system"
        else:
            blueprint = context["parameters"].get("blueprint", "saas-webapp")
        factory_state_path = self.project_root / ".ai" / "state" / "factory-state.json"
        factory_state = read_json(factory_state_path, default={})
        factory_state["active_blueprint"] = blueprint
        factory_state["updated_at"] = utc_now()
        write_json(factory_state_path, factory_state)
        self.registries.upsert("blueprints", "blueprint_id", {"blueprint_id": blueprint, "selected_at": utc_now(), "project": context["project"]})
        return StepResult(status="passed", state_updates={"active_blueprint": blueprint}, artifacts_written=[".ai/state/factory-state.json", ".factory/registries/blueprints.json"], message=f"blueprint selected: {blueprint}")

    def _handle_initialize_project(self, agent_id: str, step: dict[str, Any], context: dict[str, Any]) -> StepResult:
        project = context["project"]
        if not project:
            return StepResult(status="failed", message="project is required", failure_class="missing_required_input", severity="high")
        self.registries.upsert("projects", "project_id", {
            "project_id": project,
            "blueprint": read_json(self.project_root / ".ai" / "state" / "factory-state.json", default={}).get("active_blueprint"),
            "status": "initialized",
            "initialized_at": utc_now(),
        })
        portfolio_path = self.project_root / ".ai" / "projects" / "project-portfolio.json"
        portfolio = read_json(portfolio_path, default={"projects": []})
        if not any(item.get("id") == project for item in portfolio.get("projects", [])):
            portfolio.setdefault("projects", []).append({"id": project, "status": "initialized", "created_at": utc_now()})
            write_json(portfolio_path, portfolio)
        factory_state_path = self.project_root / ".ai" / "state" / "factory-state.json"
        factory_state = read_json(factory_state_path, default={})
        factory_state["active_project"] = project
        factory_state["active_pipeline"] = context["workflow_id"]
        factory_state["updated_at"] = utc_now()
        write_json(factory_state_path, factory_state)
        return StepResult(status="passed", state_updates={"active_project": project}, artifacts_written=[".factory/registries/projects.json", ".ai/projects/project-portfolio.json", ".ai/state/factory-state.json"], message=f"project initialized: {project}")

    def _handle_plan_module(self, agent_id: str, step: dict[str, Any], context: dict[str, Any]) -> StepResult:
        module = context["parameters"].get("module")
        project = context["project"]
        if not module or not project:
            return StepResult(status="failed", message="module and project are required", failure_class="missing_required_input", severity="high")
        plan = {
            "project": project,
            "module": module,
            "workflow": context["workflow_id"],
            "steps": ["implement", "test", "review"],
            "mandatory_checks": ["workflow_definition_exists", "module_plan_exists"],
            "updated_at": utc_now(),
        }
        write_json(self.project_root / ".ai" / "state" / "plan.json", plan)
        self.registries.upsert("modules", "module_id", {"module_id": f"{project}:{module}", "project": project, "module": module, "status": "planned", "updated_at": utc_now()})
        return StepResult(status="passed", state_updates={"plan": plan}, artifacts_written=[".ai/state/plan.json", ".factory/registries/modules.json"], message=f"module planned: {module}")

    def _handle_build_module(self, agent_id: str, step: dict[str, Any], context: dict[str, Any]) -> StepResult:
        project = context["project"]
        module = context["parameters"].get("module")
        if not module or not project:
            return StepResult(status="failed", message="module and project are required", failure_class="missing_required_input", severity="high")
        build_dir = self.project_root / "src" / "generated" / module
        build_dir.mkdir(parents=True, exist_ok=True)
        marker = build_dir / "FACTORY_BUILD.md"
        marker.write_text(
            f"# Generated module marker\n\nProject: {project}\nModule: {module}\nGenerated by deterministic factory runtime.\n",
            encoding="utf-8",
        )
        self.registries.upsert("build_runs", "build_id", {"build_id": f"{context['run_id']}:{module}", "project": project, "module": module, "status": "built", "built_at": utc_now()})
        return StepResult(status="passed", artifacts_written=[str(marker.relative_to(self.project_root)), ".factory/registries/build-runs.json"], message=f"module built: {module}", metrics={"generated_files": 1})

    def _handle_run_quality_gates(self, agent_id: str, step: dict[str, Any], context: dict[str, Any]) -> StepResult:
        return StepResult(status="passed", message="quality gates delegated to runtime engine")

    def _handle_prepare_release(self, agent_id: str, step: dict[str, Any], context: dict[str, Any]) -> StepResult:
        release_id = context["parameters"].get("release_id")
        project = context["project"]
        if not release_id or not project:
            return StepResult(status="failed", message="release_id and project are required", failure_class="missing_required_input", severity="high")
        self.registries.upsert("releases", "release_id", {"release_id": release_id, "project": project, "status": "prepared", "prepared_at": utc_now()})
        return StepResult(status="passed", artifacts_written=[".factory/registries/releases.json"], message=f"release prepared: {release_id}")

    def _handle_record_deployment_state(self, agent_id: str, step: dict[str, Any], context: dict[str, Any]) -> StepResult:
        release_id = context["parameters"].get("release_id")
        self.registries.upsert("deployment_states", "deployment_id", {"deployment_id": f"{release_id}:staged", "release_id": release_id, "status": "release_ready", "updated_at": utc_now()})
        return StepResult(status="passed", artifacts_written=[".factory/registries/deployment-states.json"], message="deployment state recorded")

    def _handle_collect_monitoring_feedback(self, agent_id: str, step: dict[str, Any], context: dict[str, Any]) -> StepResult:
        return StepResult(status="passed", message="monitoring feedback window opened")
