module Page.Transit exposing (view)

import Helpers exposing (getPageTitle)
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
        , div [ class "square" ] [ livemap model ]
        ]


title : Html msg
title =
    h1 [ class "title" ] [ text "Transit" ]


annotation : Html msg
annotation =
    div [ class "annotation" ]
        [ busIcon
        , h3 [] [ text "kolumbus.no" ]
        ]


body : Model -> Html msg
body model =
    div [ class "content" ]
        [ div [ class "departures" ] <| List.map departure model.departures
        ]


departure : Transport -> Html msg
departure transport =
    div [ class "departure" ] <|
        case transport of
            Unknown ->
                [ text "Unknown transport" ]

            Bus departure_ ->
                [ div [ class "ellipse" ] [ text departure_.name ]
                , div [] [ text departure_.destination ]
                , div [] [ text "10 min" ]
                ]

            Train departure_ ->
                [ div [ class "ellipse" ] [ trainIcon ]
                , div [] [ text departure_.destination ]
                , div [] [ text "30 min" ]
                ]


livemap : Model -> Html msg
livemap model =
    iframe [ class "transit__map", src "https://www.kolumbus.no/ruter/kart/sanntidskart/?c=58.914520,5.732501,14&lf=all&vt=bus,ferry" ] [ text "Loading" ]
