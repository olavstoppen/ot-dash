module Model exposing (Birthdays, CalendarCategory(..), CalendarEvent, DegreesCelsius, Departure, Emoji, Flags, Here, Href, InstagramPost, LunchData, Media, MilliMeter, Model, Msg(..), Page(..), Pages, Person, Rainfall, RemoteData(..), SlackEvent(..), SlackInfo, Temperature, Transport(..), WeatherData, WeatherInfo, defaultCountdown)

import Browser exposing (UrlRequest(..))
import Browser.Navigation exposing (Key)
import Http exposing (Error(..))
import Time exposing (..)
import Url exposing (Url)


type alias Flags =
    { apiKey : String
    , pageCountdownMillis : Int
    }


type alias Model =
    { key : Key
    , apiKey : String
    , here : Here
    , pages : Pages
    , publicTransport : RemoteData (List Transport)
    , birthdays : Birthdays
    , slackInfo : RemoteData SlackInfo
    , slackEvents : RemoteData (List SlackEvent)
    , instagram : RemoteData (List InstagramPost)
    , lunchMenu : RemoteData (List LunchData)
    , weatherInfo : RemoteData WeatherInfo
    , calendar : RemoteData (List CalendarEvent)
    , media : Media
    }


type RemoteData a
    = NotAsked
    | Loading
    | Failure Http.Error
    | Success a


type alias Here =
    { time : Posix
    , zone : Zone
    , day : Weekday
    }


type alias Pages =
    { active : Page
    , countdown : Int
    , available : List Page
    }


type alias Media =
    { digit : Int
    , slackImgs : List Href
    , lunchImgs : List Href
    }



-- Global


type Page
    = Transit
    | Slack
    | Birthday Person
    | Weather
    | Instagram
    | Lunch
    | Calendar
    | Video
    | Traffic


type alias Href =
    String


type alias Emoji =
    Maybe Href


type alias Birthdays =
    RemoteData (List Person)



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



-- Lunch


type alias LunchData =
    { day : Weekday
    , dayName : String
    , maincourse : String
    , soup : String
    , maincourseEmojis : List Href
    , soupEmojis : List Href
    }



-- Calendar


type CalendarCategory
    = Olavstoppen
    | Bouvet
    | Holiday
    | ExternalCalendar
    | UnknownCalendarCategory


type alias CalendarEvent =
    { description : String
    , from : Posix
    , to : Posix
    , name : String
    , url : String
    , category : CalendarCategory
    , color : String
    }


type Msg
    = OnUrlRequest UrlRequest
    | OnUrlChange Url
    | FetchAllData Posix
    | EverySecond Posix
    | EveryMinute Posix
    | EveryHour Posix
    | EveryDay Posix
    | SetTimeZone Zone
    | UpdateSlackEvents (Result Http.Error (List SlackEvent))
    | UpdateWeather (Result Http.Error WeatherInfo)
    | UpdateInstagram (Result Http.Error (List InstagramPost))
    | UpdatePublicTransport (Result Http.Error (List (List Transport)))
    | UpdateSlackInfo (Result Http.Error SlackInfo)
    | UpdateLunchMenu (Result Http.Error (List LunchData))
    | UpdateBirthdays (Result Http.Error (List Person))
    | UpdateCalendar (Result Http.Error (List CalendarEvent))
    | UpdateSlackImgs (Result Http.Error (List Href))
    | UpdateLunchImgs (Result Http.Error (List Href))
    | UpdateMediaDigit Int


defaultCountdown : Int
defaultCountdown =
    6000000
