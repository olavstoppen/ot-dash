module Helpers exposing (formatDate, getPageKey)

import Model exposing (Page)
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
    ""
