module Model exposing (Departure, Model, Msg(..), Page(..), Transport(..), initModel)

import Http exposing (Error(..))
import Time exposing (..)


type alias Model =
    { counter : Int
    , serverMessage : String
    , page : Page
    , departures : List Transport
    , weather : List Forecast
    , birthdays : List Person
    , slack : SlackData
    }



-- Transit


type Transport
    = Train Departure
    | Bus Departure
    | Unknown


type alias Departure =
    { time : Posix
    , destination : String
    , name : String
    }



-- Birthdays


type alias Person =
    { firstName : String
    , lastName : String
    , imageUrl : Url
    }



-- Slack


type alias SlackData =
    { imageUrl : Url
    , topEmojis : List Emoji
    , lastestEvents : List SlackEvent
    }


type SlackEvent
    = Reaction Person Posix Emoji
    | Message Person Posix



-- Global


type Msg
    = Inc
    | TestServer
    | OnServerResponse (Result Http.Error String)


type Page
    = Transit
    | Slack
    | Birthday


type alias Url =
    String


type alias Emoji =
    Url



-- Weather


type Forecast
    = Sunny WeatherData
    | Cloudy WeatherData
    | Rain WeatherData


type alias Temperature =
    Int


type alias WeatherData =
    { high : Temperature
    , low : Temperature
    , feelslike : Temperature
    , description : String
    }



-- Instagram


type alias InstagramInfo =
    { likes : Int
    , comments : Int
    , description : String
    , imageUrl : Url
    }


initModel : Int -> Model
initModel flags =
    { counter = flags
    , serverMessage = ""
    , page = Transit
    , departures =
        [ Bus <| Departure (millisToPosix 123123123) "Kvernevik" "3"
        , Train <| Departure (millisToPosix 5645645645) "Tog til Sandnes" "X76"
        , Bus <| Departure (millisToPosix 234234234) "Buss til Forus" "6"
        , Unknown
        ]
    , weather = []
    , birthdays = []
    , slack = SlackData "" [] []
    }
