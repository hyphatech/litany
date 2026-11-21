# redundant-not-not

double boolean negation

<!-- Written by docs/catalog.ts from `litany explain redundant-not-not`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: sometimes · off by default**

`not (not e)` is `e`: `not` is total and effect-free, and `e` is
evaluated exactly once in both forms, so the double negation is pure
noise — usually sediment from mechanical edits.

```ocaml
(* bad *)  not (not ready)
(* good *) ready
```

Fires when both applications resolve to `Stdlib.not` or
`Stdlib.Bool.not`, in any combination; `not @@ not x` collapses to
direct applications in the typedtree and fires too. A quadruple
negation reports at two nested nodes — the fixes' spans nest and the
applier defers the conflict. Single negations, shadowed or rebound
`not`, `lnot` (integer complement), and functions that merely rhyme
deliberately do not fire. The fix replaces the whole application with
the operand, parenthesized unless atomic; it ships only when the
operand's source slices cleanly (`Unit.splice`).
