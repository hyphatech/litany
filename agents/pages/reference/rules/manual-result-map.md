# manual-result-map

two-case match that transforms one result arm and rebuilds the other

<!-- Written by docs/catalog.ts from `litany explain manual-result-map`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: sometimes · off by default**

`match r with Ok x -> Ok E | Error e -> Error e` is `Result.map
(fun x -> E) r`: the error arm provably rebuilds the same payload. The
mirrored shape — identity `Ok` arm,
transforming `Error` arm — is `Result.map_error` and is matched too,
with its own message.

```ocaml
(* bad *)  match r with Ok x -> Ok (parse x) | Error e -> Error e
(* good *) Result.map (fun x -> parse x) r
```

Fires on exactly two guard-less cases — `Ok` and `Error` with
bare-variable payloads, in either order, identified by the constructors'
result-type head being the global `Stdlib.result` path — in both the
`match` and the `function` form, when exactly one arm transforms and the
other is an identity rebuild; when both arms are identity rebuilds the
match is the scrutinee itself and says so. Guards, deeper payload
patterns, wildcard payloads, arms that do not rebuild their constructor
(`Result.bind` territory), both arms transforming, and user variants
spelling `Ok`/`Error` deliberately do not fire. The fix rewrites the
match form to `Result.map (fun x -> E) r` / `Result.map_error (fun e ->
E) r` (the scrutinee alone for the double identity) where the sources
slice cleanly; the `function` form has no scrutinee to name and ships
none. The `Result` rewrites are safe
where `Result` is the standard library's and `E` names no constructor or field
the checker may have chosen by its expected type, and unsafe, applied only under
`--unsafe`, otherwise. The scrutinee alone names nothing, and is safe.
