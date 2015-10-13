module BoardTest where

import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Test exposing (test, Test, suite)
import Board

isSelectedTests : Test
isSelectedTests = suite "isSelected"
                  (let
                    board = { id = "test", name = "test" }
                  in
                    [ test "yes"
                             (assert (Board.isSelected board (Just "test")))
                    , test "no"
                             (assert (Board.isSelected board (Just "cats") |> not))
                    , test "nothing"
                             (assert (Board.isSelected board Nothing |> not)) ])

tests : Test
tests = suite "Board"
        [ isSelectedTests ]
