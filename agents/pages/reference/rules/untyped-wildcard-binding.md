# untyped-wildcard-binding

let _ discards a value without naming its type

<!-- Written by docs/catalog.ts from `litany explain untyped-wildcard-binding`; never edited by hand. -->

**restriction · warning · nursery · since 1.1 · fix: never · off by default**

`let _ = e` throws a value away; naming its type keeps the throw
honest, so the day `e` returns a partial application, a promise or a
`result` the discard no longer compiles. `untyped-ignore` is the same
rule for `ignore`.

```ocaml
(* bad *)  let _ = write path text in ...
(* good *) let (_ : (unit, error) result) = write path text in ...
```

Why restrict this? Discarding is legitimate OCaml; naming the type of
every discard is a discipline a house adopts.

Fires at a wildcard binding, at any depth, whose pattern carries no
type constraint, or one that names no type (`let (_ : _) = e`, `let (_ :
'a) = e`). `let (_ : t) = e`, a named binding (`let _x = e`
included), `let () = e`, and a wildcard nested in a pattern deliberately
do not fire. No fix: only the author knows the type meant.
