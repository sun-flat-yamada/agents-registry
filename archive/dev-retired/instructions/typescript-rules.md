---
description: Code quality rules for TypeScript files under src/ and tests/.
applyTo: "src/**/*.ts, tests/**/*.ts"
---
# TypeScript Style Rules

When authoring or modifying TypeScript code, strictly adhere to these rules:

- **Strict Type Checking**: Do not bypass strict mode. Always enable and fix compilation warnings.
- **No `any` Type**: Avoid using the `any` keyword. Instead, define strict interfaces, types, or use `unknown` if the type is dynamic.
- **Prefer Async/Await**: Use `async/await` syntax instead of chaining raw `.then()` and `.catch()` promises.
- **Single Responsibility Principle**: Keep classes and functions small. Do not create functions that exceed 50 lines.
