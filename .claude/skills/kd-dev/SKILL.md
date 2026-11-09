---
name: kd-dev
description: Top-level development workflow. Use this whenever writing, modifying, refactoring, or reviewing code in any language, even for small changes. It routes to kd-code-style (always, for all code) and kd-backend-structure (for backend/server code such as APIs, services, handlers, database or external API access). Invoke before writing any code, even if the user does not mention style or architecture.
---

# kd-dev

Entry point for all coding work. This skill does no coding itself. It decides which sub-skills apply, then you follow them.

## Routing

| Situation | Invoke |
|---|---|
| Writing, editing, refactoring, or reviewing **any** code | `kd-code-style` |
| Backend work: HTTP/gRPC/queue handlers, business logic, database or storage access, calls to external APIs, dependency wiring | `kd-backend-structure` (in addition to `kd-code-style`) |
| Pure frontend, scripts, config, docs, or non-code tasks | `kd-code-style` only if code is being written; otherwise nothing |

If unsure whether code is "backend", treat it as backend when it handles requests, owns business rules, or touches storage or external services.

## Workflow

1. Classify the task using the table above.
2. Read each applicable sub-skill **before** writing code.
3. Inspect the existing codebase to see which layers, naming, and DI approach are already in place, and extend them instead of inventing parallel structures.
4. Write the code following the sub-skills.
5. Write or update unit tests. Dependencies are injected, so use mocks or fakes for repositories and gateways.
6. Before finishing, re-check the code against the checklist at the end of each applicable sub-skill.

## Conflicts and ambiguity

- If an existing project convention conflicts with a sub-skill, prefer consistency within the file or module you are touching, and mention the conflict briefly in your response.
- If a requirement is ambiguous (for example, which layer a piece of logic belongs to), ask the user instead of guessing.
- Do not do large unrelated refactors while completing a task. Suggest them instead.
