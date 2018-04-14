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
          suite "Basic parsers" [
              suite "pchar" [
                  isParse (ps.pchar #"a") "abc" #"a",
                  isNotParse (ps.pchar #"b") "abc"
              ],
              suite "anyOf" [
                  isParse (ps.anyOf [#"1", #"2"]) "1" #"1",
                  isParse (ps.anyOf [#"1", #"2"]) "2" #"2"
              ]
          ]
      ]

  fun runTests () = runAndQuit tests defaultReporter
end

val _ = ParsimonyTest.runTests ()
