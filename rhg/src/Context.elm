module Context exposing (Context, User)

import Browser.Navigation exposing (Key)
import Flags exposing (Flags)
import Url exposing (Url)


type alias Context =
    { flags : Flags
    , url : Url
    , user : Maybe User
    }


type alias User =
    { username : String
    }
