module Services exposing (fetchInstagram, fetchSlackEvents, fetchWeather)

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
                |> required "timestamp" decodeTime
                |> hardcoded "some-emoji-url"

        "message" ->
            Decode.succeed Message
                |> required "user" decodePerson
                |> required "timestamp" decodeTime

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
        |> required "forecast" (list decodeForecast)


decodeWeatherData : Decoder WeatherData
decodeWeatherData =
    let
        toDecoder : Float -> Float -> Float -> Float -> Float -> Float -> Float -> String -> String -> Decoder WeatherData
        toDecoder highestTemp lowestTemp currentTemp feelslike maxRainfall minRainfall currentRainfall description symbolUrl =
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
                }
    in
    Decode.succeed toDecoder
        |> required "highestTemp" float
        |> required "lowestTemp" float
        |> required "currentTemp" float
        |> optional "currentTemp" float 0.0
        |> optional "maxRainfall" float 0.0
        |> optional "minRainfall" float 0.0
        |> optional "currentRainfall" float 0.0
        |> optional "description" string ""
        |> required "symbolUrl" string
        |> resolve


decodeForecast : Decoder Forecast
decodeForecast =
    Decode.succeed Forecast
        |> required "highestTemp" float
        |> required "lowestTemp" float
        |> required "temp" float
        |> required "symbolUrl" string



-- Calendar


fetchCalendar : (Result Http.Error (List SlackEvent) -> Msg) -> Cmd Msg
fetchCalendar callback =
    get "" "Calendar" callback <| list decodeLatestMessage



-- Instagram


fetchInstagram : (Result Http.Error (List InstagramInfo) -> Msg) -> Model -> Cmd Msg
fetchInstagram callback { apiKey } =
    get apiKey "Instagram" callback <| list decodeInstagram


decodeInstagram : Decoder InstagramInfo
decodeInstagram =
    Decode.succeed InstagramInfo
        |> required "comments" int
        |> required "likes" int
        |> required "description" string
        |> required "imageHeight" int
        |> required "imageWidth" int
        |> required "imageUrl" string
        |> required "timestamp" decodeTime_



-- Global


decodePerson : Decoder Person
decodePerson =
    Decode.succeed Person
        |> required "firstName" string
        |> required "lastName" string
        |> optional "imageUrl" string ""


decodeTime : Decoder Posix
decodeTime =
    map stringToTime string


decodeTime_ : Decoder Posix
decodeTime_ =
    map millisToPosix int


stringToTime : String -> Posix
stringToTime text =
    millisToPosix <| Maybe.withDefault 0 <| String.toInt text
