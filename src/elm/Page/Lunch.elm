module Page.Lunch exposing (view)

import Helpers exposing (getStringAt)
import Html exposing (Html, div, h1, h3, img, strong, text)
import Html.Attributes exposing (class, classList, src)
import Model exposing (Here, Href, LunchData, LunchDish, Model, RemoteData(..))
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
    div [ class "content--tall--wide" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "lunch" ] <| List.map (lunchDay day) lunchMenu
            ]
        ]


lunchDay : Weekday -> LunchData -> Html msg
lunchDay todayWeekDay { dayName, day, dishes } =
    div [ class "lunch-day" ]
        [ div
            [ classList
                [ ( "ellipse", True )
                , ( "active", todayWeekDay == day )
                ]
            ]
            [ text <| String.slice 0 2 dayName ]
        , div [ class "lunch-courses" ] <|
            List.map course dishes
        ]


square : Model -> Html msg
square { media } =
    div [ class "square --background" ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ src <| getStringAt media.digit media.lunchImgs ] []
            ]
        ]


course : LunchDish -> Html msg
course { name, emojis } =
    let
        dish =
            name
                |> String.split ":"
                |> List.map String.trim

        { label, name_ } =
            case dish of
                [] ->
                    { label = "", name_ = "" }

                [ a ] ->
                    { label = "", name_ = a }

                a :: b :: _ ->
                    { label = a, name_ = b }
    in
    div [ class "lunch-course" ]
        [ strong [ class "course-label" ] [ text label ]
        , div [ class "course-dish" ]
            [ div [] [ text name_ ]
            , div [] <| List.map emoji emojis
            ]
        ]


emoji : Href -> Html msg
emoji emojiUrl =
    img [ class "image--small dish-emoji", src emojiUrl ] []
