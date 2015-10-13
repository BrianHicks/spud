module Spud where

import Auth
import Effects
import Html exposing (Html)
import Signal
import StartApp
import Task
import Trello

app : StartApp.App Trello.Model
app = StartApp.start { init = (Trello.init, Effects.none)
                     , inputs = [ Signal.map (\x -> (Auth.NewToken x) |> Trello.AuthAction) token
                                , Signal.map (\x -> (Auth.NewKey x) |> Trello.AuthAction) key ]
                     , update = Trello.update
                     , view = Trello.view }

main : Signal Html
main = app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks = app.tasks

port token : Signal (Maybe String)

port key : Signal (Maybe String)
