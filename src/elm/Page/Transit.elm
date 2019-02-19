module Page.Transit exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Icons exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    case model.publicTransport of
        Success publicTransport ->
            div [ class "page page__transit" ]
                [ title
                , annotation
                , body publicTransport model
                , square model
                ]

        _ ->
            div [ class "page page__transit" ]
                [ div [ class "content" ]
                    [ div [ class "animated fadeInDown faster today" ]
                        [ div [] [ text "Mangler data" ]
                        ]
                    ]
                ]


title : Html Msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Kollektivt" ]
            ]
        ]


annotation : Html Msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ busIcon
        , h3 [] [ text "kolumbus.no" ]
        ]


body : List Transport -> Model -> Html Msg
body publicTransport model =
    div [ class "content--tall" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "departures" ] <|
                List.map (departure model) <|
                    List.take 6 publicTransport
            ]
        ]


departure : Model -> Transport -> Html Msg
departure { here } transport =
    div [ class "departure" ] <|
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


square : Model -> Html Msg
square model =
    div [ class "square " ]
        [ div [ class "animated slideInLeft faster delay-2s" ]
            [ iframe [ class "transit__map ", src "https://www.kolumbus.no/ruter/kart/sanntidskart/?c=58.914520,5.732501,14&lf=all&vt=bus,ferry" ] [ text "Loading" ]
            ]
        ]
