module AuthTest where

import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Test exposing (test, Test, suite)
import Auth

authenticatedTests : Test
authenticatedTests = suite "authenticated"
                     [ test "neither"
                              (assert (Auth.authenticated Auth.init |> not))
                     , test "no token"
                              (assert (Auth.authenticated { key = Just "", token = Nothing} |> not))
                     , test "no key"
                              (assert (Auth.authenticated { key = Nothing, token = Just ""} |> not))
                     , test "both"
                              (assert (Auth.authenticated { key = Just "", token = Just ""}))]

authParamsTests : Test
authParamsTests = suite "authParams"
                  [ test "neither"
                           (assertEqual (Auth.authParams Auth.init) [("token", ""), ("key", "")])
                  , test "both"
                           (assertEqual
                            (Auth.authParams { key = Just "key", token = Just "token"})
                            [("token", "token"), ("key", "key")]) ]

tests : Test
tests = suite "Auth"
        [ authenticatedTests
        , authParamsTests ]
