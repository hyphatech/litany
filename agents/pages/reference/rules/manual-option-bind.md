# manual-option-bind

two-case option match that re-implements Option.bind

<!-- Written by docs/catalog.ts from `litany explain manual-option-bind`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

`match o with Some y -> E | None -> None`, with `E` itself
option-typed (the match's typing guarantees it), is
`Option.bind o (fun y -> E)`: same single evaluation of `o`, same `E`
on `Some`, same `None` propagation.

```ocaml
(* bad *)  match find k m with Some v -> resolve v | None -> None
(* good *) Option.bind (find k m) resolve
```

Fires on the guard-less two-case match — or bare `function` — whose
`Some` case binds a variable and whose `None` case returns the
predefined `None`, in either case order. A `Some`-arm right-hand side
that is itself a `Some _` construction is refused: `Some (g y)` is
manual `Option.map` and exactly `Some y` is the identity roundtrip —
different findings, owned elsewhere. Guards, exception arms,
non-variable payload patterns (`Some (a, b)` — a recorded false
negative), `None` arms returning anything but the predefined `None`
(`Option.fold` territory), and user-defined option lookalikes
deliberately do not fire. No fix: the rewrite restructures the whole
expression into a lambda — the message shows the form.
