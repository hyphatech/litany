# needless-list-map-before-concat

List.map feeding concatenation builds an intermediate list

<!-- Written by docs/catalog.ts from `litany explain needless-list-map-before-concat`; never edited by hand. -->

**perf · warning · stable · since 1.0 · fix: never · on by default**

`List.concat (List.map f xs)` builds a complete intermediate list of
lists only for the concatenation to traverse and discard it;
`List.concat_map f xs` fuses the two passes.

```ocaml
(* bad *)  List.concat (List.map f xs)
(* good *) List.concat_map f xs
```

Fires only when the concatenation (`List.concat` or `List.flatten`) and
`List.map` resolve to their `Stdlib` declarations and the two-argument
map application feeds the concatenation directly — including
`List.map f xs |> List.concat`, which the compiler collapses into that
shape. Shadowed or let-rebound names, `List.concat_map` itself, partial
applications (`xs |> List.map f |> List.concat` leaves one), and
anything between the map and the concatenation deliberately do not fire.
No automatic fix.
