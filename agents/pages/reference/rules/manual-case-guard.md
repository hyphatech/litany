# manual-case-guard

case body that is immediately an if-then-else

<!-- Written by docs/catalog.ts from `litany explain manual-case-guard`; never edited by hand. -->

**pedantic · warning · nursery · since 1.0 · fix: never · off by default**

A case whose right-hand side is immediately `if c then a else b` can
often become two cases with a `when` guard, letting each outcome carry
its own pattern.

```ocaml
(* bad *)  | [x] -> if x > 0 then 1 else 2
(* good *) | [x] when x > 0 -> 1 | [_] -> 2
```

Fires on each guard-less case of a `match` or `function` whose body is
exactly an `if` with an `else` branch, anchored at the `if`. Cases that
already carry a guard (the author knows the feature), else-less `if`s
(the guard rewrite has no arm for the implicit unit), `if`s that are
only a subexpression of the body, and `try` handlers — where a failing
guard falls through to re-raise, a semantic trap the suggestion must
not walk users into — deliberately do not fire. No fix: the rewrite
restructures cases and changes exhaustiveness warnings.

Pedantic: the rewrite often duplicates a non-trivial binding pattern,
re-evaluates an effectful condition, or explodes a three-way chain into
duplicated arms, so whether it reads better is a house's opinion.
