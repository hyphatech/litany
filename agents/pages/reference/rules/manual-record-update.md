# manual-record-update

record rebuilt field by field from one base

<!-- Written by docs/catalog.ts from `litany explain manual-record-update`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

A record expression that copies two or more fields verbatim from one
base record is `{ base with ... }` written longhand: more text, and the
reader must verify field by field that the copies are copies. When every
field is a verbatim copy of an immutable record, the expression is the
base itself.

```ocaml
(* bad *)  { x = r.x; y = r.y; z = 15 }
(* good *) { r with z = 15 }
```

Fires once per extension-less record expression in which some identifier
base has at least two fields copied verbatim — `l = b.l`, same label by
declaration identity: equal name and `Path.same` record head, so the
base necessarily has the constructed type and a cross-type rewrite —
suggesting `{ b with … }` against a different record type — is
structurally impossible. Fields copied from a different base, and
punned fields (which elaborate to bare identifiers, not accesses),
count as overrides and simply stay spelled out. When every field is a
copy the message says the record is the base itself — unless some
label is mutable, where the full rebuild is the deliberate copy idiom
and the rule stays silent. A base that is not an identifier
(`(get r).x`) never counts: re-evaluating it under `with` would change
effects. A one-copy record does not fire — `{ b with ... }` would
rewrite nearly the whole literal, a deliberate narrowing: one copied
field is not evidence of an update idiom. No fix: the rewrite deletes
and reorders fields;
the message shows the target form. Fields arrive in the record type's
declaration order (the typedtree does not record source order), so
multi-override messages list overrides in declaration order — a
cosmetic note, not a defect. Same-typed serialization boilerplate that
copies deliberately for explicitness is what Style/off respects.
