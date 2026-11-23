An implementation in mlx's dialect is its .mlx, which the OCaml parser
cannot read: litany reads it as the dialect's preprocessor parsed it, so
attribute suppression and the other parse-fed checks hold there as in a
.ml. The fixture is a real nested dune project whose mlx dialect runs a
stand-in for mlx-pp, which reads <jsx/> as an element.

  $ unset GITHUB_ACTIONS
  $ MLX_PP=$PWD/../mlx_pp/mlx_pp.exe
  $ mkdir proj && cd proj
  $ cat > dune-project <<EOP
  > (lang dune 3.20)
  > (dialect
  >  (name mlx)
  >  (implementation
  >   (extension mlx)
  >   (preprocess (run $MLX_PP %{input-file}))))
  > EOP
  $ cat > dune <<'EOP'
  > (library (name mlxlib))
  > EOP
  $ cat > view.mlx <<'EOP'
  > let element = <jsx/>
  > let is_empty xs = List.length xs = 0
  > let is_blank xs = (List.length xs = 0) [@litany.allow "needless-list-length: shown as written"]
  > EOP
  $ env -u INSIDE_DUNE dune build --root . @check 2>&1

The OCaml parser refuses the source; the build does not.

  $ ocamlc -stop-after parsing -impl view.mlx 2>&1 | head -1
  File "view.mlx", line 1, characters 14-15:

The unit is linted, not degraded: the unsuppressed finding is reported,
the suppressed one is not.

  $ env -u INSIDE_DUNE litany check
  File "view.mlx", line 2, characters 18-36:
  2 | let is_empty xs = List.length xs = 0
                        ^^^^^^^^^^^^^^^^^^
  Warning 0 [needless-list-length]: comparison through List.length is a needless emptiness test
  
  30 rules selected · 2 units · 1 finding · 0 skipped · 1 facts-only · 1 suppressed
  [1]

The roster names the AST mlx-pp wrote beside the build's copy of the
source, and a unit file carries it.

  $ env -u INSIDE_DUNE litany units --dump | grep -o '(parsed-source [^)]*)'
  (parsed-source _build/default/view.mlx.ml)
