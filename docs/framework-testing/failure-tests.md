# Failure Tests

Failure-oriented scenarios are stored under `framework-tests/scenarios/`.

## Purpose

These scenarios intentionally violate schema or state expectations so the validator can prove that bad inputs are rejected.

## Current scenario classes
- runtime-output positive and negative cases
- workflow-state positive and negative cases

## Why this matters

A framework that only validates happy-path examples is fragile. Negative scenarios are required to prove that the contracts are actually enforced.
