# manual-tuple-matching

single irrefutable tuple case that could be a let binding

<!-- Written by docs/catalog.ts from `litany explain manual-tuple-matching`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: sometimes · off by default**

A `match` with exactly one case whose pattern is an irrefutable tuple
does no branching: a single guard-less irrefutable case evaluates the
scrutinee, binds, and continues — which is `let`'s definition, and `let`
says so.

```ocaml
(* bad *)  match p with (a, b) -> a + b
(* good *) let (a, b) = p in a + b
```

Fires on a `match` with exactly one guard-less computation case whose
pattern is an unlabeled tuple of irrefutable components — variables,
wildcards, and nested unlabeled tuples of the same. Refutable
components (constants, constructors, records) refuse conservatively:
there the `let` form merely relocates the partiality, which is warning
8's business in both spellings. Guarded cases, multi-case matches,
`exception` arms, effect-handler matches, and the `function (a, b) ->`
spelling (`needless-fun-match`'s territory) do not fire. Alias
components (`(x, _) as whole`) and constraint components
(`((a : int), b)`) refuse conservatively, recorded false negatives. The fix rewrites `match ... with pat -> body` to
`let pat = scrutinee in body` when the unit is not preprocessed and
the keyword gaps normalize to exactly `match`, `with` (or `with |`),
and `->` — a comment in any gap refuses the fix, never the finding.
The pattern is spliced verbatim; the scrutinee through `Unit.splice`.
Purely stylistic; some houses prefer `match` even here for uniformity
with sibling arms — Style/off is the posture. `fun x -> match x with
(a, b) -> e` co-fires with `needless-fun-match` at distinct anchors
with converging remedies — both claims true; apply either fix and the
other finding clears.
