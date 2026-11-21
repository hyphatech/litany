# suspicious-physical-equality

physical comparison with a non-immediate operand

<!-- Written by docs/catalog.ts from `litany explain suspicious-physical-equality`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`==` and `!=` compare identity, not contents: on boxed values two
structurally equal operands may or may not share one allocation, so the
answer depends on the program's allocation history.

```ocaml
(* bad *)  "a" ^ "b" == "ab"
(* good *) "a" ^ "b" = "ab"
```

Fires only when the operator resolves to `Stdlib.(==)` or `Stdlib.(!=)`
and at least one operand's type is proved non-immediate: a function, a
tuple, or a predefined boxed type (`string`, `bytes`, `float`, `array`,
and kin). Operands whose immediacy is unknown — type variables,
abbreviations, user-defined types — deliberately do not fire, and neither
do shadowed operators or partial applications. Physical identity can be
intentional, so there is no automatic fix.
