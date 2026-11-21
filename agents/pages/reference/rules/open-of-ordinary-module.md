# open-of-ordinary-module

an open of a module that is not made to be opened

<!-- Written by docs/catalog.ts from `litany explain open-of-ordinary-module`; never edited by hand. -->

**restriction · warning · nursery · since 1.1 · fix: never · off by default**

An `open` of an ordinary module makes every name of the file a
question -- where did it come from? -- and a name the module gains later
silently shadows one of the file's own. A module made to be opened is
one of binding operators and nothing else (`open Result.Syntax`).

```ocaml
(* bad *)  open Store
(* good *) module S = Store
```

Why restrict this? `open` is idiomatic OCaml in many houses; aliasing
every module instead is a discipline a house adopts.

Fires at an `open` that is a structure item, at the root of a unit or
in a nested structure, through which the unit takes anything but
binding operators (`let*`, `and+`, ...) -- a value, a type, a constructor,
a record field or a member of a submodule -- or takes nothing at all. A
name written out in full is not taken through the open. An `open` of a module of binding
operators alone, and an `open` local to an expression -- `let open M in
e` or `M.(e)`, where a library of combinators or operators is opened
around the expression that uses it -- deliberately do not fire. No fix:
an alias names the module, and every use changes with it.
