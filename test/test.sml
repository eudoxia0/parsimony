structure ParsimonyTest = struct
  open MLUnit

  val tests = suite "SUnit Tests" [
          isTrue true "is true",
          isFalse false "is false"
      ]

  fun runTests () = runAndQuit tests defaultReporter
end

val _ = ParsimonyTest.runTests ()
