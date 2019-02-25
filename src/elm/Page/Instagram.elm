module Page.Instagram exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Icons exposing (..)
import List.Extra as ListExtra
import Model exposing (..)
import Time exposing (Zone)
import Time.Extra exposing (Interval(..), diff)


dayAge : Int
dayAge =
    3


getInstagramPost : Int -> Here -> List InstagramPost -> Maybe InstagramPost
getInstagramPost digit here instagramPosts =
    let
        shouldHighlight : InstagramPost -> Bool
        shouldHighlight instagramPost =
            diff Day here.zone instagramPost.time here.time < dayAge

        highlighted =
            instagramPosts
                |> List.filter shouldHighlight
    in
    if List.isEmpty highlighted then
        instagramPosts
            |> ListExtra.getAt (round <| toFloat digit / 10)

    else
        List.head highlighted


view : Model -> Html Msg
view { media, here, instagram } =
    case instagram of
        Success instagramPosts ->
            let
                instagramPost_ =
                    getInstagramPost media.digit here instagramPosts
            in
            case instagramPost_ of
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
                        , footer here instagramPost
                        , body instagramPost
                        , square instagramPost
                        ]

        _ ->
            div [] [ text "loading" ]


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
                String.lines <|
                    newLineOnFirstHash instagramPost.description
        ]


paragraph : String -> Html Msg
paragraph s =
    p [] [ text s ]


footer : Here -> InstagramPost -> Html Msg
footer { zone } instagramPost =
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
            , div [ class "stat text--medium" ] [ text <| formatDate zone instagramPost.time ]
            ]
        ]


square : InstagramPost -> Html Msg
square instagramPost =
    div [ class "square " ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ src instagramPost.imageUrl ] []
            ]
        ]
