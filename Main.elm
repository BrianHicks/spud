module Spud where

import StartApp
import Trello
import Effects
import Html exposing (..)
import Task

port token : Signal Trello.Token

view : Signal.Address Trello.TokenAction -> Trello.Token -> Html.Html
view address model =
  case model of
    Nothing ->
      div [] [text "token not set"]

    Just token ->
      div [] [text token]

app : StartApp.App Trello.Token
app = StartApp.start { init = (Trello.model, Effects.none)
                     , inputs = [ Signal.map Trello.toNewToken token ]
                     , update = Trello.update
                     , view = view }

main : Signal Html
main = app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks = app.tasks
