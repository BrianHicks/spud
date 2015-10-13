module TList where

import Debug
import Effects
import Effects exposing (Effects)
import Error
import Html exposing (..)
import Html.Attributes exposing (key, class)
import Http
import Json.Decode exposing ((:=), list, object2, string)
import List
import Signal
import Task
import URL

-- MODEL

type alias ID = String

type alias TList = { id : ID
                   , name : String }

type alias Model = { lists : List TList
                   , error : Error.Error
                   , loading : Bool }

init : Model
init = { lists = []
       , error = Nothing
       , loading = False }

-- UPDATE

type Action
  = Load ID
  | Lists (Maybe (List TList))

update : Action -> Model -> URL.Params -> (Model, Effects Action)
update action model auth =
  case action of
    Load board -> ({ model | error <- Nothing
                           , loading <- True }
                   , getLists board auth)

    Lists lists ->
      case lists of
        Nothing -> ({ model | error <- Just "Failed to load lists for board."
                            , loading <- False }
                    , Effects.none)

        Just lists -> ({ model | lists <- lists
                               , loading <- False
                               , error <- Nothing }
                       , Effects.none)

-- EFFECTS

getLists : ID -> URL.Params -> Effects Action
getLists board auth =
  Http.get (list decodeList) (listsUrl board auth)
    |> Task.toMaybe
    |> Task.map Lists
    |> Effects.task

decodeList : Json.Decode.Decoder TList
decodeList =
  object2 TList
          ("id" := string)
          ("name" := string)

listsUrl : ID -> URL.Params -> String
listsUrl board auth =
  let filters = [ ("filter", "open")
                , ("fields", "id,name") ]
      query = filters ++ auth
      url = URL.rooted "/1/boards/" ++ board ++ "/lists"
  in
    Http.url url query

-- VIEW

tlist : Signal.Address Action -> TList -> Html
tlist address model =
  li [ key model.id ]
     [ text model.name ]

emptyView : Signal.Address Action -> Model -> Html
emptyView address model =
  div [ class "empty" ]
      [ p [] [ text "no lists loaded" ]]

tlists : Signal.Address Action -> Model -> Html
tlists address model =
  if model.loading
     then div [] [text "Loading..."]
     else if List.isEmpty model.lists
          then emptyView address model
          else ul []
                  (List.map (tlist address) model.lists)

view : Signal.Address Action -> Model -> Html
view address model =
  div [ class "lists" ]
      [ Error.view model.error
      , tlists address model ]
