# outdated-str-module

reference into the outdated Str module

<!-- Written by docs/catalog.ts from `litany explain outdated-str-module`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

`Str` funnels every match through one global state: each
`Str.string_match` stores its groups in hidden cells that the next match —
from any thread — silently overwrites, so `Str.matched_group` answers for
whichever match ran last.

```ocaml
(* bad *)  Str.string_match (Str.regexp "a+") s 0
(* good *) Re.execp (Re.compile Re.(rep1 (char 'a'))) s
```

Fires once per referenced `Str` declaration per unit: every reference
to a value declared in the `Str` compilation unit — spelled directly,
through an alias, or via `open` — joins its declaration's cluster, and
the cluster is one finding anchored at the first reference, its
message carrying the count (`Str.matched_group referenced 30 times in
this unit`); a declaration referenced once keeps the plain message. A
project-local `module Str`, a functor parameter named `Str`, a value
named `str`, and `Re.Str` (Re's compatibility layer, declared in Re's
own units and a fine migration vehicle) deliberately do not fire; a
vendored unit literally named `Str` does, because the compilation unit
is the identity boundary. In preprocessed units the collapse is off
and every reference reports individually: a rewriter-spliced location
on a cluster's first reference is one the emit contract drops, and
dropping the anchor would silence references that are real. Off by
default — adopting Re is a dependency decision —
and no fix: the rewrite is a migration.
