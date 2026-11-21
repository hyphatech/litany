# Getting Started

The linter for modern OCaml.

litany is a linter for OCaml that reads what the compiler wrote. Its rules
run over the typed tree and match what a name is, never how it is spelt: an
alias or an `open` fires, and a local name that shadows one never does. A
source is linted only when its `.cmt` was compiled from those exact bytes, so
a stale artifact is a counted skip, never a stale finding.

## Install

```sh
opam repo add open-opam https://github.com/open-opam/opam-repository.git
opam install hypha-litany
```

Install it in the switch of the project it lints, on OCaml 5.5: litany reads
only the artifacts of the compiler it was built with, and refuses any other,
naming both versions.

## Lint a project

A dune project needs no configuration; any other build system reaches litany
through [a unit file](guide/build-integration.md#unit-files). Given this
library:

```ocaml title="lib/inventory.ml"
type t = { stock : (string * int) list }

let restock t = t
let check t = if List.length t.stock = 0 then restock t else t
let find t name = List.find (fun (n, _) -> n == name) t.stock
```

Run `litany check` at the project's root. It builds with `dune build @check`
and runs the default rules:

```console
$ litany check
File "lib/inventory.ml", line 4, characters 17-40:
4 | let check t = if List.length t.stock = 0 then restock t else t
                     ^^^^^^^^^^^^^^^^^^^^^^^
Warning 0 [needless-list-length]: comparison through List.length is a needless emptiness test
  fix (safe): compare with []

File "lib/inventory.ml", line 5, characters 43-52:
5 | let find t name = List.find (fun (n, _) -> n == name) t.stock
                                               ^^^^^^^^^
Warning 0 [suspicious-physical-equality]: physical comparison has a non-immediate operand

30 rules selected · 1 unit · 2 findings (1 fixable — run `litany check --fix`) · 0 skipped
```

A finding has the shape of a compiler diagnostic, so editors jump to it. The
name in brackets is the rule: `litany explain needless-list-length` prints
[its documentation](reference/rules/needless-list-length.md).

The exit code is the verdict:

| Exit | Meaning |
| --- | --- |
| 0 | no findings |
| 1 | findings |
| 2 | litany could not run: a failed build, a bad configuration, a version mismatch |
| 3 | internal error: a rule failed, and everything else completed |

## Fix

`litany check --fix` applies every safe fix, then rebuilds and lints again:

```console
$ litany check --fix
fix lib/inventory.ml: 1 applied
pass 1: 1 fix applied (1 file)
pass 2 (rebuild + re-lint): findings remain
File "lib/inventory.ml", line 5, characters 43-52:
5 | let find t name = List.find (fun (n, _) -> n == name) t.stock
                                               ^^^^^^^^^
Warning 0 [suspicious-physical-equality]: physical comparison has a non-immediate operand

30 rules selected · 1 unit · 1 finding · 1 fix applied · 0 skipped
```

The comparison is now `t.stock = []`. The physical equality has no fix: that
judgement is yours.

## Silence a finding

Annotate the code, with a reason:

```ocaml
let check t =
  (if List.length t.stock = 0 then restock t else t)
  [@litany.allow "needless-list-length: benchmarking the walk itself"]
```

An `allow` that no longer hides anything is itself a finding, so suppressions
cannot rot.

## Next

- [Selecting rules](guide/selecting-rules.md) -- what runs by default,
  and what you can add.
- [Configuration](guide/configuration.md) -- the `litany` file.
- [Build integration](guide/build-integration.md) -- findings in your
  editor, and other build systems.
- [CI](guide/ci.md) -- annotations on GitHub, and JSON.
- [The rules](reference/rules.md) -- every rule litany has.
