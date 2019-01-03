module Services exposing (fetchSlackEvents)

import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Model exposing (..)
import Time exposing (..)


baseUrl : String -> String
baseUrl path =
    "https://pingubot-server.herokuapp.com/" ++ path


get : String -> (Result Http.Error a -> Msg) -> Decoder a -> Cmd Msg
get path callback decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "x-api-key" "" ]
        , url = baseUrl path
        , body = Http.emptyBody
        , expect = Http.expectJson callback decoder
        , timeout = Nothing
        , tracker = Nothing
        }



-- Slack


fetchSlackEvents : (Result Http.Error (List SlackEvent) -> Msg) -> Cmd Msg
fetchSlackEvents callback =
    get "LatestMessages" callback <| list decodeLatestMessage


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


fetchWeather : (Result Http.Error (List SlackEvent) -> Msg) -> Cmd Msg
fetchWeather callback =
    get "Weather" callback <| list decodeLatestMessage



-- Calendar


fetchCalendar : (Result Http.Error (List SlackEvent) -> Msg) -> Cmd Msg
fetchCalendar callback =
    get "Calendar" callback <| list decodeLatestMessage



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


stringToTime : String -> Posix
stringToTime text =
    millisToPosix <| Maybe.withDefault 0 <| String.toInt text
