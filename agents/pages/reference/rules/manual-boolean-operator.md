# manual-boolean-operator

if with one boolean-literal branch spells an operator longhand

<!-- Written by docs/catalog.ts from `litany explain manual-boolean-operator`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: sometimes · off by default**

An `if` with exactly one boolean-literal branch spells a boolean
operator in longhand: `if c then true else e` is `c || e`, `then false
else e` is `not c && e`, `then e else true` is `not c || e`, and `then
e else false` is `c && e`. Every rewrite preserves evaluation order and
effects.

```ocaml
(* bad *)  if found then true else retry ()
(* good *) found || retry ()
```

Fires when the condition is not itself a boolean literal (that is
suspicious-literal-condition's finding) and exactly one branch is a
boolean literal by predefined-constructor identity. Two-literal
branches are redundant-if-bool's, and integer 0/1 branches and
user-defined `True`/`False` constructors deliberately do not fire.

Style: in a scanning loop --
`if i = len then true else if … then false else aux (i + 1)` -- the
operator rewrite is a side-grade that folds match-, let-, and multi-line
arms into `||`/`&&` operands, so it is off by default and opt-in.
The unambiguous two-literal shapes are redundant-if-bool's. The fix performs the table's rewrite
from the condition's and surviving branch's source slices
(`Unit.splice`), parenthesizing non-atomic operands; every cell splices
`not`, `&&`, or `||` — spellings that resolve in the fix site's scope,
which the rule never checked — so all fixes are unsafe, applied only
under `--fix --unsafe`. The replacement is an infix expression, and an
`if` may legally sit unparenthesized as the right operand of an infix
operator (`a && if c then true else e`), where the bare rewrite would
re-associate — `a && c || e` is `(a && c) || e`, a silent behavior
change; when the `if` is an application's trailing operand the fix
parenthesizes the rewrite (`a && (c || e)`), and an `if` already
parenthesized keeps its pair through `Unit.delimited`. A standalone
`if`, or one that is a `let` body, takes the bare rewrite.
