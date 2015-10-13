module Auth where

import URL
import Maybe
import Effects
import Html exposing (Html, div, text)
import Html.Attributes exposing (classList)

-- MODEL

type alias Token = Maybe String

type alias Key = Maybe String

type alias Model = { token : Token
                   , key : Key }

init : Model
init = { token = Nothing
       , key = Nothing }

authenticated : Model -> Bool
authenticated model =
  (case model.token of
     Nothing -> False
     Just _ -> True) &&
  (case model.key of
     Nothing -> False
     Just _ -> True)

authParams : Model -> URL.Params
authParams model =
  [ ( "token", Maybe.withDefault "" model.token )
  , ( "key", Maybe.withDefault "" model.key ) ]

-- UPDATE

type Action
  = NewToken Token
  | NewKey Key

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    NewToken token -> ({ model | token <- token }, Effects.none)

    NewKey key -> ({ model | key <- key }, Effects.none)

-- VIEW

authView : Signal.Address Action -> Model -> Html
authView address model =
  div [ classList [ ( "authenticated", authenticated model )
                  , ( "auth", True ) ] ]
        [ text (if authenticated model then "Authenticated" else "Not Yet Authenticated") ]
