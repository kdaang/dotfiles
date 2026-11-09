---
name: kd-backend-structure
description: Onion architecture for backend code with entities, models, handlers, controllers, gateways, repositories, and mappers, plus dependency injection. Use whenever creating or changing backend code such as API endpoints, request handlers, business logic, database or storage access, external API calls, or service wiring, in any language. Normally invoked via kd-dev.
---

# kd-backend-structure

Language-agnostic onion architecture. Dependencies point **inward only**. The core knows nothing about the outside world.

## Building blocks

| Component | Role | Knows about |
|---|---|---|
| **Entity** | Internal struct/type representing the domain. The only data shape the core uses. | Nothing external |
| **Model** | External struct/type: request/response DTOs, DB rows, third-party API payloads. | Its own boundary only |
| **Handler** | Outermost layer. Accepts the external request (HTTP, gRPC, queue message, CLI), maps it to an entity, calls the controller, maps the result back to an external model. | Models, mappers, controller |
| **Controller** | **All business logic lives here.** Orchestrates entities, repositories, and gateways. | Entities, repository and gateway interfaces only |
| **Gateway** | Makes calls to external APIs/services. Returns entities. | External models, mappers |
| **Repository** | Talks to databases/storage. Returns entities. | Storage models, mappers |
| **Mapper** | Pure transformation between a model and an entity (and back). | One model type and one entity type |

## Layers and dependency direction

```
[ Handler ]  ->  [ Controller ]  ->  [ Repository interface ] <- [ Repository impl ]
 (outer)           (core logic)       [ Gateway interface    ] <- [ Gateway impl    ]
     |                                                                |
  Mapper (request model <-> entity)               Mapper (storage/external model <-> entity)
```

- Handler -> Controller -> Entities is the request flow.
- The controller depends on **interfaces** (ports) for repositories and gateways. Concrete implementations live in the outer layer and implement those interfaces.
- Nothing in the core imports from handlers, repositories' concrete code, gateways' concrete code, models, frameworks, ORMs, or HTTP/SDK libraries.

## Rules

### Handlers
- Do only: parse/validate the request shape, map to entity, call controller, map result/error to the external response.
- No business logic, no direct DB or external calls.
- Translate controller errors into protocol-level responses (status codes, etc.) here.

### Controllers
- Contain every business rule, decision, calculation, and orchestration.
- Accept and return **entities** (and domain-level errors) only. Never see request/response models, DB rows, HTTP types, or third-party payloads.
- Reach storage through repositories and the outside world through gateways, via injected interfaces.
- Do not construct their own dependencies.

### Repositories
- One per aggregate or storage concern. Expose domain-oriented methods (`FindByID`, `SaveGame`), not generic query builders.
- Use storage models internally, map to and from entities with a mapper, and **return entities**. Storage details (SQL, ORM types, document shapes) never leak out.
- Contain no business logic, only persistence.

### Gateways
- Wrap every external API call behind a domain-oriented interface.
- Use external models internally, map with a mapper, and **return entities**. Handle transport concerns (auth, retries, timeouts, serialization) here.
- Contain no business logic. Translate external failures into domain-level errors.

### Mappers
- Pure, stateless, side-effect free, easy to unit test.
- Each mapper handles one pair of types. Place it beside the layer that owns the model (handler mappers with handlers, storage mappers with repositories, external mappers with gateways).
- Validation of business meaning belongs in the controller or entity, not the mapper.

### Entities
- Plain domain types, free of serialization tags, ORM annotations, and framework dependencies.
- May hold behavior that is intrinsic to the entity (invariants, simple derived values). Cross-entity workflows belong in controllers.

## Dependency injection
- Wire everything in a single composition root (e.g. `main`/bootstrap): build repositories and gateways, inject them into controllers, inject controllers into handlers.
- Inject through constructors (or the language's equivalent). No globals, singletons, or service locators in the core.
- Controllers depend on interfaces so tests can pass mocks or in-memory fakes.
- Inject cross-cutting inputs such as clock, ID generation, and randomness too.

## Testing strategy
- **Controller tests**: the most important. Mock/fake repositories and gateways; assert business outcomes. No network, DB, or framework required.
- **Mapper tests**: simple table-driven input/output checks.
- **Handler tests**: mock the controller; verify request parsing, mapping, and response/error translation.
- **Repository and gateway tests**: integration-style against a test DB or stubbed external service; verify mapping and error translation.

## Suggested layout (adapt to language idioms)

```
internal/
  entity/          # internal domain types
  controller/      # business logic + repository/gateway interfaces
  handler/         # inbound adapters + request/response models + mappers
  repository/      # storage implementations + storage models + mappers
  gateway/         # external API clients + external models + mappers
cmd/ or main       # composition root (dependency wiring)
```

Follow the existing project's layout if one is already established.

## Adding a feature (workflow)
1. Define or extend **entities**.
2. Write the **controller** logic and the repository/gateway **interfaces** it needs.
3. Write controller unit tests with mocks.
4. Implement **repository/gateway** (models + mappers).
5. Implement the **handler** (models + mapper).
6. Wire dependencies in the composition root.

## Anti-patterns to reject
- Business logic in handlers, repositories, gateways, or mappers.
- Controllers referencing request models, DB rows, or HTTP concepts.
- Repositories or gateways returning storage/external models.
- Controllers instantiating repositories, gateways, or clients directly.
- Shared "god" models used across the handler, storage, and core.
- Circular dependencies or outward-pointing imports from the core.

## Final checklist
- [ ] Core (entities and controllers) has no outward imports
- [ ] Handlers contain only parsing, mapping, delegation, and error translation
- [ ] All business logic is in controllers
- [ ] Repositories and gateways return entities, with mapping done internally
- [ ] Every boundary crossing goes through a mapper
- [ ] Dependencies are injected via interfaces and wired in one place
- [ ] Controllers are unit-tested with mocks
