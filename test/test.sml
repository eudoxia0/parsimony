structure ParsimonyTest = struct
  open MLUnit

  (* Test utilities *)

  structure ps = Parsimony(ParsimonyStringInput)

  fun strInput str = ParsimonyStringInput.fromString str

  fun isParse p str out = is (fn () => case (ps.run p (strInput str)) of
                                           (ps.Success (res, _)) => if (res = out) then Pass else Fail "Bad parse"
                                         | ps.Failure _ => Fail "Bad parse")
                             str

  fun isNotParse p str = is (fn () => case (ps.run p (strInput str)) of
                                          (ps.Success (res, _)) => Fail "Good parse"
                                        | ps.Failure _ => Pass)
                            str

  (* Tests *)

  val tests = suite "Parsimony Tests" [
          suite "Built-in parsers parsers" [
              suite "pchar" [
                  isParse (ps.pchar #"a") "abc" #"a",
                  isNotParse (ps.pchar #"b") "abc"
              ],
              suite "or" [
                  isParse (ps.or (ps.pchar #"b") (ps.pchar #"a")) "abc" #"a"
              ],
              suite "anyOf" [
                  isParse (ps.anyOf [#"1", #"2"]) "1" #"1",
                  isParse (ps.anyOf [#"1", #"2"]) "2" #"2"
              ],
              suite "noneOf" [
                  isParse (ps.noneOf [#"A", #"B"]) "C" #"C",
                  isNotParse (ps.noneOf [#"A", #"B"]) "A",
                  isNotParse (ps.noneOf [#"A", #"B"]) "B"
              ],
              suite "plist" [
                  isParse (ps.plist [ps.pchar #"a", ps.pchar #"b"]) "ab" [#"a", #"b"]
              ]
          ]
      ]

  fun runTests () = runAndQuit tests defaultReporter
end

val _ = ParsimonyTest.runTests ()
