# Effective C# Guidelines

Rules and idioms derived from *Effective C#* and *More Effective C#* by Bill Wagner.

## 1. C# Language Idioms
- **Prefer `readonly` variables to `const` constants.**
  - Use `readonly` for variables whose value is resolved at runtime (dynamic constants), allowing library updates without recompilation of clients.
  - Use `const` only for compile-time constants (e.g., math constants, physical constants) that never change.
- **Prefer the `is` or `as` operators to casts.**
  - Use `as` for reference types to safely attempt a cast, checking for `null` afterward.
  - Avoid raw C-style casting, which throws `InvalidCastException` if the cast fails.
- **Prefer Query Syntax or LINQ method syntax to loop constructs.**
  - Use LINQ to perform collection manipulation in a declarative, readable, and highly optimized manner.

## 2. Resource Management
- **Understand the difference between Value Types and Reference Types.**
  - Use value types (`struct`) for small, immutable, simple data structures.
  - Use reference types (`class`) for object hierarchies and mutable state.
- **Ensure that resource-managing classes implement `IDisposable`.**
  - Implement `IDisposable` and the standard dispose pattern for any class that holds unmanaged resources or other disposable instances.
  - Always clean up resource ownership in `Dispose()`.
- **Always use `using` statements or declarations for disposable objects.**
  - Wrap disposable objects in a `using` statement or block to guarantee `Dispose()` is called even if an exception occurs.

## 3. Designing Better APIs
- **Minimize mutability of types.**
  - Prefer immutable types (e.g. `readonly struct`, `record`) to mutable types for simpler state management and thread safety.
- **Define interfaces rather than base classes when extending APIs.**
  - Interfaces provide more flexibility and allow multiple inheritance of contracts.
- **Avoid returning internal references or mutable collections.**
  - Return `IReadOnlyList<T>` or `IEnumerable<T>` instead of raw arrays or `List<T>` to prevent external modification.
- **Use properties instead of accessible data members.**
  - Properties allow encapsulation of data validation and internal representation changes.
