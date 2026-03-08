# Architecture Rules

## 1. Project shape

- Routes live in `src/routes`
- Reusable UI components live in `src/lib/components`
- Shared utilities live in `src/lib/utils`
- Project-specific services live in `src/lib/services`

## 2. Allowed patterns

- small, readable modules
- explicit imports
- composition over deep abstraction
- route-local logic stays close to the route when reuse is unlikely
- shared logic is extracted only after repeated use becomes clear

## 3. Forbidden patterns

- global abstractions without proven need
- deep nesting for simple flows
- moving files only for style reasons
- giant utility files with mixed responsibilities
- silent architecture drift without documenting it

## 4. File placement rules

- place code where the next maintainer would first look for it
- keep UI primitives in `src/lib/components`
- keep route-specific code close to its route
- do not create new top-level folders without clear need

## 5. Change rules

- prefer narrow changes to existing structure
- document meaningful structure changes in `.ai/context/project-overview.md`
- do not refactor unrelated files during a feature change

## 6. Done criteria

- changed code follows current folder rules
- no unnecessary abstraction was introduced
- file placement is easy to explain
