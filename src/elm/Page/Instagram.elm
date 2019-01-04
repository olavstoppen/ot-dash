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
                , div [ class "square" ] [ img [ src instagramPost.imageUrl ] [] ]
                ]


title : Html msg
title =
    h1 [ class "title" ] [ text "Nytt på Instagram" ]


annotation : Html msg
annotation =
    div [ class "annotation" ]
        [ img [ class "icon--med", src "/icons/instagram.png" ] []
        , h3 [] [ text "instagram.com/olavstoppen" ]
        ]


body : InstagramPost -> Html Msg
body instagramPost =
    div [ class "content" ] <|
        List.map paragraph <|
            String.lines instagramPost.description


paragraph : String -> Html Msg
paragraph s =
    p [] [ text s ]


footer : Zone -> InstagramPost -> Html msg
footer zone instagramPost =
    div [ class "footer" ]
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
