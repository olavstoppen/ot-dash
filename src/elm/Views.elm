module Views exposing (viewRemoteData)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Model exposing (..)
import String


viewRemoteData : Model -> (Model -> RemoteData a) -> (Model -> Html msg) -> Html msg
viewRemoteData model remoteData viewfn =
    case remoteData model of
        NotAsked ->
            div [ class "page" ]
                [ div [ class "title" ]
                    [ div [ class "animated fadeInDown faster" ]
                        [ h1 [] [ text "Starter opp... ️️🏗️" ]
                        ]
                    ]
                ]

        Loading ->
            div [ class "page" ]
                [ div [ class "title" ]
                    [ div [ class "animated fadeInDown faster" ]
                        [ h1 [] [ text "Laster... ⏳" ]
                        ]
                    ]
                ]

        Failure err ->
            div [ class "page" ]
                [ div [ class "title" ]
                    [ div [ class "animated fadeInDown faster" ]
                        [ h1 [] [ text "Pingu føler seg ikke så bra... \u{1F912}" ]
                        ]
                    ]
                , div [ class "content" ]
                    [ div [ class "animated fadeInDown faster " ]
                        [ div [] [ text <| httpErrorToString err ]
                        ]
                    ]
                ]

        Success _ ->
            viewfn model


httpErrorToString : Error -> String
httpErrorToString err =
    case err of
        BadUrl url ->
            "BadUrl: " ++ url

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus code ->
            "BadStatus: " ++ String.fromInt code

        BadBody string ->
            "BadBody: " ++ string
