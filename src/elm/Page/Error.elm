module Page.Error exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (Error(..))
import Icons exposing (..)


view : Error -> Html msg
view err =
    div [ class "page page__error" ]
        [ div [ class "content--wide" ]
            [ div [ class "animated fadeInDown faster " ]
                [ div [] [ text <| httpErrorToString err ]
                ]
            ]
        ]


httpErrorToString : Error -> String
httpErrorToString err =
    case err of
        BadUrl _ ->
            "BadUrl"

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus _ ->
            "BadStatus"

        BadBody s ->
            "BadBody: " ++ s
