module Board where

import Effects exposing (Effects)
import Error
import Html exposing (..)
import Html.Attributes exposing (key, class, classList)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing ((:=), list, object2, string)
import List
import Task

-- MODEL

type alias ID = String

type alias Board = { id : ID
                   , name : String }

type alias Model = { boards : List Board
                   , selected : Maybe ID
                   , loading : Bool
                   , error : Maybe String }

init : Model
init = { boards = []
       , selected = Nothing
       , loading = False
       , error = Nothing }

isSelected : Board -> Maybe ID -> Bool
isSelected board id =
  case id of
    Nothing -> False
    Just id -> board.id == id

-- UPDATE

type Action
  = Load
  | Boards (Maybe (List Board))
  | Select (Maybe ID)

update : Action -> Model -> List (String, String) -> (Model, Effects Action)
update action model auth =
  case action of
    Load -> ({ model | error <- Nothing
                     , loading <- True }
             , getBoards auth)

    Boards boards ->
      case boards of
        Nothing -> ({ model | error <- Just "Failed to load boards."
                            , loading <- False }
                    , Effects.none)

        Just boards -> ({ model | error <- Nothing
                                , loading <- False
                                , boards <- boards }
                        , Effects.none)

    Select id -> ({ model | selected <- id }, Effects.none)

-- EFFECTS

getBoards : List (String, String) -> Effects Action
getBoards auth =
  Http.get (list decodeBoard) (boardsUrl auth)
    |> Task.toMaybe
    |> Task.map Boards
    |> Effects.task

decodeBoard : Json.Decode.Decoder Board
decodeBoard =
  object2 Board
          ("id" := string)
          ("name" := string)

boardsUrl : List (String, String) -> String
boardsUrl auth =
  let filters = [ ("filter", "open")
                , ("fields", "id,name") ]
      query = filters ++ auth
  in
    Http.url "https://api.trello.com/1/members/me/boards" query

-- VIEW

board : Signal.Address Action -> Board -> Bool -> Html
board address model selected =
  li [ key model.id
     , classList [ ( "board", True )
                 , ( "selected", selected ) ]
     , onClick address (Select (Just model.id)) ]
     [ h2 [ class "title" ] [ text model.name ] ]

emptyView : Signal.Address Action -> Model -> Html
emptyView address model =
  div [ class "empty" ]
      [ p [] [ text "no boards loaded" ]
      , button [ onClick address Load ]
               [ text "Load you some Boards!" ] ]

boards : Signal.Address Action -> Model -> Html
boards address model =
  if model.loading
     then div [] [ text "Loading..." ]
     else if List.isEmpty model.boards
             then emptyView address model
             else ul []
                     (List.map (\b -> board address b (isSelected b model.selected)) model.boards)

view : Signal.Address Action -> Model -> Html
view address model =
  div [ class "boards" ]
      [ Error.view model.error
      , boards address model ]
