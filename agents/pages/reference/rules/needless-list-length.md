# needless-list-length

List.length compared with 0 or 1 to test emptiness

<!-- Written by docs/catalog.ts from `litany explain needless-list-length`; never edited by hand. -->

**perf · warning · stable · since 1.0 · fix: sometimes · on by default**

Comparing `List.length` with a constant zero or one to ask "is this
list empty?" walks the whole list to answer a constant-time question.

```ocaml
(* bad *)  if List.length xs = 0 then …
(* good *) if xs = [] then …
```

Fires only when `List.length` and the comparison operator both resolve to
their `Stdlib` declarations and the relation is logically equivalent to
emptiness or non-emptiness: `length = 0`, `length <> 0`, `length > 0`,
`length <= 0`, `length >= 1`, `length < 1`, in either operand order.
Shadowed or rebound names, other constants (`= 1` is a singleton test, not
an emptiness test), relations that are always or never true (`< 0`,
`>= 0`), and non-literal operands deliberately do not fire. The fix
(`compare with []`) rewrites to `xs = []` or `xs <> []`, preserving the
relation's polarity; it ships only when the operand's source slices
cleanly (`Unit.splice`). It is safe only in the cells whose matched
operator is the spliced one (`= 0` and `<> 0`, either operand order):
there the spliced spelling just resolved to its `Stdlib` declaration at
this very spot. The other cells splice an operator the rule never
resolved — a fix-site scope shadowing `=` or `<>` would change the
value — so their fix is unsafe, applied only under `--fix --unsafe`.
