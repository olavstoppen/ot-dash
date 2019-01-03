module Services exposing (fetchDepartures, fetchSlackEvents)

import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Model exposing (..)
import Time exposing (..)


fetchDepartures : (Result Http.Error String -> Msg) -> Cmd Msg
fetchDepartures callback =
    Http.get
        { url = "/test"
        , expect =
            Http.expectJson callback <|
                Decode.field "result" Decode.string
        }


fetchSlackEvents : (Result Http.Error (List SlackEvent) -> Msg) -> Cmd Msg
fetchSlackEvents callback =
    Http.get
        { url = "https://pingubot-server.herokuapp.com/LatestMessages"
        , expect = Http.expectJson callback <| list decodeLatestMessage
        }


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
