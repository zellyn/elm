module Pages.SignIn exposing (..)

import Browser
import Components.Header
import Context exposing (Context)
import Effect exposing (..)
import Html exposing (button, div, form, h1, input, label, p, text)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onInput, onSubmit)
import Route



-- INIT


type alias Model =
    { username : String
    , password : String
    }


init : Context -> ( Model, Effect Msg )
init _ =
    ( { username = "", password = "" }
    , Effect.none
    )



-- UPDATE


type Msg
    = SubmittedForm
    | ChangedUsername String
    | ChangedPassword String


update : Context -> Msg -> Model -> ( Model, Effect Msg )
update context msg model =
    case msg of
        ChangedUsername username ->
            ( { model | username = username }
            , Effect.none
            )

        ChangedPassword password ->
            ( { model | password = password }
            , Effect.none
            )

        SubmittedForm ->
            ( model
            , Effect.batch
                [ Effect.signInUser { username = model.username }
                , Effect.pushRoute Route.Dashboard
                ]
            )



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
        , p [] [ text "Hi" ]
        , form [ onSubmit SubmittedForm ]
            [ label []
                [ div [] [ text "Username" ]
                , input [ onInput ChangedUsername, value model.username ] []
                ]
            , label []
                [ div [] [ text "Password" ]
                , input [ onInput ChangedPassword, value model.password, type_ "password" ] []
                ]
            , div [] [ button [] [ text "Sign in" ] ]
            ]
        ]
    }
