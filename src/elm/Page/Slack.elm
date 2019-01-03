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
        , div [ class "square" ] [ text "IMAGE HERE" ]
        ]


title : Html msg
title =
    h1 [ class "title" ] [ text "Skravletoppen" ]


annotation : Html msg
annotation =
    div [ class "annotation" ]
        [ h3 [] [ text "Slack idag" ]
        ]


body : Model -> Html msg
body model =
    div [ class "content" ]
        [ div [ class "events" ] <| List.map event model.slackEvents
        ]


event : SlackEvent -> Html msg
event slackEvent =
    div [ class "event" ] <|
        case slackEvent of
            Reaction person time emoji ->
                [ div [] [ text "IMAGE" ]
                , div [ class "" ] [ text ("@" ++ person.firstName) ]
                , div [] [ text "reacted with " ]
                , div [] [ text "EMOJI" ]
                ]

            Message person time ->
                [ div [ class "" ] [ text person.firstName ]
                , div [] [ text "posted something new and very interesting" ]
                ]

            UnknownSlackEvent ->
                [ text "Who dis slack event" ]
