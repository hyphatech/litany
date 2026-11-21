# invalid-hashtable-key

polymorphic Hashtbl operation on a value proved functional

<!-- Written by docs/catalog.ts from `litany explain invalid-hashtable-key`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`Stdlib.Hashtbl`'s default operations hash and compare keys with the
polymorphic primitives. A functional key is broken at runtime, but not
by hashing: hashing a closure returns a value — different on every run
— and a lookup raises `Invalid_argument` only when a distinct
functional key shares its bucket, misses silently otherwise, and
succeeds only on physical identity.

```ocaml
(* bad *)  Hashtbl.mem callbacks handler
(* good *) Hashtbl.mem callbacks (Handler.id handler)
```

Fires when `Hashtbl.find`, `find_opt`, `find_all`, `mem`, `remove`,
`seeded_hash`, `hash`, `hash_param`, `add`, or `replace` resolves to its
`Stdlib` declaration at exact arity and the hashed argument's type
proves a function: an arrow, or a `list`, `array`, or `option` of one. The proof never guesses — type
variables and abbreviations (`type callback = int -> int`) stay clean,
as do shadowed `Hashtbl` modules, partial applications, and
`Hashtbl.Make` instances, whose operations carry the functor's own
identities and whose custom hash is exactly the remedy. No fix: choosing
a hashable key needs domain intent.
