# quadratic-list-append

list append folded with the accumulator on the left

<!-- Written by docs/catalog.ts from `litany explain quadratic-list-append`; never edited by hand. -->

**perf · warning · stable · since 1.0 · fix: never · on by default**

`(@)` copies its left operand and shares its right. A fold whose
accumulator sits on the left of `(@)` therefore copies everything
accumulated so far at every step — quadratic in the total length where
`List.concat` and `List.concat_map` are linear.

```ocaml
(* bad *)  List.fold_left (fun acc x -> acc @ [f x]) [] xs
(* good *) List.concat_map (fun x -> [f x]) xs
```

Fires when `List.fold_left`, `Array.fold_left`, or `Seq.fold_left`
resolves to its `Stdlib` declaration with `Stdlib.(@)`/`List.append` —
or a two-parameter lambda appending with its accumulator (first)
parameter on the left — as the first unlabeled argument, at any
saturation up to three; and when `List.fold_right`/`Array.fold_right`
takes a lambda with its accumulator (second) parameter on the left, the
quadratic reversal. `List.fold_right (@) xss []` is **linear** — each
element is copied once; it is `List.concat` itself — and deliberately
does not fire, and neither do element-on-the-left lambdas, consing,
rebound operators, or labeled folds. The recursive spelling
(`rev xs @ [x]`) is a recorded false negative: it needs a second rule
kind on one rule, which the engine does not yet allow. No fix: the
rewrites restructure the expression; the message names them.
