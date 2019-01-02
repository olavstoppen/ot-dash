module Helpers exposing (formatDate, getPageKey, getPageTitle, toPascalCase)

import Browser exposing (UrlRequest(..))
import Model exposing (Page(..))
import String
import Time exposing (Posix, toHour, toMinute, toSecond, utc)


formatDate : Posix -> String
formatDate time =
    String.fromInt (toHour utc time)
        ++ ":"
        ++ String.fromInt (toMinute utc time)
        ++ ":"
        ++ String.fromInt (toSecond utc time)
        ++ " (UTC)"


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
            "slack"

        Instagram ->
            "slack"


getPageTitle : Page -> String
getPageTitle page =
    toPascalCase <| getPageKey page


toPascalCase : String -> String
toPascalCase text =
    String.concat
        [ String.toUpper <| String.slice 0 1 text
        , String.toLower <| String.slice 1 (String.length text) text
        ]
