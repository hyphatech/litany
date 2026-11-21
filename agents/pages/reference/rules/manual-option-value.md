# manual-option-value

two-case match extracting an option's value over a trivial default

<!-- Written by docs/catalog.ts from `litany explain manual-option-value`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: sometimes · off by default**

`match o with Some x -> x | None -> D` is `Option.value o
~default:D` — but only when `D` is guaranteed cheap and effect-free:
`Option.value` evaluates its `default` argument always, the match only
on `None`. The rule proves `D` trivial before firing — a literal, an
identifier, or a nullary constructor — so every effectful or costly
default deliberately stays clean.

```ocaml
(* bad *)  match o with Some x -> x | None -> 0
(* good *) Option.value o ~default:0
```

Fires on exactly two guard-less cases — `Some` with a bare-variable
payload returned unchanged, and `None` returning a trivial `D`, in
either order, by predefined-constructor identity — in both the `match`
and the `function` form. Effectful or raising defaults, transforming
`Some` arms (`Option.fold` territory), guards, unused payloads, and
user-defined `Some`/`None` constructors deliberately do not fire. The
fix rewrites the match form to `Option.value o ~default:D` where the
sources slice cleanly; the `function` form has no scrutinee to name and
ships none. The fix is safe where `Option` is the
standard library's and the default names no constructor the checker may have
chosen by its expected type, and unsafe, applied only under `--unsafe`, otherwise.
