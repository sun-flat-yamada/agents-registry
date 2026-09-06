# Effective C++ Guidelines

Rules and idioms derived from *Effective C++* and *More Effective C++* by Scott Meyers.

## 1. Accustoming Yourself to C++
- **Prefer const, enum, and inline to `#define`.**
  - Replace macro constants with `const` objects or `enum` types to ensure compiler type checking and scoping.
  - Replace macro functions with template `inline` functions to avoid macro side-effects.
- **Use `const` whenever possible.**
  - Apply `const` to pointers, function parameters, return types, and member functions to enforce read-only semantics.
  - Declare member functions `const` if they do not modify the object's logical state.
- **Ensure that objects are initialized before they're used.**
  - Always initialize data members in constructor member initialization lists.
  - Initialize them in the order of their declaration in the class.

## 2. Constructors, Destructors, and Assignment Operators
- **Declare destructors virtual in polymorphic base classes.**
  - If a class has any virtual functions, it should have a virtual destructor.
  - If a class is not designed to be a base class, do not declare its destructor virtual.
- **Prevent exceptions from leaving destructors.**
  - Catch all exceptions inside destructors and swallow or terminate the program. Destructors should never throw exceptions.
- **Never call virtual functions during construction or destruction.**
  - Virtual functions called during base class construction or destruction resolve to the base class implementation, not the derived class implementation.

## 3. Resource Management
- **Use objects to manage resources (RAII).**
  - Wrap heap resources in smart pointers (`std::unique_ptr`, `std::shared_ptr`) or RAII containers immediately upon acquisition.
- **Release resources in destructors.**
  - Ensure every resource acquired in a constructor is freed in the corresponding destructor.
- **Think carefully about copying behavior in resource-managing classes.**
  - Explicitly define copy constructor and copy assignment operator or delete them (`= delete`) if copying is not permitted.

## 4. Designs and Declarations
- **Make interfaces easy to use correctly and hard to use incorrectly.**
  - Introduce custom types to prevent passing incorrect arguments (e.g. wrapper structs for Day/Month/Year).
  - Constrain parameter values where possible.
- **Prefer pass-by-reference-to-const to pass-by-value.**
  - Pass user-defined types (classes/structs) by reference-to-const to avoid copying overhead and slicing problems.
  - Pass built-in types, iterators, and function objects by value.

## 5. Implementations
- **Postpone variable definitions as long as possible.**
  - Do not define a variable until you are ready to initialize and use it to avoid unnecessary construction/destruction overhead.
- **Minimize casting.**
  - Avoid `dynamic_cast` where possible; use virtual functions instead.
  - Use C++ style casts (`static_cast`, `const_cast`, `reinterpret_cast`) instead of C-style casts.
