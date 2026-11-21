# manual-eta-lambda

anonymous function that only forwards its parameters

<!-- Written by docs/catalog.ts from `litany explain manual-eta-lambda`; never edited by hand. -->

**style · warning · nursery · since 1.0 · fix: sometimes · off by default**

An anonymous function whose body only forwards its parameters, in
order, to a single identifier is that identifier wrapped in a closure:
`fun x -> parse x` is `parse`, and the wrapper adds an allocation and a
layer of reading without adding meaning.

```ocaml
(* bad *)  Result.map (fun x -> parse x) r
(* good *) Result.map parse r
```

Fires on an anonymous function expression (`fun`, not a `let`-bound
definition) in any position — an argument, the callee of an immediate
application, a list element, a pipeline stage — whose parameters are all
unlabeled plain variables and whose body is one application of an
identifier callee to exactly those parameters, in order, all unlabeled,
proved by declaration identity (`Ident.same` positionally, which also
retires the duplicate-name hazard: in `fun x x -> g x x` both arguments
carry the second `x` and position one fails). The gate is what makes
the reduction exact, and each clause is a deliberate non-firing: the
callee must be a plain identifier or module path (`(get ()) x` forces
`get ()` once per call, `f` once at the reduction; a staged `(add 1) x`
likewise), not one of the lambda's own parameters (`fun f -> f x`), and
not spelled as an operator (`fun x y -> x + y` is the section `( + )`, a
different edit — and the parser respells unary minus, so an operator's
slice is not its name); the application must apply all and only the
parameters as unlabeled positional arguments (a partial forward
`fun x y -> f x`, an extra argument `f x 0`, a repeated one `f x x`, a
swapped order, a labeled or optional argument — labels change arity
semantics); the callee's arrow spine must be unlabeled over the
forwarded prefix (with `g : ?d:int -> int -> int`, `fun x -> g x` has
type `int -> int` while `g` keeps the optional — the erasure gate eta-reducible-forwarding
records); and the lambda, its
parameters, its callee, its body, and its arguments carry no type
annotation, coercion, newtype, or attribute the reduction would drop —
`fun env -> f (env :> t)` forwards a coerced `env`, not `env`. A body that
is itself a function (`fun x -> fun y -> f x y`, `fun x -> function
...`) is not a forward. The callee's own arity is irrelevant:
`fun x -> f x` with a binary `f` is `f` at the same type.

Two further non-firings keep the fix legal. A lambda that is the whole
right-hand side of a `let` binding (`let f = fun x -> g x`, and the
`let f x = g x` sugar the parser desugars to it) is
eta-reducible-forwarding's — that rule's doc records why reducing a
named definition is a judgment, not a mechanical edit (closure identity,
the type surface a wrapper pins); this rule never fires there. And a
lambda in tail position of a `let rec` right-hand side whose callee is
one of the recursively bound names (`let rec f = let g = 1 in fun x -> f
x`) does not fire: the reduced `let rec f = let g = 1 in f` is rejected
by the compiler's recursive-definition check, while under an intervening
`fun` (`let rec go = fun l -> List.map (fun x -> go x) l`) the use is
already delayed and the reduction is legal.

Style, off by default: an eta-expanded lambda is sometimes deliberate —
an `[@inline]` site, a closure the author wants distinct from the callee,
or a forward reference to a not-yet-defined recursive binding. The fix
replaces the lambda with the callee's own spelling, restoring the
author's parentheses when the lambda's location included them
(`Result.map (fun x -> parse x) r` becomes `Result.map parse r`), and is
Safe: under the gate the two expressions are the same value at the same
type. The one observable difference is closure identity — the wrapper
is a fresh allocation, the callee is the one it already was, so `==` on
them differs — which is not a soundness concern: a program observing it
compares functions, itself flagged — physically by
suspicious-physical-equality, structurally (where it raises) by
invalid-function-comparison. Verified OCaml 5.5.0 arm64 non-flambda:
`fun x -> succ x` and `succ` compile to the same cmm up to symbol names
(the compiler eta-expands the primitive itself), so the rationale is
style and identity, never speed.
