# suspicious-rec-without-recursion

let rec group that never recurses

<!-- Written by docs/catalog.ts from `litany explain suspicious-rec-without-recursion`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: sometimes · on by default**

A `let rec` whose bindings never reference the group is wearing a
costume: the reader budgets for recursion that never happens, and the
`rec` silently changes which same-named outer bindings the bodies see.
The compiler's warning 39 makes the same judgment — off in the vanilla
compiler, an error under dune's dev profile, so this rule's yield is
non-dune workspaces and permissive configurations — but cannot repair
it.

```ocaml
(* bad *)  let rec parse s = lex s in parse input
(* good *) let parse s = lex s in parse input
```

Fires once per `let rec` group — structure-level items and
expression-level `let … in` alike — none of whose bindings references
any binding of the group, proved by declaration identity: a use of a
group identity anywhere inside a group body blocks the finding however
deeply nested, while a same-spelled inner rebinding is a different
identity and never counts. Uses after the group — in the `in` body or
later in the unit — do not block; they are what the binding is for.
Partially recursive groups (`let rec f x = f x and g y = y`) never
fire: dropping `rec` is not their remedy, splitting the group is.
Class-body groups are a recorded false negative — the group dispatch
does not see them. The fix deletes the `rec`
keyword when the unit is not preprocessed and exactly whitespace,
`let`, whitespace, `rec`, whitespace separates the group start from
its first pattern — an attribute or comment there refuses the fix,
never the finding. The identity proof is what makes the deletion safe:
no body resolves any group name, so removing those names from the
bodies' scope retargets nothing.
