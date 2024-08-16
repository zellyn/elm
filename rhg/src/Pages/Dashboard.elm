module Pages.Dashboard exposing (..)

import Browser
import Components.Header
import Context exposing (Context)
import Effect exposing (..)
import Html exposing (h1, p, text)
import Html.Attributes exposing (..)



-- INIT


type alias Model =
    {}


init : Context -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = None


update : Context -> Msg -> Model -> ( Model, Effect Msg )
update context msg model =
    case msg of
        None ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Context -> Model -> Sub Msg
subscriptions context model =
    Sub.none



-- VIEW


view : Context -> Model -> Browser.Document Msg
view context model =
    { title = "My Elm app"
    , body =
        [ Components.Header.view
        , h1 [] [ text "Dashboard" ]
        , case context.user of
            Just user ->
                p [] [ text ("Dashboard for " ++ user.username) ]

            Nothing ->
                p [] [ text "Please sign in" ]
        ]
    }
