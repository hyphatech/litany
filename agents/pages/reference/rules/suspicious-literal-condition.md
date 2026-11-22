# suspicious-literal-condition

if over a literal true or false condition

<!-- Written by docs/catalog.ts from `litany explain suspicious-literal-condition`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

A literal `true`/`false` condition makes one branch dead and the
`if` a lie — almost always a debugging leftover or an unfinished edit.

```ocaml
(* bad *)  if false then log_debug state
(* good *) delete the branch, or name the flag it was meant to test
```

Fires on `if` whose condition is the boolean literal itself, by
predefined-constructor identity. Named flags (`let debug = true … if
debug`) deliberately do not fire — there is no constant propagation —
and neither do runtime conditions, `while true` (the idiomatic infinite
loop, structurally not an `if`), or two-case matches on a boolean
(redundant-match-bool's business). No automatic fix.
