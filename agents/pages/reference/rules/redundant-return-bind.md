# redundant-return-bind

bind of a fresh return wraps a value only to unwrap it

<!-- Written by docs/catalog.ts from `litany explain redundant-return-bind`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: never · off by default**

Binding a freshly returned value is the left identity law: the wrap is
undone by the bind, so applying the callback to the value directly says
the same thing without the round trip.

```ocaml
(* bad *)  Option.bind (Option.some x) f
(* good *) f x
```

Fires when a known-lawful pair resolves by declaration and the scrutinee
is that pair's return applied to a value — the return function
(`Option.some`, `Result.ok`, `Lwt.return`) or its constructor form
(`Some x`, `Ok x`, by predefined/global constructor identity):
definitional for `Option` and `Result`, documented for `Lwt`. Arbitrary
scrutinees, `Error` (not a return), partial applications, and a
project's own `bind`/`return` deliberately do not fire — each listed
pair is an audited lawfulness claim. No fix: naming the callback's
argument is editorial.
