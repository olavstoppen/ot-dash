module Page.Video exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Icons exposing (..)
import Model exposing (..)
import String exposing (..)


view : Model -> Html msg
view _ =
    div [ class "page video-page" ]
        [ annotation
        , body
        ]


annotation : Html msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ img [ class "icon--med", src "/icons/sa-icon.png" ] []
        , h3 [] [ text "Jåttå, retning Jåttåvågen (øst)" ]
        ]


body : Html msg
body =
    div [ class "content--big" ]
        [ div [ class "animated fadeInDown faster video-view" ]
            [ iframe
                [ src "https://video-embed.sadev.tech/sa/102777"
                , id "video-view"
                , attribute "allowFullscreen" "false"
                , attribute "scrolling" "no"
                ]
                []
            ]
        ]
