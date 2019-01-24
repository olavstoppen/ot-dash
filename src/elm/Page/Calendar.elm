module Page.Calendar exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Icons exposing (..)
import Model exposing (..)
import Time exposing (..)


view : Model -> Html Msg
view model =
    case model.calendar of
        Success calendarEvents ->
            div [ class "page page__calendar" ]
                [ title
                , annotation
                , body calendarEvents model.here
                , square model
                ]

        _ ->
            div [ class "page page__calendar" ]
                [ div [ class "content" ]
                    [ div [ class "animated fadeInDown faster" ]
                        [ div [] [ text "Where has the calendar gone? 😱" ]
                        ]
                    ]
                ]


title : Html Msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Kommende hendelser!" ]
            ]
        ]


annotation : Html Msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ h3 [] [ text "📅" ]
        , h3 [] [ text "Hendelser" ]
        ]


body : List CalendarEvent -> Here -> Html Msg
body calendarEvents here =
    div [ class "content--tall" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "calendar" ] <| List.map (calendarEvent here) calendarEvents
            ]
        ]


calendarEvent : Here -> CalendarEvent -> Html Msg
calendarEvent { zone } { name, from, to, category } =
    let
        dates =
            String.concat
                [ formatDate zone from
                , ", "
                , formatTime zone from
                , " - "
                , formatTime zone to
                ]
    in
    div [ class "calendarEvent" ]
        [ div
            [ classList
                [ ( "day ellipse", True )
                , ( "active", False )
                ]
            ]
            [ text <| String.slice 0 1 <| formatDay zone from ]
        , div [ class "event" ]
            [ strong [] [ text name ]
            , p [ class "dates" ] [ text dates ]
            ]
        ]


square : Model -> Html Msg
square model =
    div [ class "square" ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ class "", src "" ] []
            ]
        ]
