module Route exposing (Route(..), fromUrl, toString)

import Url exposing (Url)


type Route
    = Dashboard
    | Counter
    | SignIn
    | NotFound


fromUrl : Url -> Route
fromUrl url =
    case url.path of
        "/" ->
            Dashboard

        "/counter" ->
            Counter

        "/sign-in" ->
            SignIn

        _ ->
            NotFound


toString : Route -> String
toString route =
    case route of
        Dashboard ->
            "/"

        Counter ->
            "/counter"

        SignIn ->
            "/sign-in"

        NotFound ->
            "/404"
