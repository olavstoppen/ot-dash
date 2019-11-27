module Page.Traffic exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Icons exposing (..)
import Model exposing (..)
import String exposing (..)


view : Model -> Html Msg
view _ =
    div [ class "page traffic-page" ]
        [ annotation
        , body
        ]


annotation : Html Msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ h3 [] [ text "Trafikk" ]
        ]


body : Html Msg
body =
    div [ class "content--big" ]
        [ div [ class "animated fadeInDown faster traffic-view" ]
            [ iframe
                [ src "https://embed.waze.com/iframe?zoom=12&lat=58.913916&lon=5.739776&ct=livemap"
                , id "traffic-view"
                , attribute "allowFullscreen" "false"
                , attribute "scrolling" "no"
                ]
                []
            ]
        ]
