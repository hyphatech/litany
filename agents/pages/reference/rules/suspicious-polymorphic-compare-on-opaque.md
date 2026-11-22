# suspicious-polymorphic-compare-on-opaque

polymorphic comparison of a Set, Map, or Hashtbl value

<!-- Written by docs/catalog.ts from `litany explain suspicious-polymorphic-compare-on-opaque`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`Set.Make` and `Map.Make` build balanced trees whose shape depends on
insertion history, and `Hashtbl.t` is a mutable record of bucket arrays:
structural comparison sees those representations, not the values they
encode. Two equal sets can compare unequal, `<` orders trees
meaninglessly, and `=` on tables compares bucket layout — the functors
export `equal` and `compare` precisely because polymorphic comparison
cannot work.

```ocaml
(* bad *)  if s1 = s2 then …
(* good *) if IntSet.equal s1 s2 then …
```

Fires when `=`, `<>`, `<`, `>`, `<=`, `>=`, `compare`, `min`, or `max`
resolves to its `Stdlib` declaration with an operand — or `List.mem`,
`List.assoc`, `List.assoc_opt`, or `List.mem_assoc` with its compared
key — whose type proves an opaque head: `Hashtbl.t`, a `Set.Make` or
`Map.Make` instance reached across a compilation-unit boundary, or a
`list`, `array`, or `option` of one. The proof never guesses: shadowed
operators, the modules' own `equal`/`compare`, abbreviation heads
(`type cache = … Hashtbl.t`), physical equality, and partial or labeled
applications deliberately do not fire. Functor instances declared in the
linted unit itself and tuple components are recorded false negatives.
No fix: the remedy is the module's own
`equal`/`compare` or a key redesign the author must choose.
