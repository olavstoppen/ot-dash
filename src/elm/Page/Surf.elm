module Page.Surf exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view _ =
    div [ class "page surf-page" ]
        [ title
        ]


title : Html msg
title =
    div [ class "title" ]
        [ div [ class "animated fadeInDown faster" ]
            [ h1 [] [ text "No surf today 🌊🏄\u{1F3FB}\u{200D}♂️ 😢" ]
            ]
        ]
