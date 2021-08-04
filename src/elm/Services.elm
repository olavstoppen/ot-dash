module Services exposing (fetchBirthdays, fetchCalendar, fetchInstagram, fetchLunchImgs, fetchLunchMenu, fetchPublicTransport, fetchSlackEvents, fetchSlackImgs, fetchSlackInfo, fetchWeather)

import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing (withDefault)
import Json.Decode.Pipeline exposing (..)
import Model exposing (..)
import Time exposing (Posix, Weekday(..), millisToPosix)


pingubotUrl : String -> String
pingubotUrl path =
    "https://ot-pingu-server.azurewebsites.net/" ++ path
    --"http://localhost:4001/" ++ path


pingubotHeaders : String -> List Http.Header
pingubotHeaders apiKey =
    [ Http.header "x-api-key" apiKey ]


limit : String
limit =
    "30"


tenorUrl : String
tenorUrl =
    "https://api.tenor.com/v1/random?key=B81HIUQSPE5Q&limit=" ++ limit ++ "&contentfilter=high&q=typing"


unslpashUrl : String
unslpashUrl =
    "https://api.unsplash.com/photos/random?collections=202618,575196&count=" ++ limit


unslpashHeaders : List Http.Header
unslpashHeaders =
    [ Http.header
        "Authorization"
        "Client-ID a15e8f9c25d93d6985245b161feba5eec1185b2eb7b62b478d8d0c0f1c43ec21"
    ]


get : List Http.Header -> String -> (Result Http.Error a -> Msg) -> Decoder a -> Cmd Msg
get headers url callback decoder =
    Http.request
        { method = "GET"
        , headers = headers
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson callback decoder
        , timeout = Nothing
        , tracker = Nothing
        }



-- Global decoders


decodePerson : Decoder Person
decodePerson =
    Decode.succeed Person
        |> required "firstName" string
        |> required "lastName" string
        |> optional "imageUrl" string ""


decodeTime : Decoder Posix
decodeTime =
    map toPosix int


toPosix : Int -> Posix
toPosix number =
    millisToPosix <| number * 1000


decodeEmoji : Decoder Emoji
decodeEmoji =
    maybe string



-- Slack


fetchSlackEvents :
    (Result Http.Error (List SlackEvent) -> Msg)
    -> Model
    -> Cmd Msg
fetchSlackEvents callback { apiKey } =
    get (pingubotHeaders apiKey) (pingubotUrl "LatestMessages") callback <| list decodeLatestMessage


decodeLatestMessage : Decoder SlackEvent
decodeLatestMessage =
    field "message" string
        |> andThen decodeSlackEvent


decodeSlackEvent : String -> Decoder SlackEvent
decodeSlackEvent message =
    case message of
        "reaction_added" ->
            Decode.succeed Reaction
                |> required "user" decodePerson
                |> required "posix" decodeTime
                |> optional "emojiUrl" decodeEmoji Nothing

        "message" ->
            Decode.succeed Message
                |> required "user" decodePerson
                |> required "posix" decodeTime

        _ ->
            succeed UnknownSlackEvent



-- Slack info


fetchSlackInfo :
    (Result Http.Error SlackInfo -> Msg)
    -> Model
    -> Cmd Msg
fetchSlackInfo callback { apiKey } =
    get (pingubotHeaders apiKey) (pingubotUrl "Emojistats") callback <| decodeSlackInfo


decodeSlackInfo : Decoder SlackInfo
decodeSlackInfo =
    map SlackInfo (list decodeEmoji)



-- Weather


fetchWeather : (Result Http.Error WeatherInfo -> Msg) -> Model -> Cmd Msg
fetchWeather callback { apiKey } =
    get (pingubotHeaders apiKey) (pingubotUrl "Weather") callback <| decodeWeatherInfo


decodeWeatherInfo : Decoder WeatherInfo
decodeWeatherInfo =
    Decode.succeed WeatherInfo
        |> required "today" decodeWeatherData
        |> required "forecast" (list decodeWeatherData)


decodeWeatherData : Decoder WeatherData
decodeWeatherData =
    let
        toDecoder : Float -> Float -> Float -> Float -> Float -> Float -> Float -> String -> String -> String -> Decoder WeatherData
        toDecoder highestTemp lowestTemp currentTemp feelslike maxRainfall minRainfall currentRainfall description symbolUrl day =
            let
                temperature =
                    { high = highestTemp
                    , low = lowestTemp
                    , current = currentTemp
                    , feelslike = feelslike
                    }

                maybeRainfall =
                    if (maxRainfall + minRainfall + currentRainfall) > 0 then
                        Just
                            { high = maxRainfall
                            , low = minRainfall
                            , current = currentRainfall
                            }

                    else
                        Nothing
            in
            Decode.succeed
                { temperature = temperature
                , rainfall = maybeRainfall
                , description = description
                , symbolUrl = symbolUrl
                , day = day
                }
    in
    Decode.succeed toDecoder
        |> required "highestTemp" float
        |> required "lowestTemp" float
        |> required "temp" float
        |> optional "temp" float 0.0
        |> optional "maxRainfall" float 0.0
        |> optional "minRainfall" float 0.0
        |> optional "currentRainfall" float 0.0
        |> optional "description" string ""
        |> required "symbolUrl" string
        |> required "name" string
        |> resolve



