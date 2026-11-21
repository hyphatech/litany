# used-underscore-binding

underscore-prefixed binding is used

<!-- Written by docs/catalog.ts from `litany explain used-underscore-binding`; never edited by hand. -->

**suspicious · warning · nursery · since 1.0 · fix: never · off by default**

A leading underscore declares "this binding is intentionally unused"
and silences the compiler's unused warnings. Using the binding anyway
makes the name lie — and keeps the compiler from noticing when the
binding later becomes genuinely unused.

```ocaml
(* bad *)  let _count = tally xs in report _count
(* good *) let count = tally xs in report count
```

Fires once per binding, at the declaration, when a variable or alias
pattern binds a name beginning with exactly one underscore and the unit
uses that declaration anywhere — bare, or qualified through a module
path. The wildcard `_` binds nothing, names beginning with two
underscores follow a different convention, and unused underscore
bindings are the convention working as intended. A use through a
signature ascription carries the ascription's minted identity, not the
declaration's, and stays clean.

Tool-minted names stay clean even when used: `_1` and kin (an
underscore followed by
digits only — menhir's semantic values) and `…__NNN_` shapes (a name
ending in a double underscore, digits, and a final underscore —
jane-street ppx internals, `_of_a__001_`). Both are bound-and-used by
generated code as a calling convention, not a lie the author told; in
field review they were 99.9% of the rule's volume. Committed generated
sources carry them verbatim, so the name gate applies everywhere; the
generated-unit gate rides separately. Renaming is a
refactor, not a mechanical edit, so there is no fix.
