(* [<jsx/>] stands for an element: it is read as [()] padded to the same
   six bytes, so every position in the AST is the .mlx's own, as mlx-pp's
   are. The output is what [Pparse.read_ast] reads: the magic, the name of
   the file read, then the structure. *)

let element = "<jsx/>"
let unit_padded = "()    "

let read_elements source =
  let b = Bytes.of_string source in
  let n = String.length element in
  for i = 0 to String.length source - n do
    if String.equal (String.sub source i n) element then
      Bytes.blit_string unit_padded 0 b i n
  done;
  Bytes.to_string b

let () =
  match Sys.argv with
  | [| _; path |] ->
      let source = In_channel.with_open_bin path In_channel.input_all in
      let lexbuf = Lexing.from_string (read_elements source) in
      Lexing.set_filename lexbuf path;
      let ast = Parse.implementation lexbuf in
      Out_channel.set_binary_mode stdout true;
      output_string stdout Config.ast_impl_magic_number;
      output_value stdout path;
      output_value stdout (ast : Parsetree.structure)
  | _ ->
      prerr_endline "usage: mlx_pp FILE";
      exit 2
