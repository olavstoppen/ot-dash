module Page.Lunch exposing (view)

import ElmEscapeHtml exposing (unescape)
import Helpers exposing (getStringAt)
import Html exposing (Html, div, h1, h3, img, strong, text)
import Html.Attributes exposing (class, classList, src, style)
import Model exposing (Here, Href, LunchData, LunchDish, Model, RemoteData(..))
import Time exposing (Weekday)
import Json.Decode exposing (bool)


view : Model -> Html msg
view model =
    case model.lunchMenu of
        Success lunchMenu ->
            div [ class "page lunch-page" ]
                [ body lunchMenu model.here
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


body : List LunchData -> Here -> Html msg
body lunchMenu { day } =
    div [ class "content--box" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "lunch" ] <| List.map (lunchDay day) lunchMenu
            ]
        ]


lunchDay : Weekday -> LunchData -> Html msg
lunchDay todayWeekDay { dayName, day, dishes } =
    div [ classList [("lunch-day", True) , ( "day__active", todayWeekDay == day )]  ]
        [ div
            [ classList
                [ ( "day", True )
                ]
            ]
            [ text <| dayName ]
        , dishes
            |> List.filter (\x -> not <| (String.isEmpty x.name || x.name == "."))
            |> List.map course
            |> div [ class "lunch-courses" ]
        ]


square : Model -> Html msg
square { media } =
    div [ class "square animated fadeIn faster lunch-img", style "background-image" <| "url(" ++ (getStringAt media.digit media.lunchImgs) ++")" ]
            []


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

                a :: b ->
                    { label = a, name_ = String.concat b }
    in
    div [ class "lunch-course" ]
        [ div [ class "course-dish" ]
            [ div [] [ text <| unescape <| label ++ " - " ++ name_ ]
            , div [] <| List.map emoji emojis
            ]
        ]


emoji : Href -> Html msg
emoji emojiUrl =
    img [ class "image--xsmall dish-emoji", src emojiUrl ] []
