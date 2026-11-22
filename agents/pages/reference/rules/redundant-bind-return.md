# redundant-bind-return

bind into a bare return re-wraps the value unchanged

<!-- Written by docs/catalog.ts from `litany explain redundant-bind-return`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

Binding a computation into its monad's own `return` is the right
identity law: every value is re-wrapped exactly as it arrived, so the
whole expression is the computation it started from.

```ocaml
(* bad *)  Option.bind o Option.some
(* good *) o
```

Fires when a known-lawful pair resolves by declaration: `Option.bind`
with `Option.some`, `Result.bind` with `Result.ok`, or `Lwt.bind` /
`Lwt.Infix.(>>=)` with `Lwt.return` — the return passed as the bare
callback, or as a lambda returning exactly the bound value
(`fun x -> Some x`, `function x -> Ok x`, `fun x -> Lwt.return x`;
constructor and function returns alike, by declaration or
predefined-constructor identity). A project's own `bind` and `return`
never fire, lawful or not: each listed pair is an audited lawfulness
claim, and other identities match nothing. `let*` syntax, guarded or
multi-case `function` callbacks, and callbacks returning anything but
the bound value deliberately do not fire. No automatic fix.
