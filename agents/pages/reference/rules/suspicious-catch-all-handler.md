# suspicious-catch-all-handler

wildcard exception handler swallows every exception

<!-- Written by docs/catalog.ts from `litany explain suspicious-catch-all-handler`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`try … with _ -> …` handles every exception — `Out_of_memory`,
`Stack_overflow`, `Assert_failure`, and the one the author never
anticipated — indistinguishably from the one it meant to catch, hiding
real failures.

```ocaml
(* bad *)  try f () with _ -> default
(* good *) try f () with Not_found -> default
```

Fires once per wildcard, guard-less handler case: in `try` handlers and
in `match` `exception` arms, anchored at the wildcard itself. A named
binder (`with e -> …`) deliberately does not fire even when unused —
warning 27 owns that, and a name at least admits `raise e`. Guarded
wildcards, wildcards inside deeper patterns (`Failure _`), or-patterns,
and wildcard value cases do not fire either. No fix: only the author
knows which exception was meant.

The deliberate `with _ -> None` option-izer is one `[@litany.allow]` away.
