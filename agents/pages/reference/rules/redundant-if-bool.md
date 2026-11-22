# redundant-if-bool

if whose both branches are boolean literals restates the condition

<!-- Written by docs/catalog.ts from `litany explain redundant-if-bool`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: sometimes · off by default**

An `if` whose branches are the two boolean literals restates its own
condition: `if c then true else false` is `c`, and `then false else
true` is `not c`. Both rewrites preserve evaluation order and effects.

```ocaml
(* bad *)  if p x then true else false
(* good *) p x
```

Fires when the condition is not itself a boolean literal (that is
suspicious-literal-condition's finding) and both branches are boolean
literals — differing ones, by predefined-constructor identity. Equal
literals (`then true else true`) are a degenerate shape left to a
future same-arms analysis, and integer 0/1 branches and user-defined
`True`/`False` constructors deliberately do not fire. The
one-literal family (`then true else e`, and kin) is
`manual-boolean-operator`, Style and opt-in. The fix performs
the rewrite from the condition's source slice (`Unit.splice`),
parenthesizing a non-atomic slice; preprocessed units ship without
one. Only the `use the condition` cell is safe: negation splices
`not` — a spelling that resolves in the fix site's scope, which the
rule never checked — so its fix is unsafe, applied only under
`--fix --unsafe`.
