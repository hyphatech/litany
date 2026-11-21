# redundant-list-roundtrip

list converted to a sequence and immediately back

<!-- Written by docs/catalog.ts from `litany explain redundant-list-roundtrip`; never edited by hand. -->

**perf · warning · stable · since 1.0 · fix: never · on by default**

`List.of_seq (List.to_seq xs)` walks the list twice and allocates a
fresh copy just to end where it started.

```ocaml
(* bad *)  List.of_seq (List.to_seq xs)
(* good *) xs
```

Fires only when both conversions resolve to their `Stdlib.List`
declarations and the inner application feeds the outer one directly; the
types then already prove the roundtrip. The compiler collapses `|>` into
direct applications, so `xs |> List.to_seq |> List.of_seq` fires too.
Shadowed or let-rebound names, sequence work between the conversions,
the reverse `to_seq (of_seq s)` direction, and other `of_seq` targets
(`Array.of_seq`) deliberately do not fire. No fix: `List.of_seq`
allocates a fresh list, so removing the roundtrip changes physical
identity.
