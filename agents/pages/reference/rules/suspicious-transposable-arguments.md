# suspicious-transposable-arguments

three adjacent same-typed unlabeled parameters

<!-- Written by docs/catalog.ts from `litany explain suspicious-transposable-arguments`; never edited by hand. -->

**pedantic · warning · stable · since 1.0 · fix: never · off by default**

Two adjacent same-typed unlabeled parameters include the symmetric
operations — `equal`, `compare`, `append`, `levenshtein` — where labels
would be noise. Three or more have no symmetric reading: every call
site is a silent transposition bug waiting, type-correct and wrong.

```ocaml
(* bad *)  val invalid_arg' : string -> string -> string -> 'a
(* good *) val invalid_arg' : m:string -> fn:string -> string -> 'a
```

Fires once per exported structure-level value binding of a
Library-kind unit whose arrow spine contains three or more consecutive
unlabeled parameters of equal type, anchored at the binding's name in
the implementation. Units without kind metadata degrade to silence;
labels break adjacency, which is exactly the remedy the rule teaches.
No fix: labeling is an API change.

Narrowings, each in the false-negative-safe direction: the spine is
read from the implementation binding's type rather than the interface
val (there is no signature dispatch kind yet, and findings anchor only
in the editable source) — the interface type is always at least as
specific, so an implementation hit implies an interface hit, never the
reverse; type equality is syntactic (`Path.same` heads with equal
arguments, or the same type variable) without abbreviation expansion,
so `t -> string -> t` with `type t = string` stays silent; and for
mli-backed units the export gate joins the interface's value names at
the unit's root (module-level linking is nominal by name), so values
of nested modules are not reported. Variadic-ish combinator
signatures where order is conventional are the recorded false-positive
risk and what Pedantic/off absorbs.
