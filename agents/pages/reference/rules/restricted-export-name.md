# restricted-export-name

exported name breaking the configured naming policy

<!-- Written by docs/catalog.ts from `litany explain restricted-export-name`; never edited by hand. -->

**restriction · warning · stable · since 1.0 · fix: never · off by default**

An exported name is API surface forever: a prime-suffixed `parse'`
or a five-underscore `total_count_of_all_things` in an interface makes
every consumer spell the house's least readable habit. Inside a
function those names are the author's business; on the export surface
they are policy, and this rule is that policy's closed vocabulary —
enumerated options, never a user-supplied regex (a regex option would
be a second pattern language smuggled through configuration).

```lisp
(rule restricted-export-name
 (forbid-suffix ')
 (max-underscores 3))
```

```ocaml
(* bad *)  val parse' : string -> t
(* good *) val parse_exn : string -> t
```

Why restrict this? Every condemned spelling is legitimate OCaml —
`f'` is idiomatic mathematics, long underscored names are a taste — so
no default may claim them as defects; which spellings a house bans is
policy, cherry-picked, never in `all`. Litany's export index makes
these checks one walk over resolved exports instead of a text scan. No
fix: renaming an export is an interface decision.

Fires once per exported name — a value or type of the unit's export
surface — that a configured restriction condemns: `(forbid-suffix <s>)`
condemns a name ending in `<s>`, `(max-underscores <n>)` a name
carrying more than `<n>` underscores. Restrictions are tried in
configured order and the first condemning one reports, its option named
in the message. The export surface is the seam's: the unit's interface
when it has one, the implementation's own inferred signature when it
does not — so an `.mli` decides what is exported, and an ml-only unit
exports every root declaration, executables and tests included: their
root names are surface to their own readers, and the tier keeps the
rule opt-in. Findings anchor at the implementation's matching root
declaration (`let`, `external`, or `type`), never in the `.mli`.

Without a `(rule restricted-export-name ...)` form, or with one holding
no restrictions, the rule is inert. Names the interface hides, local
bindings and type abbreviations inside functions or nested modules,
module names, a forbidden suffix occurring mid-name, and names at the
underscore limit deliberately do not fire. Recorded false negatives, in
the safe direction: exported members of submodules (the export surface
joins interface to implementation at the unit's root only) and exports
satisfied by `include` (no root declaration to anchor at).
