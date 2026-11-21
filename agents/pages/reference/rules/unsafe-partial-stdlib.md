# unsafe-partial-stdlib

reference to a partial stdlib eliminator

<!-- Written by docs/catalog.ts from `litany explain unsafe-partial-stdlib`; never edited by hand. -->

**restriction · warning · stable · since 1.0 · fix: never · off by default**

The stdlib's partial eliminators raise on the case their type admits
but their contract excludes: `List.hd` and `List.tl` raise `Failure` on
`[]`, `List.nth` raises on short lists and negative indices, `Option.get`
raises `Invalid_argument` on `None`, and `Result.get_ok`/`get_error`
raise on the other constructor. Each has a total spelling — a match,
`List.nth_opt`, `Option.value`, or `Result.get_ok'` with its carried
message.

```ocaml
(* bad *)  Option.get (find_user id)
(* good *) match find_user id with Some u -> … | None -> …
```

Why restrict this? Partiality is a legitimate tool — a raise in a
failing test is the test doing its job, and field review measured
exactly that population (261 findings on one real workspace, 246 of
them in test code, the sampled remainder contract-true). A partial
eliminator is a finding only where the house has banned the idiom in
favor of total spellings, so the rule is house policy in the
`restriction` tier — off even under `--select all`, cherry-picked by
exact name, with `[@litany.expect]` as the per-call justification
trail.

Fires once per reference that resolves to a listed `Stdlib` declaration
— saturated calls, partial applications, and first-class uses alike, and
through aliases and `open`. Shadowed modules, values merely named `hd`,
the `_opt`/`value` siblings, and the `Not_found` retrieval protocol
(`List.find`, `Hashtbl.find`, `Sys.getenv`, …) deliberately do not fire.
No fix: each remedy restructures control flow.
