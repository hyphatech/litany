# disable-all-warnings

a warning attribute disables every warning

<!-- Written by docs/catalog.ts from `litany explain disable-all-warnings`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`[@@@warning "-a"]` (and its spellings `"-A"` and `"a"`) clears
warning set `a` — OCaml's complete warning set — hiding every problem the
compiler would otherwise report from that point on.

```ocaml
(* bad *)  [@@@warning "-a"]
(* good *) [@@@warning "-27-32"]   (* name the warnings, with a reason *)
```

Fires on `warning` and `ocaml.warning` attributes, attached or floating,
whose payload is exactly one of the standalone disable-everything
specifications. Selective or compound specifications (`"-27"`, `"-a+31"`),
enabling specifications (`"+a"`), other payload shapes, and similarly
named attributes deliberately do not fire. A finding describes the
directive, not the final warning state after sibling or inherited
attributes. No fix: removing or narrowing an override needs knowledge of
the warnings intentionally managed at that scope.
