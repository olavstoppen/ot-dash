module Model exposing (Departure, Emoji, Forecast(..), Href, InstagramInfo, Model, Msg(..), Page(..), Person, SlackData, SlackEvent(..), Temperature, Transport(..), WeatherData)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Http exposing (Error(..))
import Time exposing (..)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser)


type alias Model =
    { key : Key
    , serverMessage : String
    , activePage : Page
    , pages : List Page
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
    , imageUrl : Href
    }



-- Slack


type alias SlackData =
    { imageUrl : Href
    , topEmojis : List Emoji
    , lastestEvents : List SlackEvent
    }


type SlackEvent
    = Reaction Person Posix Emoji
    | Message Person Posix



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
    , imageUrl : Href
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
    | TestServer
    | OnServerResponse (Result Http.Error String)
