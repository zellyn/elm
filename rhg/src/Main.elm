module Main exposing (main)

import Browser
import Browser.Navigation as Nav exposing (Key)
import Context exposing (Context)
import Effect exposing (Effect(..))
import Flags exposing (Flags)
import Html exposing (h1, text)
import Html.Attributes exposing (..)
import Pages.Counter
import Pages.Dashboard
import Pages.SignIn
import Route
import Task
import Url exposing (Url)



-- INIT


type alias Model =
    { flags : Flags
    , url : Url
    , key : Key
    , page : PageModel
    , user : Maybe Context.User
    }


toContext : Model -> Context
toContext model =
    { flags = model.flags
    , url = model.url
    , user = model.user
    }


type PageModel
    = Dashboard Pages.Dashboard.Model
    | Counter Pages.Counter.Model
    | SignIn Pages.SignIn.Model
    | NotFound


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    initializePage
        url
        { flags = flags
        , url = url
        , key = key
        , page = NotFound
        , user = Nothing
        }


initializePage : Url -> Model -> ( Model, Cmd Msg )
initializePage url model =
    case Route.fromUrl url of
        Route.Dashboard ->
            let
                ( dashboardModel, dashboardCmd ) =
                    Pages.Dashboard.init (toContext model)
            in
            ( { model | page = Dashboard dashboardModel }
            , Effect.map DashboardMsg dashboardCmd
                |> fromEffectToCmd model
            )

        Route.Counter ->
            let
                ( counterModel, counterCmd ) =
                    Pages.Counter.init (toContext model)
            in
            ( { model | page = Counter counterModel }
            , Effect.map CounterMsg counterCmd
                |> fromEffectToCmd model
            )

        Route.SignIn ->
            let
                ( signInModel, signInCmd ) =
                    Pages.SignIn.init (toContext model)
            in
            ( { model | page = SignIn signInModel }
            , Effect.map SignInMsg signInCmd
                |> fromEffectToCmd model
            )

        Route.NotFound ->
            ( { model | page = NotFound }
            , Cmd.none
            )



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | SignInUser Context.User
    | DashboardMsg Pages.Dashboard.Msg
    | CounterMsg Pages.Counter.Msg
    | SignInMsg Pages.SignIn.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( UrlRequested request, _ ) ->
            case request of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            initializePage url
                { model | url = url }

        ( SignInUser user, _ ) ->
            ( { model | user = Just user }, Cmd.none )

        ( DashboardMsg pageMsg, Dashboard pageModel ) ->
            let
                ( dashboardModel, dashboardCmd ) =
                    Pages.Dashboard.update (toContext model) pageMsg pageModel
            in
            ( { model | page = Dashboard dashboardModel }
            , Effect.map DashboardMsg dashboardCmd
                |> fromEffectToCmd model
            )

        ( DashboardMsg _, _ ) ->
            ( model, Cmd.none )

        ( CounterMsg pageMsg, Counter pageModel ) ->
            let
                ( counterModel, counterCmd ) =
                    Pages.Counter.update (toContext model) pageMsg pageModel
            in
            ( { model | page = Counter counterModel }
            , Effect.map CounterMsg counterCmd
                |> fromEffectToCmd model
            )

        ( CounterMsg _, _ ) ->
            ( model, Cmd.none )

        ( SignInMsg pageMsg, SignIn pageModel ) ->
            let
                ( signInModel, signInCmd ) =
                    Pages.SignIn.update (toContext model) pageMsg pageModel
            in
            ( { model | page = SignIn signInModel }
            , Effect.map SignInMsg signInCmd
                |> fromEffectToCmd model
            )

        ( SignInMsg _, _ ) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        Dashboard dashboardModel ->
            Sub.map DashboardMsg
                (Pages.Dashboard.subscriptions (toContext model) dashboardModel)

        Counter counterModel ->
            Sub.map CounterMsg
                (Pages.Counter.subscriptions (toContext model) counterModel)

        SignIn signInModel ->
            Sub.map SignInMsg
                (Pages.SignIn.subscriptions (toContext model) signInModel)

        NotFound ->
            Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        Dashboard dashboardModel ->
            documentMap DashboardMsg
                (Pages.Dashboard.view (toContext model) dashboardModel)

        Counter counterModel ->
            documentMap CounterMsg
                (Pages.Counter.view (toContext model) counterModel)

        SignIn signInModel ->
            documentMap SignInMsg
                (Pages.SignIn.view (toContext model) signInModel)

        NotFound ->
            { title = "404"
            , body =
                [ h1 [] [ text "Page not found" ] ]
            }


documentMap : (pageMsg -> Msg) -> Browser.Document pageMsg -> Browser.Document Msg
documentMap toMsg doc =
    { title = doc.title
    , body = List.map (Html.map toMsg) doc.body
    }



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }



-- EFFECTS


fromEffectToCmd : Model -> Effect Msg -> Cmd Msg
fromEffectToCmd model effect =
    case effect of
        Effect.None ->
            Cmd.none

        Effect.Batch effects ->
            Cmd.batch (List.map (fromEffectToCmd model) effects)

        Effect.SignInUser data ->
            sendMsg (SignInUser data)

        Effect.PushRoute route ->
            Nav.pushUrl model.key (Route.toString route)


sendMsg : Msg -> Cmd Msg
sendMsg msg =
    Task.succeed msg
        |> Task.perform identity
