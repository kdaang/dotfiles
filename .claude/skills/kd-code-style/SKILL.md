---
name: kd-code-style
description: Clean code principles for all code. Use whenever writing, modifying, or reviewing code in any language, covering naming, function design, error handling, comments, duplication, and testability. Normally invoked via kd-dev, but use it directly any time code is being produced.
---

# kd-code-style

Language-agnostic clean code rules. Apply them using the idioms of the language at hand.

## Naming
- Names reveal intent: `remainingBalance`, not `rb` or `data`.
- Functions are verbs (`calculateSettlement`), types and variables are nouns, booleans read as questions (`isSettled`, `hasPendingBuyIn`).
- One word per concept across the codebase (do not mix `fetch`, `get`, `retrieve` for the same thing).
- Avoid abbreviations, noise words (`Manager`, `Helper`, `Util`), and encoded types.
- Name length scales with scope: short in tiny scopes, descriptive in wide ones.

## Functions
- Do one thing, at one level of abstraction. If you can describe it only with "and", split it.
- Keep them small. Extract when a block needs a comment to explain what it does.
- Aim for 0-2 parameters; group related ones into a value object. Avoid boolean flag parameters; write two functions.
- Command-query separation: a function either changes state or returns information, not both.
- Prefer pure functions. Isolate side effects at the edges.
- Use early returns and guard clauses; keep nesting shallow (max about 2 levels).

## Structure and design
- **SRP**: one reason to change per module, class, or function.
- **Open/closed**: extend through new implementations, not edits to working code.
- **Liskov and interface segregation**: small, focused interfaces; implementations honor the contract.
- **Dependency inversion**: depend on abstractions. Inject dependencies through constructors or parameters; never construct collaborators inside business logic.
- **KISS and YAGNI**: build the simplest thing that works for current requirements. No speculative abstractions.
- **DRY, with judgment**: remove duplicated knowledge, not coincidental similarity. Wait for the third occurrence before abstracting.
- **Law of Demeter**: talk to direct collaborators, avoid `a.getB().getC().doThing()`.
- Prefer composition over inheritance.
- Prefer immutability. Make illegal states unrepresentable (use types and enums over loose strings or flags).
- Replace magic numbers and strings with named constants.

## Error handling
- Fail fast: validate inputs at boundaries and reject bad data early.
- Never swallow errors silently. Handle them, or propagate with added context.
- Use specific error types or codes rather than generic ones; do not use errors for normal control flow.
- Do not return or pass null/nil where an explicit empty value, optional, or error is clearer.

## Comments and formatting
- Code should explain *what*; comments explain *why* (intent, trade-offs, non-obvious constraints).
- Delete commented-out code and dead code. Version control remembers.
- No TODOs without context; no noisy or redundant comments.
- Follow the project's formatter and linter. Keep related code close together.
- **Write code top-down (the stepdown rule).** A caller is always defined above the functions it calls: if `a` calls `b`, then `a` comes before `b`. Order the file as the call trace reads: entry point first, then the helpers it calls, in the order they are called, each followed by its own callees. A reader should follow the flow by reading downward without scrolling back up. Where the language requires declaration before use (for example, some scripting languages or C-style forward declarations), keep this order as far as the language allows and use forward declarations or hoisting where available.

## Testing
- Every behavior change comes with tests. Tests are clean code too: one concept per test, descriptive names, arrange/act/assert.
- Tests are fast, isolated, repeatable, and self-validating. No reliance on network, clock, or global state; inject them.
- Test behavior through the public interface, not implementation details.

## Working in existing code
- Boy Scout Rule: leave the code slightly cleaner than you found it, within the scope of the task.
- Make the change easy, then make the easy change. Refactor in separate, small steps.
- Match local conventions unless they violate the rules above in a harmful way.

## Final checklist
- [ ] Names are clear and consistent
- [ ] Functions are small, single-purpose, shallow
- [ ] Dependencies are injected, not hard-coded
- [ ] Errors are handled with context, none swallowed
- [ ] No magic values, dead code, or duplicated logic
- [ ] Callers are above callees, so the file reads top-down in call order
- [ ] Comments explain why, not what
- [ ] Tests cover the new behavior
