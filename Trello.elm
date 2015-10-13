module Trello (Model, init, toNewToken, update, view) where

import Effects
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Signal

-- MODEL

type alias Token = Maybe String

type alias Model = { token : Token }

init : Model
init = { token = Nothing }

authenticated : Model -> Bool
authenticated model =
  case model.token of
    Nothing -> False
    Just _  -> True

-- UPDATE

type Action
  = NewToken Token

toNewToken : Token -> Action
toNewToken token = NewToken token

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    NewToken token -> ({ model | token <- token }, Effects.none)

-- VIEW

authView : Signal.Address Action -> Model -> Html
authView address model =
  div [class (if authenticated model then "authenticated" else "unauthenticated")]
      [text (if authenticated model then "Authenticated" else "Not Yet Authenticated")]

view : Signal.Address Action -> Model -> Html
view address model =
  authView address model
