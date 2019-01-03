module Page.Instagram exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
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
        [ h3 [] [ text "instagram.com/olavstoppen" ]
        ]


body : InstagramInfo -> Html msg
body instagramPost =
    div [ class "content" ]
        [ text instagramPost.description
        ]


footer : Zone -> InstagramInfo -> Html msg
footer zone instagramPost =
    div [ class "footer" ]
        [ div [ class "stats" ]
            [ div [ class "stat" ] [ text <| String.fromInt instagramPost.likes ]
            , div [ class "stat" ] [ text <| String.fromInt instagramPost.comments ]
            , div [ class "stat" ] [ text <| formatDate zone instagramPost.time ]
            ]
        ]
