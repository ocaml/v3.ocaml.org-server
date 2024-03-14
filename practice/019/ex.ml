open OUnit2

module type Testable = sig
  val remove_at : int -> 'a list -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "remove_at" >::: [
    "remove 1st element" >:: (fun _ ->
      assert_equal ["a"; "c"; "d"]
        (Tested.remove_at 1 ["a"; "b"; "c"; "d"]));
    "remove last element" >:: (fun _ ->
      assert_equal ["a"; "b"; "c"]
        (Tested.remove_at 3 ["a"; "b"; "c"; "d"]));
    "remove beyond list length" >:: (fun _ ->
      assert_equal ["a"; "b"; "c"; "d"]
        (Tested.remove_at 5 ["a"; "b"; "c"; "d"]));
    "remove from empty list" >:: (fun _ ->
      assert_equal []
        (Tested.remove_at 1 []));
    "remove 0th element" >:: (fun _ ->
      assert_equal ["b"; "c"; "d"]
        (Tested.remove_at 0 ["a"; "b"; "c"; "d"]));
  ]

  let v = "Remove the K'th Element Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl