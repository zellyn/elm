module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Browser.Events
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import ModRand exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Posix)



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



--- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onAnimationFrame OnAnimationFrame



-- MODEL


type alias Model =
    { cols : Int
    , rows : Int
    , seed1 : Int
    , seed2 : Int
    , size : Float
    , animate : Bool
    , millis : Int
    }


type alias Flags =
    {}


init : Flags -> ( Model, Cmd msg )
init flags =
    ( { cols = 12
      , rows = 22
      , seed1 = 1922110153
      , seed2 = 1769133315
      , size = 10
      , animate = False
      , millis = 0
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = None
    | OnAnimationFrame Posix
    | GotAnimationClick Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        OnAnimationFrame posix ->
            ( { model | millis = Time.posixToMillis posix }, Cmd.none )

        GotAnimationClick animate ->
            ( { model | animate = animate }, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Schotter"
    , body =
        [ div []
            [ svg
                [ width "630" -- (* 3.5 (- 160 -20)) 630.0
                , height "1015" -- (* 3.5 (- 270 -20)) 1015.0
                , viewBox "-20 -20 160 270"
                , Svg.Attributes.style "background-color:#eae6e2"
                ]
                (picture model)
            , Html.br [] []
            , button
                [ onClick (GotAnimationClick (not model.animate)) ]
                [ Html.text
                    (if model.animate then
                        "do not animate"

                     else
                        "animate"
                    )
                ]
            ]
        ]
    }


picture : Model -> List (Svg msg)
picture model =
    let
        count =
            model.cols * model.rows

        timeFlux =
            if model.animate then
                toFloat model.millis / 10000 |> sin

            else
                1

        offsetModRand =
            ModRand.new model.seed1 5 (2 ^ 31)

        twistModRand =
            ModRand.new model.seed2 5 (2 ^ 31)

        offsetValues =
            ModRand.nextN offsetModRand (2 * count) -timeFlux timeFlux |> Tuple.first |> pairs

        twistValues =
            ModRand.nextN twistModRand count -timeFlux timeFlux |> Tuple.first

        data =
            List.map2 (\offsets twist -> { offsets = offsets, twist = twist }) offsetValues twistValues
    in
    [ g
        [ stroke "#41403a"
        , strokeWidth "0.4"
        , fill "none"
        , strokeLinecap "round"
        , strokeLinejoin "round"
        ]
        (grid model.cols model.size data box)
    ]


grid : Int -> Float -> List a -> (Int -> Float -> ( Int, Int ) -> a -> b) -> List b
grid cols size data fn =
    let
        mapper =
            \index datum ->
                fn index size ( index // cols, modBy cols index ) datum
    in
    List.indexedMap mapper data


box : Int -> Float -> ( Int, Int ) -> { offsets : ( Float, Float ), twist : Float } -> Svg msg
box index size ( row, col ) data =
    let
        ( yOffset, xOffset ) =
            data.offsets

        twist =
            -data.twist * toFloat index / 264.0 * 45

        xPos =
            size * toFloat col + xOffset * (toFloat index / 264) * size / 2

        yPos =
            size * toFloat row + yOffset * (toFloat index / 264) * size / 2
    in
    rect
        [ x (String.fromFloat xPos)
        , y (String.fromFloat yPos)
        , width (String.fromFloat size)
        , height (String.fromFloat size)
        , transform (rotStr twist (xPos + size / 2) (yPos + size / 2))
        ]
        []



-- ( List.concat (List.map (\yIndex -> Tuple.first <| row seed yIndex width size) (List.range 0 (height - 1))), seed )


rotStr : Float -> Float -> Float -> String
rotStr degrees xCenter yCenter =
    "rotate(" ++ String.fromFloat degrees ++ "," ++ String.fromFloat xCenter ++ "," ++ String.fromFloat yCenter ++ ")"



-- List utils


{-| Divide a list up into pieces of a given length
-}
groups : Int -> List a -> List (List a)
groups n list =
    if List.length list == 0 then
        []

    else if List.length list <= n then
        [ list ]

    else
        List.take n list :: groups n (List.drop n list)


{-| Turn each pair of elements in a list into a pair
-}
pairs : List a -> List ( a, a )
pairs list =
    case list of
        [] ->
            []

        [ _ ] ->
            []

        a :: b :: rest ->
            ( a, b ) :: pairs rest
