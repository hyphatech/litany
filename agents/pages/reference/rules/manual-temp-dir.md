# manual-temp-dir

temp file removed and re-created as a directory

<!-- Written by docs/catalog.ts from `litany explain manual-temp-dir`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: sometimes · on by default**

`Filename.temp_file` creates the file exclusively — that exclusivity
is its entire security contract. Removing the file and re-creating its
name as a directory forfeits it: between the remove and the mkdir any
other process can claim the now-predictable path in a shared temp
directory (CWE-377), making the mkdir fail — or succeed inside an
attacker-provided symlinked parent where the temp directory is shared.
`Filename.temp_dir` (stdlib since 5.1, always inside the support
window) is the atomic, dedicated form.

```ocaml
(* bad *)  let d = Filename.temp_file p "" in
           Sys.remove d; Sys.mkdir d 0o700; ...
(* good *) let d = Filename.temp_dir p "" in ...
```

Fires on the three-step sequence: a binding of a `Filename.temp_file`
application (the omitted `?temp_dir` is tolerated) whose body removes
the bound path (`Sys.remove` or `Unix.unlink`) and then — directly, or
after one intervening statement — re-creates
it with `Unix.mkdir` or `Sys.mkdir`. Path identity is the bound
declaration's, never spelling: removing or making some other path
never counts. Anchored at the `temp_file` application. The fix
rewrites the direct shape to `Filename.temp_dir`, dropping the remove
and mkdir statements, when the unit is not preprocessed, the callee is
spelled exactly `Filename.temp_file`, the argument gaps are pure
whitespace (a written `~temp_dir:` refuses), the permission argument
is an integer literal (carried as `~perms:` unless it is `0o700`,
`temp_dir`'s default), the mkdir is followed by further statements
(so the binding still binds a path the rest uses), and no comment sits
in the deleted region. Any refused gate refuses the fix, never the
finding. The fix is safe where `Filename` is the standard library's, and unsafe,
applied only under `--unsafe`, otherwise. The sequence split across helper functions is a documented
false negative.
