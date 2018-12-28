module Page.Transit exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Time exposing (Posix)



-- 11031058, buss til Stavanger
-- 11031058, buss retning Sandnes
-- JÅT, tog


view : Model -> Html msg
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
        [ img [ class "icon", src "/icons/bus.svg" ] []
        , h3 [] [ text "kolumbus.no" ]
        ]


body : Model -> Html msg
body model =
    div [ class "content" ]
        [ div [ class "passings" ] <| List.map passing model.passings
        ]


passing : Transport -> Html msg
passing transport =
    div [ class "passing" ] <|
        case transport of
            Unknown ->
                [ text "Unknown transport" ]

            Bus passing_ ->
                [ div [ class "ellipse" ] [ text passing_.name ]
                , div [] [ text passing_.destination ]
                , div [] [ text "10 min" ]
                ]

            Train passing_ ->
                [ img [ class "icon--med", src "/icons/bus.svg" ] []
                , div [] [ text passing_.destination ]
                , div [] [ text "30 min" ]
                ]


livemap : Model -> Html msg
livemap model =
    iframe [ class "transit__map", src "https://www.kolumbus.no/ruter/kart/sanntidskart/?c=58.914520,5.732501,14&lf=all&vt=bus,ferry" ] []
