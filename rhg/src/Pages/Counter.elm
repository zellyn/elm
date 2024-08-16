module Pages.Counter exposing (..)

import Browser
import Components.Header
import Context exposing (Context)
import Effect exposing (..)
import Html exposing (button, h1, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



-- INIT


type alias Model =
    { count : Int
    }


init : Context -> ( Model, Effect Msg )
init _ =
    ( { count = 0
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Reset
    | None


update : Context -> Msg -> Model -> ( Model, Effect Msg )
update context msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Effect.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Effect.none )

        Reset ->
            ( { model | count = 0 }, Effect.none )

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
        , h1 [] [ text "Counter" ]
        , p [] [ text ("Count: " ++ String.fromInt model.count) ]
        , button [ onClick Increment ] [ text "Plus" ]
        , button [ onClick Decrement ] [ text "Minus" ]
        , button [ onClick Reset ] [ text "Reset" ]
        ]
    }
