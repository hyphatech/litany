# redundant-match-bool

boolean match interrupting an if/else chain

<!-- Written by docs/catalog.ts from `litany explain redundant-match-bool`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: sometimes · off by default**

A two-case match on a boolean — `match e with true -> a | false ->
b`, or the `function` form — is `if`/`else` in longhand. Standalone,
that longhand is a deliberate house style in wide use (cmdliner's
whole surface, sexplib0's parsers, ppxlib's printers) and is left
alone. What this rule reports is the boolean match that interrupts an
if/else cascade: one sitting as the `else` continuation of an
enclosing `if`, or whose own arms continue into `if`/`else` — there
the switch of form buries one branch of a multi-way decision, and
`if` keeps the cascade in one shape.

```ocaml
(* bad *)  if p then x else match c with true -> a | false -> b
(* good *) if p then x else if c then a else b
```

Fires on exactly two guard-less cases whose patterns are the boolean
literals (predefined-constructor identity) covering `true` and `false`
in either order, in both the `match` and the `function` form — and
only in the cascade positions: the match is an `else` branch, or an
arm's body is itself an `if`/`else` (the `function` form, never a
branch of an enclosing `if`, fires on the arm shape alone). A
standalone two-case boolean match never fires: the house styles are
recorded negatives. Guards, extra or wildcard cases, `exception` cases
(the `if` rewrite would change semantics), user-defined two-constructor
variants, and matches carrying effect handlers deliberately do not
fire. The fix rewrites the match form to `if`/`else` (the `function`
form has no scrutinee to build the condition from and ships none); it
applies only when the scrutinee's and both arms' source slices cleanly
(`Unit.splice`).
