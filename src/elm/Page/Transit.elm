module Page.Transit exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Icons exposing (..)
import Model exposing (..)


view : Model -> Html msg
view model =
    case model.publicTransport of
        Success publicTransport ->
            div [ class "page transit-page" ]
                [ title
                , annotation
                , body publicTransport model
                , square model
                ]

        _ ->
            div [ class "page transit-page" ]
                [ div [ class "content" ]
                    [ div [ class "animated fadeInDown faster today" ]
                        [ div [] [ text "Mangler data" ]
                        ]
                    ]
                ]


title : Html msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Kollektivt" ]
            ]
        ]


annotation : Html msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ busIcon
        , h3 [] [ text "kolumbus.no" ]
        ]


body : List Transport -> Model -> Html msg
body publicTransport model =
    div [ class "content--tall" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "transit-departures" ] <|
                List.map (departure model) <|
                    List.take 6 publicTransport
            ]
        ]


departure : Model -> Transport -> Html msg
departure { here } transport =
    div [ class "transit-departure" ] <|
        case transport of
            Unknown ->
                [ text "Ukjent transport" ]

            Bus departure_ ->
                [ div [ class "ellipse active" ] [ text departure_.name ]
                , div [] [ text departure_.destination ]
                , div [] [ text <| formatDateDiffMinutes here.zone here.time departure_.time ]
                ]

            Train departure_ ->
                [ div [ class "ellipse active" ] [ trainIcon "icon--med" ]
                , div [] [ text departure_.destination ]
                , div [] [ text <| formatDateDiffMinutes here.zone here.time departure_.time ]
                ]


square : Model -> Html msg
square _ =
    div [ class "square " ]
        [ div [ class "animated slideInLeft faster delay-2s transit-map" ]
            [ iframe [ class "", src "https://www.kolumbus.no/ruter/kart/sanntidskart/?c=58.914520,5.732501,14&lf=all&vt=bus,ferry" ] [ text "Loading" ]
            ]
        ]
