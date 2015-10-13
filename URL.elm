module URL where

import String

-- MODEL

type alias Params = List (String, String)

rooted : String -> String
rooted path =
  "https://api.trello.com" ++ (if String.startsWith "/" path then "" else "/") ++ path
