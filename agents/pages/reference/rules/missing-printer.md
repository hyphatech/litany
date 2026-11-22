# missing-printer

comparable abstract type whose interface exposes no printer

<!-- Written by docs/catalog.ts from `litany explain missing-printer`; never edited by hand. -->

**pedantic · warning · nursery · since 1.0 · fix: never · off by default**

An interface that already exposes `equal`, `compare`, or
`to_string` for its abstract type has declared it a
comparable/serializable value — and a value you can compare but not
print is a debugging dead end. Handle and machine types without that
value evidence are left alone: reasonable maintainers disagree there,
which is why this rule is Pedantic.

```ocaml
(* bad *)  type t  val equal : t -> t -> bool             (* no pp *)
(* good *) type t  val equal : t -> t -> bool  val pp : Format.formatter -> t -> unit
```

Fires once per abstract type — no manifest, no representation — in the
unit's interface whose same signature level exposes an
`equal : t -> t -> bool`, `compare : t -> t -> int`, or
`to_string : t -> string` (shapes checked against that type's own
identity, never by name alone) and no `pp` (or `pp_<name>`) of type
`Format.formatter -> t -> unit`, anchored at the implementation's
matching toplevel type declaration — the emit contract owns findings to
the editable source, so the `.mli` declaration itself cannot anchor.
Units without an interface, abstract types without value evidence,
manifest and represented types, and printers for other types that
happen to be named `pp` deliberately do not fire. Recorded false
negatives: types declared in submodule signatures (the toplevel join
is what the `type_decl` seam supports today) and interface types
satisfied by an `include` in the implementation. An `equal` that
exists only to feed a container functor is the accepted Pedantic
price — `[@litany.expect]` covers it. No fix: naming and placing a
printer is authorship.
