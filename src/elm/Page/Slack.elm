module Page.Slack exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div [ class "page page__slack" ]
        [ title
        , annotation
        , body model
        , square
        , footer model
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


body : Model -> Html Msg
body model =
    div [ class "content" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "events " ] <| List.map event model.slackEvents
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


square : Html Msg
square =
    div [ class "square " ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ src "/images/typing.png" ] []
            ]
        ]


footer : Model -> Html Msg
footer model =
    div [ class "footer animated fadeIn faster" ]
        [ topEmojis model.slackInfo.topEmojis
        ]


imageRound : String -> Html Msg
imageRound imageUrl =
    img [ class "image image--round", src imageUrl ] []


image : String -> Html Msg
image emoji =
    img [ class "image--small", src emoji ] []


topEmojis : List String -> Html Msg
topEmojis emojis =
    div [ class "topEmojis" ] <|
        List.concat
            [ [ h4 [] [ text "Topp emojis" ] ]
            , List.map image emojis
            ]
