# restricted-global-mutable-state

toplevel mutable state in library code

<!-- Written by docs/catalog.ts from `litany explain restricted-global-mutable-state`; never edited by hand. -->

**restriction · warning · stable · since 1.0 · fix: never · off by default**

A `ref`, `Hashtbl.t`, or mutable-record value bound at a library's
toplevel lives for the whole process: every consumer shares it, tests
interfere through it, two domains race on it, and no caller can create
a second independent instance. Litany's own law — pure core, state in
the driver — is this rule, self-applied.

```ocaml
(* bad *)  let registry : (string, handler) Hashtbl.t = Hashtbl.create 16
(* good *) a table created by the caller and passed down, or a
           `create`d value the API threads explicitly
```

Why restrict this? Deliberate globals are legitimate — fmt's style
store and cmdliner's uid counter are designed — and the field count is
small (2 sightings in ~9,700 reviewed lines), so a ban is house
policy, not a defect claim: off even under `--select all`,
cherry-picked by a
workspace whose libraries keep state in the caller. The known
false-positive shapes are named up front: memo tables, interning
pools, and caches are deliberate state, and `[@litany.allow]` with a
reason is the designed outlet — a lazy cache (`let table = lazy …`)
is already the blessed initialize-once spelling and stays clean by
shape.

Fires once per variable bound by an item of the unit's root structure —
a root `include struct ... end`'s items included: they land on the
unit's export surface like any root item — whose type's head is
`Stdlib.ref`, `Stdlib.Hashtbl.t`, or a record type declared at the
unit's root with a `mutable` field, in units whose roster kind is
`Library`. Executables and tests own their
process and never fire; a unit whose roster carries no kind is
deliberately silent — a metadata-gated rule degrades to silence,
never to guessing. Local bindings inside functions and
let-expressions, `lazy` thunks, pure records, and functions that
merely return fresh state deliberately do not fire. Arrays are out of
scope in v1: the array type does not distinguish a buffer from state —
a lookup-table literal and a mutable accumulator spell the same type —
so an array ban would claim a structural proof the type cannot give.
Abbreviation heads are compared as inferred, never expanded
(`type counter = int ref` stays clean), a mutable-record head the
unit does not declare at its own root — a nested module's, one
`include`d from a named module, another unit's — stays clean, and a
binding that binds no variable or destructures stays clean: each is a
recorded false negative in the safe direction. No fix: moving state
into the caller is an API redesign.
