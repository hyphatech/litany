# manual-result-bind

two-case result match that re-implements Result.bind

<!-- Written by docs/catalog.ts from `litany explain manual-result-bind`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

`match r with Ok x -> E | Error e -> Error e`, with `E` itself
result-typed and the error returned unchanged, is
`Result.bind r (fun x -> E)`: same single evaluation of `r`, same `E`
on `Ok`, same error propagation. It is the single most recurrent manual
shape in the corpora — including per-directory hand-defined
`let ( let* ) = <the bind match>` operators, whose definitions fire and
should: `let ( let* ) = Result.bind` is the tighter definition.

```ocaml
(* bad *)  match route t s with Error e -> Error e | Ok d -> submit d
(* good *) Result.bind (route t s) (fun d -> submit d)
```

Fires on the guard-less two-case match — or bare `function` — whose
`Ok` case binds a variable with a right-hand side that is not an
`Ok _` construction (that shape is manual-result-map's — exact
partition, no co-fire), and whose `Error` case is the payload rebuild
`Error e -> Error e`, in either case order. The rebuild's payload types
must agree on both sides: a coerced rebuild
(`Error (e :> wider)`) widens where `Result.bind` would not typecheck
and is refused. The alias spelling `Error _ as e -> e` is a recorded
false negative until a pattern-alias view lands. Guards, exception
arms, deeper payload patterns, transformed or dropped errors, `Error`
right-hand sides that are not `Error` constructions, and user variants
spelling `Ok`/`Error` deliberately do not fire. One definition site is
exempt — the self-definition gate: a module named `Result` defining the
like-named `bind` from this match (stdppx's shape; its `Result.bind`
is this match) must not be told to use `Result.bind`. The gate accepts
the match that is the eventual function body of a value binding named
`bind` inside a module binding named `Result`, or at the root of a
unit itself named `Result`; every other definition, `( let* )`
included, keeps firing. No fix: the rewrite restructures the `Ok` arm
into a lambda — the message shows the form.
