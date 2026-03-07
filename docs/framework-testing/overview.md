# Framework Testing Overview

The framework-testing system verifies the framework itself.

## Important boundary

Framework tests are **not** part of the normal runtime feature loop in generated projects.
They exist to answer a different question:

> Is the framework internally coherent and still enforcing the intended contracts?

## What is included
- validator-driven contract checks
- schema scenario validation
- golden-run trace validation
- fixture manifest validation
- scaffold smoke testing

## What is not implied

Passing the framework tests does not prove that every future live model run will succeed. It proves that the framework contracts, templates, mappings, and fixtures are internally consistent.
