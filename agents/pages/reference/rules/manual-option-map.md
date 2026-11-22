# manual-option-map

two-case match that unwraps, transforms, and rewraps an option

<!-- Written by docs/catalog.ts from `litany explain manual-option-map`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: sometimes · off by default**

`match o with Some x -> Some E | None -> None` is `Option.map
(fun x -> E) o` written longhand: both forms evaluate the scrutinee once
and `E` only in the `Some` case.

```ocaml
(* bad *)  match o with Some x -> Some (x + 1) | None -> None
(* good *) Option.map (fun x -> x + 1) o
```

Fires on exactly two guard-less cases — `Some` with a bare-variable
payload rebuilding `Some`, and `None` rebuilding `None`, in either
order, by predefined-constructor identity — in both the `match` and the
`function` form. The degenerate rebuild `Some x -> Some x` is the
scrutinee itself and gets its own message. Guards, wildcard arms, deeper
payload patterns, aliases, `exception` arms, user-defined `Some`/`None`
constructors, and `Some` arms that do not rebuild `Some` (`Option.bind`
territory) deliberately do not fire. The fix rewrites the match form to
`Option.map (fun x -> E) o` — the tighter `Option.map f o` when `E` is
exactly `f x` for an identifier `f` other than `x`, and the scrutinee
alone for the degenerate rebuild — where the sources slice cleanly; the
`function` form has no scrutinee to name and ships none. The `Option.map`
rewrite is safe where `Option` is the standard library's and `E` names no
constructor or field the checker may have chosen by its expected type, and
unsafe, applied only under `--unsafe`, otherwise. The scrutinee alone names
nothing, and is safe.
