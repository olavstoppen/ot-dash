module Page.Instagram exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Icons exposing (..)
import Model exposing (..)
import Time exposing (Zone)


view : Model -> Html Msg
view model =
    case List.head model.instagram of
        Nothing ->
            div [ class "page page__instagram" ]
                [ title
                , annotation
                , div [ class "content" ] [ text "No new posts on Instagram" ]
                ]

        Just instagramPost ->
            div [ class "page page__instagram" ]
                [ title
                , annotation
                , footer model.zone instagramPost
                , body instagramPost
                , square instagramPost
                ]


title : Html Msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Nytt på Instagram" ]
            ]
        ]


annotation : Html Msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ img [ class "icon--med", src "/icons/instagram.png" ] []
        , h3 [] [ text "instagram.com/olavstoppen" ]
        ]


body : InstagramPost -> Html Msg
body instagramPost =
    div [ class "content" ]
        [ div [ class "animated fadeInDown faster" ] <|
            List.map paragraph <|
                String.lines instagramPost.description
        ]


paragraph : String -> Html Msg
paragraph s =
    p [] [ text s ]


footer : Zone -> InstagramPost -> Html Msg
footer zone instagramPost =
    div [ class "footer animated fadeIn faster" ]
        [ div [ class "stats" ]
            [ div [ class "stat" ]
                [ likeIcon
                , text <| String.fromInt instagramPost.likes
                ]
            , div [ class "stat" ]
                [ chatIcon
                , text <| String.fromInt instagramPost.comments
                ]
            , div [ class "stat" ] [ text <| formatDate zone instagramPost.time ]
            ]
        ]


square : InstagramPost -> Html Msg
square instagramPost =
    div [ class "square " ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ src instagramPost.imageUrl ] []
            ]
        ]
