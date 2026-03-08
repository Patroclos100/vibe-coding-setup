from __future__ import annotations

from pathlib import Path
from typing import Any

from .json_io import read_json, write_json


class ArtifactRegistry:
    REGISTRIES = {
        "projects": ".factory/registries/projects.json",
        "modules": ".factory/registries/modules.json",
        "blueprints": ".factory/registries/blueprints.json",
        "releases": ".factory/registries/releases.json",
        "build_runs": ".factory/registries/build-runs.json",
        "policy_versions": ".factory/registries/policy-versions.json",
        "quality_reports": ".factory/registries/quality-reports.json",
        "deployment_states": ".factory/registries/deployment-states.json",
    }

    def __init__(self, project_root: Path) -> None:
        self.project_root = project_root

    def _path(self, name: str) -> Path:
        return self.project_root / self.REGISTRIES[name]

    def get(self, name: str) -> dict[str, Any]:
        return read_json(self._path(name), default={"items": []})

    def put(self, name: str, payload: dict[str, Any]) -> None:
        write_json(self._path(name), payload)

    def upsert(self, name: str, key: str, item: dict[str, Any]) -> None:
        data = self.get(name)
        items = data.setdefault("items", [])
        for idx, existing in enumerate(items):
            if existing.get(key) == item.get(key):
                items[idx] = {**existing, **item}
                self.put(name, data)
                return
        items.append(item)
        self.put(name, data)
