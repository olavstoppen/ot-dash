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
            let
                imageUrl =
                    case model.instagram of
                        Success instagramPosts ->
                            instagramPosts
                                |> List.map .imageUrl
                                |> getStringAt (round <| toFloat model.media.digit / 3)

                        _ ->
                            ""
            in
            div [ class "page page__calendar" ]
                [ title
                , annotation
                , body calendarEvents model.here
                , square imageUrl
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
        , h3 [] [ text "Kalender" ]
        ]


body : List CalendarEvent -> Here -> Html Msg
body calendarEvents here =
    div [ class "content--tall" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "calendar" ] <| List.map (calendarEvent here) calendarEvents
            ]
        ]


calendarEvent : Here -> CalendarEvent -> Html Msg
calendarEvent { zone, time } { name, from, to, category, color } =
    let
        dates =
            String.concat
                [ formatDate zone from
                , ", "
                , formatTime zone from
                , " - "
                , formatTime zone to
                ]

        isActive =
            formatDate zone time == formatDate zone from
    in
    div [ class "calendarEvent" ]
        [ div
            [ classList
                [ ( "day ellipse", True )
                , ( "active", isActive )
                ]

            -- , style "border-color" color
            -- , style "background-color"
            --     (if isActive then
            --         color
            --      else
            --         ""
            --     )
            ]
            [ text <| String.slice 0 2 <| formatWeekDayName zone from ]
        , div [ class "event" ]
            [ p [] [ text name ]
            , p [ class "dates" ] [ text dates ]
            ]
        ]


square : Href -> Html Msg
square imageUrl =
    div [ class "square" ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ class "", src imageUrl ] []
            ]
        ]
