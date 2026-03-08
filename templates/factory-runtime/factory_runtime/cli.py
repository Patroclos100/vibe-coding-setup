from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

from .runtime import FactoryRuntime


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="factory", description="Deterministic AI Software Factory runtime")
    parser.add_argument("--project-root", default=".", help="Project root containing .ai and .factory")
    sub = parser.add_subparsers(dest="cmd", required=True)

    run = sub.add_parser("run", help="Execute a factory workflow")
    run_sub = run.add_subparsers(dest="run_cmd", required=True)

    intake = run_sub.add_parser("intake", help="Normalize intake and initialize a product")
    intake.add_argument("--project", required=True)
    intake.add_argument("--request", required=True)
    intake.add_argument("--blueprint", default="saas-webapp")

    build = run_sub.add_parser("build-module", help="Plan and build a module")
    build.add_argument("--project", required=True)
    build.add_argument("--module", required=True)

    release = run_sub.add_parser("release", help="Prepare and validate a release")
    release.add_argument("--project", required=True)
    release.add_argument("--release-id", required=True)

    sub.add_parser("status", help="Show runtime status")

    resume = sub.add_parser("resume", help="Resume or rerun a run")
    resume.add_argument("run_id")
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    runtime = FactoryRuntime(Path(args.project_root))

    if args.cmd == "status":
        print(json.dumps(runtime.status(), indent=2))
        return 0
    if args.cmd == "resume":
        print(json.dumps(runtime.resume(args.run_id), indent=2))
        return 0
    if args.cmd == "run":
        if args.run_cmd == "intake":
            payload = runtime.run_command("intake", project=args.project, request=args.request, blueprint=args.blueprint)
        elif args.run_cmd == "build-module":
            payload = runtime.run_command("build-module", project=args.project, module=args.module)
        elif args.run_cmd == "release":
            payload = runtime.run_command("release", project=args.project, release_id=args.release_id)
        else:
            parser.error(f"unknown run command: {args.run_cmd}")
            return 2
        print(json.dumps(payload, indent=2))
        return 0
    parser.error("unknown command")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
