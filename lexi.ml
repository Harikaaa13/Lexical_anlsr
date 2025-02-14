type token =
  | Keyword of string
  | Operator of string
  | Punctuation of string
  | IntLiteral of int
  | Identifier of string
  | Unknown of string

let regex_keyword = Str.regexp "\\b\\(if\\|then\\|else\\|while\\|let\\|in\\)\\b"
let regex_operator = Str.regexp "\\(==\\|=\\|!=\\|<=\\|>=\\|<\\|>\\|+\\|-\\|*\\|/\\|:=\\)"
let regex_punctuation = Str.regexp "[{}();,]"
let regex_int_literal = Str.regexp "-?[0-9]+"
let regex_identifier = Str.regexp "[a-zA-Z_][a-zA-Z0-9_]*"
let regex_whitespace = Str.regexp "[ \t\n\r]+"
let regex_unknown = Str.regexp "[^a-zA-Z0-9_{}();,+\\-*\\/:= \t\n\r]+"

let tokenize input =
  let tokens = ref [] in
  let pos = ref 0 in
  let length = String.length input in

  while !pos < length do
    if Str.string_match regex_whitespace input !pos then
      pos := Str.match_end ()
    else if Str.string_match regex_keyword input !pos then
      (tokens := Keyword (Str.matched_string input) :: !tokens; pos := Str.match_end ())
    else if Str.string_match regex_operator input !pos then
      (tokens := Operator (Str.matched_string input) :: !tokens; pos := Str.match_end ())
    else if Str.string_match regex_punctuation input !pos then
      (tokens := Punctuation (Str.matched_string input) :: !tokens; pos := Str.match_end ())
    else if Str.string_match regex_int_literal input !pos then
      (tokens := IntLiteral (int_of_string (Str.matched_string input)) :: !tokens; pos := Str.match_end ())
    else if Str.string_match regex_identifier input !pos then
      (tokens := Identifier (Str.matched_string input) :: !tokens; pos := Str.match_end ())
    else if Str.string_match regex_unknown input !pos then
      let match_end = Str.match_end () in
      (tokens := Unknown (String.sub input !pos (match_end - !pos)) :: !tokens; pos := match_end)
    else
      (tokens := Unknown (String.sub input !pos 1) :: !tokens; pos := !pos + 1)
  done;
  List.rev !tokens

let print_tokens tokens =
  List.iter (function
      | Keyword k -> Printf.printf "Keyword: %s\n" k
      | Operator o -> Printf.printf "Operator: %s\n" o
      | Punctuation p -> Printf.printf "Punctuation: %s\n" p
      | IntLiteral i -> Printf.printf "IntLiteral: %d\n" i
      | Identifier id -> Printf.printf "Identifier: %s\n" id
      | Unknown u -> Printf.printf "Unknown: %s\n" u
  ) tokens

let () =
  let input = read_line () in
  let tokens = tokenize input in
  print_tokens tokens