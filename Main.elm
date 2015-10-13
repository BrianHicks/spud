module Spud where

import Effects
import StartApp
import Task
import Trello
import Signal
import Html exposing (Html)

app : StartApp.App Trello.Model
app = StartApp.start { init = (Trello.init, Effects.none)
                     , inputs = [ Signal.map Trello.NewToken token
                                , Signal.map Trello.NewKey key ]
                     , update = Trello.update
                     , view = Trello.view }

main : Signal Html
main = app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks = app.tasks

port token : Signal (Maybe String)

port key : Signal (Maybe String)
