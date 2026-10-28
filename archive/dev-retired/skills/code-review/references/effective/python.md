# Effective Python Guidelines

Rules and idioms derived from *Effective Python* by Brett Slatkin.

## 1. Pythonic Thinking
- **Follow the PEP 8 style guide.**
  - Use 4 spaces for indentation, snake_case for functions/variables, PascalCase for classes, and UPPER_CASE for constants.
- **Prefer formatted string literals (f-strings) over C-style formatting and `str.format`.**
  - f-strings are cleaner, more concise, and faster.
- **Write helper functions instead of complex expressions.**
  - If a one-liner expression is too complex to read, break it out into a helper function with proper naming.
- **Prefer `get` or `setdefault` over handling KeyErrors.**
  - Use `dict.get(key, default)` or `defaultdict` for safer dictionary access.

## 2. Functions and Generators
- **Never use mutable default arguments.**
  - Use `None` as the default value and document it in the docstring. Initialize the mutable object (e.g. `list`, `dict`) inside the function body.
- **Use keyword-only and positional-only arguments.**
  - Enforce explicit parameter names for configuration options, and prevent caller bindings for positional arguments.
- **Prefer generators to returning lists.**
  - Return generators (`yield`) for large sequence processors to avoid high memory consumption and improve performance.

## 3. Classes and Interfaces
- **Prefer helper classes over dicts and tuples.**
  - Do not nest dictionaries or tuples too deeply. Refactor into lightweight helper classes or named tuples.
- **Use `property` instead of getter and setter methods.**
  - Write standard public attributes first. If behavior needs encapsulation later, wrap it in `@property`.
- **Use `super()` to initialize parent classes.**
  - Call `super().__init__()` instead of calling parent class constructors directly to handle diamond-shaped inheritance hierarchies correctly.
- **Prefer public attributes over private ones.**
  - Use single leading underscore `_var` for protected members. Do not use double leading underscores `__var` (private) unless naming conflicts are an actual risk.
