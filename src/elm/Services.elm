module Services exposing (fetchBirthdays, fetchCalendar, fetchInstagram, fetchPublicTransport, fetchSlackEvents, fetchWeather)

import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Model exposing (..)
import Time exposing (..)


baseUrl : String -> String
baseUrl path =
    "https://pingubot-server.herokuapp.com/" ++ path


get : String -> String -> (Result Http.Error a -> Msg) -> Decoder a -> Cmd Msg
get apiKey path callback decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "x-api-key" apiKey ]
        , url = baseUrl path
        , body = Http.emptyBody
        , expect = Http.expectJson callback decoder
        , timeout = Nothing
        , tracker = Nothing
        }



-- Slack


fetchSlackEvents :
    (Result Http.Error (List SlackEvent) -> Msg)
    -> Model
    -> Cmd Msg
fetchSlackEvents callback { apiKey } =
    get apiKey "LatestMessages" callback <| list decodeLatestMessage


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
                |> required "emojiUrl" string

        "message" ->
            Decode.succeed Message
                |> required "user" decodePerson
                |> required "posix" decodeTime

        _ ->
            succeed UnknownSlackEvent



-- Weather


fetchWeather : (Result Http.Error WeatherInfo -> Msg) -> Model -> Cmd Msg
fetchWeather callback { apiKey } =
    get apiKey "Weather" callback <| decodeWeatherInfo


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


fetchCalendar : (Result Http.Error (List SlackEvent) -> Msg) -> Cmd Msg
fetchCalendar callback =
    get "" "Calendar" callback <| list decodeLatestMessage



-- Instagram


fetchInstagram : (Result Http.Error (List InstagramPost) -> Msg) -> Model -> Cmd Msg
fetchInstagram callback { apiKey } =
    get apiKey "Instagram" callback <| list decodeInstagram


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


fetchBirthdays : (Result Http.Error (List SlackEvent) -> Msg) -> Cmd Msg
fetchBirthdays callback =
    get "" "Calendar" callback <| list decodeLatestMessage



-- [
--   {
--     "firstName": "Stian",
--     "lastName": "Bakkenator",
--     "imageUrl": "https://secure.gravatar.com/avatar/db4defee9f1940fdb5d5f48718dffc4d.jpg?s=512&d=https%3A%2F%2Fa.slack-edge.com%2F7fa9%2Fimg%2Favatars%2Fava_0021-512.png"
--   },
--   {
--     "firstName": "Stian",
--     "lastName": "Bakken Batman",
--     "imageUrl": "https://secure.gravatar.com/avatar/048195daf5327cef0444ac61ad958c3a.jpg?s=512&d=https%3A%2F%2Fa.slack-edge.com%2F7fa9%2Fimg%2Favatars%2Fava_0002-512.png"
--   }
-- ]
-- Public Transport


fetchPublicTransport : (Result Http.Error (List (List Transport)) -> Msg) -> Model -> Cmd Msg
fetchPublicTransport callback { apiKey } =
    get apiKey "PublicTransport" callback <| list decodeDepartures


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
        |> required "departurePosix" decodeTime
        |> required "text" string
        |> optional "route" string "3"
        |> map Bus


decodeTrain : Decoder Transport
decodeTrain =
    Decode.succeed Departure
        |> required "departurePosix" decodeTime
        |> required "text" string
        |> optional "route" string "NSB"
        |> map Train



-- Global


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
