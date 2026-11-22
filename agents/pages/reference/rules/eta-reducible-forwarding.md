# eta-reducible-forwarding

binding that only forwards its arguments

<!-- Written by docs/catalog.ts from `litany explain eta-reducible-forwarding`; never edited by hand. -->

**style · warning · nursery · since 1.0 · fix: never · off by default**

A binding whose body only forwards its parameters, in order, to a
single identifier is that identifier with extra ceremony: an allocation
per closure, and a name that promises logic it does not have.

```ocaml
(* bad *)  let f x y = g x y
(* good *) let f = g
```

Fires once per variable binding of an n-parameter function — every
parameter unlabeled and a plain variable — whose body is a single
application of an identifier callee to exactly those parameters, in
order, all unlabeled, proved by declaration identity (`Ident.same`
positionally, which also retires the duplicate-name hazard: in
`fun x x -> g x x` both arguments carry the second `x` and position
one fails). It fires only where the reduction is type-preserving and
legal: the callee must not be the binding itself (`let rec f = f` is
rejected by the compiler) nor one of the parameters, and the callee's
arrow spine must be unlabeled over the forwarded prefix — the
gate: with `let g ?(d = 0) x = x + d`, the wrapper
`let f x = g x` has type `int -> int` while `g` keeps
`?d:int -> int -> int`, so reducing changes the type and the call-site
surface. A type variable in the spine, or fewer visible arrows than
parameters, refuses. Inline eta-lambdas passed to higher-order
functions are a separate rule candidate with their own false-positive
profile, not this rule; PPX-materialized forwarders never fire (the
engine-wide emit contract). The value restriction is not a hazard: the
callee is an identifier — a syntactic value — so `let f = g`
generalizes exactly as the wrapper does; recorded here so reviewers
need not re-derive it.
Style, off by default: the claim is true, and the remedy is sometimes
worse than the disease — deliberate wrappers name things, pin
monomorphic types without an annotation, keep closure identity distinct,
or hold an indirection the author expects to swap. All are true
positives by the rule's claim and all defensible; the rule is for
codebases that want forwarding wrappers called out. No fix, ever: eta
reduction can change a binding's inferred type surface and its closure
identity — never mechanical.
