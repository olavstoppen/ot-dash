module Page.Lunch exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Icons exposing (..)
import Model exposing (..)
import Time exposing (..)


view : Model -> Html Msg
view model =
    case model.lunchMenu of
        Success lunchMenu ->
            div [ class "page page__lunch" ]
                [ title
                , annotation
                , body lunchMenu model.here
                , square model
                ]

        _ ->
            div [ class "page page__lunch" ]
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
            [ h1 [] [ text "Lunsjmeny!" ]
            ]
        ]


annotation : Html Msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ img [ class "image--small", src "/images/toma.png" ] []
        , h3 [] [ text "Kanalpiren" ]
        ]


body : List LunchData -> Here -> Html Msg
body lunchMenu { day } =
    div [ class "content--tall" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "lunch" ] <| List.map (lunchDay day) lunchMenu
            ]
        ]


lunchDay : Weekday -> LunchData -> Html Msg
lunchDay todayWeekDay { dayName, maincourse, soup, day } =
    div [ classList [ ( "lunchDay", True ), ( "active", todayWeekDay == day ) ] ]
        [ div [ class "day " ] [ text dayName ]
        , div [ class "maincourse" ]
            [ strong [] [ text "Varmrett: " ]
            , text maincourse
            ]
        , div [ class "soup" ]
            [ strong [] [ text "Suppe: " ]
            , text soup
            ]
        ]


getRandomFoodImage : Model -> String
getRandomFoodImage model =
    "https://images.unsplash.com/photo-1444952483853-7c36e902e722?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjUwMDQxfQ"


square : Model -> Html Msg
square model =
    div [ class "square" ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ class "", src <| getRandomFoodImage model ] []
            ]
        ]
