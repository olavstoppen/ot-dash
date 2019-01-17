module Page.Slack exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


images : List String
images =
    [ "https://media.tenor.com/images/71b38a1ed321789dcb7af1ee61dc4dd2/tenor.gif"
    , "https://media.tenor.com/images/e34da5e49418ae5ff6c356bc015bf44e/tenor.gif"
    , "https://media.tenor.com/images/cc2c43308b72caa5861eb711ff2f84f9/tenor.gif"
    , "https://media.tenor.com/images/537c747fb73ab8b0202a12cd31bf077c/tenor.gif"
    , "https://media.tenor.com/images/bd316052396fd5142efe63e821b0dae9/tenor.gif"
    , "https://media.tenor.com/images/a994785cd21b919b1352000ef5068801/tenor.gif"
    , "https://media.tenor.com/images/6dc9719aba90b0d21e4ec4f0e67079fe/tenor.gif"
    , "https://media.tenor.com/images/0d1eeaf0fd56d677e3d756ee89bc5750/tenor.gif"
    , "https://media.tenor.com/images/65887228665610f7fde6f8511e2fdd53/tenor.gif"
    , "https://media.tenor.com/images/a85d27dcf14541ff43b31ff5b1288938/tenor.gif"
    ]


view : Model -> Html Msg
view { slackEvents, slackInfo, here } =
    div [ class "page page__slack" ]
        [ title
        , annotation
        , body slackEvents
        , square "https://media.tenor.com/images/a994785cd21b919b1352000ef5068801/tenor.gif"
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
        [ img [ class "icon--med", src "/icons/slack.png" ] []
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
                , div [ class "who" ] [ text person.firstName ]
                , div [] [ text "reacted with " ]
                , div [] [ image emoji ]
                ]

            Message person time ->
                [ div [] [ imageRound person.imageUrl ]
                , div [ class "who" ] [ text person.firstName ]
                , div [] [ text "posted something new and very interesting" ]
                , div [] []
                ]

            UnknownSlackEvent ->
                [ text "Who dis slack event" ]


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
                    [ h4 [] [ text "No one is reacting 😲" ]
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
