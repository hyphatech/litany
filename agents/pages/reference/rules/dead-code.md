# dead-code

exported value unreachable from any root

<!-- Written by docs/catalog.ts from `litany explain dead-code`; never edited by hand. -->

**suspicious · warning · nursery · since 1.0 · fix: never · off by default**

An exported value no chain of live code reaches is dead: not used
directly, and every path that mentions it starts from something itself
dead. Where `unused-export` asks "does anyone name it", this rule
solves reachability — forward closure from the explicit roots — so a
group of units that only reference each other (a dead island, mutual
recursion included) is reported whole, exactly the case per-unit
analysis cannot see.

```ocaml
(* bad *)  two units using only each other, reachable from no root
(* good *) delete the island
```

Roots are explicit, computed from roster metadata: exports of public
(or unknown-visibility) libraries, the top level of executables and
tests, and `[@litany.root "reason"]` annotations. Granularity is the
export row: value declarations only, and intra-unit dependencies are
conservative — a live unit keeps every export its own implementation
references alive, so a value used only by a dead sibling of a live
unit is a recorded false negative, never a false positive. Unit-level
references keep the whole referenced unit provisionally live. The rule
runs only when every roster unit joined — one fact-skip withholds it
and the summary names the blockers. Workspaces built without
occurrence recording under-populate unit-level references. No fix:
deleting reachable-from-nowhere code is a
judgment about intent.
