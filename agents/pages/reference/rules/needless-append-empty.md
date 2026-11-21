# needless-append-empty

append or concatenation with the neutral element

<!-- Written by docs/catalog.ts from `litany explain needless-append-empty`; never edited by hand. -->

**style · warning · stable · since 1.0 · fix: sometimes · off by default**

Appending the neutral element does nothing — except allocate.
`[] @ l` is `l` itself (the stdlib's append returns its second argument
on an empty first); `l @ []` walks and copies `l` to end where it
started; `"" ^ s` and `s ^ ""` allocate a fresh copy of `s` (`^` never
returns an operand).

```ocaml
(* bad *)  xs @ []
(* good *) xs
```

Fires when `@` or `List.append` resolves to its `Stdlib` declaration
with the predefined `[]` as either operand, and when `^` or
`String.cat` does with the literal `""` as either operand; a both-empty
operation reports once. Singleton appends (`[x] @ l`), shadowed
operators, `String.concat`, and `Bytes.cat` deliberately do not fire.
The fix replaces the whole application with the other operand: safe for
`[] @ l` (result, effects, and physical identity all preserved), unsafe
for the other three legs — they remove a copy, and legacy code copies
strings via `s ^ ""` deliberately.
