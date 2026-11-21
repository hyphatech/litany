# needless-fun-match

fun-then-match over an otherwise unused final parameter

<!-- Written by docs/catalog.ts from `litany explain needless-fun-match`; never edited by hand. -->

**style · warning · nursery · since 1.0 · fix: never · off by default**

`fun x -> match x with …` where `x` is used only as the scrutinee is
`function` with an extra name: the binding adds nothing a reader can
use, and the match cases already bind what matters.

```ocaml
(* bad *)  fun x -> match x with [] -> 1 | _ -> 2
(* good *) function [] -> 1 | _ -> 2
```

Fires when the whole body is a match on the function's final parameter —
unlabeled, non-optional — and no case guard or body uses that
parameter. Case-side rebindings of the same name are different
identities and do not block. Labeled parameters (the rewrite would
change call sites), scrutinees that are not the bare parameter, matches
that are only part of the body, and matches with `exception` cases
(`function` cannot carry them) deliberately do not fire. Neither does a
scrutinee carrying an explicit type constraint —
`fun mty -> match (mty : Types.module_type) with …` — where the
annotation is load-bearing (constructor disambiguation) and the
`function` rewrite has nowhere to put it: so such a site is left alone. The drop-parameter rewrite has no automatic
fix.
