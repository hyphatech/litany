# suspicious-general-float-equality

bit-exact equality on floats

<!-- Written by docs/catalog.ts from `litany explain suspicious-general-float-equality`; never edited by hand. -->

**pedantic · warning · stable · since 1.0 · fix: never · off by default**

`=` and `<>` on floats ask for bit-exact equality of values that
arithmetic rarely reproduces bit-exactly: `0.1 +. 0.2 <> 0.3`.

```ocaml
(* bad *)  weight = 0.1
(* good *) Float.abs (weight -. 0.1) < epsilon
```

Fires when `=` or `<>` resolves to its `Stdlib` declaration and at
least one operand's type head is the predefined `float`. Comparisons
against exactly representable anchors are excluded: a float literal
denoting zero (`0.`, `-0.0`, `0x0p0`) and the `infinity` and
`neg_infinity` constants. A `nan` constant operand is
invalid-nan-comparison's finding, never this rule's — the two rules
partition float `=`/`<>` exactly. Orderings are meaningful on floats
and out of scope; type abbreviations over `float` are conservatively
clean (no expansion); shadowed operators do not fire. Code that means
bit-exact equality writes `Float.equal x y` — a distinct declaration
this rule never matches — or carries `[@litany.allow
"suspicious-general-float-equality: exact comparison intended"]` where
the operator form must stay. No fix: a margin-of-error rewrite is
domain-specific.
