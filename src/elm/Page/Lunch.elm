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
                        [ div [] [ text "Where has the lunch gone? 😱" ]
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
        [ h3 [] [ text "🍽️" ]
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
    div [ class "lunchDay" ]
        [ div
            [ classList
                [ ( "day ellipse", True )
                , ( "active", todayWeekDay == day )
                ]
            ]
            [ text <| String.slice 0 1 dayName ]
        , div [ class "labels" ]
            [ strong [] [ text "Varmrett: " ]
            , strong [] [ text "Suppe: " ]
            ]
        , div [ class "courses" ]
            [ p [] [ text maincourse ]
            , p [] [ text soup ]
            ]
        ]


getRandomFoodImage : Model -> String
getRandomFoodImage model =
    "https://images.unsplash.com/photo-1487376318617-f43c7b41e2e2?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjUwMTY4fQ"


square : Model -> Html Msg
square model =
    div [ class "square" ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ class "", src <| getRandomFoodImage model ] []
            ]
        ]
