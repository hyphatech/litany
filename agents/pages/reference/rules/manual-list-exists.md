# manual-list-exists

recursive function that re-implements List.exists

<!-- Written by docs/catalog.ts from `litany explain manual-list-exists`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

A recursive function whose body is the two-case list recursion
returning `false` on `[]` and `E || self … tl` on cons re-implements
`List.exists (fun x -> E)`: same left-to-right evaluation, same
short-circuit on the first `true`, same effect order when `E` is
effectful — and `List.exists` says what it does.

```ocaml
(* bad *)  let rec has p = function
             | [] -> false
             | x :: xs -> p x || has p xs
(* good *) let has p = List.exists p
```

Fires when the shape is proved: exactly two guard-less cases by
predefined-list identity, the nil case the literal `false`, and the
cons case `E || SELFCALL` where the step `E` uses neither the function
nor the bound tail and the self-call passes every parameter unchanged
with the bound tail in list position. A self-call left of `||`
(evaluation order differs), a `true` nil case (constant, not exists),
a same-named outer function without `rec`, a recursion argument other
than the bound tail, guards, extra cases, and user-defined `(::)`/`[]`
deliberately do not fire. The `if p x then true else self xs` spelling
is redundant-if-bool's inner `if`. No fix: the rewrite restructures
the whole binding.
