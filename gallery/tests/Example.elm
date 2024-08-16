module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (..)
import Test exposing (..)


suite : Test
suite =
    let
        bigMod =
            2 ^ 31
    in
    describe "The Main Schotter module"
        [ describe "ModRand"
            [ test "works trivially for small values" <|
                \_ ->
                    let
                        modRand =
                            newModRand 1 5 bigMod
                    in
                    modRandNext modRand 0 (toFloat bigMod)
                        |> Expect.equal ( 5, newModRand 5 5 bigMod )
            , test "works for halfway point" <|
                \_ ->
                    let
                        modRand =
                            newModRand (bigMod // 2) 5 bigMod
                    in
                    modRandNext modRand 0 (toFloat bigMod)
                        |> Expect.equal ( toFloat bigMod / 2, modRand )
            , test "works for lists" <|
                \_ ->
                    let
                        modRand =
                            newModRand 17 5 bigMod
                    in
                    modRandN modRand 12 0 (toFloat bigMod)
                        |> Expect.equal
                            ( [ 2002906977, 830078125, 166015625, 33203125, 6640625, 1328125, 265625, 53125, 10625, 2125, 425, 85 ]
                            , { modRand | seed = 2002906977 }
                            )
            ]
        ]
