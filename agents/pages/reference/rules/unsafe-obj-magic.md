# unsafe-obj-magic

use of Obj.magic

<!-- Written by docs/catalog.ts from `litany explain unsafe-obj-magic`; never edited by hand. -->

**restriction · warning · stable · since 1.0 · fix: never · off by default**

`Obj.magic` bypasses the type system entirely: the checker accepts
any use at any type, and a mistake becomes memory corruption at run time,
not a compile error.

```ocaml
(* bad *)  let id : 'a -> 'a = Obj.magic
(* good *) a typed interface, a GADT, or a documented unsafe module
           boundary reviewed on its own
```

Why restrict this? Every real use is a deliberate kernel, specialist code
where each use was justified on its own terms.
"No `Obj.magic`" is a house ban a workspace
adopts, not a universal improvement the catalog can claim. So the rule is
`restriction`-tier policy: off even under `--select all`, cherry-picked by
exact name, with the reviewed boundary carrying its `[@litany.allow]`
justification.

Fires at every identifier expression whose resolved identity is
`Stdlib.Obj.magic` — direct calls, opened uses, and first-class references
alike, at the identifier itself. Shadowed same-spelling definitions, later
uses of a value bound to `Obj.magic` (the binding's right-hand side already
fired), other `Obj` members, and unresolved identities deliberately do not
fire. There is no automatic fix.
