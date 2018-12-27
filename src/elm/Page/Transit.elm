module Page.Transit exposing (transit)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Msg(..), initModel)


transit : Model -> Html msg
transit model =
    div [ class "page" ]
        [ div [ class "title" ] [ h1 [] [ text "Transit" ] ]
        , div [ class "annotation" ] [ h3 [] [ text "kolumbus og nsb" ] ]
        , div [ class "content" ] [ div [] [ text "some kind of body goes here" ] ]
        , div [ class "middle" ] [ livemap model ]
        ]


livemap : Model -> Html msg
livemap model =
    iframe [ src "https://www.kolumbus.no/ruter/kart/sanntidskart/?c=58.914111,5.728542,16&lf=all&vt=bus,ferry" ] []