-- Calendar


fetchCalendar : (Result Http.Error (List CalendarEvent) -> Msg) -> Model -> Cmd Msg
fetchCalendar callback { apiKey } =
    get (pingubotHeaders apiKey) (pingubotUrl "Calendar/upcoming-events?amount=5") callback <| list decodeCalendar


decodeCalendar : Decoder CalendarEvent
decodeCalendar =
    Decode.succeed CalendarEvent
        |> required "description" (string |> withDefault "")
        |> required "fromPosix" decodeTime
        |> required "toPosix" decodeTime
        |> required "name" (string |> withDefault "")
        |> required "url" (string |> withDefault "")
        |> required "category" decodeCategory
        |> required "color" (string |> withDefault "")


decodeCategory : Decoder CalendarCategory
decodeCategory =
    string
        |> andThen
            (\category ->
                case category of
                    "Olavstoppen" ->
                        succeed Olavstoppen

                    "Bouvet" ->
                        succeed Bouvet

                    "Ferie" ->
                        succeed Holiday

                    "Ekstern" ->
                        succeed ExternalCalendar

                    _ ->
                        succeed UnknownCalendarCategory
            )



-- Instagram


fetchInstagram : (Result Http.Error (List InstagramPost) -> Msg) -> Model -> Cmd Msg
fetchInstagram callback { apiKey } =
    get (pingubotHeaders apiKey) (pingubotUrl "Instagram") callback <| list decodeInstagram


decodeInstagram : Decoder InstagramPost
decodeInstagram =
    Decode.succeed InstagramPost
        |> required "comments" int
        |> required "likes" int
        |> required "description" string
        |> required "imageHeight" int
        |> required "imageWidth" int
        |> required "imageUrl" string
        |> required "posix" decodeTime



-- Birthday


fetchBirthdays : (Result Http.Error (List Person) -> Msg) -> Model -> Cmd Msg
fetchBirthdays callback { apiKey } =
    get (pingubotHeaders apiKey) (pingubotUrl "Birthdays") callback <| list decodePerson



-- Public Transport


fetchPublicTransport : (Result Http.Error (List (List Transport)) -> Msg) -> Model -> Cmd Msg
fetchPublicTransport callback { apiKey } =
    get (pingubotHeaders apiKey) (pingubotUrl "PublicTransport") callback <| list decodeDepartures


decodeDepartures : Decoder (List Transport)
decodeDepartures =
    field "transportMode" string
        |> andThen decodeStop


decodeStop : String -> Decoder (List Transport)
decodeStop transportMode =
    case transportMode of
        "bus" ->
            field "departures" (list decodeBus)

        "rail" ->
            field "departures" (list decodeTrain)

        _ ->
            succeed [ Unknown ]


decodeBus : Decoder Transport
decodeBus =
    Decode.succeed Departure
        |> required "expectedDeparturePosix" decodeTime
        |> required "text" string
        |> optional "line" string ""
        |> map Bus


decodeTrain : Decoder Transport
decodeTrain =
    Decode.succeed Departure
        |> required "expectedDeparturePosix" decodeTime
        |> required "text" string
        |> optional "line" string "NSB"
        |> map Train



-- LunchMenu


fetchLunchMenu : (Result Http.Error (List LunchData) -> Msg) -> Model -> Cmd Msg
fetchLunchMenu callback { apiKey } =
    get (pingubotHeaders apiKey) (pingubotUrl "LunchMenu") callback <| list decodeLunch


decodeLunch : Decoder LunchData
decodeLunch =
    Decode.succeed LunchData
        |> required "day" decodeDay
        |> required "day" string
        |> required "dishes" (list decodeLunchDish)


decodeLunchDish : Decoder LunchDish
decodeLunchDish =
    Decode.succeed LunchDish
        |> required "name" string
        |> required "emojis" (list string)


concat : List String -> Decoder String
concat strings =
    succeed <| String.join " " strings


decodeDay : Decoder Weekday
decodeDay =
    string
        |> andThen toWeekday


toWeekday : String -> Decoder Weekday
toWeekday day =
    case day of
        "Mandag" ->
            succeed Mon

        "Tirsdag" ->
            succeed Tue

        "Onsdag" ->
            succeed Wed

        "Torsdag" ->
            succeed Thu

        "Fredag" ->
            succeed Fri

        _ ->
            fail "Day not found"



-- Tenor


fetchSlackImgs : (Result Http.Error (List Href) -> Msg) -> Cmd Msg
fetchSlackImgs callback =
    get [] tenorUrl callback <| decodeTenor


decodeTenor : Decoder (List Href)
decodeTenor =
    field "results"
        (list <| field "media" (list <| at [ "mediumgif", "url" ] string))
        |> andThen
            flatHref


flatHref : List (List Href) -> Decoder (List Href)
flatHref lists =
    succeed <| List.concat lists



-- Unsplash


fetchLunchImgs : (Result Http.Error (List Href) -> Msg) -> Cmd Msg
fetchLunchImgs callback =
    get unslpashHeaders unslpashUrl callback <| decodeUnslpash


decodeUnslpash : Decoder (List Href)
decodeUnslpash =
    list <| at [ "urls", "regular" ] string
