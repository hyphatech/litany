# suspicious-if-same-branches

if whose two branches are written identically

<!-- Written by docs/catalog.ts from `litany explain suspicious-if-same-branches`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`if c then A else B` where `A` and `B` are the same bytes decides
nothing: either the condition is unnecessary or — more often — one
branch was meant to differ and a paste was never edited.

```ocaml
(* bad *)  if is_admin u then grant u else grant u
(* good *) if is_admin u then grant u else deny u
```

Fires when both branch slices of a non-preprocessed unit succeed and are
byte-identical after whitespace normalization (runs of spaces, tabs, and
newlines collapse to one space), and the condition is not a boolean
literal (suspicious-literal-condition owns those). Equality is the
source text, nothing deeper: branches differing only in a comment differ
in intent and do not fire, and `L.map` vs `List.map` — same resolution,
different spelling — is a deliberate false negative. Identical slices
imply identical effects, so no purity analysis is needed. No fix:
collapsing to one branch would bless the suspected copy-paste bug — the
author must decide which branch was meant to differ.
