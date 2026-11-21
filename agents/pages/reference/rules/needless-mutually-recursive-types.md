# needless-mutually-recursive-types

and-chained type that is not mutually recursive with its group

<!-- Written by docs/catalog.ts from `litany explain needless-mutually-recursive-types`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

An `and`-chained type group asserts to the reader that its members
are mutually recursive. A member that participates in no reference
cycle with its siblings makes the assertion false coupling: the group
reads as co-dependent, refactors move it as a block, and the actual
dependency structure is hidden.

```ocaml
(* bad *)  type t1 = A of t2 and t2 = B of t1 and t3 = C of t1
(* good *) type t1 = A of t2 and t2 = B of t1
           type t3 = C of t1
```

Fires once per member of a multi-declaration group that is mutually
reachable with no sibling over the identity-resolved reference graph —
each such declaration can stand as its own `type` item (type
declarations are recursive by default, so even a self-recursive
singleton extracts cleanly, unlike `let`). Members of a genuine cycle
never fire, and a singleton group has no `and` to indict. Edges are by
declaration identity, so a same-named outer type never confuses the
graph, and under `nonrec` no sibling edge can exist — every member of
a multi-declaration `nonrec` group reports, derived rather than
special-cased. No fix: splitting the group is a reordering of
declarations, not a span edit, and computing a correct order is out of
scope.
