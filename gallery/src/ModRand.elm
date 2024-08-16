module ModRand exposing
    ( new
    , next
    , nextN
    )

{-| ModRand is a simple random-by-multiply-and-mod random number
generator, descibed by Georg Nees in his 1969 thesis and used in
many of his early artworks.
-}


{-| ModRand is a simple random-by-multiply-and-mod tuple
-}
type alias MR =
    { seed : Int
    , mul : Int
    , mod : Int
    }


new : Int -> Int -> Int -> MR
new seed mul mod =
    { seed = seed, mul = mul, mod = mod }


{-| Generate the next random value, in a given range
-}
next : MR -> Float -> Float -> ( Float, MR )
next modRand min max =
    let
        nextModRand =
            { modRand | seed = modBy modRand.mod (modRand.seed * modRand.mul) }
    in
    ( min + (max - min) * (toFloat nextModRand.seed / toFloat modRand.mod), nextModRand )


{-| Generate a list of random values in a given range
-}
nextN : MR -> Int -> Float -> Float -> ( List Float, MR )
nextN modRand count min max =
    if count <= 0 then
        ( [], modRand )

    else if count == 1 then
        Tuple.mapFirst List.singleton (next modRand min max)

    else
        let
            ( rest, nextModRand ) =
                nextN modRand (count - 1) min max

            ( val, finalModRand ) =
                next nextModRand min max
        in
        ( rest ++ [ val ], finalModRand )
