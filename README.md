# Parsimony

**Parsimony** is a parser combinator library for Standard ML.

It features:

- Source location tracking.
- Extensive example code.

# Example Session

In lieu of a 'Hello, World!' example, here is an example of using Parsimony in
an interactive SML/NJ session (output elided/edited as needed):

~~~sml
> sml -m parsimony.cm

- structure ps = Parsimony(ParsimonyStringInput);
structure ps : PARSIMONY

- fun str s = ParsimonyStringInput.fromString s;
val str = fn : string -> ParsimonyStringInput.input

- ps.run (ps.pchar #"a") (str "abc");
val it = Success (#"a",-) : (char * ps.input) ps.result

- ps.run (ps.or (ps.pchar #"b") (ps.pchar #"a")) (str "abc");
val it = Success (#"a",-) : (char * ps.input) ps.result

- val digitParser = ps.anyOf [#"0", #"1", #"2", #"3", #"4", #"5", #"6", #"7", #"8", #"9"];
val digitParser = Parser fn : char ps.parser

- ps.run digitParser (str "123");
val it = Success (#"1",-) : (char * ps.input) ps.result
~~~

# Examples

## Natural Numbers

~~~sml
structure ps = Parsimony(ParsimonyStringInput)

val digitParser = ps.anyOf [#"0", #"1", #"2", #"3", #"4", #"5", #"6", #"7", #"8", #"9"]

fun parseInt str = case (Int.fromString str) of
                       SOME i => i
                     | NONE => raise Match

val naturalParser = ps.pmap (parseInt o String.implode) (ps.many1 digitParser)

ps.run naturalParser (ParsimonyStringInput.fromString "123")
(* val it = Success (123,-) *)
~~~

## Integers

Continuing from the previous example:

~~~sml
datatype sign = Positive | Negative

val signParser = let val posParser = ps.seqR (ps.opt (ps.pchar #"+")) (ps.preturn Positive)
                     val negParser = ps.seqR (ps.pchar #"-") (ps.preturn Negative)
                 in
                     ps.or negParser posParser
                 end;

fun applySign (Positive, int) = int
  | applySign (Negative, int) = ~int

val integerParser = ps.pmap applySign (ps.seq signParser naturalParser)

ps.run integerParser (ParsimonyStringInput.fromString "-123")
(* val it = Success (~123,-) *)
~~~

## Quoted Strings

~~~sml
structure ps = Parsimony(ParsimonyStringInput)

val stringChar = ps.or (ps.seqR (ps.pchar #"\\") (ps.pchar #"\"")) (ps.noneOf [#"\""])

val quotedString = ps.pmap String.implode (ps.between (ps.pchar #"\"") (ps.many stringChar) (ps.pchar #"\""))

ps.run quotedString (ParsimonyStringInput.fromString "\"test\"")
(* val it = Success ("test",-) *)

ps.run quotedString (ParsimonyStringInput.fromString "\"test \\\"inner\\\" test\"")
(* val it = Success ("test \"inner\" test",-) *)
~~~

## S-Expressions

# API Reference

## The `INPUT` Signature

## The `ParsimonyStringInput` Structure

## The `PARSIMONY` Signature

## The `Parsimony` Functor

# License

Copyright (c) 2018 Fernando Borretti

Licensed under the MIT License.
