module Board where

import Debug
import Effects
import Html exposing (..)
import Html.Attributes exposing (key, class, classList)
import List

-- MODEL

type alias ID = String

type alias Board = { id : ID
                   , desc : String
                   , name : String }

type alias Model = { boards : List Board
                   , selected : Maybe ID }

init : Model
init = { boards = []
       , selected = Nothing }

isSelected : Board -> Maybe ID -> Bool
isSelected board id =
  case id of
    Nothing -> False
    Just id -> board.id == id

-- UPDATE

type Action
  = Load
  | Boards (List Board)
  | Select (Maybe ID)

update : Action -> Model -> List (String, String) -> (Model, Effects.Effects Action)
update action model auth =
  case action of
    Load -> Debug.crash "TODO"

    Boards boards -> ({ model | boards <- boards }, Effects.none)

    Select id -> ({ model | selected <- id }, Effects.none)

-- EFFECTS


-- VIEW

board : Signal.Address Action -> Board -> Bool -> Html
board address model selected =
  li [ key model.id
     , classList [ ( "board", True )
                 , ( "selected", selected ) ] ] -- todo: click event
     [ h2 [ class "title" ] [ text model.name ]
     , p [] [ text model.desc ]]

boards : Signal.Address Action -> Model -> Html
boards address model =
  if List.isEmpty model.boards
     then div [ classList [ ("empty", True), ("boards", True) ] ] [ text "no boards loaded" ]
     else ul [ class "boards" ]
             (List.map (\b -> board address b (isSelected b model.selected)) model.boards)

view : Signal.Address Action -> Model -> Html
view address model =
  boards address model
