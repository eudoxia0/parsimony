signature PARSIMONY = sig
  type parser_name
  type pos

  datatype 'a result = Success of 'a
                     | Failure of parser_name * pos * string

  type 'a parser

  type input

  val run : 'a parser -> input -> ('a * input) result
  val explain : 'a result -> string

  val preturn : 'a -> 'a parser
  val pmap : ('a -> 'b) -> 'a parser -> 'b parser
  val pmap2 : ('a -> 'b -> 'c) -> 'a parser -> 'b parser -> 'c parser

  val pfail : 'a parser
  val pchar : char -> char parser
  val seq : 'a parser -> 'b parser -> ('a * 'b) parser
  val or : 'a parser -> 'a parser -> 'a parser

  val choice : 'a parser list -> 'a parser
  val satisfy : (char -> bool) -> char parser

  val anyOf : char list -> char parser
  val noneOf : char list -> char parser

  val opt : 'a parser -> 'a option parser
  val optV : 'a parser -> 'a -> 'a parser

  val plist : 'a parser list -> 'a list parser

  val many : 'a parser -> 'a list parser
  val many1 : 'a parser -> 'a list parser
end
