module Page.Transit exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Icons exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div [ class "page page__transit" ]
        [ title
        , annotation
        , body model
        , square model
        ]


title : Html msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Transit" ]
            ]
        ]


annotation : Html msg
annotation =
    div [ class "annotation" ]
        [ busIcon
        , h3 [] [ text "kolumbus.no" ]
        ]


body : Model -> Html msg
body model =
    div [ class "content" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "departures" ] <| List.map (departure model) model.publicTransport
            ]
        ]


departure : Model -> Transport -> Html msg
departure model transport =
    div [ class "departure" ] <|
        case transport of
            Unknown ->
                [ text "Unknown transport" ]

            Bus departure_ ->
                [ div [ class "ellipse" ] [ text departure_.name ]
                , div [] [ text departure_.destination ]
                , div [] [ text <| formatDateDiffMinutes model.zone model.now departure_.time ]
                ]

            Train departure_ ->
                [ div [ class "ellipse" ] [ trainIcon ]
                , div [] [ text departure_.destination ]
                , div [] [ text <| formatDateDiffMinutes model.zone model.now departure_.time ]
                ]


livemap : Model -> Html msg
livemap model =
    iframe [ class "transit__map", src "https://www.kolumbus.no/ruter/kart/sanntidskart/?c=58.914520,5.732501,14&lf=all&vt=bus,ferry" ] [ text "Loading" ]


square : Model -> Html Msg
square model =
    div [ class "square " ]
        [ div [ class "animated slideInLeft faster delay-2s" ]
            [ iframe [ class "transit__map ", src "https://www.kolumbus.no/ruter/kart/sanntidskart/?c=58.914520,5.732501,14&lf=all&vt=bus,ferry" ] [ text "Loading" ]
            ]
        ]
