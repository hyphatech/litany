# unused-export

exported value never used by another unit

<!-- Written by docs/catalog.ts from `litany explain unused-export`; never edited by hand. -->

**suspicious · warning · nursery · since 1.0 · fix: never · off by default**

An exported value no other unit of the workspace references is
surface a maintainer must read, document, and keep compiling for
nobody. The finding anchors at the declaration — the `.mli` line when
the unit has one — and the claim is exact and non-transitive: the
value is used by no *other* unit, counting nothing about whether its
users are themselves alive (that judgment is `dead-code`'s).

```ocaml
(* bad *)  val helper : int -> int   (* no other unit mentions it *)
(* good *) delete the export (and the binding, if nothing local uses it)
```

Roots are never candidates: exports of public (or unknown-visibility)
libraries — external consumers exist outside every universe litany can
enumerate — and declarations annotated `[@litany.root "reason"]`.
Executables and tests have no interface surface, so their values are
never candidates (`dead-code` covers them). Value declarations only:
types and modules have no always-on cross-unit use signal, so 1.0
stays silent on them rather than guess.
A unit-level reference (a use the compiler recorded against the unit
without pinning a declaration) conservatively shields every export of
the referenced unit. Cross-module honesty: the rule runs only when
every roster unit joined — one fact-skip withholds it, and the summary
names the blockers. Workspaces built without occurrence recording
under-populate unit-level references; module-alias-only and
functor-argument uses can then be missed in the shielding direction —
a recorded nursery caveat. No fix: deleting an
export is an interface decision.
