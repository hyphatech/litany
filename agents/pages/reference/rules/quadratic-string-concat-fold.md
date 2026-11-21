# quadratic-string-concat-fold

string concatenation folded through (^)

<!-- Written by docs/catalog.ts from `litany explain quadratic-string-concat-fold`; never edited by hand. -->

**perf · warning · stable · since 1.0 · fix: never · on by default**

Folding `(^)` over a collection copies the whole accumulator for every
element: joining n segments allocates quadratically where `String.concat`
allocates the result once.

```ocaml
(* bad *)  List.fold_left ( ^ ) ""
(* good *) String.concat ""
```

Fires when `List.fold_left`, `List.fold_right`, `Array.fold_left`,
`Array.fold_right`, or `Seq.fold_left` resolves to its `Stdlib`
declaration with `Stdlib.(^)` as the first of one or two unlabeled
arguments — at any saturation, the partially applied `fold ( ^ )` and
`fold ( ^ ) ""` and the fully saturated three-argument call alike. A
rebound `(^)`, the eta-expanded `fun acc s -> acc ^ s`, labeled folds
(`ListLabels.fold_left ~f:( ^ )`), other operators, and Buffer
accumulation deliberately do not fire. The `String.concat ""` rewrite
of the saturated form lands with a later release; no automatic fix
until then — the promise flips to `Sometimes` with it.
