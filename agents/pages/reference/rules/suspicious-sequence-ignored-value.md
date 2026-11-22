# suspicious-sequence-ignored-value

pure projection discarded where the compiler cannot warn

<!-- Written by docs/catalog.ts from `litany explain suspicious-sequence-ignored-value`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

In `e1; e2` the compiler warns on a non-unit `e1` (warning 10) —
except when `e1`'s type is a type variable, where it must stay silent
because `unit` is a possible instantiation. That hole swallows exactly
the discards most worth hearing about: applications of pure
projections whose entire purpose is the returned value, discarded
inside a function polymorphic in that value.

```ocaml
(* bad *)  let f xs = List.hd xs; List.length xs
(* good *) let f xs = let x = List.hd xs in use x; List.length xs
```

Fires on a sequence left-hand side that is a saturated application of
an enumerated pure projection — `List.hd`, `Option.get`,
`Result.get_ok`, `Result.get_error`, `fst`, `snd`, `List.nth`,
`List.assoc`, `List.assq`, `List.find`, `Hashtbl.find` — whose result
type is a bare type variable. Concrete result types are warning 10's
(the compiler already spoke — litany says nothing), `ignore (…)` is
the sanctioned discard, effectful pops (`Queue.pop`, `Stack.pop`) are
deliberate drops outside the set, and rebound or shadowed names never
match. No fix: the remedy is deciding what to do with the value.
