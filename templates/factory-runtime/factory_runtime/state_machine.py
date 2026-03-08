from __future__ import annotations

from pathlib import Path
from typing import Any

from .json_io import read_json


class StateMachine:
    def __init__(self, project_root: Path) -> None:
        self.project_root = project_root
        self.definition = read_json(project_root / ".ai" / "contracts" / "runtime-state-machine.json")
        self.states = self.definition["states"]
        self.allowed = self.definition["allowed_transitions"]

    def initial_state(self) -> str:
        return self.definition["initial_state"]

    def can_transition(self, current_state: str, next_state: str) -> bool:
        return next_state in self.allowed.get(current_state, [])

    def validate_transition(self, current_state: str, next_state: str) -> None:
        if not self.can_transition(current_state, next_state):
            raise ValueError(f"forbidden state transition: {current_state} -> {next_state}")

    def describe_state(self, state: str) -> dict[str, Any]:
        return self.states[state]
