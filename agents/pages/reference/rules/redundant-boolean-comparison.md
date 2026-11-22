# redundant-boolean-comparison

comparison with a boolean constant

<!-- Written by docs/catalog.ts from `litany explain redundant-boolean-comparison`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: sometimes · on by default**

Comparing a boolean with `true` or `false` restates the operand:
`x = true` is `x`, `x = false` is `not x`. The comparison adds noise and
often signals a leftover simplification.

```ocaml
(* bad *)  if flag = true then …
(* good *) if flag then …
```

Fires when `=` or `<>` resolves to its `Stdlib` declaration, is applied to
exactly two unlabeled arguments, and exactly one operand is a literal
`true` or `false` of the predefined `bool` type, in either operand order.
Shadowed or rebound operators, comparisons of two constants, other
operators (`==`, `<`, `Bool.equal`), and same-spelling constructors of
another type deliberately do not fire. The fix drops the constant: the
comparison becomes the operand itself (`x = true` → `x`, safe) or its
negation (`x = false` → `not x`, `x <> true` → `not x`) — the negation
splices a `not` the rule never resolved, so a fix-site scope shadowing
`not` would change the value: that cell's fix is unsafe, applied only
under `--fix --unsafe`. Either fix ships only when the operand's source
slices cleanly (`Unit.splice`).
