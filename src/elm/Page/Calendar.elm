module Page.Calendar exposing (view)

import Helpers exposing (formatDate, formatTime, formatWeekDayName, getStringAt)
import Html exposing (Html, div, h1, h3, img, p, text)
import Html.Attributes exposing (class, classList, src)
import Model exposing (CalendarEvent, Here, Href, Model, RemoteData(..))


view : Model -> Html msg
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
            div [ class "page calendar-page" ]
                [ title
                , annotation
                , body calendarEvents model.here
                , square imageUrl
                ]

        _ ->
            div [ class "page calendar-page" ]
                [ div [ class "content" ]
                    [ div [ class "animated fadeInDown faster" ]
                        [ div [] [ text "Where has the calendar gone? 😱" ]
                        ]
                    ]
                ]


title : Html msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Kommende hendelser!" ]
            ]
        ]


annotation : Html msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ h3 [] [ text "📅" ]
        , h3 [] [ text "Kalender" ]
        ]


body : List CalendarEvent -> Here -> Html msg
body calendarEvents here =
    div [ class "content--tall" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "calendar" ] <| List.map (calendarEvent here) calendarEvents
            ]
        ]


calendarEvent : Here -> CalendarEvent -> Html msg
calendarEvent { zone, time } { name, from, to } =
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
    div [ class "calendar-event" ]
        [ div
            [ classList
                [ ( "ellipse", True )
                , ( "active", isActive )
                ]
            ]
            [ text <| String.slice 0 2 <| formatWeekDayName zone from ]
        , div [ class "event-description" ]
            [ p [] [ text name ]
            , p [ class "event-dates" ] [ text dates ]
            ]
        ]


square : Href -> Html msg
square imageUrl =
    div [ class "square" ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ class "", src imageUrl ] []
            ]
        ]
