module Page.Transit exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Svg exposing (path, svg)
import Svg.Attributes exposing (class, d, height, viewBox, width)
import Time exposing (Posix)



-- 11031058, buss til Stavanger
-- 11031058, buss retning Sandnes
-- JÅT, tog


busIcon =
    svg [ class "icon--med", width "28", height "32", viewBox "0 0 28 32" ] [ path [ d "M24 15.3594V7H4V15.3594H24ZM19.7031 24.6562C20.1719 25.125 20.7708 25.3594 21.5 25.3594C22.2292 25.3594 22.8281 25.125 23.2969 24.6562C23.7656 24.1354 24 23.5365 24 22.8594C24 22.1823 23.7656 21.6094 23.2969 21.1406C22.8281 20.6198 22.2292 20.3594 21.5 20.3594C20.7708 20.3594 20.1719 20.6198 19.7031 21.1406C19.2344 21.6094 19 22.1823 19 22.8594C19 23.5365 19.2344 24.1354 19.7031 24.6562ZM4.70312 24.6562C5.17188 25.125 5.77083 25.3594 6.5 25.3594C7.22917 25.3594 7.82812 25.125 8.29688 24.6562C8.76562 24.1354 9 23.5365 9 22.8594C9 22.1823 8.76562 21.6094 8.29688 21.1406C7.82812 20.6198 7.22917 20.3594 6.5 20.3594C5.77083 20.3594 5.17188 20.6198 4.70312 21.1406C4.23438 21.6094 4 22.1823 4 22.8594C4 23.5365 4.23438 24.1354 4.70312 24.6562ZM0.640625 23.6406V7C0.640625 4.34375 1.78646 2.57292 4.07812 1.6875C6.36979 0.802083 9.67708 0.359375 14 0.359375C18.3229 0.359375 21.6302 0.802083 23.9219 1.6875C26.2135 2.57292 27.3594 4.34375 27.3594 7V23.6406C27.3594 25.099 26.7865 26.349 25.6406 27.3906V30.3594C25.6406 30.8281 25.4844 31.2188 25.1719 31.5312C24.8594 31.8438 24.4688 32 24 32H22.3594C21.8906 32 21.474 31.8438 21.1094 31.5312C20.7969 31.2188 20.6406 30.8281 20.6406 30.3594V28.6406H7.35938V30.3594C7.35938 30.8281 7.17708 31.2188 6.8125 31.5312C6.5 31.8438 6.10938 32 5.64062 32H4C3.53125 32 3.14062 31.8438 2.82812 31.5312C2.51562 31.2188 2.35938 30.8281 2.35938 30.3594V27.3906C1.21354 26.349 0.640625 25.099 0.640625 23.6406Z" ] [] ]


trainIcon =
    svg [ class "icon", width "28", height "32", viewBox "0 0 560 560" ]
        [ path [ d "M517.8,486.8H37.2c-9.9,0-17.9-8-17.9-17.9c0-9.9,8-17.9,17.9-17.9h480.6c9.9,0,17.9,8,17.9,17.9C535.7,478.8,527.7,486.8,517.8,486.8z" ] []
        , path [ d "M537.1,325c-15.3-45.4-50.6-106.1-50.6-106.1c-15.3-28.3-50.3-28.7-50.3-28.7H287.3l28.2-19.6c7.9-5.5,12.5-13.8,12.5-22.7c0-9-4.6-17.3-12.5-22.7l-70.1-48.7c-8.1-5.7-19.2-3.7-24.9,4.5c-5.6,8.1-3.6,19.2,4.5,24.9l60.5,42.1l-59.5,42.3c0,0-180.5-0.1-181.5,0c-14.6,0.7-24.9,13.2-24.9,27.6v158.1c0,15.4,12.5,27.9,27.9,27.9c0,0,418.2,0.2,438.1,0.2c23.1,0,38-15.6,38-15.6C551.2,364.8,537.1,325,537.1,325z M136.9,268.5c0,5.2-4.3,9.5-9.5,9.5h-5.9H56.8c-5.2,0-9.5-4.3-9.5-9.5v-32.8c0-5.2,4.3-9.5,9.5-9.5h64.6h5.9c5.2,0,9.5,4.3,9.5,9.5V268.5z M252.1,268.5c0,5.2-4.3,9.5-9.5,9.5H172c-5.2,0-9.5-4.3-9.5-9.5v-32.8c0-5.2,4.3-9.5,9.5-9.5h70.5c5.2,0,9.5,4.3,9.5,9.5V268.5z M469,278.1h-86.3c-5.4,0-9.9-4.4-9.9-9.9v-32c0-5.4,4.4-9.9,9.9-9.9h63.5c5.4,0,11.6,4.1,13.8,9l14.9,33.7C477.1,274,474.4,278.1,469,278.1z" ] []
        ]


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
        [ div [ class "" ] [ busIcon ]
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
    iframe [ class "transit__map", src "https://www.kolumbus.no/ruter/kart/sanntidskart/?c=58.914520,5.732501,14&lf=all&vt=bus,ferry" ] []
