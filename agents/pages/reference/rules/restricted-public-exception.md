# restricted-public-exception

exception declared in a public library interface

<!-- Written by docs/catalog.ts from `litany explain restricted-public-exception`; never edited by hand. -->

**restriction · warning · stable · since 1.0 · fix: never · off by default**

An exception in a public interface is an untyped failure path every
consumer inherits: the type checker tracks no `exception` the way it
tracks a `result`, so callers learn about the escape at run time, and
the interface's signatures stop telling the whole truth about what a
call can do.

```ocaml
(* bad *)  exception Parse_error of string
(* good *) type error = [ `Parse of string ]
           val parse : string -> (t, error) result
```

Why restrict this? Declared exceptions are legitimate OCaml across the
ecosystem — `Not_found` and `Exit` in the standard library,
`Scanf.Scan_failure`, the error exception of nearly every parser — so
no default may claim them as defects and this is never a Suspicious
rule. A result-typed house style (errors as typed `result` values) is
policy a workspace adopts, cherry-picked by exact name, off even under
`--select all`.

Fires once per exception of the export surface of a public library
unit — the interface when the unit has one, the implementation's own
inferred signature when it does not — anchored at the implementation's
matching root `exception` declaration (the emit contract owns findings
to the editable source). The gate is the roster's: only units whose
stanza kind is `Library` and whose visibility is `Public` fire
(`Unknown` visibility is treated as `Public`, the roster's own root
convention). Executables and tests have no consumers to protect and
never fire; a private library's exceptions are the workspace's own
business; a unit whose roster carries no kind is deliberately silent —
a metadata-gated rule degrades to silence, never to guessing. An
exception the `.mli` hides, a `let exception` inside a function, and
`type t += …` extension constructors deliberately do not fire.
Recorded false negatives, in the safe direction: exceptions of
submodule signatures (the export surface joins interface to
implementation at the unit's root only) and an interface exception
satisfied by `include` (no root declaration to anchor at). No fix:
replacing an exception with a `result` is an API redesign.
