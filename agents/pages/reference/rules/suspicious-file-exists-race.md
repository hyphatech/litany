# suspicious-file-exists-race

exists check guarding a filesystem operation on the same path

<!-- Written by docs/catalog.ts from `litany explain suspicious-file-exists-race`; never edited by hand. -->

**restriction · warning · stable · since 1.0 · fix: never · off by default**

`if Sys.file_exists p then <operate on p>` is two non-atomic steps:
the world can change between them — a concurrent test run, an `at_exit`
cleanup, a watch loop — so the guard buys nothing (the guarded
operation can still raise) while adding a race window. The principled
form performs the operation and matches its exception; the ops this
rule watches each have a crisp one-errno rewrite (`ENOENT`/`EEXIST`).

```ocaml
(* bad *)  if Sys.file_exists path then Sys.remove path
(* good *) (try Sys.remove path with Sys_error _ -> ())
```

Why restrict this? The race is real but widely tolerated: in
single-process test cleanup it never fires, so a report there is
robustness pedantry, while the same shape in library code (a `finally`
cleanup whose unguarded `Sys.remove` masks the body's result) earns
its keep. Whether the exception-matching discipline is worth demanding
everywhere is house policy, so the rule sits in the `restriction`
tier: off even under `--select all`, cherry-picked by workspaces that
adopt it.

Fires, in non-preprocessed units, on an `if` whose condition is a
`Sys.file_exists E` probe — bare, under `not`, or as the left conjunct
of `&&` with a `Sys.is_directory` refinement — when either arm applies
`Sys.remove`, `Sys.mkdir`, `Sys.rename`, `Unix.unlink`, `Unix.mkdir`,
or `Unix.rmdir` (by resolved identity) to a path argument whose source
slice equals `E`'s after whitespace normalization, `E` itself being
syntactically pure: an identifier, a constant, or a constructor of
pure parts. Anchored at the condition, one finding per `if`. An
operation under a `try` — or under a `match` with an `exception` case
on its scrutinee — is tolerated: a handled operation is the remedy,
not the defect. Guarded reads (`Sys.readdir`), a computed or impure
path expression (`Filename.concat dir f` refuses the purity test —
identical slices could denote different files), operations on a
different path, operations deferred inside a function or `lazy`,
operations under a nested exists-guard (the inner `if` reports
itself), operations past a `let` that rebinds an identifier of the
probed path (the spelling now names a different file, so slice
equality would lie — the rebinding subtree is skipped whole), platform
probes, and existence checks used as values deliberately do not fire;
each is a recorded false negative in the safe direction. No fix: the
remedy restructures control flow around the operation's exception.
