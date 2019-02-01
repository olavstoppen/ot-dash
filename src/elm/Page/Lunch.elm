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
lunchDay todayWeekDay { dayName, maincourse, soup, day, maincourseEmojis, soupEmojis } =
    div [ class "lunchDay" ]
        [ div
            [ classList
                [ ( "day ellipse", True )
                , ( "active", todayWeekDay == day )
                ]
            ]
            [ text <| String.slice 0 2 dayName ]
        , div [ class "courses" ]
            [ div [ class "course" ]
                [ strong [ class "label" ] [ text "Varmrett: " ]
                , div [ class "description" ]
                    [ div [ class "dish" ] [ text maincourse ]
                    , div [ class "emojis" ] <| List.map emoji maincourseEmojis
                    ]
                ]
            , div [ class "course" ]
                [ strong [ class "label" ] [ text "Suppe: " ]
                , div [ class "description" ]
                    [ div [ class "dish" ] [ text soup ]
                    , div [ class "emojis" ] <| List.map emoji soupEmojis
                    ]
                ]
            ]
        ]


square : Model -> Html Msg
square { media } =
    div [ class "square" ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ class "", src <| getStringAt media.digit media.lunchImgs ] []
            ]
        ]


emoji : Href -> Html Msg
emoji emojiUrl =
    img [ class "image--small emoji", src emojiUrl ] []
