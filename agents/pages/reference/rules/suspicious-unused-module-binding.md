# suspicious-unused-module-binding

module binding the unit never uses and never exports

<!-- Written by docs/catalog.ts from `litany explain suspicious-unused-module-binding`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

A named module binding that the unit never references, and that
nothing outside the unit can reference, is dead text: a local
`let module M = … in e` whose body never mentions `M`, or a toplevel
`module M = …` in a unit whose interface does not export `M`. The
compiler's warning 60 makes exactly this judgment soundly — and ships
disabled in every mainstream default, so in practice no one has ever
seen it. This rule makes the same judgment from the artifact,
config-independently: uses are counted by resolved identity over every
path the typedtree stores, and export is read from the unit's own
compiled interface.

```ocaml
(* bad *)  let module Tbl = Hashtbl.Make (Int) in body  (* Tbl unseen *)
(* good *) module _ = struct let () = register () end   (* effect-only *)
```

Fires at the binder's name when it is never used: for a `let module`
unit-wide emptiness is exactly body emptiness; for a toplevel binding
the interface must exist and hide the name — a unit without an `.mli`
exports everything through its inferred signature and stays silent,
exactly where an enabled warning 60 is also silent. Module bindings
nested inside sub-structures need per-path signature reasoning and are
recorded false negatives; `Pstr_recmodule` groups are not dispatched.
The anonymous `module _ = …` is the sanctioned effect-only spelling
and refuses by construction. A stale `.cmti` can misreport exports at this rule's gate. No fix: a
module body can perform effects at initialization, so deletion is
never mechanical.
