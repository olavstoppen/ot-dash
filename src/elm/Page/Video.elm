module Page.Video exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Icons exposing (..)
import Model exposing (..)
import String exposing (..)


view : Model -> Html Msg
view model =
    div [ class "page page__video" ]
        [ annotation
        , body
        ]


annotation : Html Msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ img [ class "icon--med", src "/icons/sa-icon.png" ] []
        , h3 [] [ text "Jåttå, retning Jåttåvågen (øst)" ]
        ]


body : Html Msg
body =
    div [ class "content--big" ]
        [ div [ class "animated fadeInDown faster video" ]
            [ iframe
                [ src "https://video-embed.sadev.tech/sa/100166"
                , id "video"
                , attribute "allowFullscreen" "false"
                , attribute "scrolling" "no"
                ]
                []
            ]
        ]
