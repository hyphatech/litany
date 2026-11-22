# invalid-nan-comparison

comparison with nan is a compile-time constant

<!-- Written by docs/catalog.ts from `litany explain invalid-nan-comparison`; never edited by hand. -->

**correctness · error · stable · since 1.0 · fix: never · on by default**

IEEE 754 makes `nan` unordered with everything, itself included: `=`,
`<`, `>`, `<=`, and `>=` against `nan` are always `false` and `<>` is
always `true`, so the comparison never tests what it spells.

```ocaml
(* bad *)  x = nan
(* good *) Float.is_nan x
```

Fires when `=`, `<>`, `<`, `>`, `<=`, or `>=` resolves to its `Stdlib`
declaration with `Stdlib.nan` or `Stdlib.Float.nan` as an operand.
Shadowed operators or `nan` names, `nan` reached through an alias
(`let m = nan in x = m` — identity, not dataflow), `compare` and its kin
(a defined total order), physical equality (not constant: the same box
compares true), and other float constants deliberately do not fire. The
rewrite to `Float.is_nan` changes a constant answer into the intended
test — unsafe by policy. No automatic fix in this release — the promise
flips to `Sometimes` when that rewrite lands.
