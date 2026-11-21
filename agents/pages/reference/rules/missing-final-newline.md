# missing-final-newline

file does not end with a newline

<!-- Written by docs/catalog.ts from `litany explain missing-final-newline`; never edited by hand. -->

**style · warning · nursery · since 1.0 · fix: always · off by default**

A file whose last line has no terminating LF confuses line-oriented
tools — `cat` runs files together, `wc -l` miscounts, diffs grow the
"no newline at end of file" wart — and appending a line churns the
previous one.

```ocaml
(* bad *)  …let x = 1⏹
(* good *) …let x = 1␊⏹
```

Reports a zero-width finding at the end-of-file insertion point when the
last byte of a non-empty file is not LF. Empty files are clean, and CRLF
endings are accepted because their final byte is LF. Every finding carries
the insertion fix (`add a final newline`), appending one line terminator
in the file's own style: `\r\n` when the file's last line break is CRLF,
one LF otherwise — a fix must not leave a file with mixed endings.
