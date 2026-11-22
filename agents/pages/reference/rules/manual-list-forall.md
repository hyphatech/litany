# manual-list-forall

recursive function that re-implements List.for_all

<!-- Written by docs/catalog.ts from `litany explain manual-list-forall`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

A recursive function whose body is the two-case list recursion
returning `true` on `[]` and `E && self … tl` on cons re-implements
`List.for_all (fun x -> E)`: same left-to-right evaluation, same
short-circuit on the first `false`, same effect order when `E` is
effectful — and `List.for_all` says what it does.

```ocaml
(* bad *)  let rec all p = function
             | [] -> true
             | x :: xs -> p x && all p xs
(* good *) let all p = List.for_all p
```

Fires when the shape is proved: exactly two guard-less cases by
predefined-list identity, the nil case the literal `true`, and the
cons case `E && SELFCALL` where the step `E` uses neither the function
nor the bound tail and the self-call passes every parameter unchanged
with the bound tail in list position. A self-call left of `&&`
(evaluation order differs), a `false` nil case (constant, not
for_all), a same-named outer function without `rec`, a recursion
argument other than the bound tail, guards, extra cases, and
user-defined `(::)`/`[]` deliberately do not fire. The
`if p x then self xs else false` spelling is redundant-if-bool's inner
`if`. No fix: the rewrite restructures the whole binding.
