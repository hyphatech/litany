# redundant-guard-true

when guard that is literally true or false

<!-- Written by docs/catalog.ts from `litany explain redundant-guard-true`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: sometimes · on by default**

A guard that is literally `true` never fails: the case behaves as
if unguarded, but the `when` costs the reader a double-take and costs
the compiler its exhaustiveness analysis. A guard that is literally
`false` never succeeds: the arm is dead. Both are almost always a
leftover or an unfinished edit — suspicious-literal-condition's
rationale, relocated to guards.

```ocaml
(* bad *)  match x with n when true -> n | _ -> 0
(* good *) match x with n -> n
```

Fires on every case of a `match`, `function`, or `try` whose guard is
the boolean literal itself, by predefined-constructor identity, at the
guard. Real guards and named flags (`when debug`) deliberately do not
fire — there is no constant propagation — and `when true && debug` is
redundant-boolean-operator's node inside the guard. Matches carrying
effect-handler cases are refused (recorded false negative). The fix
deletes an always-true guard only on the final arm — dropping an
earlier arm's guard can render later arms warning-11 dead under
`-warn-error` — and only when the bytes after the pattern are exactly
`when` `true` with whitespace; an always-false guard never carries a
fix (deleting a dead arm is an intent decision).
