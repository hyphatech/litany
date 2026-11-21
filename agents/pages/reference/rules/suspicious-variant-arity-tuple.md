# suspicious-variant-arity-tuple

constructor whose one argument is a parenthesized tuple

<!-- Written by docs/catalog.ts from `litany explain suspicious-variant-arity-tuple`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`C of int * int` declares a two-field constructor — one block,
fields inline. `C of (int * int)` declares a one-field constructor
whose field is a boxed tuple — an extra allocation and an extra
indirection on every construction and every match, invisible at most
use sites because the pattern `C (x, y)` happens to typecheck against
both.

```ocaml
(* bad *)  type t = Pair of (int * int)
(* good *) type t = Pair of int * int
(* good *) type point = int * int
           type t = Pair of point
```

Fires once per constructor whose argument list is exactly one
parenthesized tuple type, at that type — GADT constructors included:
`B : (int * int) -> t` draws the same representation line as
`D of (int * int)`. Declarations under `[@@unboxed]` are exempt (the
attribute requires the single-argument form, so the boxing complaint
is void), as is a tuple among several fields (`C of (int * int) *
string` has no flat spelling — the parentheses are load-bearing) and a
named tuple type (`C of point` — the sanctioned spelling when the
tuple-as-one-value is the choice). No fix: flattening changes the
runtime representation and breaks every `C p`-as-value use site; the
remedy is a decision, stated in the message.
