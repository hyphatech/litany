# suspicious-ambiguous-constructors

constructor that shadows a standard constructor

<!-- Written by docs/catalog.ts from `litany explain suspicious-ambiguous-constructors`; never edited by hand. -->

**suspicious · warning · nursery · since 1.0 · fix: never · off by default**

A variant that declares a constructor named `Some`, `None`, `Ok`,
`Error`, `::`, or `[]` shadows a predefined or stdlib constructor for
the rest of the scope: every later unannotated `Some x` builds this
type, option/result code nearby starts needing type-directed
disambiguation, and the reader must track which `Some` is which. The
compiler's own diagnostics (warnings 41/42) fire only at use sites,
only when force-enabled, and are off in vanilla and dune-dev defaults
alike — the declaration, where the decision is actually made, is dark
everywhere.

```ocaml
(* bad *)  type str_option = Some of string | None
(* good *) type str_option = Found of string | Missing
```

Fires once per shadowing constructor, at its declaration. A re-export
(`type 'a maybe = 'a option = None | Some of 'a`) redeclares
constructors that already exist by construction and is exempt: a
variant kind with a manifest is necessarily the re-export form.
`exception Error of string` shadows identically but is an extension
constructor, not a variant declaration — a recorded false negative. No
fix: the remedy (rename, or prefix with the domain) is a design
decision, and a DSL that deliberately re-models this vocabulary should
carry `[@litany.allow]` with the reason at the declaration.
