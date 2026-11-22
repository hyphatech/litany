# trailing-whitespace

trailing spaces or tabs at end of line

<!-- Written by docs/catalog.ts from `litany explain trailing-whitespace`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: always · off by default**

Trailing whitespace is invisible, churns diffs, and survives only
until the next editor with different settings touches the line.

```ocaml
(* bad *)  let x = 1␣␣
(* good *) let x = 1
```

Reports each maximal run of ASCII space or tab immediately before LF,
CRLF, or end of file, outside a string literal, where it is the string's
content. A lone CR is ordinary source content, not a line
ending, so whitespace before one deliberately does not fire. Every finding
carries the deletion fix (`delete the trailing whitespace`), removing
exactly the reported run.
