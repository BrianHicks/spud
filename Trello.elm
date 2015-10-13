module Trello where

import Board
import Effects
import Html exposing (Html, div, text)
import Html.Attributes exposing (classList)
import Maybe
import Signal

-- MODEL

type alias Token = Maybe String

type alias Key = Maybe String

type alias Model = { token : Token
                   , key : Key
                   , board : Board.Model }

init : Model
init = { token = Nothing
       , key = Nothing
       , board = Board.init }

authenticated : Model -> Bool
authenticated model =
  case model.token of
    Nothing -> False
    Just _  -> True

authParams : Model -> List (String, String)
authParams model =
  [ ( "token", Maybe.withDefault "" model.token )
  , ( "key", Maybe.withDefault "" model.key ) ]

-- UPDATE

type Action
  = NewToken Token
  | NewKey Key
  | BoardAction Board.Action

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    NewToken token -> ({ model | token <- token }, Effects.none)

    NewKey key -> ({ model | key <- key }, Effects.none)

    BoardAction sub ->
      let
        (board, fx) = Board.update sub model.board (authParams model)
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
