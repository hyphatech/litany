# suspicious-failwith-in-library

failwith referenced in library code

<!-- Written by docs/catalog.ts from `litany explain suspicious-failwith-in-library`; never edited by hand. -->

**restriction · warning · stable · since 1.0 · fix: never · off by default**

`Failure` is anonymous — the one exception no caller can match
meaningfully — and `failwith` in a library manufactures it at the API
boundary: configuration failures, invariant violations, and stubs all
escape as the same unmatchable exception.

```ocaml
(* bad *)  let connect cfg = if bad cfg then failwith "bad TLS config" else …
(* good *) let connect cfg = if bad cfg then Error `Tls_config else Ok …
```

Why restrict this? The defect is the *escape* — an anonymous `Failure`
crossing the API boundary — and this rule cannot prove an escape: local
failwith trampolines (raise here, catch just above) are a legitimate
style established libraries practice, and the same reference-level
check would flag them. A rule that cannot prove the defect and flags
the practice is house policy by definition, so it sits in the
`restriction` tier: off even under `--select all`, cherry-picked by a
workspace whose libraries speak typed errors, with `[@litany.expect]`
as the justification trail for the trampolines it cannot see.

Fires once per resolved reference to `Stdlib.failwith` — aliasing a
failwith is a failwith — in units whose roster kind is `Library`,
except references lexically enclosed in a `Texp_try` (the same-function
trampoline shape: raise here, catch just above). Executables and tests
fail fast by right and are clean by kind; a unit whose roster carries
no kind is deliberately silent — a metadata-gated rule degrades to
silence, never to guessing. A locally shadowed `failwith` resolves to a
local declaration and never fires. The exemption is meant for a try
whose handler matches `Stdlib.Failure` alone; handler
exception-constructor identity needs a pattern-side view that has not
landed, so any enclosing try exempts — a recorded false negative in
the safe direction. Cross-function trampolines take one `[@litany.expect]`. No
fix: the replacement error path is a design decision.
