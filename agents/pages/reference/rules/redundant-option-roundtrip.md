# redundant-option-roundtrip

option converted to a list only to take its head back

<!-- Written by docs/catalog.ts from `litany explain redundant-option-roundtrip`; never edited by hand. -->

**perf · warning · stable · since 1.0 · fix: never · on by default**

`List.nth_opt (Option.to_list o) 0` allocates an intermediate list
just to rebuild the option it started from — the whole expression is `o`.

```ocaml
(* bad *)  List.nth_opt (Option.to_list o) 0
(* good *) o
```

Fires only when both functions resolve to their `Stdlib` declarations and
the index is the integer literal `0`; the types then already prove the
roundtrip. Shadowed or let-rebound names, any other index (literal or
not), partial applications, operator pipelines, and anything between the
two conversions deliberately do not fire. No fix: replacing the
expression with `o` changes physical identity, which a caller may
observe.
