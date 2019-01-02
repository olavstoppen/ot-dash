module Services exposing (fetchDepartures)

import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Model exposing (..)


fetchDepartures : (Result Http.Error String -> Msg) -> Cmd Msg
fetchDepartures callback =
    Http.get
        { url = "/test"
        , expect = Http.expectJson callback (Decode.field "result" Decode.string)
        }
