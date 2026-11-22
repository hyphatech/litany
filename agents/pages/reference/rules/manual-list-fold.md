# manual-list-fold

recursive function that re-implements a List fold

<!-- Written by docs/catalog.ts from `litany explain manual-list-fold`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

A recursive function with an accumulator whose body is the two-case
list recursion returning the accumulator on `[]` re-implements
`List.fold_left` (accumulator transformed, tail call in tail position)
or `List.fold_right` (result rebuilt around the recursive call,
accumulator threaded unchanged).

```ocaml
(* bad *)  let rec sum acc = function
             | [] -> acc
             | x :: xs -> sum (acc + x) xs
(* good *) let sum acc = List.fold_left ( + ) acc
```

Fires when either shape is proved — the nil case returning one of the
parameters (that parameter is the accumulator), and the cons case
either the tail call with only the accumulator position transformed
(fold_left) or one self-call with every parameter unchanged inside a
step that touches neither the function nor the tail (fold_right); in
the match form the step must not read the scrutinized list parameter
either — it is rebound at every recursive call, so no fold callback
can see it. The message names the replacement. The step may be any
expression — an operator, not just an applied parameter. Nil cases
returning a literal
(no accumulator parameter to keep the signature), changed-and-wrapped
accumulators, two self-calls, guarded or extra cases, user-defined
`(::)`/`[]`, and same-named outer functions deliberately do not fire.
No fix: the rewrite restructures the whole binding.
