module Model exposing (Model, Msg(..), Page(..), Passing, Transport(..), initModel)

import Http exposing (Error(..))
import Time exposing (..)


type alias Model =
    { counter : Int
    , serverMessage : String
    , page : Page
    , passings : List Transport
    }


type Transport
    = Train Passing
    | Bus Passing
    | Unknown


type alias Passing =
    { time : Posix
    , destination : String
    , name : String
    }


type Msg
    = Inc
    | TestServer
    | OnServerResponse (Result Http.Error String)


type Page
    = Transit
    | Slack
    | Birthday


initModel : Int -> Model
initModel flags =
    { counter = flags
    , serverMessage = ""
    , page = Transit
    , passings =
        [ Bus <| Passing (millisToPosix 123123123) "Kvernevik" "3"
        , Train <| Passing (millisToPosix 5645645645) "Tog til Sandnes" "X76"
        , Bus <| Passing (millisToPosix 234234234) "Buss til Forus" "6"
        , Unknown
        ]
    }
