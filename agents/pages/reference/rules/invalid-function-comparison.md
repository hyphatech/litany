# invalid-function-comparison

structural comparison with a function operand

<!-- Written by docs/catalog.ts from `litany explain invalid-function-comparison`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

Structural comparison of functions is meaningless: `compare` raises
`Invalid_argument` on distinct closures, and `=` either raises or answers
by physical identity.

```ocaml
(* bad *)  f = g
(* good *) compare by a key the functions carry, or track identity
           explicitly
```

Fires when `=`, `<>`, `<`, `>`, `<=`, `>=`, `compare`, `min`, or `max`
resolves to its `Stdlib` declaration, is applied to exactly two unlabeled
arguments, and an operand's type is a function arrow. Shadowed or rebound
comparisons, physical equality, partial applications, and operands whose
arrow type hides behind an abbreviation deliberately do not fire. No fix:
a meaningful comparison needs domain-specific intent.
