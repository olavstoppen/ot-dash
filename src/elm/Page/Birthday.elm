module Page.Birthday exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Icons exposing (..)
import Model exposing (..)
import Time exposing (Zone)


view : Person -> Html Msg
view person =
    div [ class "page page__birthday" ]
        [ annotation
        , title
        , body person
        , square person.imageUrl
        , footer
        ]


title : Html Msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "Gratulere med dagen!" ]
            ]
        ]


annotation : Html Msg
annotation =
    div [ class "annotation--corner animated fadeIn faster flags" ]
        [ img [ class "", src "/images/flags.svg" ] []
        ]


body : Person -> Html Msg
body { firstName } =
    div [ class "content" ]
        [ div [ class "animated fadeInDown faster" ]
            [ p [] [ text "Hurra for deg som fyller ditt år! Ja, deg vil vi gratulere!" ]
            , p [] [ text "Alle i ring omkring deg vi står, og se nå vil vi marsjere, bukke, nikke, neie, snu oss omkring, danse så for deg med hopp og sprett og spring, ønske deg av hjertet alle gode ting, og si meg så, hva vil du mere?" ]
            , p [] [ text <| "Gratulerer " ++ firstName ++ "!" ]
            ]
        ]


square : Href -> Html Msg
square imageUrl =
    div [ class "square " ]
        [ div [ class "animated slideInLeft faster" ]
            [ img [ src imageUrl ] []
            ]
        ]


footer : Html Msg
footer =
    div [ class "footer--tall animated fadeIn faster" ]
        [ div [ class "gifts" ]
            [ img [ src "images/cake.svg" ] []
            , img [ src "images/gift.svg" ] []
            ]
        ]
