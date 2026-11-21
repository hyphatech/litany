# wildcard-over-owned-variant

a wildcard arm in a match over a variant the code owns

<!-- Written by docs/catalog.ts from `litany explain wildcard-over-owned-variant`; never edited by hand. -->

**restriction · warning · nursery · since 1.1 · fix: never · off by default**

A match over a variant the code owns names every case, so a
constructor added later is a compile error at every match that should
handle it -- warning 8 asks for it -- where a `_` arm takes it silently
into whatever the arm does.

```ocaml
(* bad *)  match s with Open -> "open" | _ -> "closed"
(* good *) match s with Open -> "open" | Done | Dropped -> "closed"
```

Why restrict this? A match over another library's variant ends in a
catch-all, since a variant grows in a minor release, so a wildcard is
not a defect in itself; which variants a house owns is its own to say.

```lisp
(rule wildcard-over-owned-variant
 (owned app_core app_http))
```

Fires at a guard-less `_` value arm of a `match` whose other arms name a
constructor of a variant declared in the same compilation unit, in
another module of the same wrapped library, or in a library the
`(owned <library> ...)` option names. A variant of any other library,
the predefined ones (`option`, `list`, `bool`), an extensible variant,
which has no last case to name, a guarded wildcard, a wildcard nested in
a pattern (`Some _`), an `exception _` arm, and a match whose arms name
no constructor deliberately do not fire. A module alias names the module
it aliases: `module E = Either` owns nothing. Recorded
false negatives, in the safe direction: `function` matches, and a
library built unwrapped. No fix: only the author knows what each case
should do.
