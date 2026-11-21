# suspicious-lost-backtrace

work between catching and re-raising can overwrite the backtrace

<!-- Written by docs/catalog.ts from `litany explain suspicious-lost-backtrace`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`raise e` on a handler-bound exception compiles to a backtrace-
preserving reraise — but what it preserves is the *current* per-domain
backtrace buffer, and any raise that happens in between, even one that
is caught, rewrites that buffer. A handler that logs, unlocks, or cleans
up before re-raising can therefore report the wrong backtrace.

```ocaml
(* bad *)  try f () with e -> log_error e; raise e
(* good *) try f () with
           | e ->
               let bt = Printexc.get_raw_backtrace () in
               log_error e;
               Printexc.raise_with_backtrace e bt
```

Fires on `try` handlers and `match … with exception` arms that bind
their exception to a bare variable without a guard, do at least one
statement of work (a sequence or `let` spine), and end in `raise` of
exactly that variable; the finding anchors at the final reraise. The
bare `try f () with e -> raise e` already preserves the backtrace and
does not fire; neither do guards, `raise_notrace` (explicit discard),
`Printexc.raise_with_backtrace` (the remedy), re-raises of a different
or wrapped exception, or handlers matching a specific exception pattern.
No fix: the rewrite introduces a binding and reorders the handler.
