module TList where

import Effects
import Effects exposing (Effects)
import Error
import Http
import Json.Decode exposing ((:=), list, object2, string)
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
