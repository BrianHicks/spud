module Trello where

import Board
import Effects
import Html exposing (Html, div, text)
import Signal
import TList
import Auth
import Task

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
  | ListAction TList.Action

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
        extra = boardExtra sub
      in
        ( { model | board <- board }
        , Effects.batch [ Effects.map BoardAction fx
                        , extra ])

    ListAction sub ->
      let
        (lists, fx) = TList.update sub model.lists (Auth.authParams model.auth)
      in
        ( { model | lists <- lists }
        , Effects.map ListAction fx )

boardExtra : Board.Action -> Effects.Effects Action
boardExtra action =
  case action of
    Board.Select id ->
      case id of
        Nothing -> Effects.none
        Just id ->
          TList.Load id
            |> ListAction
            |> Task.succeed
            |> Effects.task

    _ -> Effects.none


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
      [ model |> toString |> text
      , Auth.authView (Signal.forwardTo address AuthAction) model.auth
      , Board.view (Signal.forwardTo address BoardAction) model.board
      , TList.view (Signal.forwardTo address ListAction) model.lists ]
