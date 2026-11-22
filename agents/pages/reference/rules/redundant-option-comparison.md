# redundant-option-comparison

comparison with None spells an Option predicate

<!-- Written by docs/catalog.ts from `litany explain redundant-option-comparison`; never edited by hand. -->

**pedantic · warning · stable · since 1.0 · fix: sometimes · off by default**

`o = None` and `o <> None` are `Option.is_none o` and
`Option.is_some o` spelled through the polymorphic comparison. The
named predicates state the intent and survive a payload type turning
uncomparable. That is a preference, not a defect: the comparison is a
constant-time tag test either way, and `x = None` is common, idiomatic
OCaml — hence Pedantic. Adopt it where a codebase wants the predicate
spelling; `!r = None` reads at least as well as `Option.is_none !r`.

```ocaml
(* bad *)  if o = None then default else run o
(* good *) if Option.is_none o then default else run o
```

Fires when `=` or `<>` resolves to its `Stdlib` declaration with
exactly one operand the predefined `None` constructor, in either
position. Comparisons against `Some e` are out of scope entirely —
payload equality may deep-traverse and raise, and is a meaningful
program. `None = None` (a two-constant expression), orderings,
`compare`, physical equality, user-defined `None` lookalikes, and
shadowed operators deliberately do not fire. The fix rewrites the whole
comparison to the predicate applied to the other operand — structural
comparison against the immediate `None` decides on the tag without
traversing the payload, so the predicate computes the same answer, even
for payloads whose comparison would raise. The fix is safe where `Option` is the
standard library's, and unsafe, applied only under `--unsafe`, otherwise.

The reporting unit is the boolean chain, not the comparison: when two
or more such comparisons are direct operands of one `Stdlib` `&&`/`||`
chain (`s.arch <> None && s.layers <> None && s.rope <> None`), the
chain is one finding — anchored at
the whole chain, its fix rewriting every comparison at once — not one
per operand. A chain carrying exactly
one such comparison reports it as the standalone form does; a
comparison below anything other than a chain connective (an argument, a
`not`) keeps its own finding, and a rebound connective is no chain at
all. In preprocessed units the collapse is off and every comparison
reports individually: a rewriter-manufactured chain could anchor the
collapsed finding at a ghost location the emit contract drops,
silencing members that are real.
