# restricted-dependency

reference to a dependency forbidden by workspace policy

<!-- Written by docs/catalog.ts from `litany explain restricted-dependency`; never edited by hand. -->

**restriction · warning · stable · since 1.0 · fix: never · off by default**

A dependency the workspace has moved off — `Str` for `Re`, a bare
stdlib helper for the house wrapper — stays reachable forever, and the
policy against it lives in review comments until a linter carries it.
This rule is the configured deny-list: each forbid in the config names a
module or value and the replacement to use, and every reference
resolving to a forbidden declaration reports that replacement.

```lisp
(rule restricted-dependency
 (forbid Str
  (use "Re — Str answers matches through global state"))
 (forbid Stdlib.invalid_arg
  (use "Import.invalid_arg' — house messages carry module and function")))
```

```ocaml
(* bad *)  let re = Str.regexp "a+"
(* good *) let re = Re.compile Re.(rep1 (char 'a'))
```

A forbid path ending in a capitalized component forbids a module: a
single component (`Str`) is a compilation unit, and a dotted path
(`Stdlib.Obj`, `Vendor.Internal`) resolves by signature walk from its
head unit, through module aliases — any value reference reaching through
the forbidden module fires. A path ending in a lowercase or operator
component (`Stdlib.invalid_arg`, quoted `"Stdlib.(=)"`) forbids that
one value. Matching is by resolved declaration UID, never by spelling:
`open`s and aliases (`module R = Str`) fire, and a forbidden path that
does not resolve in the linted workspace matches nothing — never an
error — so one house config serves projects that lack the library
entirely. Mind the spelling of separately compiled libraries: `Str` is
its own compilation unit, so write `(forbid Str ...)` — `Stdlib.Str`
names no declaration and matches nothing. Operator paths must be quoted
so the config reader keeps them one atom: `(forbid "Stdlib.(=)" ...)`.

Why restrict this? Every forbidden name is legitimate OCaml — `Str`
ships with the distribution, `invalid_arg` is the stdlib's own
spelling — so no default may claim them as defects; which dependencies a
workspace bans is house policy, and the reason travels in the mandatory
`use` remedy so the finding argues its own case. Litany's own
`outdated-str-module` is this rule with a hard-coded list — it found a
real global-state race in field review. Resolution
by declaration UID makes this strictly sounder than path matching: a
rebound or shadowed name never matches, an alias always does. No fix:
every replacement is a migration.

Fires once per value reference resolving to a forbidden declaration —
forbids are tried in configured order, the first match reports — with
the forbid's `use` replacement verbatim in the message (`... is a
restricted module; use ...` for a module forbid, `... is a restricted
value; use ...` for a value forbid). A forbid may be scoped after its
remedy: `(only <glob> ...)` applies it in those files alone, `(except
<glob> ...)` in every file but those, both in `per-path`'s glob grammar
against the workspace-relative path -- a library's ban that a test may
break, or a clock call one module alone may make. Without a
`(rule restricted-dependency ...)` form, or with one holding no forbids,
the rule is inert: nothing is forbidden, nothing fires. Project-local
modules or values shadowing a forbidden spelling, same-named wrapper
modules declared in other units (`Re.Str`, its own declarations), later
uses of a value bound to a forbidden one (the binding's right-hand side
already fired), and a forbidden module's constructors and types
(references, not types, are the finding unit) deliberately do not fire.
