module Page.Slack exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Icons exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view { slackEvents, slackInfo, here, media } =
    div [ class "page page__slack" ]
        [ title
        , annotation
        , body slackEvents
        , square <| getStringAt media.digit media.slackImgs
        , footer slackInfo
        ]


title : Html Msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Skravletoppen" ]
            ]
        ]


annotation : Html Msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ slackIcon
        , h3 [] [ text "Slack i dag" ]
        ]


body : RemoteData (List SlackEvent) -> Html Msg
body slackEvents =
    div [ class "content" ]
        [ div [ class "animated fadeInDown faster" ]
            [ case slackEvents of
                Success slackEvents_ ->
                    div [ class "events " ] <| List.map event slackEvents_

                _ ->
                    div [] [ text "Ingen skravling 😞" ]
            ]
        ]


event : SlackEvent -> Html Msg
event slackEvent =
    div [ class "event" ] <|
        case slackEvent of
            Reaction person time emoji ->
                [ div [] [ imageRound person.imageUrl ]
                , div [ class "who text--medium" ] [ text person.firstName ]
                , div [ class "text--medium" ] [ text "reagerte med " ]
                , image emoji
                ]

            Message person time ->
                [ div [] [ imageRound person.imageUrl ]
                , div [ class "who text--medium" ] [ text person.firstName ]
                , div [ class "text--medium" ] [ text "skrev noe nytt og spennende " ]
                ]

            UnknownSlackEvent ->
                [ text "Hmm, hva har jeg gjort på Slack....? \u{1F914}" ]


square : Href -> Html Msg
square imageUrl =
    div [ class "square " ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ src imageUrl ] []
            ]
        ]


footer : RemoteData SlackInfo -> Html Msg
footer slackInfo =
    div [ class "footer animated fadeIn faster" ]
        [ div [ class "topEmojis" ] <|
            case slackInfo of
                Success slackInfo_ ->
                    topEmojis slackInfo_.topEmojis

                _ ->
                    [ h4 [] [ text "Ingen reagerer 😲" ]
                    ]
        ]


imageRound : String -> Html Msg
imageRound imageUrl =
    img [ class "image image--round", src imageUrl ] []


image : String -> Html Msg
image emoji =
    img [ class "image--small", src emoji ] []


topEmojis : List String -> List (Html Msg)
topEmojis emojis =
    List.concat
        [ [ h4 [] [ text "Topp emojis" ] ]
        , List.map image emojis
        ]
