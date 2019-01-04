module Model exposing (DegreesCelsius, Departure, Emoji, Flags, Href, InstagramInfo, MilliMeter, Model, Msg(..), Page(..), Person, Rainfall, SlackEvent(..), SlackInfo, Temperature, Transport(..), WeatherData, WeatherInfo)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Http exposing (Error(..))
import Time exposing (..)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser)


type alias Flags =
    { apiKey : String
    }


type alias Model =
    { key : Key
    , apiKey : String
    , zone : Zone
    , activePage : ( Int, Page )
    , pages : List ( Int, Page )
    , departures : List Transport
    , weatherInfo : WeatherInfo
    , birthdays : List Person
    , slackInfo : SlackInfo
    , slackEvents : List SlackEvent
    , instagram : List InstagramInfo
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
    , imageUrl : Href
    }



-- Slack


type alias SlackInfo =
    { imageUrl : Href
    , topEmojis : List Emoji
    , lastestEvents : List SlackEvent
    }


type SlackEvent
    = Reaction Person Posix Emoji
    | Message Person Posix
    | UnknownSlackEvent



-- Weather


type alias WeatherInfo =
    { today : WeatherData
    , forecast : List WeatherData
    }


type alias WeatherData =
    { temperature : Temperature
    , rainfall : Maybe Rainfall
    , description : String
    , symbolUrl : String
    }


type alias Temperature =
    { high : DegreesCelsius
    , low : DegreesCelsius
    , current : DegreesCelsius
    , feelslike : DegreesCelsius
    }


type alias Rainfall =
    { high : MilliMeter
    , low : MilliMeter
    , current : MilliMeter
    }


type alias DegreesCelsius =
    Float


type alias MilliMeter =
    Float



-- Instagram


type alias InstagramInfo =
    { comments : Int
    , likes : Int
    , description : String
    , imageHeight : Int
    , imageWidth : Int
    , imageUrl : Href
    , time : Posix
    }



-- Global


type Page
    = Transit
    | Slack
    | Birthday
    | Weather
    | Instagram


type alias Href =
    String


type alias Emoji =
    Href


type Msg
    = OnUrlRequest UrlRequest
    | OnUrlChange Url
    | ChangePage Posix
    | SetTimeZone Zone
    | UpdateSlackEvents (Result Http.Error (List SlackEvent))
    | UpdateWeather (Result Http.Error WeatherInfo)
    | UpdateInstagram (Result Http.Error (List InstagramInfo))
