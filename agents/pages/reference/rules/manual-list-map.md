# manual-list-map

recursive function that hand-rolls a list map

<!-- Written by docs/catalog.ts from `litany explain manual-list-map`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

A recursive function whose body is exactly the two-case list
recursion `[] -> []` / `x :: xs -> E :: self … xs` re-implements
`List.map (fun x -> E)`: more code, no TRMC, and a reader must
re-verify that the recursion is structural.

```ocaml
(* bad *)  let rec map1 f = function
             | [] -> []
             | h :: tl -> f h :: map1 f tl
(* good *) let map1 f = List.map f
```

Fires when the whole shape is proved: the binding is a variable, every
parameter an unlabeled variable, the two cases guard-less with
predefined `[]`/`(::)` identity, every parameter passed through the
recursion unchanged with the bound tail in the list position (any
parameter position), and the head expression using neither the tail, the
function itself, nor — in the match form — the scrutinized list
parameter, which is rebound at every recursive call and so denotes a
different list per iteration. Guarded or extra cases, alias patterns,
heads that read the tail or the scrutinized list, arguments other than
the bound tail, user-defined
`(::)`/`[]` constructors, and same-named outer functions (identity, not
spelling) deliberately do not fire. No fix: the rewrite restructures
the whole binding; the message names the replacement.
