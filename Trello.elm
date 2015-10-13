module Trello where

import Board
import Effects
import Html exposing (Html, div, text)
import Html.Attributes exposing (classList)
import Maybe
import Signal
import TList
import Auth

-- MODEL

type alias Model = { auth : Auth.Model
                   , board : Board.Model
                   , lists : TList.Model }

init : Model
init = { auth = Auth.init
       , board = Board.init
       , lists = TList.init }

-- UPDATE

type Action
  = AuthAction Auth.Action
  | BoardAction Board.Action

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    AuthAction sub ->
      let
        (auth, fx) = Auth.update sub model.auth
      in
        ( { model | auth <- auth }
        , Effects.map AuthAction fx )

    BoardAction sub ->
      let
        (board, fx) = Board.update sub model.board (Auth.authParams model.auth)
      in
        ( { model | board <- board }
        , Effects.map BoardAction fx )

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
      [ model |> toString |> text
      , Auth.authView (Signal.forwardTo address AuthAction) model.auth
      , Board.view (Signal.forwardTo address BoardAction) model.board ]
