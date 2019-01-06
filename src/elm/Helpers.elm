module Helpers exposing (formatDate, formatDateDiffMinutes, formatDateTime, getPageKey, getPageTitle, sortTransport, toMonthNumber, toPascalCase)

import Browser exposing (UrlRequest(..))
import Model exposing (..)
import String exposing (..)
import Task
import Time exposing (..)
import Time.Extra exposing (..)


formatDate : Zone -> Posix -> String
formatDate zone time =
    concat
        [ fromInt (toDay zone time)
        , "."
        , fromInt (toMonthNumber <| toMonth zone time)
        , "."
        , fromInt (toYear zone time)
        ]


formatDateTime : Zone -> Posix -> String
formatDateTime zone time =
    concat
        [ padLeft 2 '0' <| fromInt (toHour zone time)
        , ":"
        , padLeft 2 '0' <| fromInt (toMinute zone time)
        , ", "
        , fromInt (toDay zone time)
        , "."
        , fromInt (toMonthNumber <| toMonth zone time)
        , "."
        , fromInt (toYear zone time)
        ]


formatDateDiffMinutes : Zone -> Posix -> Posix -> String
formatDateDiffMinutes zone from to =
    (diff Minute zone from to |> fromInt) ++ " min"


toMonthNumber : Month -> Int
toMonthNumber month =
    case month of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            9

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12


getPageKey : Page -> String
getPageKey page =
    case page of
        Transit ->
            "transit"

        Birthday ->
            "birthday"

        Slack ->
            "slack"

        Weather ->
            "weather"

        Instagram ->
            "instagram"

        Lunch ->
            "lunch"


getPageTitle : Page -> String
getPageTitle page =
    toPascalCase <| getPageKey page


toPascalCase : String -> String
toPascalCase text =
    String.concat
        [ String.toUpper <| String.slice 0 1 text
        , String.toLower <| String.slice 1 (String.length text) text
        ]


sortTransport : Transport -> Transport -> Order
sortTransport departure1 departure2 =
    let
        getDepartureTime departure =
            case departure of
                Train { time } ->
                    Time.posixToMillis time

                Bus { time } ->
                    Time.posixToMillis time

                Unknown ->
                    0
    in
    compare (getDepartureTime departure1) (getDepartureTime departure2)
