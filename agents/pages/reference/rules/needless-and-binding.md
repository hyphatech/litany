# needless-and-binding

let rec binding riding an and-chain it does not need

<!-- Written by docs/catalog.ts from `litany explain needless-and-binding`; never edited by hand. -->

**style · warning · nursery · since 1.0 · fix: never · off by default**

A `let rec … and …` chain asserts co-dependence. A binding that
neither calls itself through the group nor participates in any
reference cycle with its siblings is riding a chain it doesn't need:
readers assume the bindings are entangled, and the group resists being
split or moved.

```ocaml
(* bad *)  let rec is_even n = n = 0 || is_odd (n - 1)
           and is_odd n = n <> 0 && is_even (n - 1)
           and double x = x + x
(* good *) let rec is_even n = n = 0 || is_odd (n - 1)
           and is_odd n = n <> 0 && is_even (n - 1)
           let double x = x + x
```

Fires once per binding of a recursive multi-binding group that is
mutually reachable with no sibling over the identity-resolved
reference graph — self-recursive-only bindings extract as their own
`let rec`, inert bindings as a plain `let`; the message says which.
Members of a genuine cycle never fire, and groups where no binding
references the group at all are suspicious-rec-without-recursion's
finding, never this rule's — an exact partition. Edges are proved from
the unit's use index by declaration identity, so a same-spelled inner
rebinding contributes no edge; an unplaceable use or a non-variable
pattern refuses the group conservatively. Warning 39 is silent on
every positive here (it needs the whole group inert). No fix:
extraction reorders bindings above or below the group — guidance, not
an edit.
