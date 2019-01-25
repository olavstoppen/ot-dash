module Helpers exposing (formatDate, formatDateDiffMinutes, formatDateTime, formatDay, formatTime, formatWeekDayName, fullName, getPageKey, getPageTitle, getStringAt, newLineOnFirstHash, sortTransport, toMonthNumber, toPascalCase)

import Browser exposing (UrlRequest(..))
import List.Extra as ListExtra
import Model exposing (..)
import Regex
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


formatTime : Zone -> Posix -> String
formatTime zone time =
    concat
        [ padLeft 2 '0' <| fromInt (toHour zone time)
        , ":"
        , padLeft 2 '0' <| fromInt (toMinute zone time)
        ]


formatDay : Zone -> Posix -> String
formatDay zone time =
    fromInt <| toDay zone time


formatWeekDayName : Zone -> Posix -> String
formatWeekDayName zone time =
    getWeekDayName <| toWeekday zone time


getWeekDayName : Weekday -> String
getWeekDayName weekday =
    case weekday of
        Mon ->
            "Mandag"

        Tue ->
            "Tirsdag"

        Wed ->
            "Onsdag"

        Thu ->
            "Torsdag"

        Fri ->
            "Fredag"

        Sat ->
            "Lørdag"

        Sun ->
            "Søndag"


formatDateDiffMinutes : Zone -> Posix -> Posix -> String
formatDateDiffMinutes zone from to =
    let
        diffNow =
            diff Minute zone from to
    in
    if diffNow == 0 then
        " nå"

    else
        (diffNow |> fromInt) ++ " min"


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

        Birthday person ->
            "birthday/" ++ person.firstName

        Slack ->
            "slack"

        Weather ->
            "weather"

        Instagram ->
            "instagram"

        Lunch ->
            "lunch"

        Calendar ->
            "calendar"


getPageTitle : Page -> String
getPageTitle page =
    case page of
        Lunch ->
            "Lunsj"

        Birthday _ ->
            "Bursdag"

        Weather ->
            "Været"

        Transit ->
            "Kollektivt"

        Calendar ->
            "Hendelser"

        _ ->
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


fullName : Person -> String
fullName { firstName, lastName } =
    String.concat [ firstName, " ", lastName ]


getStringAt : Int -> List Href -> String
getStringAt digit imgUrls =
    imgUrls
        |> ListExtra.getAt digit
        |> Maybe.withDefault ""


newLineOnFirstHash : String -> String
newLineOnFirstHash text =
    Regex.splitAtMost 1 hash text
        |> String.join "\n #"


hash : Regex.Regex
hash =
    Maybe.withDefault Regex.never <|
        Regex.fromString "#"