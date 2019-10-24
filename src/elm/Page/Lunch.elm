module Page.Lunch exposing (view)

import Helpers exposing (getStringAt)
import Html exposing (Html, div, h1, h3, img, strong, text)
import Html.Attributes exposing (class, classList, src)
import Model exposing (Here, Href, LunchData, Model, RemoteData(..))
import Time exposing (Weekday)


view : Model -> Html msg
view model =
    case model.lunchMenu of
        Success lunchMenu ->
            div [ class "page lunch-page" ]
                [ title
                , annotation
                , body lunchMenu model.here
                , square model
                ]

        _ ->
            div [ class "page lunch-page" ]
                [ div [ class "content" ]
                    [ div [ class "animated fadeInDown faster today" ]
                        [ div [] [ text "Where has the lunch gone? 😱" ]
                        ]
                    ]
                ]


title : Html msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Lunsjmeny!" ]
            ]
        ]


annotation : Html msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ h3 [] [ text "🍽️" ]
        , h3 [] [ text "Kanalpiren" ]
        ]


body : List LunchData -> Here -> Html msg
body lunchMenu { day } =
    div [ class "content--tall" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "lunch" ] <| List.map (lunchDay day) lunchMenu
            ]
        ]


lunchDay : Weekday -> LunchData -> Html msg
lunchDay todayWeekDay { dayName, maincourse, soup, day, maincourseEmojis, soupEmojis } =
    div [ class "lunch-day" ]
        [ div
            [ classList
                [ ( "ellipse", True )
                , ( "active", todayWeekDay == day )
                ]
            ]
            [ text <| String.slice 0 2 dayName ]
        , div [ class "lunch-courses" ]
            [ course "Varmrett: " maincourse maincourseEmojis
            , course "Suppe: " soup soupEmojis
            ]
        ]


square : Model -> Html msg
square { media } =
    div [ class "square" ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ src <| getStringAt media.digit media.lunchImgs ] []
            ]
        ]


course : String -> String -> List Href -> Html msg
course label name emojis =
    div [ class "lunch-course" ]
        [ strong [ class "course-label" ] [ text label ]
        , div [ class "course-dish" ]
            [ div [] [ text name ]
            , div [] <| List.map emoji emojis
            ]
        ]


emoji : Href -> Html msg
emoji emojiUrl =
    img [ class "image--small dish-emoji", src emojiUrl ] []
