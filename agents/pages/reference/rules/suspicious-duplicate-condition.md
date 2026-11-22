# suspicious-duplicate-condition

else-if condition that duplicates the previous arm's

<!-- Written by docs/catalog.ts from `litany explain suspicious-duplicate-condition`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`if c then … else if c then e2 …` evaluates the second `c` with
nothing between the two evaluations except the first `c` itself: when
`c` is pure the second arm can never run, and the chain is almost
certainly an unedited paste.

```ocaml
(* bad *)  if x = 1 then a else if x = 1 then b else c
(* good *) if x = 1 then a else if x = 2 then b else c
```

Fires when, in a non-preprocessed unit, an `if`'s else branch is
directly another `if`, the two conditions' source slices are
byte-identical after whitespace normalization, and the condition is
syntactically pure — built only of identifiers, constants, constructors,
and applications of the `Stdlib` boolean and comparison operators.
Conditions with any other call (it may be effectful), dereferences,
field or array reads (another domain could write between evaluations),
and boolean-literal conditions (suspicious-literal-condition's) refuse.
Only adjacent arms are compared: `if a … else if b … else if a` is a
recorded false negative. No fix: which arm was meant is the author's
call.
