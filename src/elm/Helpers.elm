module Helpers exposing (formatDate, getPageKey, getPageTitle, toPascalCase)

import Browser exposing (UrlRequest(..))
import Model exposing (Page(..))
import String exposing (..)
import Task
import Time exposing (..)


formatDate : Zone -> Posix -> String
formatDate zone time =
    concat
        [ fromInt (toDay zone time)
        , "."
        , fromInt (toMonthNumber <| toMonth zone time)
        , "."
        , fromInt (toYear zone time)
        ]


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


getPageTitle : Page -> String
getPageTitle page =
    toPascalCase <| getPageKey page


toPascalCase : String -> String
toPascalCase text =
    String.concat
        [ String.toUpper <| String.slice 0 1 text
        , String.toLower <| String.slice 1 (String.length text) text
        ]
