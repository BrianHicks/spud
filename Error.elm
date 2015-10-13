module Error where

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Maybe

type alias Error = Maybe String

view : Error -> Html
view error =
  let
    styles = case error of
               Nothing -> [("display", "none")]
               Just _  -> []
  in
    div [ class "error"
        , style styles]
        [ Maybe.withDefault "" error |> text ]
