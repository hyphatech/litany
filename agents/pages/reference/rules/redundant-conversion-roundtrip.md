# redundant-conversion-roundtrip

conversion immediately undone by its inverse

<!-- Written by docs/catalog.ts from `litany explain redundant-conversion-roundtrip`; never edited by hand. -->

**perf · warning · stable · since 1.0 · fix: sometimes · on by default**

Converting a value out of its type and immediately back does
allocation and parsing work to end where it started:
`int_of_string (string_of_int n)` is `n`.

```ocaml
(* bad *)  int_of_string (string_of_int n)
(* good *) n
```

Fires only on compositions proved identities by the stdlib's contracts,
with both conversions resolving to their `Stdlib` declarations and the
inner application feeding the outer directly: `int_of_string` of
`string_of_int`, `bool_of_string` of `string_of_bool`, `Char.chr` of
`Char.code`, `of_string` of `to_string` for `Int32`/`Int64`/`Nativeint`,
and `Bytes.to_string` of `Bytes.of_string`. Pipeline spellings collapse
and fire. The reverse directions deliberately do not: `string_of_int
(int_of_string s)` canonicalizes (`"+3"`, `"0x10"` change),
`Char.code (Char.chr n)` deletes a range check, `Bytes.of_string
(Bytes.to_string b)` must stay a fresh mutable copy, and the lossy float
pair is excluded; shadowed conversions and work between the two also
stay clean. The fix — the inner argument itself — is Safe for the
unboxed pairs (int, bool, char) and withheld for the boxed and copying
pairs, where replacement changes physical identity.
