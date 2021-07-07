module Page.Slack exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Icons exposing (..)
import Model exposing (..)


view : Model -> Html msg
view { slackEvents, slackInfo, media } =
    div [ class "page slack-page" ]
        [ title
        , annotation
        , body slackEvents
        , square <| getStringAt media.digit media.slackImgs
        , footer slackInfo
        ]


title : Html msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Skravletoppen" ]
            ]
        ]


annotation : Html msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ slackIcon
        , h3 [] [ text "Slack i dag" ]
        ]


body : RemoteData (List SlackEvent) -> Html msg
body slackEvents =
    div [ class "content" ]
        [ div [ class "animated fadeInDown faster" ]
            [ case slackEvents of
                Success slackEvents_ ->
                    div [ class "slack-events " ] <| List.map event slackEvents_

                _ ->
                    div [] [ text "Ingen skravling 😞" ]
            ]
        ]


event : SlackEvent -> Html msg
event slackEvent =
    div [ class "slack-event" ] <|
        case slackEvent of
            Reaction person _ emoji ->
                case emoji of
                    Nothing ->
                        [ div [] [ viewImageRound person.imageUrl ]
                        , div [ class "event-who text--medium" ] [ text person.firstName ]
                        , div [ class "text--medium" ] [ text "reagerte på noe spennende" ]
                        ]

                    Just emojiUrl ->
                        [ div [] [ viewImageRound person.imageUrl ]
                        , div [ class "event-who text--medium" ] [ text person.firstName ]
                        , div [ class "text--medium" ] [ text "reagerte med " ]
                        , viewImage emojiUrl
                        ]

            Message person _ ->
                [ div [] [ viewImageRound person.imageUrl ]
                , div [ class "event-who text--medium" ] [ text person.firstName ]
                , div [ class "text--medium" ] [ text "skrev noe nytt og spennende " ]
                ]

            UnknownSlackEvent ->
                [ text "Hmm, hva har jeg gjort på Slack....? \u{1F914}" ]


square : Href -> Html msg
square imageUrl =
    div [ class "square " ]
        [ div [ class "animated fadeInLeft faster" ]
            [ img [ src imageUrl ] []
            ]
        ]


footer : RemoteData SlackInfo -> Html msg
footer slackInfo =
    div [ class "footer animated fadeIn faster" ]
        [ div [ class "slack-reactions" ] <|
            case slackInfo of
                Success slackInfo_ ->
                    viewTopEmojis slackInfo_.topEmojis

                _ ->
                    [ h4 [] [ text "Ingen reagerer 😲" ]
                    ]
        ]


viewImageRound : Href -> Html msg
viewImageRound imageUrl =
    img [ class "image image--round", src imageUrl ] []


viewImage : Href -> Html msg
viewImage imageUrl =
    img [ class "image--small", src imageUrl ] []


viewTopEmojis : List Emoji -> List (Html msg)
viewTopEmojis emojis =
    List.concat
        [ [ h4 [] [ text "Topp emojis" ] ]
        , emojis
            |> List.map (Maybe.withDefault "")
            |> List.filter (String.isEmpty >> not)
            |> List.map viewImage
        ]
