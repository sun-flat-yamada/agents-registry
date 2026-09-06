# Effective Java Guidelines

Rules and idioms derived from *Effective Java* (3rd Edition) by Joshua Bloch.

## 1. Creating and Destroying Objects
- **Consider static factory methods instead of constructors.**
  - Static factories have names, don't require creating a new object each time, and can return subtype instances.
- **Consider a builder when faced with many constructor parameters.**
  - Builder pattern avoids "telescoping constructors" and improves readability and safety for parameter combinations.
- **Enforce the singleton property with a private constructor or an enum type.**
  - A single-element enum type is often the best way to implement a singleton.
- **Avoid creating unnecessary objects.**
  - Reuse immutable objects, prefer primitives to boxed primitives (avoid auto-boxing overhead).

## 2. Methods Common to All Objects
- **Obey the general contract when overriding `equals`.**
  - Ensure reflexivity, symmetry, transitivity, consistency, and non-nullity.
- **Always override `hashCode` when you override `equals`.**
  - Equal objects must have equal hash codes, or collections like `HashMap` and `HashSet` will malfunction.
- **Always override `toString`.**
  - Provide a clear, informative representation for diagnostic and logging purposes.

## 3. Classes and Interfaces
- **Minimize the accessibility of classes and members.**
  - Make each class or member as inaccessible as possible (information hiding / encapsulation).
- **Minimize mutability.**
  - Make classes immutable where possible. Immutable classes are simple, thread-safe, and can be shared freely.
- **Favor composition over inheritance.**
  - Inheritance violates encapsulation unless both classes are under control of the same programmers or the base class is explicitly designed for inheritance.
- **Prefer interfaces to abstract classes.**
  - Interfaces allow multiple inheritance of contracts and are ideal for defining mixins.

## 4. Generics and Enums
- **Don't use raw types.**
  - Using raw types (e.g. `List` instead of `List<String>`) loses type safety and expressiveness.
- **Use wildcards to increase API flexibility.**
  - Remember PECS: Producer Extends, Consumer Super. Use `? extends T` for input parameters, and `? super T` for output parameters.
- **Use enums instead of int constants.**
  - Enums provide compile-time type safety and rich behavior.
