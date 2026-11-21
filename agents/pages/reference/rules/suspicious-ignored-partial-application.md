# suspicious-ignored-partial-application

ignore of a value that is still a function

<!-- Written by docs/catalog.ts from `litany explain suspicious-ignored-partial-application`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`ignore e` where `e` is still a function discards a closure — a
partial application whose remaining arguments, and therefore whose
effects, never happen. The compiler's warning 5 already covers the
spelled-out half — `ignore (f x)` with arguments missing, and the
`let`/`match`/`if` spines ending in one; what it cannot see is a
function *value* reaching `ignore`: a partially applied closure bound
earlier, an alias, a literal `fun`.

```ocaml
(* bad *)  let flush = save fd in … ignore flush
(* good *) let flush = save fd in … flush data
```

Fires when `ignore` resolves to its `Stdlib` declaration with exactly
one unlabeled argument whose type head is an arrow and whose shape
warning 5 does not already flag; the pipeline spellings `e |> ignore`
and `ignore @@ e` reach the rule as the same application. Applications,
method sends, and statement spines stay clean — the compiler owns them —
as do constraint-annotated arguments (`ignore (f : _ -> _)`, warning 5's
documented escape and this rule's accepted discard idiom), shadowed
`ignore`, non-arrows, and abbreviation heads (`type cb = unit -> unit`).
A literal closure fires — the pinned decision. No fix: the remedy is
supplying the missing arguments, or the typed discard
`let (_ : _ -> _) = e` when the discard is deliberate.
