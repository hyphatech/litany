# manual-format-quoting

format literal hand-quotes %s where %S quotes and escapes

<!-- Written by docs/catalog.ts from `litany explain manual-format-quoting`; never edited by hand. -->

**pedantic · warning · nursery · since 1.0 · fix: sometimes · off by default**

A format string that hand-writes quotes around `%s` — `"name=\"%s\""`
— re-implements `%S` minus its escaping: `%S` prints the argument quoted
*and* OCaml-escaped, so payloads containing quotes, backslashes, or
control characters stay unambiguous.

```ocaml
(* bad *)  Printf.sprintf "name=\"%s\"" n
(* good *) Printf.sprintf "name=%S" n
```

Fires once per typed format literal containing the byte sequence
`"` `%` `s` `"`, whatever function consumes it — `Printf`, `Format`, and
every user of `format6` alike. Plain strings that merely contain the
sequence are never elaborated to a format constructor and are clean by
construction; dynamic formats have no literal. The fix replaces each
hand-quoted `%s` with `%S` and is Unsafe: `%S` escapes its argument
where the hand-written quotes do not, which changes output on payloads
containing quotes, backslashes, or control characters — usually the
improvement the author wants, but a behavior change.
