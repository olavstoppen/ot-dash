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
        [ body person
        , background "https://images.unsplash.com/photo-1495934270965-eca97329fde8?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80"
        ]


body : Person -> Html Msg
body { firstName } =
    div [ class "content--middle" ]
        [ div [ class "animated fadeInDown faster " ]
            [ div [ class "person" ]
                [ h1 [] [ text <| "🎂 Gratulere med dagen " ++ firstName ++ "! 🎂" ]
                ]
            ]
        ]


background : Href -> Html Msg
background imageUrl =
    div [ class "full-page" ]
        [ div [ class "container" ] [ img [ src imageUrl, class "image" ] [] ]
        ]
