module Test where

import ElmTest.Runner.Element exposing (runDisplay)
import ElmTest.Test exposing (Test, suite)

import URLTest
import AuthTest
import BoardTest

tests : Test
tests = suite "Spud"
        [ URLTest.tests
        , AuthTest.tests
        , BoardTest.tests ]

main = runDisplay tests
