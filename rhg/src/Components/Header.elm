module Components.Header exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    header
        [ style "display" "flex"
        , style "background" "#333"
        , style "color" "#fff"
        , style "padding" "1rem"
        , style "justify-content" "space-between"
        ]
        [ strong [] [ text "MyCoolApp" ]
        , div
            [ style "display" "flex"
            , style "gap" "1rem"
            ]
            [ a [ href "/" ] [ text "Dashboard" ]
            , a [ href "/counter" ] [ text "Counter" ]
            , a [ href "/sign-in" ] [ text "Sign in" ]
            ]
        ]
