module Trello (Token, TokenAction, toNewToken, model, update) where

import Effects exposing (none)

-- token actions
type TokenAction = NewToken Token

toNewToken : Token -> TokenAction
toNewToken tkn = NewToken tkn

type alias Token = Maybe String

-- token models
model : Token
model = Nothing

update : TokenAction -> Token -> (Token, Effects.Effects TokenAction)
update action model =
  case action of
    NewToken token -> (token, none)
