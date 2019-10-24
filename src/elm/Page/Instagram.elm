module Page.Instagram exposing (view)

import Helpers exposing (formatDate, newLineOnFirstHash)
import Html exposing (Html, div, h1, h3, img, p, text)
import Html.Attributes exposing (class, src)
import Icons exposing (chatIcon, likeIcon)
import List.Extra as ListExtra
import Model exposing (Here, InstagramPost, Model, RemoteData(..))
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


view : Model -> Html msg
view { media, here, instagram } =
    case instagram of
        Success instagramPosts ->
            let
                instagramPost_ =
                    getInstagramPost media.digit here instagramPosts
            in
            case instagramPost_ of
                Nothing ->
                    div [ class "page instagram-page" ]
                        [ title
                        , annotation
                        , div [ class "content" ] [ text "No new posts on Instagram" ]
                        ]

                Just instagramPost ->
                    div [ class "page instagram-page" ]
                        [ title
                        , annotation
                        , footer here instagramPost
                        , body instagramPost
                        , square instagramPost
                        ]

        _ ->
            div [] [ text "loading" ]


title : Html msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Nytt på Instagram" ]
            ]
        ]


annotation : Html msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ img [ class "icon--med", src "/icons/instagram.png" ] []
        , h3 [] [ text "instagram.com/olavstoppen" ]
        ]


body : InstagramPost -> Html msg
body instagramPost =
    div [ class "content" ]
        [ div [ class "animated fadeInDown faster" ] <|
            List.map paragraph <|
                String.lines <|
                    newLineOnFirstHash instagramPost.description
        ]


paragraph : String -> Html msg
paragraph s =
    p [] [ text s ]


footer : Here -> InstagramPost -> Html msg
footer { zone } instagramPost =
    div [ class "footer animated fadeIn faster" ]
        [ div [ class "instagram-stats" ]
            [ div [ class "instagram-stat" ]
                [ likeIcon
                , text <| String.fromInt instagramPost.likes
                ]
            , div [ class "instagram-stat" ]
                [ chatIcon
                , text <| String.fromInt instagramPost.comments
                ]
            , div [ class "instagram-stat text--medium" ] [ text <| formatDate zone instagramPost.time ]
            ]
        ]


square : InstagramPost -> Html msg
square instagramPost =
    div [ class "square " ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ src instagramPost.imageUrl ] []
            ]
        ]
