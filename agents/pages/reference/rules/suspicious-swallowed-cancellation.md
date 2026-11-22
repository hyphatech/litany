# suspicious-swallowed-cancellation

total handler around eio code converts cancellation into a value

<!-- Written by docs/catalog.ts from `litany explain suspicious-swallowed-cancellation`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: sometimes · on by default**

Eio delivers fiber cancellation as the `Eio.Cancel.Cancelled`
exception out of any suspending operation, and a handler must let it
through, or the fiber keeps running with a corrupted notion of what
happened: cancellations get recorded as data errors, cleanup runs
twice, supervisors log garbage.

```ocaml
(* bad *)  try Ok (Eio.Path.read_dir dir) with exn -> Error exn
(* good *) try Ok (Eio.Path.read_dir dir) with
           | Eio.Cancel.Cancelled _ as cancelled -> raise cancelled
           | exn -> Error exn
```

Fires on a `try` handler or the `exception` cases of a `match` where a
guard-less total arm — a bare variable or wildcard — converts to a
value (a wrap-raise like `raise (Wrapped e)` still converts
cancellation and counts; a plain re-raise of the binder, or
`Printexc.raise_with_backtrace`, does not), no sibling arm passes the
exception through (an alias arm re-raising its own binder,
`| Eio.Cancel.Cancelled _ as e -> raise e` — the discipline real Eio
code practices), and the guarded region applies at least one function
declared in an `Eio`-family compilation unit (`Eio`, `Eio_unix`,
`Eio_main`, `Eio_posix`) — total handlers around pure code stay silent.
The pass-through condition is meant to be `Eio.Cancel.Cancelled`
constructor identity by UID; pattern-side exception-constructor
identity has not landed, so the alias-re-raise shape stands in — a bare
`Eio.Cancel.Cancelled _` sibling arm does not yet silence (a recorded
gap), and a sibling alias arm re-raising a non-Cancelled exception
silences (recorded false negative). Handlers inside
`Eio.Cancel.protect` and deliberate supervisor recorders are
`[@litany.allow]` cases. The fix inserts the guard arm on its own line
before the total one, and only when that arm sits on its own
`| `-prefixed line; it changes behavior — that is its point — so it
applies only under `--fix --unsafe`.
