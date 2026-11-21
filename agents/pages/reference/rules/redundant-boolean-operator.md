# redundant-boolean-operator

boolean operator with a constant operand

<!-- Written by docs/catalog.ts from `litany explain redundant-boolean-operator`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

A `&&` or `||` with a literal `true` or `false` operand computes
nothing the other operand does not already say: `x && true` is `x`,
`false || x` is `x`, `false && e` is `false` with `e` never evaluated.

```ocaml
(* bad *)  enabled && true
(* good *) enabled
```

Fires when `&&` or `||` resolves to its `Stdlib` declaration, is applied
to exactly two unlabeled arguments, exactly one operand is a literal
`true` or `false`, and dropping the operator preserves what the program
evaluates: any constant on the left (short-circuiting already decided
what runs), a neutral constant on the right (`&& true`, `|| false`), or
an absorbing constant on the right (`&& false`, `|| true`) only when the
discarded left operand is a bare identifier or constant and so provably
pure. Shadowed operators, two-constant operations, and absorbing cases
whose discarded operand could have effects deliberately do not fire. No
automatic fix.
