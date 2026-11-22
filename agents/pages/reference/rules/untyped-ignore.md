# untyped-ignore

ignore discards a value without naming its type

<!-- Written by docs/catalog.ts from `litany explain untyped-ignore`; never edited by hand. -->

**restriction · warning · nursery · since 1.1 · fix: never · off by default**

`ignore` throws a value away; naming its type keeps the throw
honest. A function later given one more argument is then a partial
application discarded in silence, and a promise or a `result` the same:
a type named at the discard is a compile error the day the value
changes. `untyped-wildcard-binding` is the same rule for `let _ =`.

```ocaml
(* bad *)  ignore (Queue.pop q)
(* good *) ignore (Queue.pop q : int)
```

Why restrict this? Discarding is legitimate OCaml, and the compiler's
warnings own the cases nobody meant; naming the type of every discard
is a discipline a house adopts.

Fires at `ignore e` -- the identity `Stdlib.ignore`, applied to one
argument -- whose argument carries no type constraint, or one that names
no type (`ignore (e : _)`, `ignore (e : 'a)`). `ignore (e : t)`, `ignore
(e :> t)`, `ignore` passed as a value, and a shadowing `ignore` deliberately
do not fire. Recorded false negative, in the safe direction: a value
bound to `ignore` and applied later (`let drop = ignore in drop x`). No
fix: only the author knows the type meant.
