# manual-list-filter-map

recursive function that re-implements List.filter or filter_map

<!-- Written by docs/catalog.ts from `litany explain manual-list-filter-map`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

The cons-or-skip list recursion — keep a (possibly transformed)
element in one branch, recurse past it in the other — re-implements
`List.filter_map`, or plain `List.filter` when the kept element is the
head unchanged.

```ocaml
(* bad *)  let rec evens = function
             | [] -> []
             | x :: xs -> if x mod 2 = 0 then x :: evens xs
                          else evens xs
(* good *) let evens = List.filter (fun x -> x mod 2 = 0)
```

Fires when the shape is proved: the two-case recursion of
manual-list-map's scaffold whose cons case is either
`if C then E :: SELF else SELF` (or mirrored) or
`match G with Some y -> y :: SELF | None -> SELF` — both branches the
identical recursion with only the bound tail advanced, the condition or
scrutinee and the kept head using neither the tail, the function, nor —
in the match form — the scrutinized list parameter (rebound at every
recursive call);
predefined `Some`/`None` identity. The message names `List.filter` when
the kept head is exactly the bound element, `List.filter_map`
otherwise. Else-branches that are not the bare recursion (take-while
shapes), match-form kept heads other than the bound option payload,
guards, user-defined constructors, and same-named outer functions
deliberately do not fire. No fix: the rewrite restructures the whole
binding.
