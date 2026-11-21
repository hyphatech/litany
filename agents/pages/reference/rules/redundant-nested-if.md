# redundant-nested-if

else-less if directly nested in an else-less if

<!-- Written by docs/catalog.ts from `litany explain redundant-nested-if`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: sometimes · off by default**

An else-less `if` whose then-branch is directly another else-less
`if` is one condition spelled as two: `&&`'s short-circuit evaluates
the inner condition exactly when the nested form does.

```ocaml
(* bad *)  if ok then if ready then launch ()
(* good *) if ok && ready then launch ()
```

Fires when both `if`s are else-less and the inner one is the entire
then-branch (`begin end` and parentheses are transparent), at the outer
`if`. Any `else` — outer or inner — refuses: collapsing would change
what runs when the conditions split. Literal conditions are
suspicious-literal-condition's finding, `else if` chains are the idiom
and are never looked into, and a nested `if` under a `let` or sequence
deliberately does not fire. Deeper nests report once per level. The
fix rewrites the head to `c1 && c2`, parenthesizing each condition
unless atomic; it ships only when the text between the conditions is
exactly `then` `if` with whitespace — a parenthesis, `begin`, or
comment in the gap withholds the fix, not the finding. The fix writes
`&&`, so it is safe where that is the standard library's, and unsafe, applied
only under `--unsafe`, where something else in scope may bind it.
