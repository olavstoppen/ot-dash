module Model exposing (DegreesCelsius, Departure, Emoji, Flags, Href, InstagramPost, MilliMeter, Model, Msg(..), Page(..), Person, Rainfall, SlackEvent(..), SlackInfo, Temperature, Transport(..), WeatherData, WeatherInfo)

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
    , now : Posix
    , activePage : ( Int, Page )
    , pageCountdown : Int
    , pages : List ( Int, Page )
    , publicTransport : List Transport
    , weatherInfo : WeatherInfo
    , birthdays : List Person
    , slackInfo : SlackInfo
    , slackEvents : List SlackEvent
    , instagram : List InstagramPost
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
    { topEmojis : List Emoji
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
    , day : String
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


type alias InstagramPost =
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
    | UpdateNow Posix
    | SetTimeZone Zone
    | UpdateSlackEvents (Result Http.Error (List SlackEvent))
    | UpdateWeather (Result Http.Error WeatherInfo)
    | UpdateInstagram (Result Http.Error (List InstagramPost))
    | UpdatePublicTransport (Result Http.Error (List (List Transport)))
    | UpdateSlackInfo (Result Http.Error SlackInfo)
