module Effect exposing
    ( Effect(..)
    , batch
    , map
    , none
    , pushRoute
    , signInUser
    )

import Route exposing (Route)


type Effect msg
    = None
    | Batch (List (Effect msg))
    | SignInUser { username : String }
    | PushRoute Route


none : Effect msg
none =
    None


batch : List (Effect msg) -> Effect msg
batch list =
    Batch list


signInUser : { username : String } -> Effect msg
signInUser data =
    SignInUser data


pushRoute : Route -> Effect msg
pushRoute route =
    PushRoute route


map : (msg1 -> msg2) -> Effect msg1 -> Effect msg2
map toMsg effect =
    case effect of
        None ->
            None

        Batch effects ->
            Batch (List.map (map toMsg) effects)

        SignInUser data ->
            SignInUser data

        PushRoute route ->
            PushRoute route
