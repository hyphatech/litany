# suspicious-str-formatter

reference to the process-global Format.str_formatter

<!-- Written by docs/catalog.ts from `litany explain suspicious-str-formatter`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`Format.str_formatter` is one process-global buffer formatter. Two
interleaved users corrupt each other's output — in a multi-fiber or
multi-domain program interleaving is the normal case — and partial
output survives in the buffer across exceptions, so the next
`flush_str_formatter` answers with another computation's bytes
prepended. fmt guards its own API against the value by raising on it;
`Format.asprintf` is the total replacement.

```ocaml
(* bad *)  Format.fprintf Format.str_formatter "%a" pp v;
           Format.flush_str_formatter ()
(* good *) Format.asprintf "%a" pp v
```

Fires once per reference resolving to `Stdlib.Format.str_formatter` or
`Stdlib.Format.flush_str_formatter` in a Library-kind unit — spelled
directly, through an alias, or via `open`; a shadowing local
`Format` never fires. Units without kind metadata, and executables
(where a single-threaded scratch buffer can be correct in practice),
stay silent — the library boundary is where the value's process-global
sharing meets unknown callers. No body-shape analysis. The `ifprintf`
sink shape (`Format.ifprintf Format.str_formatter fmt`) is the known
benign case and still fires: suppress it with `[@litany.allow]` where a
sink formatter is deliberate.
