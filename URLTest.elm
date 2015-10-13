module URLTest where

import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)
import ElmTest.Test exposing (test, Test, suite)
import URL

rootedTests = suite "Rooted"
              [ test "with and without a slash" (assertEqual (URL.rooted "/") (URL.rooted ""))]

tests = suite "URL"
        [ rootedTests ]
