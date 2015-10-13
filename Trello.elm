module Trello (Model, init, toNewToken, update, view) where

import Effects
import Html exposing (Html, div, text)
import Html.Attributes exposing (classList)
import Signal
import Board

-- MODEL

type alias Token = Maybe String

type alias Model = { token : Token
                   , board : Board.Model }

init : Model
init = { token = Nothing
       , board = Board.init }

authenticated : Model -> Bool
authenticated model =
  case model.token of
    Nothing -> False
    Just _  -> True

-- UPDATE

type Action
  = NewToken Token
  | BoardAction Board.Action

toNewToken : Token -> Action
toNewToken token = NewToken token

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    NewToken token -> ({ model | token <- token }, Effects.none)

    BoardAction sub ->
      let
        (board, fx) = Board.update sub model.board
      in
        ( { model | board <- board }
        , Effects.map BoardAction fx )

-- VIEW

authView : Signal.Address Action -> Model -> Html
authView address model =
  div [ classList [ ( "authenticated", authenticated model )
                  , ( "auth", True ) ] ]
      [ text (if authenticated model then "Authenticated" else "Not Yet Authenticated") ]

view : Signal.Address Action -> Model -> Html
view address model =
  div []
      [ authView address model
      , Board.view (Signal.forwardTo address BoardAction) model.board ]
