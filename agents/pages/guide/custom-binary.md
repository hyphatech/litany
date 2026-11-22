# A custom binary

The rules extended with your own, by recompiling.

litany is extended by recompiling, with no plugins. Its libraries aren't
installed, so a custom binary is built in a checkout of litany, beside `bin/`.

## The rule pack

An ordinary library ([writing a rule](writing-a-rule.md)):

```lisp title="my_rules/dune"
; The rule pack: [litany] is its only dependency.

(library
 (name my_rules)
 (libraries litany))
```

```ocaml title="my_rules/my_rules.ml"
open Litany

let meta =
  Rule.meta ~name:"house-print-endline" ~group:Rule.Restriction
    ~stability:Rule.Stability.Nursery ~since:"1.0" ~fix:Rule.Never
    ~summary:"use of print_endline"
    ~doc:
      {|The house writes through a formatter its caller hands in.

    (* bad *)  print_endline "done"
    (* good *) Format.fprintf ppf "done@."

Fires at every identifier whose resolved identity is
`Stdlib.print_endline`; a shadowing definition deliberately does not
fire.|}
    ()

let print_endline = Pat.ident "Stdlib.print_endline"

let rule =
  Rule.expr meta @@ fun u e ->
  match Pat.run print_endline u e () with
  | Some () -> [ Finding.v ~loc:e.exp_loc "print through a formatter" ]
  | None -> []

let all = [ rule ]
```

## The binary

```ocaml title="main.ml"
(* The whole custom binary: the stock catalog plus your rules. *)
let () =
  let root = "." in
  let rules = Litany_rules.all @ My_rules.all in
  let progress = Litany.Progress.v ~enabled:true ~jobs:1 in
  let code =
    match Litany.Adapter.Dune.roster ~progress ~root () with
    | Error e -> Litany.Driver.refuse "%a" Litany.Adapter.Dune.pp_error e
    | Ok roster ->
        let cache =
          Litany.Driver.Result_cache.setup ~cache_dir:None ~no_cache:false ~root
            ~rules
        in
        let rebuild () = Litany.Adapter.Dune.roster ~progress ~root () in
        let code =
          Litany.Driver.run_check ~progress ~rebuild:(Some rebuild)
            ~format:Litany.Driver.Text ~jobs:None ~cache roster
            ~build_current:true ~rules ~catalog:rules ~keep:None ~fix:None
            ~explain_withheld:false
        in
        Option.iter
          (fun c -> Litany.Driver.Result_cache.finish c ~stats:false)
          cache;
        code
  in
  exit code
```

```lisp title="dune"
(executable
 (name main)
 (libraries litany litany_rules my_rules))
```

`Litany.Driver.run_check` is the whole run. To lint artifacts without dune, use
`Litany.Adapter.Walk.roster ~cmt_root ~source_root` and pass `~rebuild:None
~build_current:false`.

To keep the full command line instead, change `bin/`: the rules are named in one
place, `Cli_common.catalog`.
